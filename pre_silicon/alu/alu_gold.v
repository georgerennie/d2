module alu_gold(
	input [3:0] X,
	input [3:0] Y,
	input [1:0] F,
	output reg [3:0] XY
);

wire [3:0] adder = X + (F[0] ? -Y : Y);

always @* begin
	case (F)
		0, 1: XY = adder;
		2: XY = X << 1;
		3: XY = 0;
	endcase
end

endmodule
