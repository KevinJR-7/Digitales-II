module shift(input logic [31:0] rd2,
				 input logic [4:0] shamt,
				 input logic [1:0] sh, 
				 output logic [31:0] OutShift);


			always_comb
			
			
				case(sh) 
					 2'b00: begin 
							OutShift	= rd2 << shamt; // LSL Instruction //aplicarcorrimientos
					end 
					2'b01: begin
							OutShift	= rd2 >> shamt; // LSR Instruction 
					end
							
					2'b10: begin 
							OutShift	= rd2 >>> shamt; // ASR Instruction 
					end		
					2'b11: begin
							OutShift	= (rd2 >> shamt) | (rd2 << (32-shamt)); // ROR Instruction 
					end
					default: 
							OutShift = rd2;
			

		endcase
		
endmodule
