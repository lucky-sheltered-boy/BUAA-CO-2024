`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:00:35 08/30/2024
// Design Name:   id_fsm
// Module Name:   /home/co-eda/ISE/Verilog_char_automation/id_fsm_tb.v
// Project Name:  Verilog_char_automation
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: id_fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module id_fsm_tb;

	// Inputs
	reg [7:0] char;
	reg clk;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	id_fsm uut (
		.char(char), 
		.clk(clk), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		char = 0;
		clk = 0;

		#2;
		char="a";
		#10;
		char="b";
		#10;
		char="1";
		#10;
		char="2";
		#10;
		char="q";
	end
      always #5 clk=~clk;
endmodule

