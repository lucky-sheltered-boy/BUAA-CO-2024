`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:49:13 08/30/2024 
// Design Name: 
// Module Name:    cpu_checker 
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
`define b0 2'b00
`define b1 2'b01
`define b2 2'b10
`define s0 5'b00000
`define s1 5'b00001
`define s2 5'b00010
`define s3 5'b00011
`define s4 5'b00100
`define s5 5'b00101
`define s6 5'b00110
`define s7 5'b01000
`define s8 5'b01010
`define s9 5'b01100
`define s10 5'b01110
`define s11 5'b10000
`define s12 5'b10001

module cpu_checker(
	input clk,
	input reset,
	input [7:0] char,
	input [15:0] freq,
	output [1:0] format_type,
	output [3:0] error_code
    );
	reg [4:0] next_s;
	reg [3:0] cnt_s2;
	reg [3:0] cnt_s4;
	reg [3:0] cnt_s7;
	reg [3:0] cnt_s11;
	reg type;
	reg [15:0] TIME;
	reg wrong_time;
	reg wrong_pc;
	reg wrong_addr;
	reg wrong_grf;
	reg wrong_type;
	reg [31:0] pc;
	reg [15:0] grf;
	reg [31:0] addr;
	
	initial begin
		next_s<=`s0;
		cnt_s2<=4'b0;
		cnt_s4<=4'b0;
		cnt_s7<=4'b0;
		cnt_s11<=4'b0;
		TIME<=0;
		wrong_time<=0;
		wrong_pc<=0;
		wrong_addr<=0;
		wrong_grf<=0;
		wrong_type<=0;
		pc<=0;
		grf<=0;
		addr<=0;
	end
	
	always@(posedge clk) begin
		if(reset==1'b1) begin
			next_s<=`s0;
			cnt_s2<=4'b0;
			cnt_s4<=4'b0;
			cnt_s7<=4'b0;
			cnt_s11<=4'b0;
			TIME<=0;
			wrong_time<=0;
			wrong_pc<=0;
			wrong_addr<=0;
			wrong_grf<=0;
			wrong_type<=0;
			pc<=0;
			grf<=0;
			addr<=0;
		end
		else begin
			case(next_s)
					`s0: begin
						if(char=="^") begin
							next_s<=`s1;
							cnt_s2<=4'b0;
							cnt_s4<=4'b0;
							cnt_s7<=4'b0;
							cnt_s11<=4'b0;
							TIME<=0;
							wrong_time<=0;
							wrong_pc<=0;
							wrong_addr<=0;
							wrong_grf<=0;
							wrong_type<=0;
							pc<=0;
							grf<=0;
							addr<=0;
						end
						else begin
							next_s<=`s0;
						end
					end
					
					`s1: begin
						if(char>="0"&&char<="9") begin
							next_s<=`s2;
							cnt_s2<=cnt_s2+4'b1;
							TIME<=((TIME<<1)+(TIME<<3)+(char-"0"));
						end
						else begin
					//		wrong_type<=1;
							next_s<=`s0;
						end
					end
					
					`s2: begin
						if(char>="0"&&char<="9") begin
							if(cnt_s2<=4'b0011) begin
								cnt_s2<=cnt_s2+4'b1;
								next_s<=`s2;
								TIME<=((TIME<<1)+(TIME<<3)+(char-"0"));
							end
							else if(cnt_s2==4'b0100) begin
				//				next_s<=`s2;
								next_s<=`s0;
				//				wrong_type<=1;
   			//				wrong_time<=1;
							end
						end
						else if(char=="@") begin
								next_s<=`s3;
						end
						else begin
			//				wrong_type<=1;
							next_s<=`s0;
						end
					end
					
					`s3: begin
						if(char>="0"&&char<="9"||char>="a"&&char<="f") begin
							next_s<=`s4;
							cnt_s4<=cnt_s4+4'b1;
							pc<=((pc<<4)+((char>="0"&&char<="9") ? (char-"0") : (char-"a"+32'd10)));
						end
						else begin
				//		wrong_type<=1;
						next_s<=`s0;
						end
					end
					
					`s4: begin
						if(char>="0"&&char<="9"||char>="a"&&char<="f") begin
							if(cnt_s4<=4'b0111) begin
								cnt_s4<=cnt_s4+4'b1;
								next_s<=`s4;
								pc<=((pc<<4)+((char>="0"&&char<="9") ? (char-"0") : (char-"a"+32'd10)));
							end
							else if(cnt_s4==4'b1000) begin
	//							wrong_type<=1;
								next_s<=`s0;
	//							wrong_pc<=1;
							end
						end
						else if(char==":") begin
							if(cnt_s4==4'b1000) begin
								next_s<=`s5;
							end
							else begin
				//				wrong_type<=1;
								next_s<=`s0;
				//				wrong_pc<=1;
				//				next_s<=`s5;
							end
						end
						else begin
				//			wrong_type<=1;
							next_s<=`s0;
						end
					end
					
					`s5: begin
						if(char==" ") begin
							next_s<=`s5;
						end 
						else if(char=="$") begin
							next_s<=`s6; 
							type<=0;
						end
						else if(char==8'd42) begin
							next_s<=`s6;
							type<=1'b1;
						end
						else begin
						next_s<=`s0;
		//					wrong_type<=1;
						end
					end
					
					`s6: begin
						if(type==0) begin
							if(char>="0"&&char<="9") begin
									cnt_s7<=cnt_s7+4'b1;
									next_s<=`s7;
									grf<=((grf<<1)+(grf<<3)+(char-"0"));
							end
							else begin
							next_s<=`s0;
					//			wrong_type<=1;
							end
						end
						else if(type==1) begin
								if(char>="0"&&char<="9"||char>="a"&&char<="f") begin
										cnt_s7<=cnt_s7+4'b1;
										next_s<=`s7;
										addr<=((addr<<4)+((char>="0"&&char<="9") ? (char-"0" ): (char-"a"+32'd10)));
								end
								else begin
								next_s<=`s0;
				//					wrong_type<=1;
								end
						end
					end
					
					`s7: begin
						if(type==0) begin
								if(char>="0"&&char<="9") begin
											if(cnt_s7<=4'b0011) begin
												cnt_s7<=cnt_s7+4'b1;
												next_s<=`s7;
												grf<=((grf<<1)+(grf<<3)+(char-"0"));
											end
											else if(cnt_s7==4'b0100) begin
											next_s<=`s0;
						//						wrong_type<=1;
						//						wrong_grf<=1;
											end
								end
								else if(char==" ") begin
									next_s<=`s8;
								end
								else if(char=="<") begin
									next_s<=`s9;
								end
								else begin
								next_s<=`s0;
				//					wrong_type<=1;
								end
						end
						else if(type==1) begin
							if(char>="0"&&char<="9"||char>="a"&&char<="f") begin
								if(cnt_s7<=4'b0111) begin
									cnt_s7<=cnt_s7+4'b1;
									next_s<=`s7;
									addr<=((addr<<4)+((char>="0"&&char<="9") ? (char-"0" ): (char-"a"+32'd10)));
								end
								else if(cnt_s4==4'b1000) begin
								next_s<=`s0;
					//				wrong_type<=1;
					//				wrong_addr<=1;
								end
							end
							else if(char==" ") begin
								if(cnt_s7==4'b1000) begin
									next_s<=`s8;
								end
								else begin
								next_s<=`s0;
				//					wrong_type<=1;
			//						wrong_addr<=1;
								end
							end
							else if(char=="<") begin
								if(cnt_s7==4'b1000) begin
									next_s<=`s9;
								end
								else begin
								next_s<=`s0;
			//						wrong_type<=1;
				//					wrong_addr<=1;
								end
							end
							else begin
							next_s<=`s0;
					//			wrong_type<=1;
							end
						end
					end
					
					`s8: begin
						if(char==" ") begin
							next_s<=`s8;
						end
						else if(char=="<") begin
							next_s<=`s9;
						end
						else begin
						next_s<=`s0;
		//					wrong_type<=1;
						end
					end
					
					`s9: begin
						if(char=="=") begin
							next_s<=`s10;
						end
						else begin
						next_s<=`s0;
		//					wrong_type<=1;
						end
					end
					
					`s10: begin
						if(char==" ") begin
							next_s<=`s10;
						end
						else if(char>="0"&&char<="9"||char>="a"&&char<="f") begin
							next_s<=`s11;
							cnt_s11<=cnt_s11+4'b1;
						end
						else begin
						next_s<=`s0;
				//			wrong_type<=1;
						end
					end
					
					`s11: begin
						if(char>="0"&&char<="9"||char>="a"&&char<="f") begin
							if(cnt_s11<=4'b0111) begin
								cnt_s11<=cnt_s11+4'b1;
								next_s<=`s11;
							end
							else if(cnt_s11==4'b1000) begin
							next_s<=`s0;
				//				wrong_type<=1;
							end
						end
						else if(char=="#") begin
							if(cnt_s11==4'b1000) begin
								next_s<=`s12;
							end
							else begin
							next_s<=`s0;
					//			next_s<=`s12;
					//			wrong_type<=1;
							end
						end
						else begin
						next_s<=`s0;
					//		wrong_type<=1;
						end
					end
					
					`s12: begin
						if(char=="^") begin
							next_s<=`s1;
							cnt_s2<=4'b0;
							cnt_s4<=4'b0;
							cnt_s7<=4'b0;
							cnt_s11<=4'b0;
							TIME<=0;
							wrong_time<=0;
							wrong_pc<=0;
							wrong_addr<=0;
							wrong_grf<=0;
							wrong_type<=0;
							pc<=0;
							grf<=0;
							addr<=0;
						end
						else begin
							next_s<=`s0;
						end
					end
				endcase
		end
	end
	
	always@(next_s) begin
		if(next_s==`s12) begin
			if((TIME&((freq>>1)-1))!=0) begin
				wrong_time=1;
			end
			if(!(pc[1:0]==2'b00&&pc>=32'h00003000&&pc<=32'h00004fff)) begin
				wrong_pc=1;
			end
			if(!(grf>=16'd0&&grf<=16'd31)) begin
				wrong_grf=1;
			end
			if(!(addr[1:0]==2'b00&&addr>=32'h00000000&&addr<=32'h00002fff)) begin
				wrong_addr=1;
			end
		end
		else begin
			wrong_time=0;
			wrong_pc=0;
			wrong_grf=0;
			wrong_addr=0;
		end
	end
	
	assign format_type= (next_s==`s12&&type==0) ? `b1 :
														(next_s==`s12&&type==1) ? `b2 :
													   `b0;
	assign error_code= {wrong_grf,wrong_addr,wrong_pc,wrong_time};
	
endmodule