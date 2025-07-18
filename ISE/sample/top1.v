`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:37:57 08/27/2024 
// Design Name: 
// Module Name:    top_module 
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
module top1(
	input [6:0] in,
	output reg [2:0] out
    );

	integer i;
	always@(*)begin
		out=0;
		for(i=0;i<7;i=i+1)begin
			if(in[i]==1) out=out+1'b1;
			else out=out+1'b0;
		end
	end
endmodule
