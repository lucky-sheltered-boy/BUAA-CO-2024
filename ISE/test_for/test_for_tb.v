`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:33:08 09/25/2024
// Design Name:   for_test
// Module Name:   /home/co-eda/ISE/test_for/test_for_tb.v
// Project Name:  test_for
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: for_test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_for_tb;

	// Inputs
	reg [31:0] in;

	// Outputs
	wire [31:0] sum;

	// Instantiate the Unit Under Test (UUT)
	for_test uut (
		.in(in), 
		.sum(sum)
	);

	initial begin
		// Initialize Inputs
		in = 32'hffffffff;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

