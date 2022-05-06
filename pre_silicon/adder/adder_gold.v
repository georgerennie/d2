module adder_gold(
	input A,
	input B,
	input Cin,
	output Sum,
	output Cout
);

assign { Cout, Sum } = A + B + Cin;

endmodule
