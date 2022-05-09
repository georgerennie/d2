#! /usr/bin/env python3

from pathlib import Path
import itertools
from typing import Iterable
from fault_cover import FaultCover
from pysmt.shortcuts import Not


class D2CoverAll(FaultCover):
    def __init__(self, test_name: str, output_nets: Iterable[str], start: int = 0):
        print(f"Creating test {test_name}")
        super().__init__(
            "design/TEAMF_DESIGN.json",
            "design/d2lib.json",
            output_nets,
            ["A13"],  # Clock
        )

        # Start in reset
        self.ts.add_init(Not(self.sym("A14")))

        clk_rst = list(map(self.net_from_name, ["A13", "A14"]))

        # Cover all stuck-ats that arent ties or clock/reset
        for net in self.nets:
            if net in clk_rst:
                continue

            tie0 = False
            tie1 = False

            if net in self.source_map:
                cell_type = self.top.cells[self.source_map[net]].type
                tie0 = cell_type == "TIE0"
                tie1 = cell_type == "TIE1"

            if not tie0:
                self.cover_stuck_at(net, False)
            if not tie1:
                self.cover_stuck_at(net, True)

        # Cover all bridges between I/O pins except clk/rst pins
        for (a, b) in itertools.combinations(self.ports, 2):
            self.cover_io_bridge(a, b)

        fault_dir = Path("fault_vectors")
        fault_dir.mkdir(parents=True, exist_ok=True)

        with open(fault_dir / Path(test_name + ".vec"), "w") as f:
            trace = self.get_trace(timeout=10, start=start)
            vectors = self.generate_test_vectors(trace)
            f.write(vectors)


D2CoverAll("alu_fault", ["Q2", "Q3", "Q4", "Q5"], 4)
D2CoverAll("button_sync_fault", ["Q6", "Q7"], 6)
D2CoverAll("sev_seg_fault", ["Q17", "Q18", "Q19", "Q20", "Q21", "Q22", "Q23"], 5)
