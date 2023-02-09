module sequencer_equiv;

wire Clock, nReset, Tick, SyncMinIn, SyncHourIn;

wire [3:0] gold_D, gate_D;
wire [3:0] gold_Digit, gate_Digit;
wire       gold_DP, gate_DP;

sequencer gold(
	.D(gold_D),
	.Digit(gold_Digit),
	.DP(gold_DP),
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
	.*
);

always @* begin
	as__D_eq: assert(gold_D == gate_D);
	as__Digit_eq: assert(gold_Digit == gate_Digit);
	as__DP_eq: assert(gold_DP == gate_DP);
end

endmodule
