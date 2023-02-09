# Pre-silicon RTL design and verification collateral

This folder contains some designs and testbenches used in the development of
our D2 chip design project. Most testbenches are formal testbenches, stored in
`.sby` config files and corresponding `.sv` property files. Designs were
manually translated from Verilog to gate level representations because of
coursework requirements, and there are some formal equivalence checking
testbenches for these.

To run the tests, you need the following:

- To be on a linux machine with make, bash etc
- A custom yosys build with support for covering enable signals
	- https://github.com/georgerennie/yosys/tree/cover_precond
	- Note that this will be merged with https://github.com/YosysHQ/yosys/pull/2995
- SymbiYosys for formal testbenches:
	- https://github.com/YosysHQ/SymbiYosys
- Icarus Verilog for directed testbenches

To run the full test suite, run `make all`.
To update the schematic file, replace `TEAMF_DESIGN.v` with a new export from
s-edit.
