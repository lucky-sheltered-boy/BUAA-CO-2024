`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:35 10/30/2024 
// Design Name: 
// Module Name:    IM 
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

module IM(
	input [31:0] Pc_F,
	output reg [31:0] Instruction
    );

	reg [31:0] instruction_memory [7168:3072];
	reg [31:0] temp;
	
	initial begin
		$readmemh("code.txt", instruction_memory, 3072, 7168);
	end
	
	always@(*) begin
		temp = Pc_F >> 2;
		Instruction = instruction_memory[temp];
	end
	
endmodule
