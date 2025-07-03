`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:47:04 11/21/2024 
// Design Name: 
// Module Name:    VoterPlus 
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
//`default_nettype none

module VoterPlus(
	input clk,
	input reset,
	input [31:0] np,
	input [7:0] vip,
	input vvip,
	output reg [7:0] result
    );
	 
	 reg [31:0] status_np, next_np;
	 reg [7:0] status_vip, next_vip;
	 reg status_vvip, next_vvip;
	 reg [7:0] next_result;
	 
	 reg [7:0] num_np, num_vip, num_vvip;
	 integer i;
	 
	 always@(posedge clk or posedge reset) begin
		if(reset) begin
			result <= 0;
			status_np <= 0;
			status_vip <= 0;
			status_vvip <= 0;
		end else begin
			result <= next_result;
			status_np <= next_np;
			status_vip <= next_vip;
			status_vvip <= next_vvip;
		end
	 end
	 
	always@(*) begin
		next_np = status_np | np;
		next_vip = status_vip | vip;
		next_vvip = status_vvip | vvip;
	
		num_np = 0;
		for(i=0;i<=31;i=i+1) begin
			if(next_np[i] == 1'b1) begin
				num_np = num_np + 1;
			end
		end
		
		num_vip = 0;
		for(i=0;i<=7;i=i+1) begin
			if(next_vip[i] == 1'b1) begin
				num_vip = num_vip + 1;
			end
		end
		
		num_vvip = next_vvip;
	
	
	
		next_result = num_np + 8'd4 * num_vip + 8'd16 * num_vvip;
	end
endmodule
