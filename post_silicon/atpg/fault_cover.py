from typing import DefaultDict, List, Iterable, Tuple, Dict, Set
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

        # Dict from name to cover
        self.covers: Dict[str, Tuple[Symbol, TransitionSystem]] = {}

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

        assert fault_name not in self.covers
        self.covers[fault_name] = (
            Or(observation_points),
            fan_out_system.map_symbols(subs),
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
        fault_name = f"bridge({self.name_from_net(net_1)}, {self.name_from_net(net_2)})"
        assert fault_name not in self.covers
        self.covers[fault_name] = (condition, TransitionSystem())

    def get_trace(self, timeout: int = 20, start: int = 0) -> Tuple[Model, int]:
        covers: List[Symbol] = []
        cover_ts = self.ts

        for cover, fault_ts in self.covers.values():
            covers.append(cover)
            cover_ts += fault_ts

        return CoverBMC(cover_ts).generate_trace(covers, timeout=timeout, start=start)

    def get_subset_trace(
        self, cover_names: Iterable[str], timeout: int = 20, start: int = 0
    ) -> Tuple[Model, int]:
        covers: List[Symbol] = []
        cover_ts = self.ts

        for name in cover_names:
            cover, fault_ts = self.covers[name]
            covers.append(cover)
            cover_ts += fault_ts

        return CoverBMC(cover_ts).generate_trace(covers, timeout=timeout, start=start)

    def get_short_covers(self, timeout: int = 5) -> Set[str]:
        short_covers = set()
        for cover_name, (cover, fault_ts) in self.covers.items():
            print(f"Checking {cover_name}")
            model, _ = CoverBMC(self.ts + fault_ts).generate_trace(
                [cover], timeout=timeout, start=0
            )
            if model:
                short_covers.add(cover_name)
        return short_covers

    def generate_test_vector_header(self) -> str:
        header = "<PinDef>\n\t"
        header += ",".join(map(self.name_from_net, self.ports))
        header += "\n</PinDef>\n<TestVector>\n"
        return header

    def generate_test_vector_end(self) -> str:
        return "</TestVector>"

    def generate_test_vector_body(self, trace: Tuple[Model, int]) -> str:
        model, t = trace
        test_vectors = "\t# New trace\n"
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
        return test_vectors

    def generate_test_vectors(self, trace: Tuple[Model, int]) -> str:
        test_vectors = self.generate_test_vector_header()
        test_vectors += self.generate_test_vector_body(trace)
        test_vectors += self.generate_test_vector_end()
        return test_vectors

    def sym(self, name: str) -> Symbol:
        return self.symb_map[self.net_from_name(name)]
