`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:54:38 11/29/2024 
// Design Name: 
// Module Name:    CP0 
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

module CP0(
	input clk,
	input reset,
	input en,
	input [4:0] CP0_Addr,
	input [31:0] CP0_In,
	input [31:0] VPC,
	input BD_In,
	input [4:0] Exception,
	input [5:0] HWInt,
	input EXLClr,
	
	output reg [31:0] CPO_Out,
	output reg [31:0] EPC_Out,
	output req
    );
		
	reg [31:0] SR, Cause, EPC;
	
	always@(posedge clk) begin
		if(reset) begin
			SR <= 0;
			Cause <= 0;
			EPC <= 0;
		end else begin
			
		end
	end
	
	assign req = Exception == 
	
endmodule
