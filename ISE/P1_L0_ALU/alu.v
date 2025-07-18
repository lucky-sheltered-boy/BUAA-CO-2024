`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:17:04 10/01/2024 
// Design Name: 
// Module Name:    alu 
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
module alu(
	input [31:0] A, B,
	input [2:0] ALUop,
	output reg [31:0] C
    );

	always@(*) begin
		case (ALUop) 
			3'b000: begin
				C = A + B;
			end
			3'b001: begin
				C = A - B;
			end
			3'b010: begin
				C = A & B;
			end
			3'b011: begin
				C = A | B;
			end
			3'b100 :begin
				C = A >> B;
			end
			3'b101 :begin
				 C = $signed(A) >>> B;
			end
			default : begin
			
			end
		endcase
	end

endmodule
