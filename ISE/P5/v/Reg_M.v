`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:56:41 11/07/2024 
// Design Name: 
// Module Name:    Reg_M 
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

module Reg_M(
	input clk,
	input reset,
	input [31:0] Pc_M,
	input [31:0] AluAns_M,
	input [4:0] WR_M,
	input [31:0] DmAns_M,
	
	input [1:0] MemToReg_M,
	input RegWrite_M,
	input [7:0] InstrType_M,
	input [7:0] TNew_M,
	
	output reg [31:0] Pc_W,
	output reg [31:0] AluAns_W,
	output reg [4:0] WR_W,
	output reg [31:0] DmAns_W,
	
	output reg [1:0] MemToReg_W,
	output reg RegWrite_W,
	output reg [7:0] InstrType_W,
	output reg [7:0] TNew_W
	);

	always@(posedge clk) begin
		if(reset) begin
			Pc_W <= 32'h00003000;
			AluAns_W <= 0;
			WR_W <= 0;
			DmAns_W <= 0;
			MemToReg_W <= 0;
			RegWrite_W <= 0;
			InstrType_W <= `nop;
			TNew_W <= 0;
		end else begin
			Pc_W <= Pc_M;
			AluAns_W <= AluAns_M;
			WR_W <= WR_M;
			DmAns_W <= DmAns_M;
			MemToReg_W <= MemToReg_M;
			RegWrite_W <= RegWrite_M;
			InstrType_W <= InstrType_M;
			if(TNew_M == 0) begin
				TNew_W <= 0;
			end else begin
				TNew_W <= TNew_M - 1;
			end
		end
	end

endmodule
