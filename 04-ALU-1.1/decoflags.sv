module decoflags #(BITS = 5) (Af, Bf, Sumf, num,cout, aluControl, flags);

	input logic Af, Bf, Sumf, cout;
	input logic [1:0] aluControl;
	input logic [BITS-1 : 0] num;
	output logic [3:0] flags; // N,Z,C,V
	
	// Internal signals
	logic S1,S2,S3,S4;
	
	assign S4 = aluControl[0];
	assign S3 = ~(aluControl[1]);
	assign S1 = ~(S4 ^ Af ^ Bf);	//Xnor
	assign S2 = Af ^ Sumf;	//Xor
	
	assign flags[0] = num[BITS-1];	//Negative
	assign flags[1] = &(~num);	//Zero
	assign flags[2] = S3 & cout;	//Carry
	assign flags[3] = S1 & S2 & S3;	//oVerflow
	

endmodule