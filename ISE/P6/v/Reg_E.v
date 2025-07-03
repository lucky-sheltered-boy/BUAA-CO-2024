`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:25:30 11/07/2024 
// Design Name: 
// Module Name:    Reg_E 
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

module Reg_E(
	input clk,
	input reset,
	input [31:0] Pc_E,
	input [31:0] AluAns_E,
	input [4:0] WR_E,
	input [31:0] RD2_E,
	
	input [1:0] MemToReg_E,
	input RegWrite_E,
	input MemWrite_E,
	input [7:0] InstrType_E,
	input [7:0] TNew_E,
	input [4:0] Addr2_E,
	
	output reg [31:0] Pc_M,
	output reg [31:0] AluAns_M,
	output reg [4:0] WR_M,
	output reg [31:0] RD2_M,
	
	output reg [1:0] MemToReg_M,
	output reg RegWrite_M,
	output reg MemWrite_M,
	output reg [7:0] InstrType_M,
	output reg [7:0] TNew_M,
	output reg [4:0] Addr2_M
    );

	always@(posedge clk) begin
		if(reset) begin
			Pc_M <= 32'h00003000;
			AluAns_M <= 0;
			WR_M <= 0;
			RD2_M <= 0;
			
			MemToReg_M <= 0;
			RegWrite_M <= 0;
			MemWrite_M <= 0;
			InstrType_M <= `nop;
			TNew_M <= 0;
			Addr2_M <= 0;
		end else begin
			Pc_M <= Pc_E;
			AluAns_M <= AluAns_E;
			WR_M <= WR_E;
			RD2_M <= RD2_E;
			
			MemToReg_M <= MemToReg_E;
			RegWrite_M <= RegWrite_E;
			MemWrite_M <= MemWrite_E;
			InstrType_M <= InstrType_E;
			if(TNew_E == 0) begin
				TNew_M <= 0;
			end else begin
				TNew_M <= TNew_E - 1;
			end
			Addr2_M <= Addr2_E;
		end
	end

endmodule
