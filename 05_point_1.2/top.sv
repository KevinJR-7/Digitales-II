// **********
// Top Module
// ********** 
module top (clk, nreset, nenter, inputdata, disp3, disp2, disp1, disp0);
	input logic clk, nreset, nenter;
	input logic [7:0] inputdata;
	output logic [6:0] disp3, disp2, disp1, disp0;
	
	// Internal signals 
	logic loaddata, inputdata_ready;
	logic reset, enter;
	assign reset = ~nreset;
	assign enter = ~nenter;
	
	// Module instantation: control unit 
	controlunit cu0 (clk, reset, loaddata, inputdata_ready);

	// Module instantation: datapath unit 
	datapathunit dp0 (clk, reset, enter, inputdata,
						   loaddata, inputdata_ready,
						   disp3, disp2, disp1, disp0);
endmodule

// ********************** 
// Testbench for Top Unit
// ********************** 
module tb_topunit ();
	// WRITE HERE YOUR CODE
	logic clk, reset, enter;
	logic [7:0]inputdata;
	localparam delay = 20ps;
	logic [6:0] disp3, disp2, disp1, disp0;
	top topt1 (clk, reset, enter, inputdata, disp3, disp2, disp1, disp0);
	initial begin
		clk = 0;
		reset = 0;
		enter = 0;
		
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
		enter = 1;
		inputdata = 8'b10100010;
		#delay;
		enter = 0;
		#delay;
	end
endmodule