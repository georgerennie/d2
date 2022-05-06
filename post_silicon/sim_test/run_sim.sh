#! /usr/bin/env bash

DIR=`dirname "$0"`
iverilog -o $DIR/test.vvp $DIR/d2lib.v $DIR/TEAMF_DESIGN.v $1 &&
	vvp -n $DIR/test.vvp
