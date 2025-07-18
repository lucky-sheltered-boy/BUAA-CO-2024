`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:44:59 09/23/2024
// Design Name:   cscore
// Module Name:   /home/co-eda/ISE/pre_test/cscore_tb.v
// Project Name:  pre_test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cscore
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cscore_tb;

	// Inputs
	reg [7:0] char;
	reg clk;

	// Outputs
	wire [7:0] out;

	// Instantiate the Unit Under Test (UUT)
	cscore uut (
		.char(char), 
		.clk(clk), 
		.out(out)
	);

	initial begin
		clk = 0;
		
		char = "c";
		#10
		char = "s";
		#10
		char = "c";
		#10
		char = "o";
		#10
		char = "r";
		#10
		char = "e";
		#10
		
		char = "c";
		#10
		char = "s";
		#10
		char = "c";
		#10
		char = "o";
		#10
		char = "r";
		#10
		char = "e";
		#10
		
		char = "s";
		#10
		char = "c";
		#10
		
		char = "c";
		#10
		char = "s";
		#10
		char = "c";
		#10
		char = "o";
		#10
		char = "r";
		#10
		char = "e";
		#10;
	end
      
	always #5 clk = ~clk;
		
endmodule

