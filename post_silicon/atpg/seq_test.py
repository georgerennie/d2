#! /usr/bin/env python3

from pathlib import Path
import itertools
from typing import Iterable
from fault_cover import FaultCover
from pysmt.shortcuts import Not


class D2SeqTest(FaultCover):
    def __init__(self, test_name: str):
        """
        This implementation is a long way from ideal, it is slow and doesn't get
        super high coverage. That's life, this code was rushed to a deadline.
        Could be improved by more effectively utilising things like the fact
        that bridge properties generally prove fast and dont need to be covered
        to check viability of putting them in chunks.
        """

        print(f"Creating test {test_name}")

        super().__init__(
            "design/TEAMF_DESIGN.json",
            "design/d2lib.json",
            ["Q8", "Q9", "Q10", "Q11", "Q12", "Q13", "Q14", "Q15", "Q16"],  # Outputs
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

        short_covers = self.get_short_covers(timeout=5)
        # print(short_covers)

        print(f"{len(self.covers)} covers, {len(short_covers)} short covers")
        print(f"{len(short_covers) / len(self.covers)} coverage")

        test_vectors = self.generate_test_vector_header()

        chunk_size = 15
        chunks = list(zip(*(iter(short_covers),) * chunk_size))
        for i, chunk in enumerate(chunks):
            print(f"Covering chunk {i + 1} of {len(chunks)}")
            trace = self.get_subset_trace(chunk, timeout=15, start=4)
            test_vectors += self.generate_test_vector_body(trace)

        test_vectors += self.generate_test_vector_end()

        fault_dir = Path("fault_vectors")
        fault_dir.mkdir(parents=True, exist_ok=True)

        with open(fault_dir / Path(test_name + ".vec"), "w") as f:
            f.write(test_vectors)


D2SeqTest("seq_fault")
