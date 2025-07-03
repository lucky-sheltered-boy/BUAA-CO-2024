`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:43:10 10/01/2024 
// Design Name: 
// Module Name:    expr 
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
`define s0 2'b00
`define s1 2'b01
`define s2 2'b10
`define s3 2'b11

module expr(
	input clk,
	input clr,
	input [7:0] in,
	output out
    );

	reg [1:0] status,next;
	
	initial begin
		status<=`s0;
	end
	
	always@(posedge clk, posedge clr) begin
		if(clr) begin
			status<=`s0;
		end
		else begin
			status <= next;
		end
	end

	always@(*) begin
		case(status) 
			`s0: begin
				if(in>="0"&&in<="9") begin
					next = `s1;
				end
				else begin
					next = `s0;
				end
			end
			`s1: begin
				if(in=="+"||in=="*") begin
					next =`s2;
				end
				else begin
					next = `s3;
				end
			end
			`s2: begin
				if(in>="0"&&in<="9") begin
					next = `s1;
				end
				else begin
					next = `s3;
				end
			end
			`s3: begin
				next = `s3;
			end
		endcase 
	end

 assign out = status==`s1 ? 1 : 0;

endmodule
