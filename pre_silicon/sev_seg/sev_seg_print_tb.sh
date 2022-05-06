#!/usr/bin/env bash

BIN=sev_seg_print_tb_tmp
EXPECTED=sev_seg_print_tb_expected.log
LOG=sev_seg_print_tb_actual.log

cd `dirname "$0"`

set -x -e

iverilog -g2012 -o $BIN sev_seg_print_tb.v
vvp $BIN > $LOG

set +x
if cmp -s "$LOG" "$EXPECTED"; then
	echo -e "\033[0;32mPASS: sev_seg_print_tb\033[0;0m"
else
	echo -e "\033[0;33mExpected output:\033[0;0m"
	cat $EXPECTED
	echo -e "\033[0;33mActual output:\033[0;0m"
	cat $LOG
	echo -e "\033[0;31m!!!sev_seg_print_tb output differed from expected!!!\033[0m"
	exit 1
fi
set -x

rm $BIN $LOG
