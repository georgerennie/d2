"""
A bounded model checker that generates a trace covering a set of
properties during its execution
Adapted from https://github.com/pysmt/pysmt/blob/master/examples/model_checking.py
"""

from typing import List
import itertools
from pysmt.shortcuts import get_model, And, Or, Symbol, Solver
from pysmt.logics import QF_BV
from transition_system import TransitionSystem

class CoverBMC:
    """Bounded model checker that generates traces covering a set of properties"""
    def __init__(self, system: TransitionSystem, solver: str = "yices", logic = QF_BV):
        self.system = system
        self.solver = solver
        self.logic = logic

    def get_subs(self, t: int):
        """Builds a map from x to x@t and from x' to x@(t+1), for all x in system"""
        subs_t = {}
        for v in self.system.variables:
            subs_t[v] = TransitionSystem.at_time(v, t)
            subs_t[TransitionSystem.next_symb(v)] = TransitionSystem.at_time(v, t + 1)
        return subs_t

    def unwind_covers(self, covers: List[Symbol], t: int):
        """
        Unrolls the cover statements over a number of time steps, requiring
        each cover to be true in at least one time step
        """
        return And(
            Or(cover.substitute(self.get_subs(i)) for i in range(t + 1))
            for cover in covers
        )

    def generate_trace(self, covers: List[Symbol]):
        """
        Find a concrete trace from the initial state that covers all cover
        properties. Returns a pysmt model that can be probed for values, and
        the final timestep
        """
        with Solver(name=self.solver, logic=self.logic, incremental=True, generate_models=True) as s:
            # Initial state
            s.add_assertion(self.system.init().substitute(self.get_subs(0)))

            for t in itertools.count():
                # Transition relation
                s.add_assertion(self.system.trans().substitute(self.get_subs(t)))

                print(f"[CoverBMC] Checking step {t}...")
                # Solve in relation to covers
                if s.solve(self.unwind_covers(covers, t)):
                    print(f"[CoverBMC] All properties covered by end of step {t}")
                    return s.get_model(), t
