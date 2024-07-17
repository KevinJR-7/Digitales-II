/*Modulo para convertir binario a dos displays de 7 segmentos*/
module deco7seg(
	input  logic [3:0] num,
	output logic [6:0] SegD,
	output logic [6:0] SegR
);
	logic[3:0] dec, res;
	always_comb begin
		dec = num/10;
		res = num%10;
		end
		
	always_comb begin
		case(dec)
			4'b0001: SegD = 7'b1111001; // 0x79
			default: SegD = 7'b1111111;
		endcase
	end
	always_comb begin
		case(res)
			4'b0000: SegR = 7'b1000000; // 0x40
			4'b0001: SegR = 7'b1111001; // 0x79
			4'b0010: SegR = 7'b0100100; // 0x24
			4'b0011: SegR = 7'b0110000; // 0x30
			4'b0100: SegR = 7'b0011001; // 0x19
			4'b0101: SegR = 7'b0010010; // 0x12 
			4'b0110: SegR = 7'b0000010; // 0x02
			4'b0111: SegR = 7'b1111000; // 0x78
			4'b1000: SegR = 7'b0000000; // 0x00
			4'b1001: SegR = 7'b0011000; // 0x18
			4'b1010: SegR = 7'b0001000; // 0x08
			4'b1011: SegR = 7'b0000011; // 0x03
			4'b1100: SegR = 7'b1000110; // 0x46
			4'b1101: SegR = 7'b0100001; // 0x30
			4'b1110: SegR = 7'b0000110; // 0x06
			4'b1111: SegR = 7'b0001110; // 0x0E
			default: SegR = 7'b1111111;
		endcase
	end
endmodule