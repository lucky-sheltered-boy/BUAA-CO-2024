`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:30:40 08/29/2024
// Design Name:   test
// Module Name:   /home/co-eda/ISE/Verilog_counter/test_tb.v
// Project Name:  Verilog_counter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_tb;

	// Inputs
	reg in;
	reg clk;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	test uut (
		.in(in), 
		.clk(clk), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#5;
        
		// Add stimulus here

	end
   
		
		always #5 in=~in;
		always #5 clk=~clk;
endmodule

