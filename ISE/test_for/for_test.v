`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:36:11 09/23/2024 
// Design Name: 
// Module Name:    for 
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
module for_test(
	input [31:0] in,
	output reg [31:0] sum
    );
	integer i;
	always@(*) begin
		 sum = 0 ;
		 for (i=0; i<=31; i=i+1) begin
			  sum = sum + in[i]  ;
		 end
	end
endmodule
