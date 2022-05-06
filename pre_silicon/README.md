# This folder contains a number of tests and scripts used when designing our
# D2 project

To run the tests, you need the following:

- To be on a linux machine with make, bash etc
- A custom yosys build for synthesis/equivalence checking/formal verification:
	- https://github.com/georgerennie/yosys/tree/cover_precond
- SymbiYosys for formal testbenches:
	- https://github.com/YosysHQ/SymbiYosys
- Icarus Verilog for directed testbenches

To run the full test suite, run `make all`.
To update the schematic file, replace `TEAMF_DESIGN.v` with a new export from
s-edit.
