`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:47:26 10/30/2024 
// Design Name: 
// Module Name:    Extender 
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

module Extender(
	input [15:0] num,
	input [25:0] jal,
	input [7:0] Extop,
	input [31:0] PC,
	output reg [31:0] ans
    );
	 
	 always@(*) begin
		case(Extop)
			8'b00000000: begin
				ans = { {16{1'b0}} , num};            //zero
			end
			8'b00000001: begin
				ans = { {16{num[15]}} , num };   //sign
			end
			8'b00000010: begin
				ans = {num, {16{1'b0}} };
			end
			8'b00000011: begin
				ans = ({ {16{num[15]}} , num } << 2);
			end
			8'b00000100: begin
				ans = { PC[31:28],  jal, 2'b00};
			end
		endcase
	 end


endmodule
