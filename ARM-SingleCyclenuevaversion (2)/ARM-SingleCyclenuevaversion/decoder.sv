/*
 * This module is the Decoder of the Control Unit
 */ 
module decoder(input logic [1:0] Op,
					input logic [5:0] Funct,
					input logic [3:0] Rd,
					output logic [1:0] FlagW,
					output logic PCS, RegW, MemW,
					output logic MemtoReg, ALUSrc,
					output logic [1:0] ImmSrc, RegSrc, ALUControl,
					output logic Shifted);
	// Internal signals
	logic [9:0] controls;
	logic Branch, ALUOp;
	logic NoWrite;

	// Main Decoder
	always_comb
		casex(Op)
											// Data-processing immediate
			2'b00: 	if (Funct[5])	controls = 10'b0000101001;
											// Data-processing register
						else				controls = 10'b0000001001;
											// LDR
			2'b01: 	if (Funct[0])	controls = 10'b0001111000;
											// STR
						else				controls = 10'b1001110100;
											// BL
			2'b10: 	if (Funct[4]) 	controls = 12'b0110_1010_1010; // Funct [4] = L (pero es el L de branch: Instr[24])
											// B
						else				controls = 12'b0110_1000_1000;
											// Unimplemented
			default: 					controls = 10'bx;
		endcase
		
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;

	// ALU Decoder
	always_comb
		if (ALUOp) begin // which DP Instr?
			case(Funct[4:1])
				4'b0100: begin
							ALUControl = 2'b00; // ADD
							NoWrite = 1'b0;
							Shifted = 1'b0;
							
				end
				4'b0010: begin
							ALUControl = 2'b01; // SUB
							NoWrite = 1'b0;
							Shifted = 1'b0;
				end
				4'b0000: begin
							ALUControl = 2'b10; // AND
							NoWrite = 1'b0;
							Shifted = 1'b0;
				end
				4'b1100: begin
							ALUControl = 2'b11; // ORR
							NoWrite = 1'b0;
							Shifted = 1'b0;
				end
				4'b1101: begin //lsl,lsr,asr, ror
							ALUControl = 2'b00;
							NoWrite = 1'b0;
							Shifted = 1'b1;
				end
				
				default: begin
							ALUControl = 2'bx; // unimplemented
							NoWrite = 1'bx;
							Shifted = 1'bx;
				end
			endcase

			// update flags if S bit is set (C & V only for arith)
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
			end 
			else begin
				ALUControl = 2'b00; // add for non-DP instructions
				FlagW = 2'b00; // don't update Flags
				NoWrite = 1'b0;
				Shifted = 1'b0;
			end
			
	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
