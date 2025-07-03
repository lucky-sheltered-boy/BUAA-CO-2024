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
	input [4:0] Exception_F,
	input BD_F,
	input req,
	input eret_D,
	input [31:0] EPC,
	
	output reg BD_D,
	output reg [4:0] Exception_D_pre,
	output reg [31:0] Pc_D,
	output reg [31:0] Instruction_D
    );

	reg [31:0] NextPc_D, NextInstruction_D;
	
	always@(posedge clk) begin
		if(reset || req) begin
			if(reset) begin
				Pc_D <= 32'h00003000;
			end else if(req) begin
				Pc_D <= 32'h00004180;
			end
			Instruction_D <= 0;
			Exception_D_pre <= `Int;
			BD_D <= 0;
		end else begin
			if(En_F == 1) begin
				if(eret_D) begin
					Pc_D <= EPC;
					Instruction_D <= 32'd0;
					Exception_D_pre <= `Int;
					BD_D <= 0;
				end else begin
					Pc_D <= NextPc_D;
					Instruction_D <= NextInstruction_D;
					Exception_D_pre <= Exception_F;
					BD_D <= BD_F;
				end
			end
		end
	end

	always@(*) begin
		NextPc_D = Pc_F;
		NextInstruction_D = Instruction_F;
	end

endmodule
