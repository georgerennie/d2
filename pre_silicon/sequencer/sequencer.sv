// Sequencer for D2 Clock
// Samuel Simpon, 2021

module sequencer
    (output wire [3:0] D, // 7 segment data bus
    output wire [3:0] Digit, // 7 segment digit anodes
    output wire DP, // 7 segment decimal point
    input wire Tick, // 1 tick per minute
    Clock, // 200hz clock
    nReset, // low to reset the clock to 00:00
    SyncMinIn, // high for 1 clock to increment minutes
    SyncHourIn // high for 1 clock to increment hours
    );

  // Handle digits seperately for ease of use
  logic hour10;
  logic [3:0] hour1;
  logic [2:0] min10;
  logic [3:0] min1;

  logic inc_1m, inc_10h, inc_1h, inc_10m, zero_10m, zero_1h;

  register #(.BITS(3), .RESET_VAL(0), .ZERO_VAL(0)) r_min10 (.data(min10), .increment(inc_10m),
    .clock(Clock), .n_reset(nReset), .zero(zero_10m));
  register #(.BITS(4), .RESET_VAL(0), .ZERO_VAL(0)) r_min1 (.data(min1), .increment(inc_1m),
    .clock(Clock), .n_reset(nReset), .zero(inc_10m));
  
  logic [3:0]disp_digit;

  always_ff @(posedge Clock, negedge nReset)
  begin
    if (!nReset) begin
        hour10 <= 1;
        hour1 <= 2;
      end
    else begin
      if (inc_10h)
        hour10 <= !hour10;
      if (zero_1h) 
        hour1 <= (hour1 + 1) & 4'b0001;
      else if (inc_1h)
        hour1 <= hour1 + 1;
      end
  end

  always_comb
    begin
      // Roll over from 12:59 to 1:00 as 12 hour clock
      inc_1m = Tick == 1 || SyncMinIn == 1;
      inc_10m = inc_1m && min1 == 9;
      zero_10m = inc_10m && min10 == 5;
      inc_1h = (zero_10m && SyncMinIn == 0) || SyncHourIn == 1;
      inc_10h = inc_1h && (hour1 == 9 || (hour10 == 1 && hour1 == 2));
      zero_1h = inc_10h;

      DP = 1; // dp off for digits (inverted)
      D = 4'b0000; // Shouldn't be used, just in case to prevent latch
      Digit = disp_digit;
      case (disp_digit)
        // digit is basically a 2:4 decoder with an and gate on the 1 digit bit
        // with the hour10 bit to only turn on the 1st digit when it is a 1
        // The output of the mulitplexer (before the and gate) is used to drive
        // 4x 4:1 multiplexers (driving the internal and gates
        // (acting as the internal 2:4 decoder to save on gates))
        4'b1000: begin
          // D = {3'b000, hour10}; // we can cheat here and just show 1 as 0 is hidden
          D = 4'b0001;
          if (!hour10)
            Digit = 4'b0000; // Don't show a leading zero
        end
        4'b0100: begin
          D = hour1;
          DP = 0; // DP on for hour digit (inverted)
        end
        4'b0010: begin
          D = {1'b0, min10};
        end
        4'b0001: begin
          D = min1;
        end
      endcase
    end

  always_ff @(posedge Clock, negedge nReset)
    begin
      if (!nReset)
        disp_digit <= 4'b1000;
      else
        // Rotate the bits by 1
        // Pretty simple to implement
        case (disp_digit)
          4'b1000: disp_digit <= 4'b0100;
          4'b0100: disp_digit <= 4'b0010;
          4'b0010: disp_digit <= 4'b0001;
          4'b0001: disp_digit <= 4'b1000;
        endcase
    end
endmodule
