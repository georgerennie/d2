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
		as__hour10_rst: assert(hour10 == 1);
		as__hour1_rst: assert(hour1 == 2);
		as__min10_rst: assert(min10 == 0);
		as__min1_rst: assert(min1 == 0);
	end
end

// ----------------------------------------------------------------------------
// Invariants
// ----------------------------------------------------------------------------

always @* begin
	// Dont output a number greater than 9
	as__D_decimal: assert(D < 10); 

	// Dont light more than one Digit at once
	as__digit_onehot: assert($onehot0(Digit));

	// Digits should be lit at the corresponding time
	if (!Digit1)
		as__digit_cycle: assert(Digit[2:0] == current_digit[2:0]);

	// Digit1 should only be lit when displaying a 1
	if (Digit1)
		as__digit1_only_on_when_1: assert(D == 1);
	if (Digit == 4'b0000)
		as__digits_only_off_when_digit1: assert(current_digit == 4'b1000);

	// Digits should output the value from their internal reg
	if (Digit2) as__digit2_output: assert(D == hour1);
	if (Digit3) as__digit3_output: assert(D == { 1'b0, min10 });
	if (Digit4) as__digit4_output: assert(D == min1);

	// // DP should be on (active low) only for Digit 2
	as__dp_only_on_for_digit2: assert(DP == !Digit2);

	// Valid ranges for each Digit
	as__hour10_0_or_1: assert(hour10 <= 1);
	if (hour10 == 1) as__hour1_lte_2_when_hour10: assert(hour1 <= 2);
	if (hour10 == 0) as__hour1_decimal: assert(hour1 >= 1 && hour1 <= 9);
	as__min10_lte_5: assert(min10 <= 5);
	as__min1_decimal: assert(min1 <= 9);
end

// ----------------------------------------------------------------------------
// Seq Assertions
// ----------------------------------------------------------------------------

reg min10_tick_overflow;

always @(posedge Clock) begin
	if (past_valid && $past(nReset) && nReset) begin
		// min1 increment logic
		co__can_tick: cover($past(Tick));
		co__can_advance_mins: cover($past(SyncMinIn));

		if ($past(Tick) || $past(SyncMinIn)) begin
			as__min1_update: assert(min1 == ($past(min1) + 1) % 10);
		end else begin
			as__min1_stable: assert($stable(min1));
		end

		// min10 increment logic
		if (!$stable(min1) && $past(min1 == 9)) begin
			as__min10_update: assert(min10 == ($past(min10) + 1) % 6);
		end else begin
			as__min10_stable: assert($stable(min10));
		end

		// hour1 increment logic
		min10_tick_overflow =
			!$stable(min10) && $past(min10 == 5) &&
			$past(Tick) && $past(!SyncMinIn);
		co__min10_tick_overflow: cover(min10_tick_overflow);
		co__can_advance_hours: cover($past(SyncHourIn));

		if (min10_tick_overflow || $past(SyncHourIn)) begin
			if ($past(hour10 == 0) && $past(hour1 == 9)) begin
				as__hour1_decimal_wrap: assert(hour1 == 0);
			end else if ($past(hour10 == 1) && $past(hour1 == 2)) begin
				as__hour1_overflow: assert(hour1 == 1);
			end else begin
				as__hour1_update: assert(hour1 == $past(hour1) + 1);
			end
		end else begin
			as__hour1_stable: assert($stable(hour1));
		end

		// hour10 increment logic
		if (!$stable(hour1)) begin
			if ($past(hour10 == 0) && $past(hour1 == 9)) begin
				as_hour10_decimal_wrap: assert(hour10 == 1);
			end else if ($past(hour10 == 1) && $past(hour1 == 2)) begin
				as__hour10_overflow: assert(hour10 == 0);
			end else begin
				as__hour10_stable: assert($stable(hour10));
			end
		end
	end
end

endmodule
