`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:54:38 11/29/2024 
// Design Name: 
// Module Name:    CP0 
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

module CP0(
	input clk,
	input reset,
	input en,
	input [4:0] CP0_Addr,
	input [31:0] CP0_In,
	input [31:0] VPC,
	input [4:0] Exception,
	input EXLClr,
	
	output reg [31:0] CP0_Out,
	output  [31:0] EPC_Out,
	output reg req
    );
		
	reg [31:0] SR, Cause, EPC;
	
	always@(posedge clk) begin
		if(reset) begin
			SR <= 0;
			Cause <= 0;
			EPC <= 0;
		end else begin
			if(req == 0) begin
				if(en) begin
					case(CP0_Addr)
						5'd12: begin
							SR[1] <= CP0_In[1];
						end
						5'd13: begin
							Cause[6:2] <= CP0_In[6:2];
						end
						5'd14: begin
							EPC <= CP0_In;
						end
					endcase
				end
			end
			
			if(SR[1] == 1'b0) begin
				 if(Exception != `Int) begin
					EPC <= VPC;
					SR[1] <= 1'b1;
					Cause[6:2] <= Exception;
				end
			end else begin
				if(EXLClr) begin
					SR[1] <= 1'b0;
				end
			end
		end 
	end
	
	always@(*) begin
		if(Exception != `Int) begin
			req = 1;
		end else begin
			req = 0;
		end
	end
	
	always@(*) begin
		case(CP0_Addr)
			5'd12: begin
				CP0_Out = SR;
			end
			5'd13: begin
				CP0_Out = Cause;
			end
			5'd14: begin
				CP0_Out = EPC;
			end
		endcase
	end
	
	assign EPC_Out = EPC;
	
endmodule
