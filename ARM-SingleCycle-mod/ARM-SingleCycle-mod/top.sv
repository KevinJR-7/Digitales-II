/*
 * This module is the TOP of the ARM single-cycle processor
 */ 
module top(input logic clk, nreset,
			  output logic [31:0] WriteData, DataAdr,
			  output logic MemWrite,
			  input logic [9:0] switches,
			  output logic [9:0] leds);

	// Internal signals
	logic reset;
	assign reset = ~nreset;
	logic [31:0] PC, Instr, ReadData;
	
	// Instantiate instruction memory
	imem imem(PC, Instr);

	// Instantiate data memory (RAM + peripherals)
	dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData, switches, leds);

	// Instantiate processor
	arm arm(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);
endmodule

/*
 * Testbench taken from the ARM book
 */ 
module testbench_book();
	logic clk;
	logic reset;
	logic [31:0] WriteData, DataAdr;
	logic MemWrite;

	// instantiate device to be tested
	top dut(clk, reset, WriteData, DataAdr, MemWrite);

	// initialize test
	initial
	begin
		reset <= 0; # 22; reset <= 1;
	end

	// generate clock to sequence tests
	always
	begin
		clk <= 1; # 5; clk <= 0; # 5;
	end

	// check that 7 gets written to address 0x64
	// at end of program
	always @(negedge clk)
	begin
		if(MemWrite) begin
			if(DataAdr === 100 & WriteData === 7) begin
				$display("Simulation succeeded");
				$stop;
			end else if (DataAdr !== 96) begin
				$display("Simulation failed");
				$stop;
			end
		end
		if (WriteData === 12) begin
			$stop;
		end
	end
endmodule