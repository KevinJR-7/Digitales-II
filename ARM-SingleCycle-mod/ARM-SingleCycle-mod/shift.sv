/*
 * This module is the Extend block of the Datapath Unit
 */ 
module shift(input logic [7:0] Instr,
				  input logic signed [31:0] SrcA, RD2,
				  output logic signed [31:0] outShift);
	always_comb begin
		case(Instr[2:1]) //
			// LSL
			2'b00:	if (~Instr[0]) outShift = RD2 << Instr[7:3]; // Desplazamiento de Instr [7:3] = shamt5 
						else 				outShift = RD2 << SrcA;
			// LSR
			2'b01: 	if (~Instr[0]) outShift = RD2 >> Instr[7:3]; // Desplazamiento de Instr [7:3] = shamt5 
						else 				outShift = RD2 >> SrcA;
			// ASR
			2'b10:	if (~Instr[0]) outShift = RD2 >>> Instr[7:3]; // Desplazamiento de Instr [7:3] = shamt5 
						else 				outShift = RD2 >>> SrcA;
			// ROR
			default: if (~Instr[0]) outShift = (RD2 << Instr[7:3]) | (outShift = RD2 >> (32 - Instr[7:3])); 
						else 				outShift = (RD2 << SrcA) | (outShift = RD2 >> (32 - SrcA));
		endcase
	end 
endmodule