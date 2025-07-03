`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:20 11/07/2024 
// Design Name: 
// Module Name:    Reg_D 
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

module Reg_D(
	input clk,
	input reset,
	input Clr_D,
	input [31:0] Pc_D,
	input [31:0] RD1_D,
	input [31:0] RD2_D,
	input [4:0] WR_D,
	input [31:0] ExtAns_D,
	
	input [1:0] MemToReg_D,
	input RegWrite_D,
	input MemWrite_D,
	input [1:0] AluSrc_D,
	input [7:0] AluOp_D,
	input [7:0] InstrType_D,
	input [7:0] TNew_D,
	input [4:0] Addr1_D,
	input [4:0] Addr2_D,
	input Multiply_D,
	input Divide_D,
	input [4:0] Exception_D,
	input [4:0] rd_D,
	input CP0_en_D,
	input BD_D,
	input req,
	input EXLClr_D,
	
	output reg EXLClr_E,
	output reg BD_E,
	output reg CP0_en_E,
	output reg [4:0] rd_E,
	output reg [4:0] Exception_E_pre,
	output reg [31:0] Pc_E,
	output reg [31:0] RD1_E,
	output reg [31:0] RD2_E,
	output reg [4:0] WR_E,
	output reg [31:0] ExtAns_E,
	
	output reg [1:0] MemToReg_E,
	output reg RegWrite_E,
	output reg MemWrite_E,
	output reg [1:0] AluSrc_E,
	output reg [7:0] AluOp_E,
	output reg [7:0] InstrType_E,
	output reg [7:0] TNew_E,
	output reg [4:0] Addr1_E,
	output reg [4:0] Addr2_E,
	output reg Multiply_E,
	output reg Divide_E
    );
	 
	 reg [31:0] NextPc_E, NextRD1_E, NextRD2_E, NextExtAns_E;
	 reg [4:0] NextWR_E;
	 reg [1:0] NextMemToReg_E, NextAluSrc_E;
	 reg NextRegWrite_E, NextMemWrite_E;
	 reg [7:0] NextAluOp_E, NextInstrType_E;
	 reg [7:0] NextTNew_E;
	 
	 always@(posedge clk) begin
		if(reset || req || Clr_D) begin
			if(reset) begin
				Pc_E <= 32'h00003000;
			end else if(req)  begin
				Pc_E <= 32'h00004180;
			end else if(Clr_D) begin
				Pc_E <= Pc_D;
			end
			RD1_E <= 0;
			RD2_E <= 0;
			WR_E <= 0;
			ExtAns_E <= 0;
			MemToReg_E <= 0;
			AluSrc_E <= 0;
			RegWrite_E <= 0;
			MemWrite_E <= 0;
			AluOp_E <= 0;
			InstrType_E <= `nop;
			TNew_E <= 0;
			Addr1_E <= 0;
			Addr2_E <= 0;
			Multiply_E <= 0;
			Divide_E <= 0;
			Exception_E_pre <= `Int;
			rd_E <= 0;
			CP0_en_E <= 0;
			EXLClr_E <= 0;
			if(reset || req) begin
				BD_E <= 0;
			end else if(Clr_D) begin
				BD_E <= BD_D;
			end
		end else begin
			Pc_E <= NextPc_E;
			RD1_E <= NextRD1_E;
			RD2_E <= NextRD2_E;
			WR_E <= NextWR_E;
			ExtAns_E <= NextExtAns_E;
			MemToReg_E <= NextMemToReg_E;
			AluSrc_E <= NextAluSrc_E;
			RegWrite_E <= NextRegWrite_E;
			MemWrite_E <= NextMemWrite_E;
			AluOp_E <= NextAluOp_E;
			InstrType_E <= NextInstrType_E;
			if(NextTNew_E == 0) begin
				TNew_E <= 0;
			end else begin
				TNew_E <= NextTNew_E - 1;
			end
			Addr1_E <= Addr1_D;
			Addr2_E <= Addr2_D;
			Multiply_E <= Multiply_D;
			Divide_E <= Divide_D;
			Exception_E_pre <= Exception_D;
			rd_E <= rd_D;
			CP0_en_E <= CP0_en_D;
			BD_E <= BD_D;
			EXLClr_E <= EXLClr_D;
		end
	 end	

	always@(*) begin
		NextPc_E = Pc_D;
		NextRD1_E = RD1_D; 
		NextRD2_E = RD2_D;
		NextWR_E = WR_D;
		NextExtAns_E = ExtAns_D;
		NextMemToReg_E = MemToReg_D;
		NextAluSrc_E = AluSrc_D;
		NextRegWrite_E = RegWrite_D;
		NextMemWrite_E = MemWrite_D;
		NextAluOp_E = AluOp_D;
		NextInstrType_E = InstrType_D;
		NextTNew_E = TNew_D;
	end

endmodule
