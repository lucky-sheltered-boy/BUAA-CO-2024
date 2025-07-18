`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:17:29 10/29/2024 
// Design Name: 
// Module Name:    IM 
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

`define NORMAL 4'b0000
`define BEQ 4'b0001
`define JAL 4'b0010
`define JR 4'b0011

module PC(
	input [3:0] PCop,
	input [31:0] beq,
	input [31:0] jal,
	input [31:0] jr,
	input clk,
	input reset,
	output reg [31:0] PC
    );
	
	reg [31:0] next_pc;
	
	always@(posedge clk) begin
		if(reset) begin
			PC <= 32'h00003000;
		end else begin
			PC <= next_pc;
		end
	end
	
	always@(*) begin
		case(PCop)
			`NORMAL: begin
				next_pc = PC + 4;
			end
			`BEQ: begin
				next_pc = PC + 4 + beq;
			end
			`JAL: begin
				next_pc = jal;
			end
			`JR: begin
				next_pc = jr;
			end
			default: begin
				next_pc = PC;
			end	
		endcase
	end	

endmodule
