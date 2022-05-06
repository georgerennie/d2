# Replace with correct SymbiYosys invocation
# SBY := csby -j12
SBY := sby

# Replace with correct yosys invocation
YOSYS := yosys

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD := ${ROOT_DIR}/build

.PHONY: all, clean, alu, sequencer, sev_seg, \
	alu_formal, alu_equiv, \
	sequencer_formal, sequencer_equiv, \
	sev_seg_formal, sev_seg_equiv, sev_seg_print_tb

all: alu sequencer sev_seg
alu: alu_formal alu_equiv
sequencer: sequencer_formal sequencer_equiv
sev_seg: sev_seg_formal sev_seg_equiv sev_seg_print_tb

clean:
	rm ${BUILD} -r

# SBY tasks
%: */%.sby
	cd $(shell dirname $<); \
	${SBY} -f --prefix ${BUILD}/$@ $@.sby

# Yosys tasks
%: */%.ys
	cd $(shell dirname $<); \
	${YOSYS} $@.ys

sev_seg_print_tb:
	cd sev_seg; \
	bash sev_seg_print_tb.sh
