// **********************
// Multiplier Unit Module
// **********************
module multiplierunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the multiplication
	logic [47:0] mantisa;
	logic [7:0] expR;
	logic [7:0] expR_1; 
	logic signo;

	// Para normalizar la mantissa, se corre el punto hacia la derecha y se suma 1 al exponente
	assign expR_1 = expR+1;
			
	// Process: sign XORer
	assign signo = dataA[31] ^ dataB[31];
	
	// Process: exponent adder
	assign expR = dataA[30:23]+(dataB[30:23]-127);	
	
	// Process: mantissa multiplier
	assign m_mantisa = {1'b1, dataA[22:0]}*{1'b1, dataB[22:0]};
	
	// Process: operand validator and result normalizer and assembler
	always_comb begin
	
		// 0 × ±finito = 0
		if (dataA == 0 && dataB == 0) begin
			dataR = 0;
		// 0 × ± infinito = NaN
		end else if ((dataB[30:23] == 255) && dataB[22:0] == 0)begin
			dataR = 32'hffffffff;
		end else if(mantisa[47]== 1) 
				dataR = {signo, expR_1, mantisa[46:24]};		
		else
				dataR = {signo, expR, mantisa[45:23]};
	end
	
endmodule

// ***************************** 
// Testbench for Multiplier Unit
// ***************************** 
module multi_tb();

	logic [31:0] A_tb, B_tb, R_tb;
	localparam delay = 20ns;

	multiplier duff (A_tb, B_tb, R_tb);

	initial begin
	A_tb = 32'h00000000;
	B_tb = 32'h00000000;
	#(delay);

	A_tb = 32'hC124CCCD;
	B_tb = 32'hBF8CCCCD;
	#(delay);

	A_tb = 32'hC25E0000;
	B_tb = 32'h41A73333;
	#(delay);

	A_tb = 32'h41BCCCCD;
	B_tb = 32'hC1200000;
	#(delay);
	$stop;
	end
endmodule