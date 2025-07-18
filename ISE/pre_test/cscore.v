`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:14:36 09/23/2024 
// Design Name: 
// Module Name:    cscore 
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
`define s0 0
`define s1 1
`define s2 2
`define s3 3
`define s4 4
`define s5 5
`define s6 6

module cscore(
	input [7 : 0] char,
	input clk,
	output [7 : 0] out
    );
	 
	reg [7 : 0] max;
	reg [7 : 0] cnt;
	reg [7 : 0]status;
	
	
	initial begin
		max <= 0;
		cnt <= 0;
		status <= `s0;
	end
	
	always@(posedge clk) begin
		case (status)
			`s0: begin
				if (char == "c" || char == "C") begin
					status <=  `s1;
				end
				else if (char == " ") begin
					status <= `s0;
				end
				else begin
					status <= `s0;
					cnt <= 0;
				end
			end 
			
			`s1: begin
				if (char == "s" || char == "S") begin
					status <=  `s2;
				end
				else if (char == " ") begin
					status <= `s1;
				end
				else if (char == "c" || char == "C") begin
					status <=  `s1;
					cnt <= 0;
				end
				else begin
					status <= `s0;
					cnt <= 0;
				end
			end
			
			`s2: begin
				if (char == "c" || char == "C") begin
					status <=  `s3;
				end
				else if (char == " ") begin
					status <= `s2;
				end
				else if (char == "c" || char == "C") begin
					status <=  `s1;
					cnt <= 0;
				end
				else begin
					status <= `s0;
					cnt <= 0;
				end
			end
			
			`s3: begin
				if (char == "o" || char == "O") begin
					status <=  `s4;
				end
				else if (char == " ") begin
					status <= `s3;
				end
				else if (char == "c" || char == "C") begin
					status <=  `s1;
					cnt <= 0;
				end
				else begin
					status <= `s0;
					cnt <= 0;
				end
			end
			
			`s4: begin
				if (char == "r" || char == "R") begin
					status <=  `s5;
				end
				else if (char == " ") begin
					status <= `s4;
				end
				else if (char == "c" || char == "C") begin
					status <=  `s1;
					cnt <= 0;
				end
				else begin
					status <= `s0;
					cnt <= 0;
				end
			end
			
			`s5: begin
				if (char == "e" || char == "E") begin
					status <=  `s0;
					cnt <= cnt + 1;
				end
				else if (char == " ") begin
					status <= `s5;
				end
				else if (char == "c" || char == "C") begin
					status <=  `s1;
					cnt <= 0;
				end
				else begin
					status <= `s0;
					cnt <= 0;
				end
			end
		endcase
	end
	
	always@(*) begin
		if (max < cnt) begin
			max = cnt;
		end
	end
	
	assign out = max;
	
endmodule
