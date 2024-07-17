/*
 * This module is the Datapath Unit of the ARM single-cycle processor
 */ 
module datapath(input logic clk, reset,
					 input logic [1:0] RegSrc,
					 input logic RegWrite,
					 input logic [1:0] ImmSrc,
					 input logic ALUSrc,
					 input logic [2:0] ALUControl,
					 input logic MemtoReg,
					 input logic PCSrc, LSrc, EscaSrc,
					 output logic [3:0] ALUFlags,
					 output logic [31:0] PC,
					 input logic [31:0] Instr,
					 output logic [31:0] ALUResult, WriteData,
					 input logic [31:0] ReadData);
	// Internal signals
	logic [31:0] PCNext, PCPlus4, PCPlus8;
	logic [31:0] ExtImm, SrcA, SrcB, Result, outShift, WD3;
	logic [3:0] RA1, RA2, RA3;
	logic [2:0] Cmux3;
	
	// next PC logic
	mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
	flopr #(32) pcreg(clk, reset, PCNext, PC);
	adder #(32) pcadd1(PC, 32'b100, PCPlus4);
	adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

	// register file logic
	assign Cmux3 = {EscaSrc, RegSrc[0]}; // Señal para controlar el mux3 
	mux3 #(4) ra1mux(Instr[19:16], 4'b1111, Instr[11:8], Cmux3, RA1);
	
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
	mux2 #(4) muxBL_A3(Instr[15:12], 4'b1110, LSrc, RA3);
	mux2 #(32) muxBL_WD3(Result, PCPlus4, LSrc, WD3);
	regfile rf(clk, RegWrite, RA1, RA2, RA3, WD3, PCPlus8, SrcA, WriteData);
	mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);

	extend ext(Instr[23:0], ImmSrc, ExtImm);
	
	// shifter
	shift shifter(Instr[11:4], SrcA, WriteData, outShift);

	// ALU logic
	mux2 #(32) srcbmux(outShift, ExtImm, ALUSrc, SrcB);
	alu #(32) alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
endmodule