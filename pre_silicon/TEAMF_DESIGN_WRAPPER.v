module TEAMF_ALU_WRAPPER(
	input [3:0] X,
	input [3:0] Y,
	input [1:0] F,
	output reg [3:0] XY
);

TEAMF_DESIGN d(
	.A3(F[0]),
	.A4(F[1]),

	.A5(X[0]),
	.A6(X[1]),
	.A7(X[2]),
	.A8(X[3]),

	.A9(Y[0]),
	.A10(Y[1]),
	.A11(Y[2]),
	.A12(Y[3]),

	.Q2(XY[0]),
	.Q3(XY[1]),
	.Q4(XY[2]),
	.Q5(XY[3])
);
endmodule

module TEAMF_CLOCK_SEQ_WRAPPER(
	input Tick,
	input SyncMinIn,
	input SyncHourIn,
	input Clock,
	input nReset,

`ifdef SEQ_EXPOSE_INT
	output [3:0] min1,
	output [2:0] min10,
	output [3:0] hour1,
	output hour10,
`endif

	output Digit1,
	output Digit2,
	output Digit3,
	output Digit4,
	output DP,

	output D0,
	output D1,
	output D2,
	output D3
);

TEAMF_DESIGN d(
	.A13(Clock),
	.A14(nReset),
	.A17(Tick),

	.A18(SyncMinIn),
	.A19(SyncHourIn),

`ifdef SEQ_EXPOSE_INT
	.TEAMF_CLOCK_SEQ_1.min1_0(min1[0]),
	.TEAMF_CLOCK_SEQ_1.min1_1(min1[1]),
	.TEAMF_CLOCK_SEQ_1.min1_2(min1[2]),
	.TEAMF_CLOCK_SEQ_1.min1_3(min1[3]),

	.TEAMF_CLOCK_SEQ_1.min10_0(min10[0]),
	.TEAMF_CLOCK_SEQ_1.min10_1(min10[1]),
	.TEAMF_CLOCK_SEQ_1.min10_2(min10[2]),

	.TEAMF_CLOCK_SEQ_1.hour1_0(hour1[0]),
	.TEAMF_CLOCK_SEQ_1.hour1_1(hour1[1]),
	.TEAMF_CLOCK_SEQ_1.hour1_2(hour1[2]),
	.TEAMF_CLOCK_SEQ_1.hour1_3(hour1[3]),

	.TEAMF_CLOCK_SEQ_1.hour10(hour10),
`endif

	.Q8(Digit1),
	.Q9(Digit2),
	.Q10(Digit3),
	.Q11(Digit4),
	.Q12(DP),

	.Q13(D0),
	.Q14(D1),
	.Q15(D2),
	.Q16(D3)
);

endmodule

module TEAMF_SEV_SEG_WRAPPER(
	input [3:0] data,
	output [6:0] seg // segA-segG
);

TEAMF_DESIGN d(
	.A20(data[0]),
	.A21(data[1]),
	.A22(data[2]),
	.A23(data[3]),

	.Q17(seg[6]),
	.Q18(seg[5]),
	.Q19(seg[4]),
	.Q20(seg[3]),
	.Q21(seg[2]),
	.Q22(seg[1]),
	.Q23(seg[0])
);

endmodule
