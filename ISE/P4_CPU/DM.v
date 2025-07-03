`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:36:34 10/30/2024 
// Design Name: 
// Module Name:    DM 
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
module DM(
	input [31:0] addr,
	input [31:0] WD,
	input clk,
	input reset,
	input WE,
	input [31:0] PC,
	output [31:0] data 
    );

	reg [31:0] data_memory [3072:0];
	integer i;
	reg [31:0] temp;
	
	always@(posedge clk) begin
		if(reset) begin
			for(i=0;i<=3072;i=i+1) begin
				data_memory[i] <= 0;
			end
		end else begin
			if(WE) begin
				data_memory[temp] <= WD;
				$display("@%h: *%h <= %h", PC, addr, WD);
			end
		end
	end	

	always@(*) begin
		temp = addr >> 2;
	end

	assign data = data_memory[temp];

endmodule
