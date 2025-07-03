`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:37:40 11/11/2024
// Design Name:   main
// Module Name:   /media/shared/share/ISE/test/main_tb.v
// Project Name:  test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module main_tb;

	// Inputs
	reg [7:0] num1;
	reg [7:0] num2;

	// Outputs
	wire [7:0] ans1;
	wire [7:0] ans2;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.num1(num1), 
		.num2(num2), 
		.ans1(ans1), 
		.ans2(ans2)
	);

	initial begin
		// Initialize Inputs
		num1 = 8'b11001001;
		num2 = 8'b11001001;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

