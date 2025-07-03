`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:41 10/01/2024 
// Design Name: 
// Module Name:    gray 
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
module gray(
	input Clk,
	input Reset,
	input En,
	output reg [2:0] Output,
	output reg Overflow
    );
	
	initial begin
		Output <= 0;
		Overflow <=0;
	end
	
	always@(posedge Clk) begin
		if(Reset) begin
			Output <= 0;
			Overflow <= 0;
		end
		else begin
			if(En) begin
				case (Output)
					3'b000: begin
						Output <= 1;
					end
					3'b001: begin
						Output <= 3;
					end
					3'b011: begin
						Output <= 2;
					end
					3'b010: begin
						Output <= 6;
					end
					3'b110: begin
						Output <= 7;
					end
					3'b111: begin
						Output <= 5;
					end
					3'b101: begin
						Output <= 4;
					end
					3'b100: begin
						Output <= 0;
						Overflow<=1;
					end
				endcase
			end
		end
	end

endmodule
