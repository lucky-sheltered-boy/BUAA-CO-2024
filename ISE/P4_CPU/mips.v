`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:04 10/30/2024 
// Design Name: 
// Module Name:    mips 
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

// PCop type
`define NORMAL 4'b0000
`define BEQ 4'b0001
`define JAL 4'b0010
`define JR 4'b0011

// ALUop type
`define ADD 8'b00010001
`define SUB 8'b00010010 
`define AND 8'b00010011
`define OR 8'b00010100
`define XOR 8'b00010101
`define EQUAL 8'b00010110
`define BIGGER 8'b00010111
`define SMALLER 8'b00011000

// instruction type
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

module mips(
	input clk,
	input reset
    );
	
	reg [3:0] PCop;
	reg [31:0] beq;
	reg [31:0] jal;
	reg [31:0] jr;
	wire [31:0] PC;
	
	wire [31:0] instruction;
	
	wire [5:0] Op, Func;
	wire [4:0] rs, rt, rd;
	wire [15:0] immediate;
	wire [25:0] jal_immediate;

	wire[1:0] RegDst, ALUSrc, memtoReg;
	wire Regwrite, Memwrite;
	wire [3:0] PCsel;
	wire [7:0] Extop, ALUop, instr_type;
	
	reg [4:0] A1, A2, A3;
	reg [31:0] reg_data;
	wire [31:0] RD1, RD2;
	
	reg [31:0] num1, num2;
	wire [31:0] ALUans;
	
	wire [31:0] Extans;
	
	wire[31:0] DMans;
	
	PC module_pc(
		.PCop(PCop),
		.beq(beq),
		.jal(jal),
		.jr(jr),
		.clk(clk),
		.reset(reset),
		.PC(PC)
	);

	IM module_im(
		.PC(PC),
		.instruction(instruction)
	);

	splitter module_splitter(
		.instruction(instruction),
		.Op(Op),
		.Func(Func),
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.immediate(immediate),
		.jal(jal_immediate)
	);
	
	CU module_cu(
		.Op(Op),
		.Func(Func),
		.RegDst(RegDst),
		.ALUSrc(ALUSrc),
		.memtoReg(memtoReg),
		.Regwrite(Regwrite),
		.Memwrite(Memwrite),
		.PCsel(PCsel),
		.Extop(Extop),
		.ALUop(ALUop),
		.instr_type(instr_type)
	);
	
	GRF module_grf(
		.clk(clk),
		.reset(reset),
		.WE(Regwrite),
		.A1(A1),
		.A2(A2),
		.A3(A3),
		.WD(reg_data),
		.PC(PC),
		.RD1(RD1),
		.RD2(RD2)
	);
	
	ALU module_alu(
		.num1(num1),
		.num2(num2),
		.ALUop(ALUop),
		.ans(ALUans)
	);
	
	Extender module_extender(
		.num(immediate),
		.jal(jal_immediate),
		.Extop(Extop),
		.PC(PC),
		.ans(Extans)
	);
	
	DM module_dm(
		.addr(ALUans),
		.WD(RD2),
		.clk(clk),
		.reset(reset),
		.WE(Memwrite),
		.PC(PC),
		.data(DMans)
	);
	
	always@(*) begin
		A1 = rs;
	end
	
	always@(*) begin
		A2 = rt;
	end
	
	always@(*) begin
		case(RegDst)
			2'b00: begin
				A3 = rt;
			end
			2'b01: begin
				A3 = rd;
			end
			2'b10: begin
				A3 = 31;
			end
		endcase
	end
	
	always@(*) begin
		case(memtoReg) 
			2'b00: begin
				reg_data = ALUans;
			end
			2'b01: begin
				reg_data = DMans;
			end
			2'b10: begin
				reg_data = PC + 4;
			end
		endcase
	end
	
	always@(*) begin
		num1 = RD1;
	end
	
	always@(*) begin
		case(ALUSrc) 
			2'b00: begin
				num2 = RD2;
			end
			2'b01: begin
				num2 = Extans;
			end
		endcase
	end
	
	always@(*) begin
		beq = Extans;
	end
	
	always@(*) begin
		jal = Extans;
	end
	
	always@(*) begin
		jr = RD1;
	end
	
	always@(*) begin
		if(PCsel == 4'b0001 && ALUans == 1) begin
			PCop = `BEQ;
		end else if(PCsel == 4'b0010) begin
			PCop = `JAL;
		end else if(PCsel == 4'b0011) begin
			PCop = `JR;
		end else begin
			PCop = `NORMAL;
		end
	end
	
endmodule
