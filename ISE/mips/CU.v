`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:09:18 10/30/2024 
// Design Name: 
// Module Name:    CU 
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

`define add 8'b10000000
`define sub 8'b10000001
`define ori 8'b10000010
`define lui 8'b10000011
`define lw 8'b10000100
`define sw 8'b10000101
`define beq 8'b10000110
`define jal 8'b10000111
`define jr 8'b10001000
`define nop 8'b10001001

`define ADD 8'b00010001
`define SUB 8'b00010010 
`define AND 8'b00010011
`define OR 8'b00010100
`define XOR 8'b00010101
`define EQUAL 8'b00010110
`define BIGGER 8'b00010111
`define SMALLER 8'b00011000

module CU(
	input [5:0] Op,
	input [5:0] Func,
	output reg [1:0] RegDst,
	output reg [1:0] ALUSrc,
	output reg [1:0] memtoReg,
	output reg Regwrite,
	output reg Memwrite,
	output reg [3:0] PCsel,
	output reg [7:0] Extop,
	output reg [7:0] ALUop,
	output reg [7:0] instr_type
    );

	reg [7:0] instr;
	
	always@(*) begin
		if(Op == 6'b000000 && Func == 6'b100000) begin
			instr = `add;
		end else if(Op == 6'b000000 && Func == 6'b100010) begin
			instr = `sub;
		end else if(Op == 6'b001101) begin
			instr = `ori;
		end else if(Op == 6'b001111) begin
			instr = `lui;
		end else if(Op == 6'b100011) begin
			instr = `lw;
		end else if(Op == 6'b101011) begin
			instr = `sw;
		end else if(Op == 6'b000100) begin
			instr = `beq;
		end else if(Op == 6'b000011) begin
			instr = `jal;
		end else if(Op == 6'b000000 && Func == 6'b001000) begin
			instr = `jr;
		end else if(Op == 0 && Func == 0) begin
			instr = `nop;
		end
	end
	
	always@(*) begin
		if(instr == `add
		|| instr == `sub) begin
			RegDst = 2'b01;
		end else if(instr == `jr) begin
			RegDst = 2'b10;
		end else begin
			RegDst = 2'b00;
		end
		
		if(instr == `ori
		|| instr == `lui
		|| instr == `lw 
		|| instr == `sw) begin
			ALUSrc = 2'b01;
		end else begin
			ALUSrc = 2'b00;
		end
		
		if(instr == `lw) begin
			memtoReg = 2'b01;
		end else if(instr == `jal) begin
			memtoReg = 2'b10;
		end else begin
			memtoReg = 2'b00;
		end
		
		if(instr == `add
		|| instr == `sub
		|| instr == `ori 
		|| instr == `lui
		|| instr == `lw 
		|| instr == `jal) begin
			Regwrite = 1;
		end else begin
			Regwrite = 0;
		end
		
		if(instr == `sw) begin
			Memwrite = 1;
		end else begin
			Memwrite = 0;
		end
		
		if(instr == `beq) begin
			PCsel = 4'b0001;
		end else if(instr == `jal) begin
			PCsel = 4'b0010;
		end else if(instr == `jr) begin
			PCsel = 4'b0011;
		end else begin
			PCsel = 4'b0000;
		end
		
		if(instr == `lw
		|| instr == `sw) begin
			Extop = 4'b0001;
		end else if(instr == `lui) begin
			Extop = 4'b0010;
		end else if(instr == `beq) begin
			Extop = 4'b0011;
		end else if(instr == `jal) begin
			Extop = 4'b0100;
		end else begin
			Extop = 4'b0000;
		end
		
		if(instr == `sub) begin
			ALUop = `SUB;
		end else if(instr == `ori) begin
			ALUop = `OR;
		end else if(instr == `beq) begin
			ALUop = `EQUAL;
		end else begin
			ALUop = `ADD;
		end
		
		instr_type = instr;
		
	end
	
endmodule
