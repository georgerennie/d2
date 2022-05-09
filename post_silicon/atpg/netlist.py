import json
from prodict import Prodict
from typing import NewType, List, DefaultDict, Set, Optional, Tuple
from collections.abc import Iterable
from collections import defaultdict
from functools import reduce
from pysmt.shortcuts import Symbol, FreshSymbol, And, Not, FALSE
from transition_system import TransitionSystem

Net = NewType("Net", int)
Cell = NewType("Cell", str)


class Netlist:
    def __init__(self, top_json_path: str, lib_json_path: str):
        # Load flattened top module netlist from json
        with open(top_json_path, "r") as f:
            modules = json.load(f)["modules"]
            modules = list(
                m for m in iter(modules.values()) if "blackbox" not in m["attributes"]
            )
            assert len(modules) == 1, "Please flatten the design before use"
            self.top = Prodict.from_dict(modules[0])

        # Load cell modules from json, and convert to generic smt
        # representations, with variables labelled according to nodes
        with open(lib_json_path, "r") as f:
            cells = Prodict.from_dict(json.load(f)["modules"])
            self.cells = {
                name: self.cell_to_smt(content) for name, content in iter(cells.items())
            }

        # Map from net number to name
        self.net_names: dict[Net, str] = {}
        # Map from net name to symbolic variable
        self.symb_map: DefaultDict[Net, Symbol] = defaultdict(FreshSymbol)
        for (name, net) in self.top.netnames.items():
            assert len(net.bits) == 1
            assert not net.bits[0] in self.net_names
            self.net_names[net.bits[0]] = name
            self.symb_map[net.bits[0]] = Symbol(name)

        # Connectivity map from the name of each net to the name of the
        # cell driving it
        self.source_map: dict[Net, Cell] = {}

        # Connectivity map from the name of each net to the list of cells it
        # drives
        self.sink_map: dict[Net, List[Cell]] = defaultdict(list)

        for (cell_name, cell) in self.top.cells.items():
            for (conn_name, conn) in cell.connections.items():
                assert len(conn) == 1
                assert cell.port_directions[conn_name] in ["input", "output"]

                if cell.port_directions[conn_name] == "output":
                    assert not conn[0] in self.source_map
                    self.source_map[conn[0]] = cell_name

                elif cell.port_directions[conn_name] == "input":
                    self.sink_map[conn[0]].append(cell_name)

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
            get_v = lambda name: symb_map[sub_cell.connections[name][0]]

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

                # Simplify traces
                trans.append(arst.Implies(Not(clk)))

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

    def get_net_tfio(
        self, net: Net, visited_nets: Optional[Set[Net]] = None, fan_in: bool = True
    ) -> Set[Net]:
        """
        Returns the set of nets in the transistive fan-in or fan-out of the input net
        """
        visited: Set[Net] = {net} if not visited_nets else visited_nets.union({net})

        # The only undriven nets should be primary inputs. Run opt_clean if this
        # isn't the case
        if fan_in and net not in self.source_map:
            assert self.name_from_net(net) in self.top.ports
            return visited

        if not fan_in and net not in self.sink_map:
            return visited

        if fan_in:
            cells = [self.top.cells[self.source_map[net]]]
        else:
            cells = list(map(self.top.cells.get, self.sink_map[net]))

        for cell in cells:
            cell_ports = list(
                conn
                for conn in cell.connections
                if cell.port_directions[conn] == ("input" if fan_in else "output")
            )
            fan_nets = map(lambda conn: cell.connections[conn][0], cell_ports)

            for fan_net in fan_nets:
                if fan_net not in visited:
                    visited = self.get_net_tfio(fan_net, visited, fan_in)
        return visited

    def get_tfi(self, nets: Iterable[Net], visited: Optional[Set[Net]] = None):
        """
        Returns the set of nets in the union of the transistive fan-ins of
        the input nets
        """
        return reduce(lambda v, n: self.get_net_tfio(n, v, True), nets, visited)

    def get_tfo(self, nets: Iterable[Net], visited: Optional[Set[Net]] = None):
        """
        Returns the set of nets in the union of the transistive fan-outs of
        the input nets
        """
        return reduce(lambda v, n: self.get_net_tfio(n, v, False), nets, visited)

    def get_driver_system(
        self, nets: Set[Net], existing_system: Optional[TransitionSystem] = None
    ) -> Tuple[TransitionSystem, Set[Net]]:
        """
        Returns a transition system containing the logic for the cell driving
        each net in nets, as well as the set of nets that are unconstrained
        inputs to this system
        """
        system = existing_system or TransitionSystem()
        visited_cells = set()
        input_nets = set()

        for net in nets:
            # Primary inputs dont have drivers
            if net not in self.source_map:
                assert self.name_from_net(net) in self.top.ports
                continue

            # Don't include cells with more than one output net (e.g. DFF with
            # Q and nQ) more than once
            cell_name = self.source_map[net]
            if cell_name in visited_cells:
                continue

            visited_cells.add(cell_name)
            cell = self.top.cells[cell_name]

            # Create substitutions for mapping cell into transition system
            subs = {}
            for name, conn in cell.connections.items():
                if conn[0] not in nets and cell.port_directions[name] == "output":
                    continue

                subs[Symbol(name)] = self.symb_map[conn[0]]
                # Add input nets to set of all input nets
                if cell.port_directions[name] == "input":
                    input_nets.add(conn[0])

            # Merge cell into the transition system
            system.merge_system(self.cells[cell.type], subs)
            # Make sure all the nets in fan-in end up in the transition system
            assert self.symb_map[net] in system.variables()

        return system, input_nets.difference(nets)
