from typing import DefaultDict, List, Iterable, Tuple, Dict
from pysmt.shortcuts import Symbol, FreshSymbol, Not, Or
from pysmt.solvers.solver import Model
from collections import defaultdict

from netlist import Netlist, Net
from transition_system import TransitionSystem
from cover_bmc import CoverBMC


class FaultCover(Netlist):
    def __init__(
        self,
        top_json_path: str,
        lib_json_path: str,
        output_nets: Iterable[str],
        clocks: Iterable[str],
    ):
        super().__init__(top_json_path, lib_json_path)

        self.outputs = list(map(self.net_from_name, output_nets))
        self.nets = self.get_tfi(self.outputs)
        self.ts, excess = self.get_driver_system(self.nets)
        assert len(excess) == 0

        self.clocks = list(map(self.net_from_name, clocks))

        self.ports = [
            net for net in self.nets if self.name_from_net(net) in self.top.ports
        ]

        self.covers: List[Tuple[Symbol, TransitionSystem, str]] = []

    def cover_observability(
        self, fault_ts: TransitionSystem, fault_nets: Iterable[Net], fault_name: str
    ):
        subs = {var: var for var in fault_ts.variables()}
        for net in fault_nets:
            subs.pop(self.symb_map[net], None)

        tfo = self.get_tfo(fault_nets)
        fan_out_system, cut_nets = self.get_driver_system(
            tfo.difference(fault_nets), fault_ts
        )
        cut_nets.difference_update(fault_nets)

        subs.update({self.symb_map[net]: self.symb_map[net] for net in cut_nets})

        observation_points = []
        for output in self.outputs:
            assert output not in subs
            if output not in tfo:
                continue

            outer_output = FreshSymbol(self.symb_map[output].symbol_type())
            self.ts.add_variable(outer_output)
            subs[self.symb_map[output]] = outer_output

            # Try to observe a point where the output of golden and fault models
            # diverges
            observation_points.append(Not(self.symb_map[output].Iff(outer_output)))

        self.covers.append(
            (Or(observation_points), fan_out_system.map_symbols(subs), fault_name)
        )

    def cover_stuck_at(self, net: Net, value: bool):
        symb = self.symb_map[net]
        condition = symb if value else Not(symb)
        fault_ts = TransitionSystem({symb}, [], [condition])
        return self.cover_observability(
            fault_ts, [net], self.name_from_net(net) + "/" + str(int(value))
        )

    def cover_io_bridge(self, net_1: Net, net_2: Net):
        symb_1, symb_2 = self.symb_map[net_1], self.symb_map[net_2]
        condition = Not(symb_1.Iff(symb_2))
        self.covers.append(
            (
                condition,
                TransitionSystem(),
                f"diff({self.name_from_net(net_1)}, {self.name_from_net(net_2)})",
            )
        )

    def get_trace(self, timeout: int = 5, start: int = 0) -> Tuple[Model, int]:
        covers: List[Symbol] = []
        cover_ts = self.ts

        for cover, fault_ts, _ in self.covers:
            covers.append(cover)
            cover_ts += fault_ts

        return CoverBMC(cover_ts).generate_trace(covers, start=start)

    def generate_test_vectors(self, trace: Tuple[Model, int]):
        model, t = trace

        test_vectors = "<PinDef>\n\t"
        test_vectors += ",".join(map(self.name_from_net, self.ports))
        test_vectors += "\n</PinDef>\n<TestVector>\n"

        for i in range(t + 1):
            test_vectors += "\t"
            add_clock = False
            for port in self.ports:
                val = model.get_py_value(
                    TransitionSystem.at_time(self.symb_map[port], i)
                )
                if port in self.clocks and val:
                    test_vectors += "0"
                    add_clock = True
                else:
                    test_vectors += str(int(val))
            test_vectors += "\n"

            if add_clock:
                test_vectors += "\t"
                for port in self.ports:
                    if port in self.outputs:
                        test_vectors += "X"
                    else:
                        val = model.get_py_value(
                            TransitionSystem.at_time(self.symb_map[port], i)
                        )
                        test_vectors += str(int(val))
                test_vectors += "\n"

        test_vectors += "</TestVector>"
        return test_vectors

    def sym(self, name: str) -> Symbol:
        return self.symb_map[self.net_from_name(name)]


# fc = FaultCover(
#     "design/TEAMF_DESIGN.json",
#     # "design_small/TEAMF_DESIGN.json",
#     "design/d2lib.json",
#     # ["Q2", "Q3", "Q4", "Q5"],
#     # ["Q17", "Q18", "Q19", "Q20", "Q21", "Q22", "Q23"],
#     # ["Q6", "Q7"],
#     # ["Q6"],
#     # ["Q13"],
#     ["Q8", "Q9", "Q10", "Q11", "Q12", "Q13", "Q14", "Q15", "Q16"],
#     ["A13"],
# )


# fc.ts.add_init(Not(fc.sym("A14")))

# print(len(fc.nets))
# nets = list(fc.nets)

# # for net in fc.nets:
# # for i in range(20):
# #     net = nets[i]
# #     fc.cover_stuck_at(net, False)
# #     fc.cover_stuck_at(net, True)

# fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.min10_0"), False)
# fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.min10_1"), False)
# fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.min10_2"), False)
# fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.min10_0"), True)
# fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.min10_1"), True)
# fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.min10_2"), True)

# # fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.N_56"), True)
# # fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.N_56"), False)

# fc.generate_test_vectors(fc.get_trace(timeout=70, start=40))
# with open("test.vec", "w") as f:
#     f.write(fc.generate_test_vectors(fc.get_trace(timeout=70, start=40)))
