from __future__ import annotations
from typing import List, Dict, Set, Optional
from pysmt.shortcuts import Symbol, And, FreshSymbol


class TransitionSystem:
    """Trivial representation of a Transition System."""

    def __init__(
        self,
        variables: Optional[Set[Symbol]] = None,
        init: Optional[List[Symbol]] = None,
        trans: Optional[List[Symbol]] = None,
    ):
        self._variables = variables or set()
        self._init = init or []
        self._trans = trans or []

    def add_variable(self, variable: Symbol):
        """Add a variable to the set in the transition system"""
        self._variables.add(variable)

    def add_init(self, init_constraint: Symbol):
        """Add an initial property"""
        self._init.append(init_constraint)

    def add_trans(self, trans_constraint: Symbol):
        """Add a transition property"""
        self._init.append(trans_constraint)

    @staticmethod
    def next_symb(s: Symbol) -> Symbol:
        """Returns the 'next' of the given symbol"""
        return Symbol(f"next({s.symbol_name()})", s.symbol_type())

    @staticmethod
    def at_time(s: Symbol, t: int) -> Symbol:
        """Builds an SMT symbol representing s at time t"""
        return Symbol(f"{s.symbol_name()}@{t}", s.symbol_type())

    def variables(self) -> Set[Symbol]:
        """Get a set of the symbols in the system"""
        return self._variables

    def init(self) -> Symbol:
        """Get a symbol representing the initial state"""
        return And(self._init)

    def trans(self) -> Symbol:
        """Get a symbol representing the state transition"""
        return And(self._trans)

    def merge_system(self, other: TransitionSystem, subs: Dict[Symbol, Symbol]):
        """
        Map a second transition system into part of this one, assigning
        variables from subs. Any variables in other but not in subs are replaced
        with fresh symbols.
        """
        new_system = other.map_symbols(subs)
        self._variables.update(new_system._variables)
        self._init += new_system._init
        self._trans += new_system._trans

    def map_symbols(self, subs: Dict[Symbol, Symbol]):
        """
        Substitutes symbols according to subs. Any variables that dont appear
        in subs are replaced with fresh symbols.
        """
        new_variables = set()

        for v in self._variables:
            if v not in subs.keys():
                symb = FreshSymbol(v.symbol_type())
                new_variables.add(symb)
                subs[v] = symb
                subs[self.next_symb(v)] = self.next_symb(symb)
            else:
                new_variables.add(subs[v])
                subs[self.next_symb(v)] = self.next_symb(subs[v])

        return TransitionSystem(
            new_variables,
            [self.init().substitute(subs)],
            [self.trans().substitute(subs)],
        )

    def __add__(self, other: TransitionSystem):
        return TransitionSystem(
            self._variables.union(other._variables),
            self._init + other._init,
            self._trans + other._trans,
        )
