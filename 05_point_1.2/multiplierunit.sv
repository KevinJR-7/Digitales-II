// **********************
// Multiplier Unit Module
// **********************
// ISeñales internas
module multiplierunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// ISeñales internas
	logic [47:0] producto;
	logic [7:0]  exponentaux, ExponentR;
	logic SignR;
	logic [22:0] Fracc;

	//XoR para el signo 
	always_comb begin
		SignR = dataA[31] ^ dataB[31];
	end
	
	//Suma de exponentes
	always_comb begin
		exponentaux = dataA[30:23] + (dataB[30:23]-9'd127);
	end
	
	//Multiplicacion de mantisas y creación de la fraccion resultante
	always_comb begin
		producto = ({1'b1,dataA[22:0]} * {1'b1,dataB[22:0]});
		if (producto [47]) begin
			Fracc = producto[46:24];
			ExponentR = exponentaux + 1;
		end else begin
			Fracc = producto[45:23];
			ExponentR = exponentaux;
		end
	end
	//Concatenacion de R y validacion para casos de infinito o NaN
	always_comb begin
		if (((dataA[30:23] == 8'hFF) && (dataA[22:0] == 23'b0)) || 
			((dataB[30:23] == 8'hFF) && (dataB[22:0] == 23'b0))) begin
			if ((dataA == 30'b0) || (dataB == 30'b0))	begin 
				dataR = 32'h7FC00000; // +-Infinito x 0 = NaN
			end else if (((dataA[30:23] == 8'hFF) && (dataA[22:0] == 23'b0)) && 
							((dataB[30:23] == 8'hFF) && (dataB[22:0] == 23'b0))) begin
							dataR = {SignR, 8'hFF, 23'b0}; // +-Infinito x +-Infinito = +-Infinito
			end else if (((dataA[30:23] == 8'hFF) && (dataA[22:0] != 23'b0)) || 
							((dataB[30:23] == 8'hFF) && (dataB[22:0] != 23'b0))) begin
							dataR = {SignR, 31'h7FC00000}; // +-Infinito x NaN = +-NaN
			end else begin
							dataR = {SignR, 8'hFF, 23'b0}; // +- Infinito x Finito = +- Infinito
			end
		end else if (((dataA[30:23] == 8'hFF) && (dataA[22:0] != 23'b0)) || 
						((dataB[30:23] == 8'hFF) && (dataB[22:0] != 23'b0))) begin
				      dataR = 32'h7FC00000; // NaN x 0 = NaN , NaN x NaN = NaN, NaN x Finito = NaN
		end else if ((dataA == 30'b0) || (dataB == 30'b0))	begin
						dataR = 32'b0; // 0 x Finito = 0
		end else begin
					dataR = {SignR, ExponentR, Fracc}; // Casos normales
		end

	end 
endmodule

// ***************************** 
// Testbench for Multiplier Unit
// ***************************** 
module tb_multiplierunit ();
		// Declaración de señales para las entradas y salidas
		logic [31:0] dataA, dataB;
		logic [31:0] dataR;

		
		multiplierunit multiplier_unit (dataA, dataB, dataR);
		initial begin
			// Establecer valores de entrada para dataA y dataB
			dataA = 32'h7FC00000 ; 
			dataB = 32'h7FC00000;  //NaN x NaN

			#10;
		
			dataA = 32'h7F800000 ; 
			dataB = 32'h7F800000; //Infinito x Infinito
			#10;
			
			dataA = 32'h7FC00000 ;
			dataB = 32'h7F800000; //NaN x Infinito
			
			#10;
			
			dataA = 32'b0;
			dataB = 32'h7F800000; //Infinito x 0
			
			#10;
			
			dataA = 32'h7FC00000 ; 
			dataB = 32'b0; //NaN x 0
			
			#10;
			
			dataA = 32'h3F800000; 
			dataB = 32'b0; // Finito x 0
			
			#10;
			
			dataA = 32'h3F800000; 
			dataB = 32'h7F800000; // Finito x Infinito
			#10;
			dataA = 32'h3F800000; 
			dataB = 32'h7FC00000; // Finito x NaN
			#10
			
			// Terminar la simulación
			$finish;
		end

endmodule
