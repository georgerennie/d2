// Digit register for D2 Clock
// Samuel Simpon, 2021

module register  #(parameter BITS = 4, RESET_VAL = 0, ZERO_VAL = 0)
    (output logic [BITS-1:0] data, // segA-segG
    input logic increment,
    clock, n_reset, zero);
  
  always_ff @(posedge clock, negedge n_reset)
    begin
      if (!n_reset)
        data <= RESET_VAL;
      else if (increment)
        if (zero)
          data <= ZERO_VAL;
        else
          data <= data + 1;
    end
endmodule