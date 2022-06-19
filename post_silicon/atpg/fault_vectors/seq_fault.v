// Verilog test bench for D2 chip design

`timescale 1ns/1ps

module test_TEAMF_DESIGN;

// declare DUT input signals as "reg"
// declare DUT output signals as "wire"

reg A13;
reg A14;
reg A17;
reg A18;
reg A19;
wire Q8;
wire Q9;
wire Q10;
wire Q11;
wire Q12;
wire Q13;
wire Q14;
wire Q15;
wire Q16;
integer errors_Q8;
integer errors_Q9;
integer errors_Q10;
integer errors_Q11;
integer errors_Q12;
integer errors_Q13;
integer errors_Q14;
integer errors_Q15;
integer errors_Q16;

// declare error count

integer errors;

// instance Device Under Test
//   assumes top-level OrCAD schematic is named "TEAMF_DESIGN"

`ifdef DUT
  `DUT DUT(
`else
  TEAMF_DESIGN DUT(
`endif
   .A13(A13),
   .A14(A14),
   .A17(A17),
   .A18(A18),
   .A19(A19),
   .Q8(Q8),
   .Q9(Q9),
   .Q10(Q10),
   .Q11(Q11),
   .Q12(Q12),
   .Q13(Q13),
   .Q14(Q14),
   .Q15(Q15),
   .Q16(Q16)
);

// monitor the I/O
initial
  begin
    $display( "COMPILATION OK" );
    $display( "Simulation Begins" );
    $display ( "  AAAAA  QQQQQQQQQ" );
    $display ( "  11111  891111111" );
    $display ( "  34789    0123456" );
    $display ( "                  " );
    `ifdef no_monitor
    `else
    $monitor ( "  ",
      A13,
      A14,
      A17,
      A18,
      A19,
      "  ",
      Q8,
      Q9,
      Q10,
      Q11,
      Q12,
      Q13,
      Q14,
      Q15,
      Q16,
      "  @ %d ns", $time   );
    `endif
  end

// stimulii

initial
  begin
    errors = 0;
    errors_Q8 = 0;
    errors_Q9 = 0;
    errors_Q10 = 0;
    errors_Q11 = 0;
    errors_Q12 = 0;
    errors_Q13 = 0;
    errors_Q14 = 0;
    errors_Q15 = 0;
    errors_Q16 = 0;
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01100  100011000");
    apply_vector ( 5'b01100,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01100  010000100");
    apply_vector ( 5'b01100,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  000111100");
    apply_vector ( 5'b01001,9'b000111100,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000011000");
    apply_vector ( 5'b01000,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01000  100011000");
    apply_vector ( 5'b01000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01100  010000100");
    apply_vector ( 5'b01100,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  000110100");
    apply_vector ( 5'b01001,9'b000110100,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000011000");
    apply_vector ( 5'b01000,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01101  100011000");
    apply_vector ( 5'b01101,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01100  010001000");
    apply_vector ( 5'b01100,9'b010001000,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000111100");
    apply_vector ( 5'b01000,9'b000111100,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  000011000");
    apply_vector ( 5'b01101,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  010001100");
    apply_vector ( 5'b01000,9'b010001100,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01001  100011000");
    apply_vector ( 5'b01001,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  010001000");
    apply_vector ( 5'b01000,9'b010001000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  001010000");
    apply_vector ( 5'b01000,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000110000");
    apply_vector ( 5'b01000,9'b000110000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000011000");
    apply_vector ( 5'b01000,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01000  100011000");
    apply_vector ( 5'b01000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  010000100");
    apply_vector ( 5'b01000,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  001010000");
    apply_vector ( 5'b01000,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000110000");
    apply_vector ( 5'b01000,9'b000110000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  100011000");
    apply_vector ( 5'b01000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01101  100011000");
    apply_vector ( 5'b01101,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  010001000");
    apply_vector ( 5'b01000,9'b010001000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  000110100");
    apply_vector ( 5'b01001,9'b000110100,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000011000");
    apply_vector ( 5'b01000,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01001  100011000");
    apply_vector ( 5'b01001,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  010001000");
    apply_vector ( 5'b01101,9'b010001000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01011  001010000");
    apply_vector ( 5'b01011,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11011  XXXXXXXXX");
    apply_vector ( 5'b11011,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000110100");
    apply_vector ( 5'b01000,9'b000110100,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000011000");
    apply_vector ( 5'b01000,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01101  100011000");
    apply_vector ( 5'b01101,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  010001000");
    apply_vector ( 5'b01001,9'b010001000,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01100  001010000");
    apply_vector ( 5'b01100,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01100  000110100");
    apply_vector ( 5'b01100,9'b000110100,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  000011000");
    apply_vector ( 5'b01001,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  010001100");
    apply_vector ( 5'b01000,9'b010001100,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01000  100011000");
    apply_vector ( 5'b01000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  010000100");
    apply_vector ( 5'b01000,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000111000");
    apply_vector ( 5'b01000,9'b000111000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01100  100011000");
    apply_vector ( 5'b01100,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  010000100");
    apply_vector ( 5'b01001,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000110100");
    apply_vector ( 5'b01000,9'b000110100,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000011000");
    apply_vector ( 5'b01000,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01010  010000100");
    apply_vector ( 5'b01010,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01001  100011000");
    apply_vector ( 5'b01001,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01100  010001000");
    apply_vector ( 5'b01100,9'b010001000,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01100  001010000");
    apply_vector ( 5'b01100,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000110100");
    apply_vector ( 5'b01000,9'b000110100,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01000  100011000");
    apply_vector ( 5'b01000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01100  010000100");
    apply_vector ( 5'b01100,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 11100  XXXXXXXXX");
    apply_vector ( 5'b11100,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  000110100");
    apply_vector ( 5'b01001,9'b000110100,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000011000");
    apply_vector ( 5'b01000,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01000  100011000");
    apply_vector ( 5'b01000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  010000100");
    apply_vector ( 5'b01101,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000110100");
    apply_vector ( 5'b01000,9'b000110100,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01010  000011000");
    apply_vector ( 5'b01010,9'b000011000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01001  100011000");
    apply_vector ( 5'b01001,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  010001000");
    apply_vector ( 5'b01101,9'b010001000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  001010000");
    apply_vector ( 5'b01001,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000111000");
    apply_vector ( 5'b01000,9'b000111000,
                   5'b11111,9'b111111111);
    $display ( "v 00000  100011000");
    apply_vector ( 5'b00000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 01000  100011000");
    apply_vector ( 5'b01000,9'b100011000,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  010000100");
    apply_vector ( 5'b01000,9'b010000100,
                   5'b11111,9'b111111111);
    $display ( "v 11000  XXXXXXXXX");
    apply_vector ( 5'b11000,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01101  001010000");
    apply_vector ( 5'b01101,9'b001010000,
                   5'b11111,9'b111111111);
    $display ( "v 11101  XXXXXXXXX");
    apply_vector ( 5'b11101,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01001  000111000");
    apply_vector ( 5'b01001,9'b000111000,
                   5'b11111,9'b111111111);
    $display ( "v 11001  XXXXXXXXX");
    apply_vector ( 5'b11001,9'bXXXXXXXXX,
                   5'b11111,9'b000000000);
    $display ( "v 01000  000011000");
    apply_vector ( 5'b01000,9'b000011000,
                   5'b11111,9'b111111111);
    if ( errors == 0 )
      begin
        $display( "SIMULATION OK" );
        $display( "All vectors passed" );
      end
    else
      begin
        $display( "" );
        $display( "SIMULATION Failed" );
        $display( "" );
        if (  errors_Q8 > 0 )
          $display ( "       ", errors_Q8, " errors with Q8",) ;
        if (  errors_Q9 > 0 )
          $display ( "       ", errors_Q9, " errors with Q9",) ;
        if (  errors_Q10 > 0 )
          $display ( "       ", errors_Q10, " errors with Q10",) ;
        if (  errors_Q11 > 0 )
          $display ( "       ", errors_Q11, " errors with Q11",) ;
        if (  errors_Q12 > 0 )
          $display ( "       ", errors_Q12, " errors with Q12",) ;
        if (  errors_Q13 > 0 )
          $display ( "       ", errors_Q13, " errors with Q13",) ;
        if (  errors_Q14 > 0 )
          $display ( "       ", errors_Q14, " errors with Q14",) ;
        if (  errors_Q15 > 0 )
          $display ( "       ", errors_Q15, " errors with Q15",) ;
        if (  errors_Q16 > 0 )
          $display ( "       ", errors_Q16, " errors with Q16",) ;
        $display( "" );
        $display( "Total: ", errors, " errors");
        $display( "" );
      end
    $stop;
    $finish;
  end

// function declaration

task apply_vector;

  input [4:0] stimulus_vector;
  input [8:0] expected_vector;
  input [4:0] stimulus_mask;
  input [8:0] expected_mask;

  begin
    `ifdef set_x_to_0
      {A13,A14,A17,A18,A19} = stimulus_vector & stimulus_mask ;
    `else
      {A13,A14,A17,A18,A19} = stimulus_vector;
    `endif
    #500
    check_vector( expected_vector, expected_mask );
    #500
    $display("");
  end

endtask
task check_vector;

  input [8:0] expected_vector;
  input [8:0] mask_vector;

  reg [8:0] received_vector;
  reg [8:0] difference_vector;

  integer local_errors;

  begin
    local_errors = 0;
    received_vector = {Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16};
    difference_vector = ( received_vector ^ expected_vector ) & mask_vector ;
    $display( "r        %b", received_vector );
    $display( "         %s", error_point( difference_vector ) );
    if ( expected_vector[8] !== 1'bX )
      if ( expected_vector[8] !== Q8)
        begin
          $display( "error with Q8 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q8 = errors_Q8 + 1;
        end
    if ( expected_vector[7] !== 1'bX )
      if ( expected_vector[7] !== Q9)
        begin
          $display( "error with Q9 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q9 = errors_Q9 + 1;
        end
    if ( expected_vector[6] !== 1'bX )
      if ( expected_vector[6] !== Q10)
        begin
          $display( "error with Q10 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q10 = errors_Q10 + 1;
        end
    if ( expected_vector[5] !== 1'bX )
      if ( expected_vector[5] !== Q11)
        begin
          $display( "error with Q11 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q11 = errors_Q11 + 1;
        end
    if ( expected_vector[4] !== 1'bX )
      if ( expected_vector[4] !== Q12)
        begin
          $display( "error with Q12 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q12 = errors_Q12 + 1;
        end
    if ( expected_vector[3] !== 1'bX )
      if ( expected_vector[3] !== Q13)
        begin
          $display( "error with Q13 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q13 = errors_Q13 + 1;
        end
    if ( expected_vector[2] !== 1'bX )
      if ( expected_vector[2] !== Q14)
        begin
          $display( "error with Q14 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q14 = errors_Q14 + 1;
        end
    if ( expected_vector[1] !== 1'bX )
      if ( expected_vector[1] !== Q15)
        begin
          $display( "error with Q15 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q15 = errors_Q15 + 1;
        end
    if ( expected_vector[0] !== 1'bX )
      if ( expected_vector[0] !== Q16)
        begin
          $display( "error with Q16 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q16 = errors_Q16 + 1;
        end
    if ( local_errors > 0 ) $display( "" );
    errors = errors + local_errors;
  end

endtask
function [71:0] error_point;

  input [8:0] in_vector;
  integer i, j;
  begin
    error_point[ 7 : 0 ] = ( in_vector[ 0 ] === 0 ) ? " " : "^";
    error_point[ 15 : 8 ] = ( in_vector[ 1 ] === 0 ) ? " " : "^";
    error_point[ 23 : 16 ] = ( in_vector[ 2 ] === 0 ) ? " " : "^";
    error_point[ 31 : 24 ] = ( in_vector[ 3 ] === 0 ) ? " " : "^";
    error_point[ 39 : 32 ] = ( in_vector[ 4 ] === 0 ) ? " " : "^";
    error_point[ 47 : 40 ] = ( in_vector[ 5 ] === 0 ) ? " " : "^";
    error_point[ 55 : 48 ] = ( in_vector[ 6 ] === 0 ) ? " " : "^";
    error_point[ 63 : 56 ] = ( in_vector[ 7 ] === 0 ) ? " " : "^";
    error_point[ 71 : 64 ] = ( in_vector[ 8 ] === 0 ) ? " " : "^";
  end

endfunction


endmodule

