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

`include "constants.v"

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
			`BIGGERUNSIGNED: begin
				if(num1 > num2) begin
					ans = 1;
				end else begin
					ans = 0;
				end
			end
			`SMALLERUNSIGNED: begin
				if({0, num1} < {0, num2}) begin
					ans = 1;
				end else begin
					ans = 0;
				end
			end
			`BIGGERSIGNED: begin
				if($signed(num1) > $signed(num2)) begin
					ans = 1;
				end else begin
					ans = 0;
				end
			end
			`SMALLERSIGNED: begin
				if($signed(num1) < $signed(num2)) begin
					ans = 1;
				end else begin
					ans = 0;
				end
			end
		endcase
	end

endmodule
