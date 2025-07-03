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

`include "constants.v"

module PC(
	input [3:0] PcOp,
	input [31:0] BeqPc,
	input [31:0] JalPc,
	input [31:0] JrPc,
	input clk,
	input reset,
	input En_Pc,
	output reg [31:0] Pc_F
    );
	
	reg [31:0] NextPc;
	
	always@(posedge clk) begin
		if(reset) begin
			Pc_F <= 32'h00003000;
		end else begin
			if(En_Pc == 1) begin
				Pc_F <= NextPc;
			end
		end
	end
	
	always@(*) begin
		case(PcOp)
			`NORMAL: begin
				NextPc = Pc_F + 4;
			end
			`BEQ: begin
				NextPc = BeqPc;
			end
			`JAL: begin
				NextPc= JalPc;
			end
			`JR: begin
				NextPc = JrPc;
			end
		endcase
	end	

endmodule
