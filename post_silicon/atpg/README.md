# D2 Post Silicon Validation

This folder contains scripts I developed for automatic test pattern generation
using SAT to test for stuck-at and bridge faults.

The rough idea behind this ATPG technique is to construct multiple copies of
the design, one with no faults, and the others with one fault introduced each.
We then constrain the inputs to be the same and the outputs for the faulty
netlists to differ from the fault-free netlist in at least one clock cycle.
We then use a custom implemented bounded model checker to check these
properties, increasing the length until we find a trace. These traces thus
correspond to sets of inputs that would cause these faults to be observable at
the output, so are usable as test vectors.

With this technique, we were able to get 100% fault coverage on the
combinational designs. The 24-hour clock sequencer had a greater sequential
depth and some faults could take 60+ cycles to propagate to outputs. Therefore
we ran all individual faults separately with a limit of 5 cycles, and grouped
all faults that could be reached in that time into subgroups of 15 faults. We
then generated traces for these subgroups, and combined them into one long
test vector, achieving 80% coverage. This technique could be improved greatly,
and easily reach near 100% coverage, however we had very limited time to write
these scripts before a coursework submission deadline. No other teams wrote
any automated scripts to check for faults, most simply wrote a small number of
hand written fault tests with poor coverage.
