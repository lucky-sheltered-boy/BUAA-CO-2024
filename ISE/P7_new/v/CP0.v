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
	input BD_In,
	input [4:0] Exception,
	input [5:0] HWInt,
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
			Cause[15:10] <= HWInt;
			
			if(req == 0) begin
				if(en) begin
					case(CP0_Addr)
						5'd12: begin
							SR[15:10] <= CP0_In[15:10];
							SR[1] <= CP0_In[1];
							SR[0] <= CP0_In[0];
							SR[9:2] <= CP0_In[9:2];
							SR[31:16] <= CP0_In[31:16];
						end
						5'd13: begin
							Cause <= CP0_In;
						end
						5'd14: begin
							EPC <= CP0_In;
						end
					endcase
				end
			end
			
			if(SR[1] == 1'b0) begin
				if(SR[0] == 1'b1 && ((HWInt & SR[15:10]) != 6'b000000)) begin
					if(BD_In == 1'b1) begin
						EPC <= VPC - 4;
					end else begin
						EPC <= VPC;
					end
					SR[1] <= 1'b1;
					Cause[6:2] <= `Int;
					Cause[31] <= BD_In;
				end else if(Exception != `Int) begin
					if(BD_In == 1'b1) begin
						EPC <= VPC - 4;
					end else begin
						EPC <= VPC;
					end
					SR[1] <= 1'b1;
					Cause[6:2] <= Exception;
					Cause[31] <= BD_In;
				end
			end else begin
				if(EXLClr) begin
					SR[1] <= 1'b0;
				end
			end
		end 
	end
	
	always@(*) begin
		if(SR[1] == 1'b0 && ((SR[0] == 1'b1 && ((HWInt & SR[15:10]) != 6'b000000)) || Exception != `Int)) begin
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
