module sev_seg_formal(
	input [3:0] data,
	output [6:0] seg // segA-segG
);


sev_seg dut(.*);

always @* begin
	assume(data < 10);

	case (data)
		4'h0 : assert(seg === 7'b0000001);
		4'h1 : assert(seg === 7'b1001111);
		4'h2 : assert(seg === 7'b0010010);
		4'h3 : assert(seg === 7'b0000110);
		4'h4 : assert(seg === 7'b1001100);
		4'h5 : assert(seg === 7'b0100100);
		4'h6 : assert(seg === 7'b0100000);
		4'h7 : assert(seg === 7'b0001111);
		4'h8 : assert(seg === 7'b0000000);
		4'h9 : assert(seg === 7'b0000100);
	endcase
end

endmodule
