from __future__ import annotations
from typing import List, Dict, Set
from pysmt.shortcuts import Symbol, And, FreshSymbol

class TransitionSystem():
    """Trivial representation of a Transition System."""
    def __init__(self, variables: Set[Symbol], init: List[Symbol], trans: List[Symbol]):
        self.variables = variables
        self._init = init
        self._trans = trans

    def add_variable(self, variable: Symbol):
        """Add a variable to the set in the transition system"""
        self.variables.add(variable)

    def add_init(self, init_constraint: Symbol):
        """Add an initial property"""
        self._init.append(init_constraint)

    def add_trans(self, trans_constraint: Symbol):
        """Add a transition property"""
        self._init.append(trans_constraint)

    @staticmethod
    def next_symb(s: Symbol):
        """Returns the 'next' of the given symbol"""
        return Symbol(f"next({s.symbol_name()})", s.symbol_type())

    @staticmethod
    def at_time(s: Symbol, t: int):
        """Builds an SMT symbol representing s at time t"""
        return Symbol(f"{s.symbol_name()}@{t}", s.symbol_type())

    def init(self):
        """Get a symbol representing the initial state"""
        return And(self._init)

    def trans(self):
        """Get a symbol representing the state transition"""
        return And(self._trans)

    def merge_system(self, other: TransitionSystem, subs: Dict[Symbol, Symbol]):
        """
        Map a second transition system into part of this one, assigning
        variables from subs. Any variables in other but not in subs are replaced
        with fresh symbols.
        """
        self.variables.update(set(subs.values()))

        for v in other.variables:
            if v not in subs.keys():
                symb = FreshSymbol(v.symbol_type())
                self.variables.add(symb)
                subs[v] = symb
                subs[self.next_symb(v)] = self.next_symb(symb)
            else:
                subs[self.next_symb(v)] = self.next_symb(subs[v])

        self._init.append(other.init().substitute(subs))
        self._trans.append(other.trans().substitute(subs))
