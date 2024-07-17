module supermachine #(fpga_freq = 50_000_000) (clk, nreset, up, tiempo, muestreo, hex0, hex1);

	/* Entradas y salidas */
	input logic clk,nreset,up, tiempo;
	output logic [6:0] hex1;
	output logic [6:0] hex0;
	output logic muestreo;

	/* Circuito para invertir la señal de reloj */
	logic reset;
	assign reset = ~nreset;
	
	logic [3:0] num; 
	
	/* Señales para manejar los circuitos internos */
	logic clk_seconds, clk_medseconds, clkinterno;
	assign muestreo = clkinterno;

	/* Generador de señal de relol clk_seconds de 1 hz */
	cntdiv_n #(fpga_freq) cntDiv1 (clk, reset, clk_seconds);
	
	/* Generador de señal de relol clk_seconds de 2 hz */
	cntdiv_n #(fpga_freq/2) cntDiv2 (clk, reset, clk_medseconds);
	
	/* */
	deco7seg deco(num,hex0,hex1);

		
	/* Definición de estados de la FSM y señales internas para estado actual y siguiente */
	typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6, S7} State;
	State currentState, nextState;
	
	/* Circuito secuencial para actualizar estado actual con el estado siguiente (cada segundo) */
	always_ff @(posedge clkinterno, posedge reset) 
		if (reset)
			currentState <= S0;
		else 
			currentState <= nextState;
			
	/* */
	always_comb begin
		if (tiempo)
			clkinterno = clk_seconds;
		else
			clkinterno = clk_medseconds;
	end
			
	/* Circuito combinacional para determinar siguiente estado de la FSM */
	always_comb begin
		case (currentState)
			S0:	
				if(up)
					nextState = S1;
				else 
					nextState = S7;
			S1:	
				if(up)
					nextState = S2;
				else 
					nextState = S0;
			S2:	
				if(up)
					nextState = S3;
				else 
					nextState = S1;
			S3:	
				if(up)
					nextState = S4;
				else 
					nextState = S2;
			S4:	
				if(up)
					nextState = S5;
				else 
					nextState = S3;
			S5:	
				if(up)
					nextState = S6;
				else 
					nextState = S4;
			S6:	
				if(up)
					nextState = S7;
				else 
					nextState = S5;
			S7:	
				if(up)
					nextState = S0;
				else 
					nextState = S6;
			default:		
				nextState = S0;
		endcase
	end	
	
	
	/* Circuito combinacional para manejar las salidas */
	always_comb begin
		num = 4'b0;			
		case (currentState)
			S0: 
				num = 4'b0011; // 3
			S1: 
				num = 4'b0110; // 6
			S2: 
				num = 4'b1001; // 9
			S3: 
				num = 4'b1100; // 12
			S4:
				num = 4'b1111; // 15
			S5:
				num = 4'b0010; // 2
			S6:
				num = 4'b0101; // 5
			S7:
				num = 4'b0111; // 7
		endcase
	end
	
	
endmodule
	
/* Módulo testbench */
module testbench();
	/* Declaración de señales y variables internas */
	logic clk, reset, muestreo,up,tiempo;
	logic [6:0] hex0;
	logic [6:0] hex1;

	localparam fpga_freq = 8;
	localparam delay = 20ps;
	
	// Instanciar objeto
	supermachine #(fpga_freq) simulacion (clk, reset, up, tiempo, muestreo, hex0, hex1);
	
	initial begin
		clk = 0;
		reset = 0;
		up = 1;
		tiempo = 1;
		#(delay);
		reset = 1;
		#((delay*8)*(fpga_freq));
		up = 0;
		#((delay*5)*(fpga_freq));
		tiempo = 0;
		#(delay)
		reset = 0;
		#(delay)
		reset = 1;
		#((delay*8)*(fpga_freq));

		$stop;
	end
	
	always #(delay/2) clk = ~clk;

endmodule
	