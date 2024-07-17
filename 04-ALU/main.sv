module main #(BITS = 5) (clk, nreset, A, B, noperSel, currentOper, flags, hex0, hex1);

	input logic clk, nreset, noperSel;
	input logic [BITS-1 : 0] A,B;
	output logic [3:0] flags,currentOper;
	output logic [6:0] hex0,hex1;

	logic operSel, reset, intPulse;
	logic [1:0] cntSel;
	logic [BITS-1 : 0] num;

	assign reset = ~nreset;
	assign operSel = ~noperSel;
	
	pulse p0(operSel,clk,reset,intPulse);
	
	/* Definición de estados de la FSM y señales internas para estado actual y siguiente */
	typedef enum logic [1:0] {S0, S1, S2, S3} State;
	State currentState, nextState;
	
	/* Circuito secuencial para actualizar estado actual con el estado siguiente */
	always_ff @(posedge clk, posedge reset) begin
		if (reset)
			currentState <= S0;
		else if (intPulse)
			currentState <= nextState;
	end
	
	/* Circuito combinacional para determinar siguiente estado de la FSM */
	always_comb begin
		case (currentState)
			S0:	
					nextState = S1;
			S1:	
					nextState = S2;
			S2:	
					nextState = S3;
			S3:	
					nextState = S0;
		endcase
	end
	
	/* Circuito combinacional para manejar las salidas */
	always_comb begin
		case (currentState)
			S0: 
				cntSel = 2'b00; 
			S1: 
				cntSel = 2'b01;
			S2: 
				cntSel = 2'b10; 
			S3: 
				cntSel = 2'b11; 
		endcase
	end
	
endmodule
