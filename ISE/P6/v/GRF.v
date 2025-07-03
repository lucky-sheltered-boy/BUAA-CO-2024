`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:24:51 10/30/2024 
// Design Name: 
// Module Name:    GRF 
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

module GRF(
	input clk,
	input reset,
	input WE,
	input [4:0] A1, A2, A3,
	input [31:0] WD,
	input [31:0] PC,
	output reg [31:0] RD1,
	output reg [31:0] RD2
    );

	reg [31:0] register [31:0];
	integer i;
	
	always@(posedge clk) begin
		if(reset) begin
			for(i=0;i<=31;i=i+1) begin
				register[i] <= 0;
			end
		end else begin
			if(WE) begin
				if(A3 != 0) begin
					register[A3] <= WD;
				end else begin
					register[0] <= 0;
				end
				//$display("%d@%h: $%d <= %h", $time, PC, A3, WD);
			end
		end
	end

	always@(*) begin
		if(A1 == 0) begin
			RD1 = 0;
		end else begin
			if(A3 == A1) begin
				RD1 = WD;
			end else begin
				RD1 = register[A1];
			end	
		end
	end
	
	always@(*) begin
		if(A2 == 0) begin
			RD2 = 0;
		end else begin
			if(A3 == A2) begin
				RD2 = WD;
			end else begin
				RD2 = register[A2];
			end	
		end
	end
	
endmodule
