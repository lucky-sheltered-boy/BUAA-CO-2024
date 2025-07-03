`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:35:53 10/30/2024 
// Design Name: 
// Module Name:    splitter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

`include "constants.v"

module splitter(
	input [31:0] instruction,
	output [5:0] Op,
	output [5:0] Func,
	output [4:0] rs,
	output [4:0] rt,
	output [4:0] rd,
	output [15:0] immediate,
	output [25:0] jal
    );
	
	assign Op = instruction[31:26];
	assign Func = instruction[5:0];
	assign rs = instruction[25:21];
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];
	assign immediate = instruction[15:0];
	assign jal = instruction[25:0];
	
endmodule
