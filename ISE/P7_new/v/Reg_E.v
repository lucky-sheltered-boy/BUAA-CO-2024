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
	input [4:0] Exception_E,
	input [4:0] rd_E,
	input CP0_en_E,
	input BD_E,
	input req,
	input EXLClr_E,
	
	output reg EXLClr_M,
	output reg BD_M,
	output reg CP0_en_M,
	output reg [4:0] rd_M,
	output reg [4:0] Exception_M_pre,
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
		if(reset || req) begin
			if(reset) begin
				Pc_M <= 32'h00003000;
			end else if(req) begin
				Pc_M <= 32'h00004180;
			end
			AluAns_M <= 0;
			WR_M <= 0;
			RD2_M <= 0;
			
			MemToReg_M <= 0;
			RegWrite_M <= 0;
			MemWrite_M <= 0;
			InstrType_M <= `nop;
			TNew_M <= 0;
			Addr2_M <= 0;
			Exception_M_pre <= `Int;
			rd_M <= 0;
			CP0_en_M <= 0;
			BD_M <= 0;
			EXLClr_M <= 0;
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
			Exception_M_pre <= Exception_E;
			rd_M <= rd_E;
			CP0_en_M <= CP0_en_E;
			BD_M <= BD_E;
			EXLClr_M <= EXLClr_E;
		end
	end

endmodule
