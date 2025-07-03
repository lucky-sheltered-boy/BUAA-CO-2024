`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:32 11/16/2024 
// Design Name: 
// Module Name:    MD 
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
`define s0 8'b0000
`define sm1 8'b0001
`define sm2 8'b0010
`define sm3 8'b0011
`define sm4 8'b0100
`define sm5 8'b0101
`define sd1 8'b0110
`define sd2 8'b0111
`define sd3 8'b1000
`define sd4 8'b1001
`define sd5 8'b1010
`define sd6 8'b1011
`define sd7 8'b1100
`define sd8 8'b1101
`define sd9 8'b1110
`define sd10 8'b1111

module MD(
	input clk,
	input reset,
	input [31:0] num1,
	input [31:0] num2,
	input [7:0] InstrType,
	input multiply,
	input divide,
	input req,
	output reg [31:0] HI,
	output reg [31:0] LO,
	output reg start,
	output reg busy
    );
	
	reg [7:0] status;
	reg [63:0] hilo;
	reg [31:0] hi, lo;
	
	always@(posedge clk) begin
		if(reset) begin
			HI <= 0;
			LO <= 0;
			status <= `s0;
		end else begin
			if(InstrType == `mthi) begin
				if(req == 0) begin
					HI <= num1;
				end
			end else if(InstrType == `mtlo) begin
				if(req == 0) begin
					LO <= num1;
				end
			end else begin
				if(multiply == 1) begin
					if(req == 0) begin
						status <= `sm1;
					end
					case(InstrType)
						`mult: begin
							hilo <= $signed($signed({{32{num1[31]}},num1}) * $signed({{32{num2[31]}}, num2}));
						end
						`multu: begin
							hilo <= {{32{1'b0}}, num1} * {{32{1'b0}}, num2};
						end
					endcase
				end else if(divide == 1) begin
					if(req == 0) begin
						status <= `sd1;
					end
					case(InstrType)
						`div: begin
							hi <= $signed(($signed(num1) % $signed(num2)));
							lo <= $signed(($signed(num1) / $signed(num2)));
						end
						`divu: begin
							hi <= {0, num1} % {0, num2};
							lo <= {0, num1} / {0, num2};
						end
					endcase
				end else begin
					case(status)
						`sm1: begin
							status <= `sm2;
						end
						`sm2: begin
							status <= `sm3;
						end
						`sm3: begin
							status <= `sm4;
						end
						`sm4: begin
							status <= `sm5;
						end
						`sm5: begin
							status <= `s0;
							HI <= hilo[63:32];
							LO <= hilo[31:0];
						end
						`sd1: begin
							status <= `sd2;
						end
						`sd2: begin
							status <= `sd3;
						end
						`sd3: begin
							status <= `sd4;
						end
						`sd4: begin
							status <= `sd5;
						end
						`sd5: begin
							status <= `sd6;
						end
						`sd6: begin
							status <= `sd7;
						end
						`sd7: begin
							status <= `sd8;
						end
						`sd8: begin
							status <= `sd9;
						end
						`sd9: begin
							status <= `sd10;
						end
						`sd10: begin
							status <= `s0;
							HI <= hi;
							LO <= lo;
						end
					endcase
				end
			end
		end
	end
	
	always@(*) begin
		if(multiply == 1 || divide == 1) begin
			start = 1;
		end else begin
			start = 0;
		end
	end

	always@(*) begin
		if(status == `sm1
		|| status == `sm2
		|| status == `sm3
		|| status == `sm4
		|| status == `sm5
		|| status == `sd1
		|| status == `sd2
		|| status == `sd3
		|| status == `sd4
		|| status == `sd5
		|| status == `sd6
		|| status == `sd7
		|| status == `sd8
		|| status == `sd9
		|| status == `sd10) begin
			busy = 1;
		end else begin
			busy = 0;
		end
	end
endmodule
