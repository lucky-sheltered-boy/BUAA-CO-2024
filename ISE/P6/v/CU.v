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

`include "constants.v"

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
	output reg [7:0] instr_type,
	output reg [7:0] TNew_D,
	output reg [7:0] TUse_D1,
	output reg [7:0] TUse_D2,
	output reg Multiply_D,
	output reg Divide_D
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
		end else if(Op == 6'b000000 && Func == 6'b100100) begin
			instr = `and;
		end else if(Op == 6'b000000 && Func == 6'b100101) begin
			instr = `or;
		end else if(Op == 6'b001000) begin
			instr = `addi;
		end else if(Op == 6'b001100) begin
			instr = `andi;
		end else if(Op == 6'b000000 && Func == 6'b101010) begin
			instr = `slt;
		end else if(Op == 6'b000000 && Func == 6'b101011) begin
			instr = `sltu;
		end else if(Op == 6'b000101) begin
			instr = `bne;
		end else if(Op == 6'b000000 && Func == 6'b011000) begin
			instr = `mult;
		end else if(Op == 6'b000000 && Func == 6'b011001) begin
			instr = `multu;
		end else if(Op == 6'b000000 && Func == 6'b011010) begin
			instr = `div;
		end else if(Op == 6'b000000 && Func == 6'b011011) begin
			instr = `divu;
		end else if(Op == 6'b000000 && Func == 6'b010000) begin
			instr = `mfhi;
		end else if(Op == 6'b000000 && Func == 6'b010010) begin
			instr = `mflo;
		end else if(Op == 6'b000000 && Func == 6'b010001) begin
			instr = `mthi;
		end else if(Op == 6'b000000 && Func == 6'b010011) begin
			instr = `mtlo;
		end else if(Op == 6'b101000) begin
			instr = `sb;
		end else if(Op == 6'b101001) begin
			instr = `sh;
		end else if(Op == 6'b100000) begin
			instr = `lb;
		end else if(Op == 6'b100001) begin
			instr = `lh;
		end
		else begin
			instr = `nop;
		end
	end
	
	always@(*) begin
		if(instr == `add
		|| instr == `sub
		|| instr == `and
		|| instr == `or
		|| instr == `slt
		|| instr == `sltu
		|| instr == `mfhi
		|| instr == `mflo) begin
			RegDst = 2'b01;
		end else if(instr == `jal) begin
			RegDst = 2'b10;
		end else if(instr == `ori
		|| instr == `lui
		|| instr == `lw
		|| instr == `addi
		|| instr == `andi
		|| instr == `lh
		|| instr == `lb)begin
			RegDst = 2'b00;
		end else begin
			RegDst = 2'b11;
		end
		
		if(instr == `ori
		|| instr == `lui
		|| instr == `lw 
		|| instr == `sw
		|| instr == `addi
		|| instr == `andi
		|| instr == `sb
		|| instr == `sh
		|| instr == `lh
		|| instr == `lb) begin
			ALUSrc = 2'b01;
		end else begin
			ALUSrc = 2'b00;
		end
		
		if(instr == `lw
		|| instr == `lh
		|| instr == `lb) begin
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
		|| instr == `jal
		|| instr == `and
		|| instr == `or
		|| instr == `addi
		|| instr == `andi
		|| instr == `slt
		|| instr == `sltu
		|| instr == `mfhi
		|| instr == `mflo
		|| instr == `lh
		|| instr == `lb) begin
			Regwrite = 1;
		end else begin
			Regwrite = 0;
		end
		
		if(instr == `sw
		|| instr == `sh
		|| instr == `sb) begin
			Memwrite = 1;
		end else begin
			Memwrite = 0;
		end
		
		if(instr == `beq) begin
			PCsel = `BEQ;
		end else if(instr == `jal) begin
			PCsel = `JAL;
		end else if(instr == `jr) begin
			PCsel = `JR;
		end else if(instr == `bne) begin
			PCsel = `BNE;
		end
		else begin
			PCsel = `NORMAL;
		end
		
		if(instr == `lw
		|| instr == `sw
		|| instr == `addi
		|| instr == `sh
		|| instr == `sb
		|| instr == `lh
		|| instr == `lb) begin
			Extop = 4'b0001;
		end else if(instr == `lui) begin
			Extop = 4'b0010;
		end else if(instr == `beq
		|| instr == `bne) begin
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
		end else if(instr == `and
		|| instr == `andi) begin
			ALUop = `AND;
		end else if(instr == `or) begin
			ALUop = `OR;
		end else if(instr == `slt) begin
			ALUop = `SMALLERSIGNED;
		end else if(instr == `sltu) begin
			ALUop = `SMALLERUNSIGNED;
		end
		else begin
			ALUop = `ADD;
		end
		
		instr_type = instr;
		
		if(instr == `add
		|| instr == `sub
		|| instr == `ori
		|| instr == `lui
		|| instr == `and
		|| instr == `or
		|| instr == `addi
		|| instr == `andi
		|| instr == `slt
		|| instr == `sltu
		|| instr == `mfhi
		|| instr == `mflo) begin
			TNew_D = 2;
		end else if(instr == `lw
		|| instr == `lh
		|| instr == `lb) begin
			TNew_D = 3;
		end else begin
			TNew_D = 0;
		end
		
		if(instr == `add
		|| instr == `sub
		|| instr == `ori
		|| instr == `lw
		|| instr == `sw
		|| instr == `and
		|| instr == `or
		|| instr == `addi
		|| instr == `andi
		|| instr == `slt
		|| instr == `sltu
		|| instr == `mult
		|| instr == `multu
		|| instr == `div
		|| instr == `divu
		|| instr == `mthi
		|| instr == `mtlo
		|| instr == `sh
		|| instr == `sb
		|| instr == `lh
		|| instr == `lb) begin
			TUse_D1 = 1;
		end else if(instr == `lui
		|| instr == `jal
		|| instr == `mfhi
		|| instr == `mflo) begin
			TUse_D1 = 10;
		end else begin
			TUse_D1 = 0;
		end
		
		if(instr == `add
		|| instr == `sub
		|| instr == `and
		|| instr == `or
		|| instr == `slt
		|| instr == `sltu
		|| instr == `mult
		|| instr == `multu
		|| instr == `div
		|| instr == `divu) begin
			TUse_D2 = 1;
		end else if(instr == `sw
		|| instr == `sh
		|| instr == `sb) begin
			TUse_D2 = 2;
		end else if(instr == `ori
		|| instr == `lui
		|| instr == `lw
		|| instr == `jal
		|| instr == `jr
		|| instr == `addi
		|| instr == `andi
		|| instr == `mfhi
		|| instr == `mflo
		|| instr == `mthi
		|| instr == `mtlo
		|| instr == `lh
		|| instr == `lb) begin
			TUse_D2 = 10;
		end else begin
			TUse_D2 = 0;
		end
		
		if(instr == `mult
		|| instr == `multu) begin
			Multiply_D = 1;
		end else begin
			Multiply_D = 0;
		end
		
		if(instr == `div
		|| instr == `divu) begin
			Divide_D = 1;
		end else begin
			Divide_D = 0;
		end
		
	end
	
endmodule
