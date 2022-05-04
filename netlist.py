import json
from prodict import Prodict
from typing import NewType, List, DefaultDict, Set, Optional
from collections.abc import Iterable
from collections import defaultdict
from pysmt.shortcuts import Symbol, FreshSymbol, And, Not, FALSE
from transition_system import TransitionSystem

Net = NewType("Net", int)
Cell = NewType("Cell", str)

class Netlist:
    def __init__(self, top_json_path: str, lib_json_path: str):
        # Load flattened top module netlist from json
        with open(top_json_path, "r") as f:
            modules = json.load(f)["modules"]
            modules = list(filter(lambda m:
                "blackbox" not in m["attributes"], iter(modules.values())))
            assert len(modules) == 1, "Please flatten the design before use"
            self.top = Prodict.from_dict(modules[0])

        # Load cell modules from json, and convert to generic smt
        # representations, with variables labelled according to nodes
        with open(lib_json_path, "r") as f:
            cells = Prodict.from_dict(json.load(f)["modules"])
            self.cells = {
                name: self.cell_to_smt(content)
                for name, content in iter(cells.items())
            }

        # Map from net number to name
        self.net_names: dict[Net, str] = {}
        for (name, net) in self.top.netnames.items():
            assert len(net.bits) == 1
            assert not net.bits[0] in self.net_names
            self.net_names[net.bits[0]] = name

        # Connectivity map from the name of each net to the name of the
        # cell/port driving it
        self.conn_map: dict[Net, Cell] = {}
        for (cell_name, cell) in self.top.cells.items():
            for (conn_name, conn) in cell.connections.items():
                assert len(conn) == 1
                assert cell.port_directions[conn_name] in ["input", "output"]

                if cell.port_directions[conn_name] == "output":
                    assert not conn[0] in self.conn_map
                    self.conn_map[conn[0]] = cell_name

    def cell_to_smt(self, cell) -> TransitionSystem:
        """
        Construct smt formula for cell. Only yosys $logic_{or/and/not}, $xor
        and $adff currently
        """
        symb_map: DefaultDict[Net, Symbol] = defaultdict(FreshSymbol)
        init: List[Symbol] = []
        trans: List[Symbol] = []

        for name, net in cell.netnames.items():
            assert len(net.bits) == 1, "Concatenated signals not supported"
            bits = net.bits[0]
            # Constants are encoded as strings
            if isinstance(bits, str):
                trans.append(Symbol(name).Iff(bool(int(bits))))
            else:
                if bits in symb_map:
                    trans.append(Symbol(name).Iff(symb_map[bits]))
                else:
                    symb_map[bits] = Symbol(name)

        for sub_cell in cell.cells.values():
            def get_v(name):
                return symb_map[sub_cell.connections[name][0]]

            if sub_cell.type == "$logic_and":
                trans.append(get_v("Y").Iff(get_v("A") & get_v("B")))
            elif sub_cell.type == "$logic_or":
                trans.append(get_v("Y").Iff(get_v("A") | get_v("B")))
            elif sub_cell.type == "$logic_not":
                trans.append(get_v("Y").Iff(Not(get_v("A"))))
            elif sub_cell.type == "$xor":
                trans.append(get_v("Y").Iff(get_v("A") ^ get_v("B")))

            elif sub_cell.type == "$adff":
                # This clock model isnt perfect but is useful for the tests
                # we care about where the clock can be disabled for steps
                arst = get_v("ARST")
                next_arst = TransitionSystem.next_symb(arst)
                if int(sub_cell.parameters.ARST_POLARITY) == 0:
                    arst = Not(arst)
                    next_arst = Not(next_arst)

                clk = get_v("CLK")
                d = get_v("D")
                q = get_v("Q")
                next_q = TransitionSystem.next_symb(q)

                # if arst in this cycle, 0 in this cycle
                # if not arst in next cycle, d in next cycle if clock, else q
                if int(sub_cell.parameters.ARST_VALUE) == 0:
                    trans.append(arst.Implies(Not(q)))
                else:
                    trans.append(arst.Implies(q))

                trans.append(Not(next_arst).Implies(next_q.Iff(clk.Ite(d, q))))

            else:
                assert False, f"Unknown cell type {sub_cell.type}"

        return TransitionSystem(
            set(map(Symbol, cell.netnames.keys())),
            And(init),
            And(trans),
        )

    def net_from_name(self, name: str) -> Net:
        return self.top.netnames[name].bits[0]

    def name_from_net(self, net: Net) -> str:
        return self.net_names[net]

    def get_tfi(self, net: Net, maybe_visited: Optional[Set[Net]] = None):
        """Returns the set of nets in the transistve fan-in of the input net"""
        visited: Set[Net] = {net} if not maybe_visited else maybe_visited.union({net})

        if net not in self.conn_map:
            assert self.net_names[net] in self.top.ports
            return visited

        cell = self.top.cells[self.conn_map[net]]
        cell_inputs = filter(
            lambda conn: cell.port_directions[conn] == "input",
            cell.connections
        )
        cell_drivers = map(lambda conn: cell.connections[conn][0], cell_inputs)

        for driver in cell_drivers:
            if driver not in visited:
                visited = self.get_tfi(driver, visited)
        return visited

    def get_tfi_union(self, nets: Iterable[Net]):
        """
        Returns the set of nets in the union of the transistve fan-ins of
        the input nets
        """
        visited: Set[Net] = set()
        for net in nets:
            visited = self.get_tfi(net, visited)
        return visited

    def get_driver_system(self, nets: Iterable[Net]) -> TransitionSystem:
        """
        Returns a transition system containing the logic for the cell driving
        each net in nets. This doesn't guarantee that the driver logic for that
        cell is included
        """
        # Create map from nets to smt symbols, and name symbols according to
        # net names
        symb_map: DefaultDict[Net, Symbol] = defaultdict(FreshSymbol)
        symb_map.update({net: Symbol(n.name_from_net(net)) for net in nets})

        system = TransitionSystem()
        visited_cells = set()

        for net in nets:
            # Primary inputs dont have drivers
            if net not in self.conn_map:
                assert self.net_names[net] in self.top.ports
                continue

            # Don't include cells with more than one output net (e.g. DFF with
            # Q and nQ) more than once
            cell_name = self.conn_map[net]
            if cell_name in visited_cells:
                continue
            visited_cells.add(cell_name)
            cell = self.top.cells[cell_name]

            # Create substitutions for mapping cell into transition system
            subs = {
                Symbol(name): symb_map[conn[0]]
                for name, conn in cell.connections.items()
            }

            # Merge cell into the transition system
            system.merge_system(self.cells[cell.type], subs)

            # Make sure all the nets in fan-in end up in the transition system
            assert symb_map[net] in system.variables()

        return system

n = Netlist("design/TEAMF_DESIGN.json", "design/d2lib.json")
system = n.get_driver_system(n.get_tfi_union(list(map(n.net_from_name, [
    "Q8",
    "Q9",
    "Q10",
    "Q11",
    "Q12",
    "Q13",
    "Q14",
    "Q15",
    "Q16",
]))))

def sym(name):
    return Symbol(name)

cover = [And(Not(sym("Q16")), sym("Q15"), Not(sym("Q14")), sym("Q13"), sym("Q10"))]
system.add_init(Not(sym("A14")))

from cover_bmc import CoverBMC
bmc = CoverBMC(system)
model, time = bmc.generate_trace(cover)
