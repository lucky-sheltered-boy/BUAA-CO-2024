`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:54 10/30/2024 
// Design Name: 
// Module Name:    ALU 
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

`define ADD 8'b00010001
`define SUB 8'b00010010 
`define AND 8'b00010011
`define OR 8'b00010100
`define XOR 8'b00010101
`define EQUAL 8'b00010110
`define BIGGER 8'b00010111
`define SMALLER 8'b00011000

module ALU(
	input [31:0] num1, num2,
	input [7:0] ALUop,
	output reg [31:0] ans
    );

	always@(*) begin
		case(ALUop)
			`ADD: begin
				ans = (num1 + num2);
			end
			`SUB: begin
				ans = (num1 - num2);
			end
			`AND: begin
				ans = (num1 & num2);
			end
			`OR: begin
				ans = (num1 | num2);
			end
			`XOR: begin
				ans = (num1 ^ num2);
			end
			`EQUAL: begin
				ans = (num1 == num2);
			end
			`BIGGER: begin
				ans = (num1 > num2);
			end
			`SMALLER: begin
				ans = (num1 < num2);
			end
		endcase
	end

endmodule
