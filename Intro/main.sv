module main #(SHIFT_BITS = 10, CNTDIV_BITS = 25) (clk, rst, qbits);

	// inputs and outputs
	input logic clk, rst;
	output logic [SHIFT_BITS - 1: 0] qbits;
 
	// internal signals
	reg internalClk;
	
	// internal clock divider module
	cntdiv_n #(CNTDIV_BITS) cntDiv (clk, rst, internalClk);
	
	// internal shift register module
	shift_led #(SHIFT_BITS) shifter (internalClk, rst, qbits);
endmodule
