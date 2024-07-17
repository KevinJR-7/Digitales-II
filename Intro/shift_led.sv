module shift_led #(BITS = 10) (clk, rst, q);

	// Inputs and outputs
	input logic clk, rst;
	output logic [BITS - 1: 0] q;
 
	// internal signals
	reg toLeft;
	reg [BITS - 1 : 0] rShiftReg;
	
	// circuit is activated on clk or rst
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			rShiftReg <= 1'b1;
			toLeft <= 0;
		end
		
		else if (toLeft) begin // Next LED to the left
			if (rShiftReg[BITS - 1] == 1'b1) begin
				toLeft = 0;
				rShiftReg <= { 1'b0, rShiftReg[BITS - 1 : 1] };
			end
			else
				rShiftReg <= { rShiftReg[BITS - 2 : 0], 1'b0 };
		end
		else begin // Next LED to the right
			if (rShiftReg[0] == 1'b1) begin
				toLeft = 1;
				rShiftReg <= { rShiftReg[BITS - 2 : 0], 1'b0 };
			end
			else
				rShiftReg <= { 1'b0, rShiftReg[BITS - 1 : 1] };
			end
		end
		
	assign q = rShiftReg;
endmodule