module sequencer_formal(
	input Tick,
	input SyncMinIn,
	input SyncHourIn,
	input Clock,
	input nReset,

	output Digit1,
	output Digit2,
	output Digit3,
	output Digit4,
	output DP,

	output D0,
	output D1,
	output D2,
	output D3
);

// ----------------------------------------------------------------------------
// TB Setup
// ----------------------------------------------------------------------------

sequencer DUT(.*);

wire [3:0] D, Digit;
always @* assume({ D3, D2, D1, D0 } == D);
always @* assume({ Digit1, Digit2, Digit3, Digit4 } == Digit);

// Internal values for clock Digits
wire min1_0, min1_1, min1_2, min1_3, min10_0, min10_1, min10_2, hour1_0,
	hour1_1, hour1_2, hour1_3;
wire [3:0] min1;
wire [2:0] min10;
wire [3:0] hour1;
wire hour10;

always @* assume({min1_3, min1_2, min1_1, min1_0} == min1);
always @* assume({min10_2, min10_1, min10_0} == min10);
always @* assume({hour1_3, hour1_2, hour1_1, hour1_0} == hour1);

reg past_valid;
initial past_valid = 0;
always @(posedge Clock) past_valid <= 1;

// ----------------------------------------------------------------------------
// Seq TB
// ----------------------------------------------------------------------------

reg [3:0] current_digit;
always @(posedge Clock or negedge nReset) begin
	if (!nReset) current_digit <= 4'b1000;
	else current_digit <= { current_digit[0], current_digit[3:1] };
end

// ----------------------------------------------------------------------------
// Reset State
// ----------------------------------------------------------------------------

always @* begin
	if (!nReset) begin
		assert(hour10 == 1);
		assert(hour1 == 2);
		assert(min10 == 0);
		assert(min1 == 0);
	end
end

// ----------------------------------------------------------------------------
// Invariants
// ----------------------------------------------------------------------------

always @* begin
	// Dont output a number greater than 9
	assert(D < 10); 

	// Dont light more than one Digit at once
	assert((Digit & (Digit - 1)) == 0);

	// Digits should be lit at the corresponding time
	if (!Digit1) assert(Digit[2:0] == current_digit[2:0]);

	// Digit1 should only be lit when displaying a 1
	if (Digit1) assert(D == 1);
	if (Digit == 4'b0000) assert(current_digit == 4'b1000);

	// Digits should output the value from their internal reg
	if (Digit2) assert(D == hour1);
	if (Digit3) assert(D == { 1'b0, min10 });
	if (Digit4) assert(D == min1);

	// // DP should be on (active low) only for Digit 2
	assert(DP == !Digit2);

	// Valid ranges for each Digit
	assert(hour10 <= 1);
	if (hour10 == 1) assert(hour1 <= 2);
	if (hour10 == 0) assert(hour1 >= 1 && hour1 <= 9);
	assert(min10 <= 5);
	assert(min1 <= 9);
end

// ----------------------------------------------------------------------------
// Seq Assertions
// ----------------------------------------------------------------------------

reg min10_tick_overflow;

always @(posedge Clock) begin
	if (past_valid && $past(nReset) && nReset) begin
		// min1 increment logic
		cover($past(Tick));
		cover($past(SyncMinIn));

		if ($past(Tick) || $past(SyncMinIn)) begin
			assert(min1 == ($past(min1) + 1) % 10);
		end else begin
			assert($stable(min1));
		end

		// min10 increment logic
		if (!$stable(min1) && $past(min1 == 9)) begin
			assert(min10 == ($past(min10) + 1) % 6);
		end else begin
			assert($stable(min10));
		end

		// hour1 increment logic
		min10_tick_overflow =
			!$stable(min10) && $past(min10 == 5) &&
			$past(Tick) && $past(!SyncMinIn);
		cover(min10_tick_overflow);
		cover($past(SyncHourIn));

		if (min10_tick_overflow || $past(SyncHourIn)) begin
			if ($past(hour10 == 0) && $past(hour1 == 9)) begin
				assert(hour1 == 0);
			end else if ($past(hour10 == 1) && $past(hour1 == 2)) begin
				assert(hour1 == 1);
			end else begin
				assert(hour1 == $past(hour1) + 1);
			end
		end else begin
			assert($stable(hour1));
		end

		// hour10 increment logic
		if (!$stable(hour1)) begin
			if ($past(hour10 == 0) && $past(hour1 == 9)) begin
				assert(hour10 == 1);
			end else if ($past(hour10 == 1) && $past(hour1 == 2)) begin
				assert(hour10 == 0);
			end else begin
				assert($stable(hour10));
			end
		end
	end
end

endmodule
