`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:25 11/07/2024 
// Design Name: 
// Module Name:    Reg_F 
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

module Reg_F(
	input clk,
	input reset,
	input En_F,
	input [31:0] Pc_F,
	input [31:0] Instruction_F,
	
	output reg [31:0] Pc_D,
	output reg [31:0] Instruction_D
    );

	reg [31:0] NextPc_D, NextInstruction_D;
	
	always@(posedge clk) begin
		if(reset) begin
			Pc_D <= 32'h00003000;
			Instruction_D <= 0;
		end else begin
			if(En_F == 1) begin
				Pc_D <= NextPc_D;
				Instruction_D <= NextInstruction_D;
			end
		end
	end

	always@(*) begin
		NextPc_D = Pc_F;
		NextInstruction_D = Instruction_F;
	end

endmodule
