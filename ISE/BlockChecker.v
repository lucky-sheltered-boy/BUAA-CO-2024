`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:40:39 10/01/2024 
// Design Name: 
// Module Name:    BlockChecker 
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
`define s0 4'b1100
`define b1 4'b0000
`define b2 4'b0001
`define b3 4'b0010
`define b4 4'b0011
`define b5 4'b0100
`define e1 4'b0101 
`define e2 4'b0110
`define e3 4'b0111
`define error 4'b1000
`define pending 4'b1001

module BlockChecker(
	input clk,
	input reset,
	input [7:0] in,
	output result
    );

	reg [3:0] status,next;
	reg [31:0] cnt,next_cnt;
	reg error, next_error;
	
	always@(posedge clk,posedge reset) begin
		if(reset) begin
			status <= `s0;
			cnt <= 0;
			error <= 0;
		end
		else begin
			status <= next;
			cnt <= next_cnt;
			error <= next_error;
		end
	end

	always@(*) begin
		case (status)
			`s0 : begin
				if (in == "b" || in == "B") begin
					next = `b1;
				end
				else if (in == "e" || in == "E") begin
					next = `e1;
				end
				else if(in == " ") begin
					next = `s0;
				end
				else begin
					next = `pending;
				end	
				next_cnt = cnt;
				next_error = error;
			end
				`b1 : begin
					if (in == "e" || in == "E") begin
						next = `b2;
					end
					else if (in == " ") begin
						next = `s0;
					end
					else begin
						next = `pending;
					end
					next_cnt = cnt;
					next_error = error;
				end
				`b2 : begin
					if (in == "g" || in == "G") begin
						next = `b3;
					end
					else if (in == " ") begin
						next = `s0;
					end
					else begin
						next = `pending;
					end
					next_cnt = cnt;
					next_error = error;
				end
				`b3: begin
					if (in == "i" || in == "I") begin
						next = `b4;
					end
					else if (in == " ") begin
						next = `s0;
					end
					else begin
						next = `pending;
					end
					next_cnt = cnt;
					next_error = error;
				end
				`b4 : begin
					if (in == "n" || in == "N") begin
						next = `b5;
						next_cnt = cnt + 1;
					end
					else if (in == " ") begin
						next = `s0;
						next_cnt = cnt;
					end
					else begin
						next = `pending;
						next_cnt = cnt;
					end
					next_error = error;
				end
				`b5 : begin
					if (in == " ") begin
						next = `s0;
						next_cnt = cnt;
					end
					else begin
						next = `pending;
						next_cnt = cnt - 1;
					end
					next_error = error;
				end
				`e1 : begin
					if (in == "n" || in == "N") begin
						next = `e2;
					end
					else if (in == " ") begin
						next = `s0;
					end
					else begin
						next = `pending;
					end
					next_cnt = cnt;
					next_error = error;
				end
				`e2 : begin
					if (in == "d" || in == "D") begin
						next = `e3;
						if (cnt == 0) begin
							next_error = 1;
							next_cnt = cnt;
						end
						else begin
							next_cnt = cnt - 1;
							next_error = error;
						end
					end
					else if (in == " ") begin
						next = `s0;
						next_cnt = cnt;
						next_error = error;
					end
					else begin
						next = `pending;
						next_cnt = cnt;
						next_error = error;
					end
				end
				`e3 : begin
					if (in == " ") begin
						if (error == 1) begin
							next = `error;
							next_cnt = cnt;
							next_error = error;
						end
						else begin
							next = `s0;
							next_cnt = cnt;
							next_error = error;
						end
					end
					else begin
						next = `pending;
						if (error == 1) begin
							next_error = 0;
							next_cnt = cnt;
						end
						else begin
							next_cnt = cnt + 1;
							next_error = error;
						end
					end
				end
				`pending : begin
					if (in == " ") begin
						next = `s0;
						next_cnt = cnt;
						next_error = error;
					end
					else begin
						next = `pending;
						next_cnt = cnt;
						next_error = error;
					end
				end
				`error: begin
					next = `error;
					next_cnt = cnt;
					next_error = error;
				end
		endcase
	end

	assign result = (cnt == 0 && error == 0) ? 1 : 0;

endmodule
