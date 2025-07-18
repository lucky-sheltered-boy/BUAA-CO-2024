`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:27:36 08/29/2024 
// Design Name: 
// Module Name:    test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test(
	input in,
	input clk,
	output reg out
    );

	reg register;
	
	always@(posedge clk) begin
		out=register;
	end
	
	always@(*) begin
		register=in;
	end

endmodule
