// Verilog test bench for D2 chip design

`timescale 1ns/1ps

module test_TEAMF_DESIGN;

// declare DUT input signals as "reg"
// declare DUT output signals as "wire"

reg A3;
reg A4;
reg A5;
reg A6;
reg A7;
reg A8;
reg A9;
reg A10;
reg A11;
reg A12;
wire Q2;
wire Q3;
wire Q4;
wire Q5;
integer errors_Q2;
integer errors_Q3;
integer errors_Q4;
integer errors_Q5;

// declare error count

integer errors;

// instance Device Under Test
//   assumes top-level OrCAD schematic is named "TEAMF_DESIGN"

`ifdef DUT
  `DUT DUT(
`else
  TEAMF_DESIGN DUT(
`endif
   .A3(A3),
   .A4(A4),
   .A5(A5),
   .A6(A6),
   .A7(A7),
   .A8(A8),
   .A9(A9),
   .A10(A10),
   .A11(A11),
   .A12(A12),
   .Q2(Q2),
   .Q3(Q3),
   .Q4(Q4),
   .Q5(Q5)
);

// monitor the I/O
initial
  begin
    $display( "COMPILATION OK" );
    $display( "Simulation Begins" );
    $display ( "  AAAAAAAAAA  QQQQ" );
    $display ( "  3456789111  2345" );
    $display ( "         012      " );
    $display ( "                  " );
    `ifdef no_monitor
    `else
    $monitor ( "  ",
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
      "  ",
      Q2,
      Q3,
      Q4,
      Q5,
      "  @ %d ns", $time   );
    `endif
  end

// stimulii

initial
  begin
    errors = 0;
    errors_Q2 = 0;
    errors_Q3 = 0;
    errors_Q4 = 0;
    errors_Q5 = 0;
    $display ( "v 0111110001  0111");
    apply_vector ( 10'b0111110001,4'b0111,
                   10'b1111111111,4'b1111);
    $display ( "v 0010101100  0001");
    apply_vector ( 10'b0010101100,4'b0001,
                   10'b1111111111,4'b1111);
    $display ( "v 0000010011  0010");
    apply_vector ( 10'b0000010011,4'b0010,
                   10'b1111111111,4'b1111);
    $display ( "v 1011010001  1100");
    apply_vector ( 10'b1011010001,4'b1100,
                   10'b1111111111,4'b1111);
    $display ( "v 1111101001  0000");
    apply_vector ( 10'b1111101001,4'b0000,
                   10'b1111111111,4'b1111);
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
        if (  errors_Q2 > 0 )
          $display ( "       ", errors_Q2, " errors with Q2",) ;
        if (  errors_Q3 > 0 )
          $display ( "       ", errors_Q3, " errors with Q3",) ;
        if (  errors_Q4 > 0 )
          $display ( "       ", errors_Q4, " errors with Q4",) ;
        if (  errors_Q5 > 0 )
          $display ( "       ", errors_Q5, " errors with Q5",) ;
        $display( "" );
        $display( "Total: ", errors, " errors");
        $display( "" );
      end
    $stop;
    $finish;
  end

// function declaration

task apply_vector;

  input [9:0] stimulus_vector;
  input [3:0] expected_vector;
  input [9:0] stimulus_mask;
  input [3:0] expected_mask;

  begin
    `ifdef set_x_to_0
      {A3,A4,A5,A6,A7,A8,A9,A10,A11,A12} = stimulus_vector & stimulus_mask ;
    `else
      {A3,A4,A5,A6,A7,A8,A9,A10,A11,A12} = stimulus_vector;
    `endif
    #500
    check_vector( expected_vector, expected_mask );
    #500
    $display("");
  end

endtask
task check_vector;

  input [3:0] expected_vector;
  input [3:0] mask_vector;

  reg [3:0] received_vector;
  reg [3:0] difference_vector;

  integer local_errors;

  begin
    local_errors = 0;
    received_vector = {Q2,Q3,Q4,Q5};
    difference_vector = ( received_vector ^ expected_vector ) & mask_vector ;
    $display( "r             %b", received_vector );
    $display( "              %s", error_point( difference_vector ) );
    if ( expected_vector[3] !== 1'bX )
      if ( expected_vector[3] !== Q2)
        begin
          $display( "error with Q2 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q2 = errors_Q2 + 1;
        end
    if ( expected_vector[2] !== 1'bX )
      if ( expected_vector[2] !== Q3)
        begin
          $display( "error with Q3 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q3 = errors_Q3 + 1;
        end
    if ( expected_vector[1] !== 1'bX )
      if ( expected_vector[1] !== Q4)
        begin
          $display( "error with Q4 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q4 = errors_Q4 + 1;
        end
    if ( expected_vector[0] !== 1'bX )
      if ( expected_vector[0] !== Q5)
        begin
          $display( "error with Q5 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q5 = errors_Q5 + 1;
        end
    if ( local_errors > 0 ) $display( "" );
    errors = errors + local_errors;
  end

endtask
function [31:0] error_point;

  input [3:0] in_vector;
  integer i, j;
  begin
    error_point[ 7 : 0 ] = ( in_vector[ 0 ] === 0 ) ? " " : "^";
    error_point[ 15 : 8 ] = ( in_vector[ 1 ] === 0 ) ? " " : "^";
    error_point[ 23 : 16 ] = ( in_vector[ 2 ] === 0 ) ? " " : "^";
    error_point[ 31 : 24 ] = ( in_vector[ 3 ] === 0 ) ? " " : "^";
  end

endfunction


endmodule

