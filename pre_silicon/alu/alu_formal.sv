module alu_formal(
	input [3:0] X,
	input [3:0] Y,
	input [1:0] F,
	output [3:0] XY,

	input X0,
	input X1,
	input X2,
	input X3,

	input Y0,
	input Y1,
	input Y2,
	input Y3,

	input F0,
	input F1,

	output XY0,
	output XY1,
	output XY2,
	output XY3
);

`ifndef COVER_MODE
`DUT_NAME dut(.*);
`endif

always @* begin
	assume(X == { X3, X2, X1, X0 });
	assume(Y == { Y3, Y2, Y1, Y0 });
	assume(F == { F1, F0 });
	assume(XY == { XY3, XY2, XY1, XY0 });

	case (F)
		0: assert(XY === X + Y);
		1: assert(XY === X - Y);
		2: assert(XY === X * 4'h2);
		3: assert(XY === 0);
	endcase
end

endmodule
