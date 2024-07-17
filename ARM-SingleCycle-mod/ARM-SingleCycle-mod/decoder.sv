/*
 * This module is the Decoder of the Control Unit
 */ 
module decoder(input logic [1:0] Op,
					input logic [5:0] Funct,
					input logic [3:0] Rd,
					input logic shR, 
					output logic [1:0] FlagW,
					output logic PCS, RegW, MemW, NoWrite, LSrc, EscaSrc, 
					output logic MemtoReg, ALUSrc,
					output logic [1:0] ImmSrc, RegSrc, 
					output logic [2:0] ALUControl);
	// Internal signals
	logic [11:0] controls; // Antes era de 10 bits
	logic Branch, ALUOp;

	// Main Decoder
	always_comb
		casex(Op)
											// Data-processing immediate
			2'b00: 	if (Funct[5])	controls = 12'b0000_1010_0100;
											// Data-processing register with escalate as a register
						else if (shR)  controls = 12'b0000_0010_0101;
											// Data-processing register with escalate as a immediate
						else 				controls = 12'b0000_0010_0100;
											// LDR controls = 12'b0001_1110_0000; Funct[0] (L)
			2'b01: 	if (Funct[0]) begin 
							if (~Funct[5]) begin // Memory-instruction (LDR) immediate 
											controls = 12'b0001_1110_0000;
							end 
							else 			controls = 12'b0001_0110_0000; // With escalate
						end
											// STR controls = 12'b1001_1101_0000;
						else begin 
							if (~Funct[5]) begin // Memory-instruction (STR) immediate
											controls = 12'b1001_1101_0000;
							end 
							else 			controls = 12'b1001_0101_0000; // With escalate
						end 
											// BL
			2'b10:	if (Funct[4]) 	controls = 12'b0110_1010_1010; // Funct [4] = L (pero es el L de branch: Instr[24])
											// B
						else				controls = 12'b0110_1000_1000;
											// Unimplemented
			default: 					controls = 12'bx;
		endcase
		
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, LSrc, EscaSrc} = controls;

	// ALU Decoder
	always_comb begin
		NoWrite = 1'b0;
		if (ALUOp) begin // which DP Instr?
			case(Funct[4:1])
				4'b0100: ALUControl = 3'b000; // ADD
				4'b0010: ALUControl = 3'b001; // SUB
				4'b0000: ALUControl = 3'b010; // AND
				4'b1100: ALUControl = 3'b011; // ORR
				4'b1010: begin
							ALUControl = 3'b001; // SUB
							NoWrite = 1'b1;
							end
				4'b1101: begin
							ALUControl = 3'b100;
							end
				default: ALUControl = 3'bx; // unimplemented
			endcase

			// update flags if S bit is set (C & V only for arith)
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & (ALUControl == 3'b000 | ALUControl == 3'b001);
		end 
		else begin
			ALUControl = 3'b000; // add for non-DP instructions
			FlagW = 2'b00; // don't update Flags
		end
	end	
	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
