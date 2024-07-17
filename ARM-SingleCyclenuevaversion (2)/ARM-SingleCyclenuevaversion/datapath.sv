module datapath(input logic clk, reset,
					 input logic [1:0] RegSrc,
					 input logic RegWrite,
					 input logic [1:0] ImmSrc,
					 input logic ALUSrc,
					 input logic [2:0] ALUControl, // Nuevo modo para la instrucción MOV
					 input logic MemtoReg,
					 input logic PCSrc,
					 output logic [3:0] ALUFlags,
					 output logic [31:0] PC,
					 input logic [31:0] Instr,
					 output logic [31:0] ALUResult, WriteData, 
					 input logic [31:0] ReadData,
					 input logic shifted); //señal para mux después de la Alu
	// Internal signals
	logic [31:0] PCNext, PCPlus4, PCPlus8;
	logic [31:0] ExtImm, SrcA, SrcB, Result, WD3;
	logic [3:0] RA1, RA2, A3;
	logic [31:0] OutShift, ALUresult;
	logic bl_en; // Nueva señal de control para el salto BL

	// next PC logic
	mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
	flopr #(32) pcreg(clk, reset, PCNext, PC);
	adder #(32) pcadd1(PC, 32'b100, PCPlus4);
	adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

	// register file logic
	mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
	regfile rf(clk, RegWrite, RA1, RA2,
					A3, WD3, PCPlus8, 
					SrcA, WriteData);
	mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
	extend ext(Instr[23:0], ImmSrc, ExtImm);

	// ALU logic
	//mux2 #(32) srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
	shift sh(WriteData, Instr[11:7], Instr[6:5], OutShift); //Shift operaciones lsl, lsr, asr, ror
	mux2 #(32) srcbmux(OutShift, ExtImm, ALUSrc, SrcB);
	alu #(32) alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
	mux2 #(32) aluresultmux(ALUResult, SrcB, Shifted, ALUResultOut);  //MUX POST INDEX

	// Salto BL
	mux2 #(4) mux1bl(Instr[15:12],PCPlus4, RegSrc, A3);  
	mux2 #(32) mux2bl(Result, PC, RegSrc, WD3);
	//assign bl_en = (Instr[27:24] == 4'b1001); // Decodificador de salto BL
	//assign PCNext = bl_en ? ALUResult : PCPlus8; // Escritura en el registro de PC para el salto BL
endmodule