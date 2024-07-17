module pulse(
	input logic d,clk,reset,
	output logic pulse
);
	logic q1,q2;
	
	always_ff @(posedge clk, posedge reset) begin
		if (reset) begin
			q1 <= 0;
			q2 <= 0;
		end
		else begin
			q1 <= d;
			q2 <= ~q1;
		end
	end
		assign pulse = q1 & q2;
endmodule