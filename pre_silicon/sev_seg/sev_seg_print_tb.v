`include "../d2lib.v"
`include "../TEAMF_DESIGN.v"
`include "../TEAMF_DESIGN_WRAPPER.v"

module sev_seg_print_tb;

reg [3:0] data;
wire [6:0] seg;
wire SegA, SegB, SegC, SegD, SegE, SegF, SegG;

assign { SegA, SegB, SegC, SegD, SegE, SegF, SegG } = seg;

TEAMF_SEV_SEG_WRAPPER DUT(.*);

initial begin
	for (integer i = 0; i < 10; i = i + 1) begin
		$display("Testing data = %0d:", i);
		data = i;
		#100 print_digit();
	end
end

task print_digit;
	if (SegA) $write("\n");
	else      $write("---\n");

	if (SegF) $write("  ");
	else      $write("| ");

	if (SegB) $write("\n");
	else      $write("|\n");

	if (SegG) $write("\n");
	else      $write("---\n");

	if (SegE) $write("  ");
	else      $write("| ");

	if (SegC) $write("\n");
	else      $write("|\n");

	if (SegD) $write("\n");
	else      $write("---\n");
endtask

endmodule
