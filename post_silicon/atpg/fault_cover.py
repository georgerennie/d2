from typing import DefaultDict, List, Iterable, Tuple, Dict
from pysmt.shortcuts import Symbol, FreshSymbol, Not, Or
from pysmt.solvers.solver import Model
from collections import defaultdict

from netlist import Netlist, Net
from transition_system import TransitionSystem
from cover_bmc import CoverBMC


class FaultCover(Netlist):
    def __init__(
        self, top_json_path: str, lib_json_path: str, output_nets: Iterable[str]
    ):
        super().__init__(top_json_path, lib_json_path)

        self.nets = self.get_tfi(map(self.net_from_name, output_nets))
        self.ts, excess = self.get_driver_system(self.nets)
        assert len(excess) == 0

        self.ports = [
            net for net in self.nets if self.name_from_net(net) in self.top.ports
        ]

        self.covers: List[Tuple[Symbol, TransitionSystem]] = []

    def cover_observability(
        self, fault_ts: TransitionSystem, fault_nets: Iterable[Net]
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

        primary_outputs = [
            net
            for net in tfo
            if self.name_from_net(net) in self.top.ports
            and self.top.ports[self.name_from_net(net)].direction == "output"
        ]

        observation_points = []
        for output in primary_outputs:
            assert output not in subs
            outer_output = FreshSymbol(self.symb_map[output].symbol_type())
            self.ts.add_variable(outer_output)
            subs[self.symb_map[output]] = outer_output

            # Try to observe a point where the output of golden and fault models
            # diverges
            observation_points.append(Not(self.symb_map[output].Iff(outer_output)))

        self.covers.append((Or(observation_points), fan_out_system.map_symbols(subs)))

    def cover_stuck_at(self, net: Net, value: bool):
        symb = self.symb_map[net]
        condition = symb if value else Not(symb)
        fault_ts = TransitionSystem({symb}, [], [condition])
        return self.cover_observability(fault_ts, [net])

    def get_trace(self, timeout: int = 5) -> Tuple[Model, int]:
        reachable_covers = []
        reachable_ts = self.ts

        for cover, fault_ts in self.covers:
            model, _ = CoverBMC(self.ts + fault_ts).generate_trace([cover], timeout)
            if model:
                reachable_covers.append(cover)
                reachable_ts += fault_ts

        print(len(reachable_covers))
        return CoverBMC(reachable_ts).generate_trace(reachable_covers)

    def generate_test_vectors(self, trace: Tuple[Model, int]):
        model, t = trace

        test_vectors = "<PinDef>\n\t"
        test_vectors += ",".join(map(self.name_from_net, self.ports))
        test_vectors += "\n</PinDef>\n<TestVector>\n"

        for i in range(t + 1):
            test_vectors += "\t"
            test_vectors += "".join(
                str(
                    int(
                        model.get_py_value(
                            TransitionSystem.at_time(self.symb_map[port], i)
                        )
                    )
                )
                for port in self.ports
            )
            test_vectors += "\n"

        test_vectors += "</TestVector>"
        return test_vectors


fc = FaultCover(
    "design/TEAMF_DESIGN.json",
    "design/d2lib.json",
    # ["Q2", "Q3", "Q4", "Q5"]
    # ["Q17", "Q18", "Q19", "Q20", "Q21", "Q22", "Q23"]
    # ["Q6", "Q7"]
    # ["Q13"]
    ["Q8", "Q9", "Q10", "Q11", "Q12", "Q13", "Q14", "Q15", "Q16"]
)

fc.ts.add_init(Not(fc.symb_map[fc.net_from_name("A14")]))

print(len(fc.nets))
nets = list(fc.nets)

# for net in fc.nets:
    # for i in [28, 29, 30, 34, 37]:
    # for i in range(25):
    # net = nets[i]
    # print(fc.name_from_net(net))
    # fc.cover_stuck_at(net, False)
    # fc.cover_stuck_at(net, True)

fc.cover_stuck_at(fc.net_from_name("TEAMF_CLOCK_SEQ_1.min1_1"), False)

with open("test.vec", "w") as f:
    f.write(fc.generate_test_vectors(fc.get_trace(timeout=10)))
