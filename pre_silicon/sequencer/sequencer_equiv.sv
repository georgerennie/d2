module sequencer_equiv;

wire Clock, nReset, Tick, SyncMinIn, SyncHourIn;

wire [3:0] gold_D, gate_D;
wire [3:0] gold_Digit, gate_Digit;
wire       gold_DP, gate_DP;

wire       gold_hour10, gate_hour10;
wire [3:0] gold_hour1, gate_hour1;
wire [2:0] gold_min10, gate_min10;
wire [3:0] gold_min1, gate_min1;

sequencer gold(
	.D(gold_D),
	.Digit(gold_Digit),
	.DP(gold_DP),

	.hour10(gold_hour10),
	.hour1(gold_hour1),
	.min10(gold_min10),
	.min1(gold_min1),

	.*
);

TEAMF_CLOCK_SEQ_WRAPPER gate(
	.D0(gate_D[0]),
	.D1(gate_D[1]),
	.D2(gate_D[2]),
	.D3(gate_D[3]),
	.Digit1(gate_Digit[3]),
	.Digit2(gate_Digit[2]),
	.Digit3(gate_Digit[1]),
	.Digit4(gate_Digit[0]),
	.DP(gate_DP),

	.hour10(gate_hour10),
	.hour1(gate_hour1),
	.min10(gate_min10),
	.min1(gate_min1),

	.*
);

always @* begin
	prop_0: assume(gold_D == gate_D);
	prop_1: assume(gold_Digit == gate_Digit);
	prop_2: assume(gold_DP == gate_DP);

	prop_3: assume(gold_hour10 == gate_hour10);
	prop_4: assume(gold_hour1 == gate_hour1);
	prop_5: assume(gold_min10 == gate_min10);
	prop_6: assume(gold_min1 == gate_min1);
end

endmodule
