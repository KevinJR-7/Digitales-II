// ******************* 
// Get Operands Module
// ******************* 

module peripheral_getoperands (inputdata, datainput_i, dataA, dataB);
	input logic [7:0] inputdata;
	input logic [3:0] datainput_i;
	output logic [31:0] dataA, dataB;

	// Internal signals and processes to store data into proper registers
	logic [63:0] total;
	assign total[datainput_i*8 +: 8] = inputdata;
	assign dataA = total[31:0];
	assign dataB = total[63:32];
	
	
endmodule			