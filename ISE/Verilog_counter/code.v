`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:10:15 08/29/2024 
// Design Name: 
// Module Name:    code 
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
module code(
	input Clk,
	input Reset,
	input Slt,
	input En,
	output reg [63:0] Output0,
	output reg [63:0] Output1
    );
	
	reg [2:0] valid_0;
	reg [2:0] valid_1;
	
	initial begin
		valid_0<=3'b0;
		valid_1<=3'b0;
		Output0<=64'b0;
		Output1<=64'b0;
	end
	
	always@(posedge Clk) begin
		if(Reset==1) begin
			Output0<=64'b0;
			Output1<=64'b0;
			valid_1<=3'b0;
		end
		else begin
			Output0<=Output0;
			Output1<=Output1;
			valid_1<=valid_1;
		end
		
		if(Reset==0&&En==1) begin
			case(Slt)
				0: begin
					Output0<=Output0+3'b1;
				end
				1: begin
					valid_1<=valid_1+1;
					if(valid_1==3'd3) begin
						Output1<=Output1+3'b1;
						valid_1<=0;
					end
				end
				default: begin
				
				end
			endcase
		end
		else begin
		
		end
	end

endmodule
