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

`include "constants.v"

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
	
	wire[31:0] DMans_t;
	reg[31:0] DMans;
	
	wire [31:0] EPC;
	wire req;
	reg CP0_en;
	reg [4:0] Exception, Exception_F, Exception_D, Exception_E, Exception_M;
	reg EXLClr;
	wire [31:0] CP0_Out;
	
	
	PC module_pc(
		.PCop(PCop),
		.beq(beq),
		.jal(jal),
		.jr(jr),
		.EPC(EPC),
		.req(req),
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
		.rs(rs),
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
		.req(req),
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
	
	reg [31:0] ALUans_t;
	
	DM module_dm(
		.addr(ALUans),
		.WD(RD2),
		.clk(clk),
		.reset(reset),
		.WE(Memwrite),
		.req(req),
		.PC(PC),
		.data(DMans_t)
	);
	
	reg [4:0] CP0_Addr;
	
	always@(*) begin
		if (instr_type == `rtc0) begin
			CP0_Addr = rt;
		end else begin
			CP0_Addr = rd;
		end
	end
	
	reg [31:0] CP0_In;
	reg [31:0] temp;
	integer i;
	always @(*) begin
		if (instr_type == `rtc0) begin
			if (Extans == 0) begin
				temp = RD1;
			end else begin
				for(i = 0; i <= 31; i=i+1) begin
					if (i < Extans) begin
						temp[i] = RD1[i] ^ 1'd1;
					end else begin
						temp[i] = RD1[i];
					end
				end
			end
			CP0_In = temp;
		end else begin
			CP0_In = RD2;
		end
	end
	
	CP0 module_CP0(
		.clk(clk),
		.reset(reset),
		.en(CP0_en),
		.CP0_Addr(CP0_Addr),
		.CP0_In(CP0_In),
		.VPC(PC),
		.Exception(Exception),
		.EXLClr(EXLClr),
		.CP0_Out(CP0_Out),
		.EPC_Out(EPC),
		.req(req)
	);
	
	always@(*) begin
		if(PC[1:0] != 2'b00 || PC < 32'h00003000 || PC > 32'h00006ffc) begin
			Exception_F = `AdEL;
		end else begin
			Exception_F = `Int;
		end
	end
	
	always@(*) begin
		if(instr_type== `nop && instruction != 32'd0) begin
			Exception_D = `RI;
		end else if(instr_type == `syscall) begin
			Exception_D = `Syscall;
		end else begin
			Exception_D = `Int;
		end
	end
	
	wire [32:0] temp1, temp2;
	reg [32:0] add_temp, sub_temp;
	
	assign temp1 = {num1[31], num1};
	assign temp2 = {num2[31], num2};
	
	always@(*) begin
		add_temp = temp1 + temp2;
		sub_temp = temp1 - temp2;
		
		if(instr_type== `add || instr_type == `addi) begin
			if(add_temp[32] != add_temp[31]   ) begin
				Exception_E = `Ov;
			end else begin
				Exception_E = `Int;
			end
		end  else if(instr_type == `lw) begin
			if(add_temp[32] != add_temp[31]   ) begin
				Exception_E= `AdEL;
			end else begin
				Exception_E = `Int;
			end
		end else if(instr_type  == `sw) begin
			if(add_temp[32] != add_temp[31]   ) begin
				Exception_E= `AdES;
			end else begin
				Exception_E = `Int;
			end
		end else if(instr_type == `sub) begin
			if(sub_temp[32] != sub_temp[31]) begin
				Exception_E = `Ov;
			end else begin
				Exception_E = `Int;
			end
		end else begin
			Exception_E= `Int;
		end
	end
	
	always@(*) begin
		if(instr_type == `lw) begin
			if(ALUans[1:0] != 2'b00 || 
			!((ALUans >= `Dm_Addr_start && ALUans<= `Dm_Addr_end))) begin
				Exception_M = `AdEL;
			end else begin
				Exception_M = `Int;
			end
		end else if(instr_type == `sw ) begin
			if(ALUans[1:0] != 2'b00 || 
			!((ALUans >= `Dm_Addr_start && ALUans <= `Dm_Addr_end))) begin
				Exception_M = `AdES;
			end else begin
				Exception_M = `Int;
			end
		end 
		else begin
			Exception_M = `Int;
		end
	end
	
	always@(*) begin
		if (Exception_F != `Int) begin
			Exception = Exception_F;
		end else if (Exception_D != `Int) begin
			Exception = Exception_D;
		end else if (Exception_E != `Int) begin
			Exception = Exception_E;
		end else if (Exception_M != `Int) begin
			Exception = Exception_M;
		end else begin
			Exception = `Int;
		end
	end
	
	always@(*) begin
		if (instr_type == `mfc0) begin
			DMans = CP0_Out;
		end else begin
			DMans = DMans_t;
		end
	end
	
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
		if(PCsel == `BEQ && ALUans == 1) begin
			PCop = `BEQ;
		end else if(PCsel == `JAL) begin
			PCop = `JAL;
		end else if(PCsel == `JR) begin
			PCop = `JR;
		end else if(PCsel == `ERET) begin
			PCop = `ERET;
		end
		else begin
			PCop = `NORMAL;
		end
	end
	
	always@(*) begin
		if (instr_type == `mtc0 || instr_type == `rtc0) begin
			CP0_en = 1;
		end else begin
			CP0_en = 0;
		end
	end
	
	always@(*) begin
		if (instr_type == `eret) begin
			EXLClr = 1;
		end else begin
			EXLClr = 0;
		end
	end	
	
endmodule
