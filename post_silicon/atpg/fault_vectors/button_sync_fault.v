// Verilog test bench for D2 chip design

`timescale 1ns/1ps

module test_TEAMF_DESIGN;

// declare DUT input signals as "reg"
// declare DUT output signals as "wire"

reg A13;
reg A14;
reg A15;
reg A16;
wire Q6;
wire Q7;
integer errors_Q6;
integer errors_Q7;

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
   .A15(A15),
   .A16(A16),
   .Q6(Q6),
   .Q7(Q7)
);

// monitor the I/O
initial
  begin
    $display( "COMPILATION OK" );
    $display( "Simulation Begins" );
    $display ( "  AAAA  QQ" );
    $display ( "  1111  67" );
    $display ( "  3456    " );
    $display ( "          " );
    `ifdef no_monitor
    `else
    $monitor ( "  ",
      A13,
      A14,
      A15,
      A16,
      "  ",
      Q6,
      Q7,
      "  @ %d ns", $time   );
    `endif
  end

// stimulii

initial
  begin
    errors = 0;
    errors_Q6 = 0;
    errors_Q7 = 0;
    $display ( "v 0000  00");
    apply_vector ( 4'b0000,2'b00,
                   4'b1111,2'b11);
    $display ( "v 0100  00");
    apply_vector ( 4'b0100,2'b00,
                   4'b1111,2'b11);
    $display ( "v 1100  XX");
    apply_vector ( 4'b1100,2'bXX,
                   4'b1111,2'b00);
    $display ( "v 0110  00");
    apply_vector ( 4'b0110,2'b00,
                   4'b1111,2'b11);
    $display ( "v 1110  XX");
    apply_vector ( 4'b1110,2'bXX,
                   4'b1111,2'b00);
    $display ( "v 0111  00");
    apply_vector ( 4'b0111,2'b00,
                   4'b1111,2'b11);
    $display ( "v 1111  XX");
    apply_vector ( 4'b1111,2'bXX,
                   4'b1111,2'b00);
    $display ( "v 0111  10");
    apply_vector ( 4'b0111,2'b10,
                   4'b1111,2'b11);
    $display ( "v 1111  XX");
    apply_vector ( 4'b1111,2'bXX,
                   4'b1111,2'b00);
    $display ( "v 0100  01");
    apply_vector ( 4'b0100,2'b01,
                   4'b1111,2'b11);
    $display ( "v 1100  XX");
    apply_vector ( 4'b1100,2'bXX,
                   4'b1111,2'b00);
    $display ( "v 0100  00");
    apply_vector ( 4'b0100,2'b00,
                   4'b1111,2'b11);
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
        if (  errors_Q6 > 0 )
          $display ( "       ", errors_Q6, " errors with Q6",) ;
        if (  errors_Q7 > 0 )
          $display ( "       ", errors_Q7, " errors with Q7",) ;
        $display( "" );
        $display( "Total: ", errors, " errors");
        $display( "" );
      end
    $stop;
    $finish;
  end

// function declaration

task apply_vector;

  input [3:0] stimulus_vector;
  input [1:0] expected_vector;
  input [3:0] stimulus_mask;
  input [1:0] expected_mask;

  begin
    `ifdef set_x_to_0
      {A13,A14,A15,A16} = stimulus_vector & stimulus_mask ;
    `else
      {A13,A14,A15,A16} = stimulus_vector;
    `endif
    #500
    check_vector( expected_vector, expected_mask );
    #500
    $display("");
  end

endtask
task check_vector;

  input [1:0] expected_vector;
  input [1:0] mask_vector;

  reg [1:0] received_vector;
  reg [1:0] difference_vector;

  integer local_errors;

  begin
    local_errors = 0;
    received_vector = {Q6,Q7};
    difference_vector = ( received_vector ^ expected_vector ) & mask_vector ;
    $display( "r       %b", received_vector );
    $display( "        %s", error_point( difference_vector ) );
    if ( expected_vector[1] !== 1'bX )
      if ( expected_vector[1] !== Q6)
        begin
          $display( "error with Q6 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q6 = errors_Q6 + 1;
        end
    if ( expected_vector[0] !== 1'bX )
      if ( expected_vector[0] !== Q7)
        begin
          $display( "error with Q7 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q7 = errors_Q7 + 1;
        end
    if ( local_errors > 0 ) $display( "" );
    errors = errors + local_errors;
  end

endtask
function [15:0] error_point;

  input [1:0] in_vector;
  integer i, j;
  begin
    error_point[ 7 : 0 ] = ( in_vector[ 0 ] === 0 ) ? " " : "^";
    error_point[ 15 : 8 ] = ( in_vector[ 1 ] === 0 ) ? " " : "^";
  end

endfunction


endmodule

