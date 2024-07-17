module tbMain ();
	// local parameters
	localparam SHIFT_BITS = 4;
	localparam CNTDIV_BITS = 2;
	localparam CLK_PERIOD = 20ns;
	
	// internal signals
	logic clk, rst;
	logic [SHIFT_BITS - 1: 0] qbits;
	
	// Led shifter instance
	main #(SHIFT_BITS, CNTDIV_BITS) mInst (clk, rst, qbits);
	
	// Simulation process
	initial begin
	clk = 0; rst = 1; #(CLK_PERIOD * 5);
	rst = 0; #(CLK_PERIOD * 100);
	$stop;
	end
	always #(CLK_PERIOD / 2) clk = ~clk;
endmodule
