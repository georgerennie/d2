// Verilog netlist created by S-Edit 2018.3.1
// Written on Mon Oct 25 22:07:14 2021

// Library:               TEAMF_Schematics1
// Cell:                  TEAMF_DESIGN
// View name:             schematic1
// Design path:           \\filestore.soton.ac.uk\users\ss8g20\mydocuments\D2\Schematics\TEAMF_Schematics1
// Control property name(s): VERILOG
// Exclude global pins on subcircuits: <yes>



module TEAMF_FULLADDER(
	A,
	B,
	Cin,
	Cout,
	Sum
);
input A;
input B;
input Cin;
output Cout;
output Sum;

wire N_1;
wire N_2;
wire N_3;

NAND2 NAND2_1(
	.A(Cin),
	.B(A),
	.Q(N_3)
);
NAND2 NAND2_2(
	.A(B),
	.B(N_1),
	.Q(N_2)
);
NAND2 NAND2_3(
	.A(N_2),
	.B(N_3),
	.Q(Cout)
);
XOR2 XOR2_1(
	.A(A),
	.B(Cin),
	.Q(N_1)
);
XOR2 XOR2_2(
	.A(N_1),
	.B(B),
	.Q(Sum)
);
endmodule // TEAMF_FULLADDER


module TEAMF_FULLADDER_NO_Cout(
	A,
	B,
	Cin,
	Sum
);
input A;
input B;
input Cin;
output Sum;

wire N_1;

XOR2 XOR2_1(
	.A(A),
	.B(B),
	.Q(N_1)
);
XOR2 XOR2_2(
	.A(N_1),
	.B(Cin),
	.Q(Sum)
);
endmodule // TEAMF_FULLADDER_NO_Cout


module TEAMF_ALU(
	F0,
	F1,
	X0,
	X1,
	X2,
	X3,
	XY0,
	XY1,
	XY2,
	XY3,
	Y0,
	Y1,
	Y2,
	Y3
);
input F0;
input F1;
input X0;
input X1;
input X2;
input X3;
output XY0;
output XY1;
output XY2;
output XY3;
input Y0;
input Y1;
input Y2;
input Y3;

wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;

MUX2 MUX2_1(
	.A(N_6),
	.B(N_15),
	.Q(XY0),
	.S(F1)
);
MUX2 MUX2_2(
	.A(X0),
	.B(N_16),
	.Q(N_1),
	.S(F0)
);
MUX2 MUX2_3(
	.A(N_9),
	.B(N_1),
	.Q(XY1),
	.S(F1)
);
MUX2 MUX2_4(
	.A(X1),
	.B(N_16),
	.Q(N_2),
	.S(F0)
);
MUX2 MUX2_5(
	.A(N_11),
	.B(N_2),
	.Q(XY2),
	.S(F1)
);
MUX2 MUX2_6(
	.A(X2),
	.B(N_16),
	.Q(N_3),
	.S(F0)
);
MUX2 MUX2_7(
	.A(N_14),
	.B(N_3),
	.Q(XY3),
	.S(F1)
);
TEAMF_FULLADDER TEAMF_FULLADDER_1(
	.A(X0),
	.B(N_4),
	.Cin(F0),
	.Cout(N_5),
	.Sum(N_6)
);
TEAMF_FULLADDER TEAMF_FULLADDER_2(
	.A(X1),
	.B(N_7),
	.Cin(N_5),
	.Cout(N_8),
	.Sum(N_9)
);
TEAMF_FULLADDER TEAMF_FULLADDER_3(
	.A(X2),
	.B(N_10),
	.Cin(N_8),
	.Cout(N_13),
	.Sum(N_11)
);
TEAMF_FULLADDER_NO_Cout TEAMF_FULLADDER_NO_Cout_2(
	.A(X3),
	.B(N_12),
	.Cin(N_13),
	.Sum(N_14)
);
TIE0 TIE0_1(
	.Q(N_15)
);
TIE0 TIE0_4(
	.Q(N_16)
);
XOR2 XOR2_1(
	.A(Y0),
	.B(F0),
	.Q(N_4)
);
XOR2 XOR2_2(
	.A(Y1),
	.B(F0),
	.Q(N_7)
);
XOR2 XOR2_3(
	.A(Y2),
	.B(F0),
	.Q(N_10)
);
XOR2 XOR2_4(
	.A(Y3),
	.B(F0),
	.Q(N_12)
);
endmodule // TEAMF_ALU


module TEAMF_SEV_SEG(
	D0In,
	D1In,
	D2In,
	D3In,
	SegA,
	SegB,
	SegC,
	SegD,
	SegE,
	SegF,
	SegG
);
input D0In;
input D1In;
input D2In;
input D3In;
output SegA;
output SegB;
output SegC;
output SegD;
output SegE;
output SegF;
output SegG;

wire D0_INV;
wire D0_XNR_D1;
wire D1_INV;
wire D2_INV;
wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;

INV1 INV1_1(
	.A(D0In),
	.Q(D0_INV)
);
INV1 INV1_2(
	.A(D1In),
	.Q(D1_INV)
);
INV1 INV1_3(
	.A(D2In),
	.Q(D2_INV)
);
INV1 INV1_4(
	.A(N_10),
	.Q(N_2)
);
INV1 INV1_5(
	.A(N_9),
	.Q(N_4)
);
NAND2 NAND2_1(
	.A(D2In),
	.B(D0_XNR_D1),
	.Q(N_1)
);
NAND2 NAND2_2(
	.A(N_1),
	.B(N_2),
	.Q(SegD)
);
NAND2 NAND2_3(
	.A(D0_INV),
	.B(N_3),
	.Q(SegE)
);
NAND2 NAND2_4(
	.A(D1_INV),
	.B(D2In),
	.Q(N_3)
);
NAND2 NAND2_5(
	.A(N_4),
	.B(N_5),
	.Q(SegG)
);
NAND3 NAND3_1(
	.A(D0In),
	.B(D1In),
	.C(D2In),
	.Q(N_5)
);
NOR2 NOR2_1(
	.A(D0_INV),
	.B(D1_INV),
	.Q(N_6)
);
NOR2 NOR2_2(
	.A(N_6),
	.B(D2_INV),
	.Q(N_7)
);
NOR2 NOR2_3(
	.A(D0In),
	.B(D1In),
	.Q(N_8)
);
NOR3 NOR3_1(
	.A(N_11),
	.B(D1In),
	.C(D3In),
	.Q(SegA)
);
NOR3 NOR3_2(
	.A(D0_XNR_D1),
	.B(D2_INV),
	.C(D3In),
	.Q(SegB)
);
NOR3 NOR3_3(
	.A(N_7),
	.B(D3In),
	.C(N_8),
	.Q(SegF)
);
NOR3 NOR3_4(
	.A(D1In),
	.B(D2In),
	.C(D3In),
	.Q(N_9)
);
NOR4 NOR4_1(
	.A(D0In),
	.B(D1_INV),
	.C(D2In),
	.D(D3In),
	.Q(SegC)
);
NOR4 NOR4_2(
	.A(D0_INV),
	.B(D1In),
	.C(D2In),
	.D(D3In),
	.Q(N_10)
);
XNR2 XNR2_1(
	.A(D0In),
	.B(D2In),
	.Q(N_11)
);
XNR2 XNR2_2(
	.A(D0In),
	.B(D1In),
	.Q(D0_XNR_D1)
);
endmodule // TEAMF_SEV_SEG


module TEAMF_CLOCK_SEQ(
	Clock,
	D0,
	D1,
	D2,
	D3,
	DP,
	Digit1,
	Digit2,
	Digit3,
	Digit4,
	SyncHourIn,
	SyncMinIn,
	Tick,
	nReset
);
input Clock;
output D0;
output D1;
output D2;
output D3;
output DP;
output Digit1;
output Digit2;
output Digit3;
output Digit4;
input SyncHourIn;
input SyncMinIn;
input Tick;
input nReset;

wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;
wire N_16;
wire N_17;
wire N_18;
wire N_19;
wire N_20;
wire N_21;
wire N_22;
wire N_23;
wire N_24;
wire N_25;
wire N_26;
wire N_27;
wire N_28;
wire N_29;
wire N_30;
wire N_31;
wire N_32;
wire N_33;
wire N_34;
wire N_35;
wire N_36;
wire N_37;
wire N_38;
wire N_39;
wire N_40;
wire N_41;
wire N_42;
wire N_43;
wire N_44;
wire N_45;
wire N_46;
wire N_47;
wire N_48;
wire N_49;
wire N_50;
wire N_51;
wire N_52;
wire N_53;
wire N_54;
wire N_55;
wire N_56;
wire N_57;
wire N_58;
wire N_59;
wire N_60;
wire N_61;
wire N_62;
wire N_63;
wire N_64;
wire N_65;
wire N_66;
wire N_67;
wire N_68;
wire N_69;
wire N_70;
wire N_71;
wire N_72;
wire N_73;
wire N_74;
wire N_75;
wire N_76;
wire N_77;
wire carry_1hour;
wire carry_1min;
wire carry_10min;
wire hour1_0;
wire hour1_1;
wire hour1_2;
wire hour1_3;
wire hour10;
wire min1_0;
wire min1_1;
wire min1_2;
wire min1_3;
wire min10_0;
wire min10_1;
wire min10_2;

BUF4 BUF4_2(
	.A(N_34),
	.Q(Digit2)
);
BUF4 BUF4_3(
	.A(N_31),
	.Q(Digit3)
);
BUF4 BUF4_4(
	.A(N_35),
	.Q(Digit4)
);
BUF4 BUF4_5(
	.A(N_48),
	.Q(D0)
);
BUF4 BUF4_6(
	.A(N_43),
	.Q(D1)
);
BUF4 BUF4_7(
	.A(N_42),
	.Q(D2)
);
BUF4 BUF4_8(
	.A(N_38),
	.Q(D3)
);
DFFR DFFR_1(
	.Clk(Clock),
	.D(N_51),
	.Q(hour1_3),
	.nQ(N_1),
	.nRst(nReset)
);
DFFR DFFR_2(
	.Clk(Clock),
	.D(N_76),
	.Q(hour1_2),
	.nQ(N_2),
	.nRst(nReset)
);
DFFR DFFR_3(
	.Clk(Clock),
	.D(N_63),
	.Q(N_52),
	.nQ(hour1_1),
	.nRst(nReset)
);
DFFR DFFR_4(
	.Clk(Clock),
	.D(N_65),
	.Q(hour1_0),
	.nQ(N_3),
	.nRst(nReset)
);
DFFR DFFR_5(
	.Clk(Clock),
	.D(N_75),
	.Q(N_74),
	.nQ(hour10),
	.nRst(nReset)
);
DFFR DFFR_6(
	.Clk(Clock),
	.D(N_50),
	.Q(min10_2),
	.nQ(N_4),
	.nRst(nReset)
);
DFFR DFFR_7(
	.Clk(Clock),
	.D(N_73),
	.Q(min10_1),
	.nQ(N_5),
	.nRst(nReset)
);
DFFR DFFR_8(
	.Clk(Clock),
	.D(N_72),
	.Q(min10_0),
	.nQ(N_6),
	.nRst(nReset)
);
DFFR DFFR_9(
	.Clk(Clock),
	.D(N_49),
	.Q(min1_3),
	.nQ(N_7),
	.nRst(nReset)
);
DFFR DFFR_10(
	.Clk(Clock),
	.D(N_8),
	.Q(min1_2),
	.nQ(N_9),
	.nRst(nReset)
);
DFFR DFFR_11(
	.Clk(Clock),
	.D(N_10),
	.Q(min1_1),
	.nQ(N_11),
	.nRst(nReset)
);
DFFR DFFR_12(
	.Clk(Clock),
	.D(N_57),
	.Q(N_56),
	.nQ(N_12),
	.nRst(nReset)
);
DFFR DFFR_13(
	.Clk(Clock),
	.D(N_13),
	.Q(min1_0),
	.nQ(N_14),
	.nRst(nReset)
);
DFFR DFFR_14(
	.Clk(Clock),
	.D(N_12),
	.Q(N_57),
	.nQ(N_15),
	.nRst(nReset)
);
INV1 INV1_1(
	.A(N_24),
	.Q(N_17)
);
INV1 INV1_2(
	.A(N_20),
	.Q(N_68)
);
INV1 INV1_3(
	.A(N_18),
	.Q(N_66)
);
INV1 INV1_4(
	.A(N_22),
	.Q(N_70)
);
INV1 INV1_5(
	.A(N_41),
	.Q(N_19)
);
INV1 INV1_6(
	.A(N_26),
	.Q(N_21)
);
INV1 INV1_7(
	.A(N_60),
	.Q(N_58)
);
INV1 INV1_9(
	.A(carry_1min),
	.Q(N_61)
);
INV1 INV1_10(
	.A(N_16),
	.Q(carry_10min)
);
INV1 INV1_11(
	.A(N_39),
	.Q(N_44)
);
INV10 INV10_1(
	.A(N_34),
	.Q(DP)
);
INV10 INV10_2(
	.A(N_40),
	.Q(Digit1)
);
NAND2 NAND2_1(
	.A(min1_2),
	.B(N_17),
	.Q(N_18)
);
NAND2 NAND2_2(
	.A(min10_1),
	.B(N_19),
	.Q(N_20)
);
NAND2 NAND2_3(
	.A(hour1_2),
	.B(N_21),
	.Q(N_22)
);
NAND2 NAND2_4(
	.A(min1_1),
	.B(N_23),
	.Q(N_24)
);
NAND2 NAND2_6(
	.A(hour1_1),
	.B(N_25),
	.Q(N_26)
);
NAND2 NAND2_7(
	.A(hour1_0),
	.B(N_34),
	.Q(N_45)
);
NAND2 NAND2_8(
	.A(min10_0),
	.B(N_31),
	.Q(N_46)
);
NAND2 NAND2_9(
	.A(min1_0),
	.B(N_35),
	.Q(N_47)
);
NAND2 NAND2_10(
	.A(hour1_1),
	.B(N_34),
	.Q(N_27)
);
NAND2 NAND2_11(
	.A(min10_1),
	.B(N_31),
	.Q(N_28)
);
NAND2 NAND2_12(
	.A(min1_1),
	.B(N_35),
	.Q(N_29)
);
NAND2 NAND2_13(
	.A(hour1_2),
	.B(N_34),
	.Q(N_30)
);
NAND2 NAND2_14(
	.A(min10_2),
	.B(N_31),
	.Q(N_32)
);
NAND2 NAND2_15(
	.A(min1_2),
	.B(N_35),
	.Q(N_33)
);
NAND2 NAND2_16(
	.A(hour1_3),
	.B(N_34),
	.Q(N_36)
);
NAND2 NAND2_17(
	.A(min1_3),
	.B(N_35),
	.Q(N_37)
);
NAND2 NAND2_18(
	.A(N_36),
	.B(N_37),
	.Q(N_38)
);
NAND2 NAND2_19(
	.A(hour10),
	.B(N_39),
	.Q(N_40)
);
NAND3 NAND3_1(
	.A(carry_1min),
	.B(carry_10min),
	.C(min10_0),
	.Q(N_41)
);
NAND3 NAND3_2(
	.A(N_30),
	.B(N_32),
	.C(N_33),
	.Q(N_42)
);
NAND3 NAND3_3(
	.A(N_27),
	.B(N_28),
	.C(N_29),
	.Q(N_43)
);
NAND4 NAND4_1(
	.A(N_44),
	.B(N_45),
	.C(N_46),
	.D(N_47),
	.Q(N_48)
);
NOR2 NOR2_1(
	.A(carry_1min),
	.B(N_67),
	.Q(N_49)
);
NOR2 NOR2_2(
	.A(N_16),
	.B(N_69),
	.Q(N_50)
);
NOR2 NOR2_3(
	.A(carry_1hour),
	.B(N_71),
	.Q(N_51)
);
NOR2 NOR2_4(
	.A(SyncMinIn),
	.B(Tick),
	.Q(N_59)
);
NOR2 NOR2_5(
	.A(SyncHourIn),
	.B(N_55),
	.Q(N_64)
);
NOR2 NOR2_6(
	.A(N_74),
	.B(N_52),
	.Q(N_53)
);
NOR2 NOR2_7(
	.A(N_53),
	.B(N_62),
	.Q(N_54)
);
NOR2 NOR2_8(
	.A(N_54),
	.B(N_64),
	.Q(carry_1hour)
);
NOR2 NOR2_9(
	.A(N_64),
	.B(N_3),
	.Q(N_25)
);
NOR2 NOR2_10(
	.A(SyncMinIn),
	.B(carry_10min),
	.Q(N_55)
);
NOR2 NOR2_11(
	.A(N_56),
	.B(N_57),
	.Q(N_39)
);
NOR2 NOR2_12(
	.A(N_56),
	.B(N_15),
	.Q(N_34)
);
NOR2 NOR2_13(
	.A(N_12),
	.B(N_15),
	.Q(N_31)
);
NOR2 NOR2_14(
	.A(N_12),
	.B(N_57),
	.Q(N_35)
);
NOR2 NOR2_15(
	.A(N_58),
	.B(N_59),
	.Q(carry_1min)
);
NOR3 NOR3_1(
	.A(carry_1min),
	.B(N_59),
	.C(N_14),
	.Q(N_23)
);
NOR4 NOR4_1(
	.A(N_7),
	.B(min1_2),
	.C(min1_1),
	.D(N_14),
	.Q(N_60)
);
NOR4 NOR4_2(
	.A(N_4),
	.B(min10_1),
	.C(N_6),
	.D(N_61),
	.Q(N_16)
);
NOR4 NOR4_3(
	.A(N_1),
	.B(hour1_2),
	.C(hour1_1),
	.D(N_3),
	.Q(N_62)
);
XNR2 XNR2_1(
	.A(N_77),
	.B(hour1_1),
	.Q(N_63)
);
XNR2 XNR2_2(
	.A(N_64),
	.B(hour1_0),
	.Q(N_65)
);
XNR2 XNR2_3(
	.A(N_59),
	.B(min1_0),
	.Q(N_13)
);
XNR2 XNR2_4(
	.A(min1_3),
	.B(N_66),
	.Q(N_67)
);
XNR2 XNR2_5(
	.A(N_68),
	.B(min10_2),
	.Q(N_69)
);
XNR2 XNR2_6(
	.A(N_70),
	.B(hour1_3),
	.Q(N_71)
);
XOR2 XOR2_1(
	.A(N_17),
	.B(min1_2),
	.Q(N_8)
);
XOR2 XOR2_2(
	.A(N_23),
	.B(min1_1),
	.Q(N_10)
);
XOR2 XOR2_3(
	.A(carry_1min),
	.B(min10_0),
	.Q(N_72)
);
XOR2 XOR2_4(
	.A(N_19),
	.B(min10_1),
	.Q(N_73)
);
XOR2 XOR2_5(
	.A(carry_1hour),
	.B(N_74),
	.Q(N_75)
);
XOR2 XOR2_6(
	.A(N_21),
	.B(hour1_2),
	.Q(N_76)
);
XOR2 XOR2_7(
	.A(N_25),
	.B(carry_1hour),
	.Q(N_77)
);
endmodule // TEAMF_CLOCK_SEQ


module TEAMF_BUTTON_SYNC2(
	Button,
	Clock,
	SyncButton,
	nReset
);
input Button;
input Clock;
output SyncButton;
input nReset;

wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;

BUF4 BUF4_1(
	.A(N_7),
	.Q(SyncButton)
);
DFFR DFFR_1(
	.Clk(Clock),
	.D(N_4),
	.Q(N_2),
	.nQ(N_1),
	.nRst(nReset)
);
DFFR DFFR_2(
	.Clk(Clock),
	.D(N_2),
	.Q(N_6),
	.nQ(N_3),
	.nRst(nReset)
);
DFFR DFFR_3(
	.Clk(Clock),
	.D(Button),
	.Q(N_4),
	.nQ(N_5),
	.nRst(nReset)
);
NOR2 NOR2_1(
	.A(N_6),
	.B(N_1),
	.Q(N_7)
);
endmodule // TEAMF_BUTTON_SYNC2


module TEAMF_DIVIDER(
	DivideOut,
	In,
	nResetOsc
);
output DivideOut;
input In;
input nResetOsc;

wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;
wire N_13;
wire N_14;
wire N_15;

DFFR DFFR_1(
	.Clk(In),
	.D(N_2),
	.Q(N_1),
	.nQ(N_2),
	.nRst(nResetOsc)
);
DFFR DFFR_2(
	.Clk(N_2),
	.D(N_4),
	.Q(N_3),
	.nQ(N_4),
	.nRst(nResetOsc)
);
DFFR DFFR_3(
	.Clk(N_4),
	.D(N_6),
	.Q(N_5),
	.nQ(N_6),
	.nRst(nResetOsc)
);
DFFR DFFR_4(
	.Clk(N_6),
	.D(N_8),
	.Q(N_7),
	.nQ(N_8),
	.nRst(nResetOsc)
);
DFFR DFFR_5(
	.Clk(N_8),
	.D(N_10),
	.Q(N_9),
	.nQ(N_10),
	.nRst(nResetOsc)
);
DFFR DFFR_6(
	.Clk(N_10),
	.D(N_12),
	.Q(N_11),
	.nQ(N_12),
	.nRst(nResetOsc)
);
DFFR DFFR_7(
	.Clk(N_12),
	.D(N_14),
	.Q(N_13),
	.nQ(N_14),
	.nRst(nResetOsc)
);
DFFR DFFR_8(
	.Clk(N_14),
	.D(N_15),
	.Q(DivideOut),
	.nQ(N_15),
	.nRst(nResetOsc)
);
endmodule // TEAMF_DIVIDER


module TEAMF_RINGOSCILLATOR(
	EnableOsc,
	OscOut,
	nResetOsc
);
input EnableOsc;
output OscOut;
input nResetOsc;

wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;

INV1 INV1_1(
	.A(N_8),
	.Q(N_1)
);
INV1 INV1_2(
	.A(N_1),
	.Q(N_2)
);
INV1 INV1_3(
	.A(N_2),
	.Q(N_3)
);
INV1 INV1_4(
	.A(N_3),
	.Q(N_4)
);
INV1 INV1_5(
	.A(N_4),
	.Q(N_9)
);
NAND2 NAND2_1(
	.A(N_5),
	.B(N_6),
	.Q(N_7)
);
NAND2 NAND2_2(
	.A(EnableOsc),
	.B(N_10),
	.Q(N_8)
);
NOR2 NOR2_1(
	.A(N_9),
	.B(N_11),
	.Q(N_6)
);
NOR2 NOR2_2(
	.A(N_7),
	.B(N_12),
	.Q(N_10)
);
TEAMF_DIVIDER TEAMF_DIVIDER_1(
	.DivideOut(OscOut),
	.In(N_10),
	.nResetOsc(nResetOsc)
);
TIE0 TIE0_1(
	.Q(N_11)
);
TIE0 TIE0_2(
	.Q(N_12)
);
TIE1 TIE1_2(
	.Q(N_5)
);
endmodule // TEAMF_RINGOSCILLATOR


module TEAMF_DESIGN(
	A0,
	A1,
	A2,
	A3,
	A4,
	A5,
	A6,
	A7,
	A8,
	A9,
	A10,
	A11,
	A12,
	A13,
	A14,
	A15,
	A16,
	A17,
	A18,
	A19,
	A20,
	A21,
	A22,
	A23,
	Q0,
	Q1,
	Q2,
	Q3,
	Q4,
	Q5,
	Q6,
	Q7,
	Q8,
	Q9,
	Q10,
	Q11,
	Q12,
	Q13,
	Q14,
	Q15,
	Q16,
	Q17,
	Q18,
	Q19,
	Q20,
	Q21,
	Q22,
	Q23
);
input A0;
input A1;
input A2;
input A3;
input A4;
input A5;
input A6;
input A7;
input A8;
input A9;
input A10;
input A11;
input A12;
input A13;
input A14;
input A15;
input A16;
input A17;
input A18;
input A19;
input A20;
input A21;
input A22;
input A23;
output Q0;
output Q1;
output Q2;
output Q3;
output Q4;
output Q5;
output Q6;
output Q7;
output Q8;
output Q9;
output Q10;
output Q11;
output Q12;
output Q13;
output Q14;
output Q15;
output Q16;
output Q17;
output Q18;
output Q19;
output Q20;
output Q21;
output Q22;
output Q23;

wire N_1;
wire N_2;
wire N_3;
wire N_4;
wire N_5;
wire N_6;
wire N_7;
wire N_8;
wire N_9;
wire N_10;
wire N_11;
wire N_12;

BUF4 BUF4_1(
	.A(N_5),
	.Q(Q1)
);
BUF4 BUF4_2(
	.A(N_6),
	.Q(Q17)
);
BUF4 BUF4_3(
	.A(N_7),
	.Q(Q18)
);
BUF4 BUF4_4(
	.A(N_8),
	.Q(Q19)
);
BUF4 BUF4_5(
	.A(N_9),
	.Q(Q20)
);
BUF4 BUF4_6(
	.A(N_10),
	.Q(Q21)
);
BUF4 BUF4_7(
	.A(N_11),
	.Q(Q22)
);
BUF4 BUF4_8(
	.A(N_12),
	.Q(Q23)
);
BUF4 BUF4_9(
	.A(N_1),
	.Q(Q2)
);
BUF4 BUF4_10(
	.A(N_2),
	.Q(Q3)
);
BUF4 BUF4_11(
	.A(N_3),
	.Q(Q4)
);
BUF4 BUF4_12(
	.A(N_4),
	.Q(Q5)
);
INV1 INV1_1(
	.A(A0),
	.Q(Q0)
);
TEAMF_ALU TEAMF_ALU_1(
	.F0(A3),
	.F1(A4),
	.X0(A5),
	.X1(A6),
	.X2(A7),
	.X3(A8),
	.XY0(N_1),
	.XY1(N_2),
	.XY2(N_3),
	.XY3(N_4),
	.Y0(A9),
	.Y1(A10),
	.Y2(A11),
	.Y3(A12)
);
TEAMF_BUTTON_SYNC2 TEAMF_BUTTON_SYNC2_1(
	.Button(A16),
	.Clock(A13),
	.SyncButton(Q7),
	.nReset(A14)
);
TEAMF_BUTTON_SYNC2 TEAMF_BUTTON_SYNC2_2(
	.Button(A15),
	.Clock(A13),
	.SyncButton(Q6),
	.nReset(A14)
);
TEAMF_CLOCK_SEQ TEAMF_CLOCK_SEQ_1(
	.Clock(A13),
	.D0(Q13),
	.D1(Q14),
	.D2(Q15),
	.D3(Q16),
	.DP(Q12),
	.Digit1(Q8),
	.Digit2(Q9),
	.Digit3(Q10),
	.Digit4(Q11),
	.SyncHourIn(A19),
	.SyncMinIn(A18),
	.Tick(A17),
	.nReset(A14)
);
TEAMF_RINGOSCILLATOR TEAMF_RINGOSCILLATOR_1(
	.EnableOsc(A2),
	.OscOut(N_5),
	.nResetOsc(A1)
);
TEAMF_SEV_SEG TEAMF_SEV_SEG_1(
	.D0In(A20),
	.D1In(A21),
	.D2In(A22),
	.D3In(A23),
	.SegA(N_6),
	.SegB(N_7),
	.SegC(N_8),
	.SegD(N_9),
	.SegE(N_10),
	.SegF(N_11),
	.SegG(N_12)
);
endmodule // TEAMF_DESIGN

