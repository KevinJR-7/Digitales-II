module main #(BITS = 5) (clk, nreset, A, B, noperSel, currentOper, flags, hex0, hex1,hex3);

	input logic clk, nreset, noperSel;
	input logic [BITS-1 : 0] A,B; 			//Entradas de N Bits
	output logic [3:0] flags,currentOper;  //Banderas y estado actual
	output logic [6:0] hex0,hex1; 			// Salidas de display
	output logic hex3;

	/* Variables internas */
	logic operSel, Cout, reset, intPulse;
	logic [1:0] cntSel;			// Operacion seleccionada
	logic [BITS-1 : 0] Bdef;	// Se guarda la B que se va a usar
	logic [BITS-1 : 0] num;		// resultado de la operacion
	logic [7 : 0] bcd; 	// El resultado de la operacion en BCD sin signo
	logic [BITS-1: 0] sum;		// resultado de la suma
	logic [BITS-1: 0] temp;	

	assign reset = ~nreset;
	assign operSel = ~noperSel;
		
	
	/* Declaracion para los pulsos */
	pulse p0(operSel,clk,reset,intPulse);
	
	bin_bcd numout(num,bcd);
	
	deco7seg seg0(bcd[3:0],hex0);
	deco7seg seg1(bcd[7:4],hex1);
	
	/* Declaracion para las banderas */
	decoflags #(BITS) f0(A[BITS-1],B[BITS-1],sum[BITS-1],temp,Cout,cntSel,flags);	//Af, Bf, Sumf, num,cout, aluControl, flags
	
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
			S0: begin
				cntSel = 2'b00;
				currentOper = 4'b1000;
			end
			S1: begin
				cntSel = 2'b01;
				currentOper = 4'b0100;
			end
			S2: begin
				cntSel = 2'b10;
				currentOper = 4'b0010;
			end
			S3: begin
				cntSel = 2'b11; 
				currentOper = 4'b0001;
			end
		endcase
	end		
	
	always_comb begin
		if (cntSel == 2'b01)
			Bdef = ~B;
		else
			Bdef = B;
	end
	
	always_comb begin
	{Cout,sum} = {1'b0,A} + {1'b0,(Bdef + cntSel[0])};
		case (cntSel)
			2'b00,2'b01 : begin
				hex3 = ~flags[0];
				temp = sum;
				num = (sum[BITS-1] == 0) ? sum : (~sum +1);				
				
			end
			2'b10 : begin
				hex3 = 1;
				temp = A & B;
				num = A & B;
			end
			2'b11 : begin
				hex3 = 1;
				temp = A | B;
				num = A | B;
			end
		endcase
	end
	
	
endmodule

/* Módulo testbench */
module testbench();
	localparam BITS = 5;
	logic clk, reset, operSel,hex3;
	logic [BITS-1 : 0] A,B; 			
	logic [3:0] flags,currentOper; 
	logic [6:0] hex0,hex1; 			
	
	localparam delay = 10ps;
	main #(BITS) simulacion(clk, reset, A, B, operSel, currentOper, flags, hex0, hex1,hex3);
	
	initial begin
		clk = 0;
		reset = 0;
		operSel = 0;
		A = 5'b1101;
		B = 5'b110;
		#(delay);
		reset = 1;
		for (int i = 0; i < 256; i = i+1)begin
			operSel = ~operSel;
			#(delay);
			A = A+3;
			B = B+4;		
		end
		$stop;
	end
	
	always #(delay/2) clk = ~clk;

endmodule