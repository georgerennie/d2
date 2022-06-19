// Verilog test bench for D2 chip design

`timescale 1ns/1ps

module test_TEAMF_DESIGN;

// declare DUT input signals as "reg"
// declare DUT output signals as "wire"

reg A20;
reg A21;
reg A22;
reg A23;
wire Q17;
wire Q18;
wire Q19;
wire Q20;
wire Q21;
wire Q22;
wire Q23;
integer errors_Q17;
integer errors_Q18;
integer errors_Q19;
integer errors_Q20;
integer errors_Q21;
integer errors_Q22;
integer errors_Q23;

// declare error count

integer errors;

// instance Device Under Test
//   assumes top-level OrCAD schematic is named "TEAMF_DESIGN"

`ifdef DUT
  `DUT DUT(
`else
  TEAMF_DESIGN DUT(
`endif
   .A20(A20),
   .A21(A21),
   .A22(A22),
   .A23(A23),
   .Q17(Q17),
   .Q18(Q18),
   .Q19(Q19),
   .Q20(Q20),
   .Q21(Q21),
   .Q22(Q22),
   .Q23(Q23)
);

// monitor the I/O
initial
  begin
    $display( "COMPILATION OK" );
    $display( "Simulation Begins" );
    $display ( "  AAAA  QQQQQQQ" );
    $display ( "  2222  1112222" );
    $display ( "  0123  7890123" );
    $display ( "               " );
    `ifdef no_monitor
    `else
    $monitor ( "  ",
      A20,
      A21,
      A22,
      A23,
      "  ",
      Q17,
      Q18,
      Q19,
      Q20,
      Q21,
      Q22,
      Q23,
      "  @ %d ns", $time   );
    `endif
  end

// stimulii

initial
  begin
    errors = 0;
    errors_Q17 = 0;
    errors_Q18 = 0;
    errors_Q19 = 0;
    errors_Q20 = 0;
    errors_Q21 = 0;
    errors_Q22 = 0;
    errors_Q23 = 0;
    $display ( "v 1000  1001111");
    apply_vector ( 4'b1000,7'b1001111,
                   4'b1111,7'b1111111);
    $display ( "v 0000  0000001");
    apply_vector ( 4'b0000,7'b0000001,
                   4'b1111,7'b1111111);
    $display ( "v 0011  0001100");
    apply_vector ( 4'b0011,7'b0001100,
                   4'b1111,7'b1111111);
    $display ( "v 1110  0001111");
    apply_vector ( 4'b1110,7'b0001111,
                   4'b1111,7'b1111111);
    $display ( "v 0100  0010010");
    apply_vector ( 4'b0100,7'b0010010,
                   4'b1111,7'b1111111);
    $display ( "v 1010  0100100");
    apply_vector ( 4'b1010,7'b0100100,
                   4'b1111,7'b1111111);
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
        if (  errors_Q17 > 0 )
          $display ( "       ", errors_Q17, " errors with Q17",) ;
        if (  errors_Q18 > 0 )
          $display ( "       ", errors_Q18, " errors with Q18",) ;
        if (  errors_Q19 > 0 )
          $display ( "       ", errors_Q19, " errors with Q19",) ;
        if (  errors_Q20 > 0 )
          $display ( "       ", errors_Q20, " errors with Q20",) ;
        if (  errors_Q21 > 0 )
          $display ( "       ", errors_Q21, " errors with Q21",) ;
        if (  errors_Q22 > 0 )
          $display ( "       ", errors_Q22, " errors with Q22",) ;
        if (  errors_Q23 > 0 )
          $display ( "       ", errors_Q23, " errors with Q23",) ;
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
  input [6:0] expected_vector;
  input [3:0] stimulus_mask;
  input [6:0] expected_mask;

  begin
    `ifdef set_x_to_0
      {A20,A21,A22,A23} = stimulus_vector & stimulus_mask ;
    `else
      {A20,A21,A22,A23} = stimulus_vector;
    `endif
    #500
    check_vector( expected_vector, expected_mask );
    #500
    $display("");
  end

endtask
task check_vector;

  input [6:0] expected_vector;
  input [6:0] mask_vector;

  reg [6:0] received_vector;
  reg [6:0] difference_vector;

  integer local_errors;

  begin
    local_errors = 0;
    received_vector = {Q17,Q18,Q19,Q20,Q21,Q22,Q23};
    difference_vector = ( received_vector ^ expected_vector ) & mask_vector ;
    $display( "r       %b", received_vector );
    $display( "        %s", error_point( difference_vector ) );
    if ( expected_vector[6] !== 1'bX )
      if ( expected_vector[6] !== Q17)
        begin
          $display( "error with Q17 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q17 = errors_Q17 + 1;
        end
    if ( expected_vector[5] !== 1'bX )
      if ( expected_vector[5] !== Q18)
        begin
          $display( "error with Q18 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q18 = errors_Q18 + 1;
        end
    if ( expected_vector[4] !== 1'bX )
      if ( expected_vector[4] !== Q19)
        begin
          $display( "error with Q19 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q19 = errors_Q19 + 1;
        end
    if ( expected_vector[3] !== 1'bX )
      if ( expected_vector[3] !== Q20)
        begin
          $display( "error with Q20 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q20 = errors_Q20 + 1;
        end
    if ( expected_vector[2] !== 1'bX )
      if ( expected_vector[2] !== Q21)
        begin
          $display( "error with Q21 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q21 = errors_Q21 + 1;
        end
    if ( expected_vector[1] !== 1'bX )
      if ( expected_vector[1] !== Q22)
        begin
          $display( "error with Q22 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q22 = errors_Q22 + 1;
        end
    if ( expected_vector[0] !== 1'bX )
      if ( expected_vector[0] !== Q23)
        begin
          $display( "error with Q23 @ %d ns", $time );
          local_errors = local_errors + 1;
          errors_Q23 = errors_Q23 + 1;
        end
    if ( local_errors > 0 ) $display( "" );
    errors = errors + local_errors;
  end

endtask
function [55:0] error_point;

  input [6:0] in_vector;
  integer i, j;
  begin
    error_point[ 7 : 0 ] = ( in_vector[ 0 ] === 0 ) ? " " : "^";
    error_point[ 15 : 8 ] = ( in_vector[ 1 ] === 0 ) ? " " : "^";
    error_point[ 23 : 16 ] = ( in_vector[ 2 ] === 0 ) ? " " : "^";
    error_point[ 31 : 24 ] = ( in_vector[ 3 ] === 0 ) ? " " : "^";
    error_point[ 39 : 32 ] = ( in_vector[ 4 ] === 0 ) ? " " : "^";
    error_point[ 47 : 40 ] = ( in_vector[ 5 ] === 0 ) ? " " : "^";
    error_point[ 55 : 48 ] = ( in_vector[ 6 ] === 0 ) ? " " : "^";
  end

endfunction


endmodule

