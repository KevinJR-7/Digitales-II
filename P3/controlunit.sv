// *******************
// Control Unit Module
// *******************

module controlunit (clk, reset, loaddata, inputdata_ready);
	input logic  clk, reset;
	output logic  loaddata;
	input logic inputdata_ready;

	// Internal signals for state machine
	typedef enum logic [1:0] {S0, S1} State;
	State currentState, nextState;
	
	// Process (Sequential): update currentState
	always_ff @(posedge clk, posedge reset) begin
		if (reset)
			currentState <= S0;
		else if (inputdata_ready)
			currentState <= nextState;
	end
	
	// Process (Combinational): update nextState
	always_comb begin
		case (currentState)
			S0:
						nextState = S1;
			S1:	
						nextState = S1;
		endcase
	end

	// Process (Combinational): update outputs 
	always_comb begin
		case (currentState)
			S0: 
				loaddata = 1;
			S1: 
				loaddata = 0;
		endcase
	end		
endmodule

// ************************** 
// Testbench for Control Unit
// ************************** 
module tb_controlunit ();
	// WRITE HERE YOUR CODE
endmodule