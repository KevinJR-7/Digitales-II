/*Modulo para convertir binario a dos displays de 7 segmentos*/
module deco7seg(
	input  logic [3:0] num,
	output logic [6:0] Seg
);
		
	always_comb begin
		case(num)
			4'b0000: Seg = 7'b1000000; // 0x40 - 0
			4'b0001: Seg = 7'b1111001; // 0x79 - 1
			4'b0010: Seg = 7'b0100100; // 0x24 - 2
			4'b0011: Seg = 7'b0110000; // 0x30 - 3
			4'b0100: Seg = 7'b0011001; // 0x19 - 4
			4'b0101: Seg = 7'b0010010; // 0x12 - 5
			4'b0110: Seg = 7'b0000010; // 0x02 - 6
			4'b0111: Seg = 7'b1111000; // 0x78 - 7
			4'b1000: Seg = 7'b0000000; // 0x00 - 8
			4'b1001: Seg = 7'b0011000; // 0x18 - 9
			4'b1010: Seg = 7'b0001000; // 0x08 - a
			4'b1011: Seg = 7'b0000011; // 0x03 - b
			4'b1100: Seg = 7'b1000110; // 0x46 - c
			4'b1101: Seg = 7'b0100001; // 0x30 - d
			4'b1110: Seg = 7'b0000110; // 0x06 - e
			4'b1111: Seg = 7'b0001110; // 0x0E - f
			default: Seg = 7'b1111111;
		endcase
	end
endmodule