from typing import DefaultDict, List, Iterable, Tuple
from pysmt.shortcuts import Symbol, FreshSymbol, Not, Or
from pysmt.solvers.solver import Model
from collections import defaultdict

from netlist import Netlist, Net
from transition_system import TransitionSystem
from cover_bmc import CoverBMC


class FaultCover(Netlist):
    def __init__(self, top_json_path: str, lib_json_path: str, output_nets: Iterable[str]):
        super().__init__(top_json_path, lib_json_path)
        self.nets = self.get_tfi(map(self.net_from_name, output_nets))
        self.ts, excess = self.get_driver_system(self.nets)
        assert len(excess) == 0
        self.covers: List[Symbol] = []

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

        self.covers.append(Or(observation_points))
        self.ts.merge_system(fan_out_system, subs)

    def cover_stuck_at(self, net: Net, value: bool):
        symb = self.symb_map[net]
        condition = symb if value else Not(symb)
        fault_ts = TransitionSystem({symb}, [], [condition])
        return self.cover_observability(fault_ts, [net])

    def get_trace(self, timeout: int = 5) -> Tuple[Model, int]:
        bmc = CoverBMC(self.ts)
        reachable_covers = []
        for cover in self.covers:
            model, _ = bmc.generate_trace([cover], timeout)
            if model:
                reachable_covers.append(cover)

        return bmc.generate_trace(reachable_covers)


fc = FaultCover("design/TEAMF_DESIGN.json", "design/d2lib.json", ["Q2", "Q3", "Q4", "Q5"])
# fc = FaultCover("design/TEAMF_DESIGN.json", "design/d2lib.json", ["Q17", "Q18", "Q19", "Q20", "Q21", "Q22", "Q23"])
# fc = FaultCover("design/TEAMF_DESIGN.json", "design/d2lib.json", ["Q13"])
for net in fc.nets:
    fc.cover_stuck_at(net, False)
    fc.cover_stuck_at(net, True)

fc.get_trace()

"""
To make this faster:
- Only feed the fault logic to the BMC for queries where it is needed
- Parralelise individual fault checks
"""
