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
module GRF(
	input clk,
	input reset,
	input WE,
	input req,
	input [4:0] A1, A2, A3,
	input [31:0] WD,
	input [31:0] PC,
	output [31:0] RD1, RD2
    );

	reg [31:0] register [31:0];
	integer i;
	
	always@(posedge clk) begin
		if(reset) begin
			for(i=0;i<=31;i=i+1) begin
				register[i] <= 0;
			end
		end else begin
			if(req == 0 && WE) begin
				if(A3 != 0) begin
					register[A3] <= WD;
				end else begin
					register[0] <= 0;
				end
				$display("@%h: $%d <= %h", PC, A3, WD);
			end
		end
	end

	assign RD1 = register[A1];
	assign RD2 = register[A2];
	
endmodule
