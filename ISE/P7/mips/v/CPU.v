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

module CPU(
	input clk,
	input reset,
	
	//PC
	input [31:0] i_inst_rdata,
	output [31:0] i_inst_addr,
	
	//DM
	input [31:0] m_data_rdata,
	output [31:0] m_data_addr,
	output [31:0] m_data_wdata,
	output [3:0] m_data_byteen,
	output [31:0] m_inst_addr,
	
	//GRF
	output w_grf_we,
	output [4:0] w_grf_addr,
	output [31:0] w_grf_wdata,
	output [31:0] w_inst_addr,
	
	input [5:0] HWInt,
	output [31:0] macroscopic_pc
    );
	
	wire [31:0] EPC;
	wire req;
	//FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	
	reg [4:0] Exception_F;
	reg eret_D;
	
	//F_PC
	reg BD_F;
	
	reg [3:0] PcOp;
	reg [31:0] BeqPc;
	reg [31:0] BnePc;
	reg [31:0] JalPc;
	reg [31:0] JrPc;
	wire [31:0] Pc_F;
	reg En_Pc;
	
	//F_IM
	wire [31:0] Instruction_F;
	
	//Reg_F
	reg En_F;
	
	//DDDDDDDDDDDDDDDDDDDDDDDDD
	wire BD_D;
	wire [4:0] rd_D;
	wire [4:0] Exception_D_pre;
	reg [4:0] Exception_D, Exception_D_now;
	wire CP0_en_D;
	wire EXLClr_D;
	
	//Reg_F
	wire [31:0] Pc_D;
	wire [31:0] Instruction_D;
	
	//splitter
	wire [5:0] Op, Func;
	wire [4:0] rs, rt, rd;
	wire [15:0] immediate;
	wire [25:0] jal_immediate;
	
	//CU
	wire[1:0] RegDst_D, AluSrc_D, MemToReg_D;
	wire RegWrite_D, MemWrite_D;
	wire [3:0] PcSel_D;
	wire [7:0] ExtOp_D, AluOp_D, InstrType_D;
	wire [7:0] TNew_D, TUse_D1, TUse_D2;
	wire Multiply_D, Divide_D;
	
	//GRF
	reg [4:0] A1, A2;
	reg [31:0] WD;
	reg [31:0] RD1_D, RD2_D;
	wire [31:0] RD1_D_t, RD2_D_t;
	wire [4:0] Addr1_D, Addr2_D;
	
	//Extender
	wire [31:0] ExtAns_D;
	
	//Reg_D
	reg [4:0] WR_D;
	reg Clr_D;
	
	reg Sign1, Sign2, Sign3, Sign4;
	//EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
	wire BD_E;
	wire CP0_en_E;
	wire [4:0] rd_E;
	wire EXLClr_E;
	
	wire [4:0] Exception_E_pre;
	reg [4:0] Exception_E, Exception_E_now;
	wire [32:0] temp1, temp2;
	reg [32:0] add_temp, sub_temp;
	
	//ALU
	reg [31:0] AluNum1, AluNum2;
	wire [31:0] AluAns_E_t;
	
	//MD
	wire [31:0] HI_E, LO_E;
	wire Start_E, Busy_E;
	
	//Reg_D
	reg [31:0] AluAns_E;
	wire [31:0] Pc_E;
	reg [31:0] RD1_E,RD2_E;
	wire [4:0] WR_E;
	wire [31:0] ExtAns_E;
	wire [1:0] MemToReg_E, AluSrc_E;
	wire RegWrite_E, MemWrite_E;
	wire [7:0] AluOp_E, InstrType_E;
	wire [7:0] TNew_E;
	wire [31:0] RD1_E_t, RD2_E_t;
	wire [4:0] Addr1_E, Addr2_E;
	wire Multiply_E, Divide_E;
	
	//transfer
	reg [31:0] Data_E;
	
	//MMMMMMMMMMMMMMMMMMMMM
	wire BD_M;
	wire CP0_en_M;
	wire [4:0] rd_M;
	wire [31:0] CP0_Out;
	wire EXLClr_M;
	
	wire [4:0] Exception_M_pre;
	reg [4:0] Exception_M, Exception_M_now;
	
	//Reg_E
	wire [31:0] Pc_M;
	wire [31:0] AluAns_M;
	wire [4:0] WR_M;
	reg [31:0] RD2_M;
	wire [1:0] MemToReg_M;
	wire RegWrite_M;
	wire MemWrite_M;
	wire [7:0] InstrType_M;
	wire [7:0] TNew_M;
	wire [31:0] RD2_M_t;
	wire [4:0] Addr2_M;
	
	//DM
	wire[31:0] DmAns_M_t;
	reg [31:0] DmAns_M;
	reg [31:0] DmData_M;
	reg [3:0] ByteEn_M;
	reg [3:0] ByteEn_M_t;
	
	//transfer
	reg [31:0] Data_M;
	
	//WWWWWWWWWWWWWWWWWWWW
	//Reg_M
	wire RegWrite_W;
	wire [4:0] WR_W;
	wire [31:0] Pc_W;
	wire [31:0] AluAns_W;
	wire [31:0] DmAns_W;
	wire [1:0] MemToReg_W;
	wire [7:0] InstrType_W;
	wire [7:0] TNew_W;
	
	//transfer
	reg [31:0] Data_W;
	
	//FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	
	PC module_pc(
		.PcOp(PcOp),
		.BeqPc(BeqPc),
		.BnePc(BnePc),
		.JalPc(JalPc),
		.JrPc(JrPc),
		.clk(clk),
		.reset(reset),
		.req(req),
		.En_Pc(En_Pc),
		.Pc_F(Pc_F),
		.EPC(EPC)
	);

	//IM
	assign i_inst_addr = Pc_F;
	assign Instruction_F = (Exception_F == `AdEL) ? 32'd0 : i_inst_rdata;
	
	Reg_F module_Reg_F(
		.clk(clk),
		.reset(reset),
		.Pc_F(Pc_F),
		.Instruction_F(Instruction_F),
		.Exception_F(Exception_F),
		.Exception_D_pre(Exception_D_pre),
		.BD_F(BD_F),
		.req(req),
		.BD_D(BD_D),
		.eret_D(eret_D),
		.EPC(EPC),
		.En_F(En_F),
		.Pc_D(Pc_D),
		.Instruction_D(Instruction_D)
	);

	//DDDDDDDDDDDDDDDDDDDDDDDDDD

	splitter module_splitter(
		.instruction(Instruction_D),
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
		.RegDst(RegDst_D),
		.ALUSrc(AluSrc_D),
		.memtoReg(MemToReg_D),
		.Regwrite(RegWrite_D),
		.Memwrite(MemWrite_D),
		.PCsel(PcSel_D),
		.Extop(ExtOp_D),
		.ALUop(AluOp_D),
		.instr_type(InstrType_D),
		.TNew_D(TNew_D),
		.TUse_D1(TUse_D1),
		.TUse_D2(TUse_D2),
		.Multiply_D(Multiply_D),
		.Divide_D(Divide_D),
		.CP0_en(CP0_en_D),
		.EXLClr(EXLClr_D)
	);
	
	GRF module_grf(
		.clk(clk),
		.reset(reset),
		.WE(RegWrite_W),
		.A1(A1),
		.A2(A2),
		.A3(WR_W),
		.WD(WD),
		.PC(Pc_W),
		.RD1(RD1_D_t),
		.RD2(RD2_D_t)
	);
	assign w_grf_we = RegWrite_W;
	assign w_grf_addr = WR_W;
	assign w_grf_wdata = WD;
	assign w_inst_addr = Pc_W;
	
	
	Extender module_extender(
		.num(immediate),
		.jal(jal_immediate),
		.Extop(ExtOp_D),
		.PC(Pc_D),
		.ans(ExtAns_D)
	);
	
	Reg_D module_Reg_D(
		.clk(clk),
		.reset(reset),
		.Clr_D(Clr_D),
		.Pc_D(Pc_D),
		.RD1_D(RD1_D),
		.RD2_D(RD2_D),
		.WR_D(WR_D),
		.ExtAns_D(ExtAns_D),
		
		.MemToReg_D(MemToReg_D),
		.AluSrc_D(AluSrc_D),
		.RegWrite_D(RegWrite_D),
		.MemWrite_D(MemWrite_D),
		.AluOp_D(AluOp_D),
		.InstrType_D(InstrType_D),
		.TNew_D(TNew_D),
		.Addr1_D(Addr1_D),
		.Addr2_D(Addr2_D),
		.Multiply_D(Multiply_D),
		.Divide_D(Divide_D),
		.Exception_D(Exception_D),
		.rd_D(rd_D),
		.CP0_en_D(CP0_en_D),
		.BD_D(BD_D),
		.req(req),
		.EXLClr_D(EXLClr_D),
		
		.EXLClr_E(EXLClr_E),
		.BD_E(BD_E),
		.CP0_en_E(CP0_en_E),
		.rd_E(rd_E),
		.Exception_E_pre(Exception_E_pre),
		.Pc_E(Pc_E),
		.RD1_E(RD1_E_t),
		.RD2_E(RD2_E_t),
		.WR_E(WR_E),
		.ExtAns_E(ExtAns_E),
		
		.MemToReg_E(MemToReg_E),
		.AluSrc_E(AluSrc_E),
		.RegWrite_E(RegWrite_E),
		.MemWrite_E(MemWrite_E),
		.AluOp_E(AluOp_E),
		.InstrType_E(InstrType_E),
		.TNew_E(TNew_E),
		.Addr1_E(Addr1_E),
		.Addr2_E(Addr2_E),
		.Multiply_E(Multiply_E),
		.Divide_E(Divide_E)
	);
	
	//EEEEEEEEEEEEEEEEEEEEEEEEE
	
	ALU module_alu(
		.num1(AluNum1),
		.num2(AluNum2),
		.ALUop(AluOp_E),
		.ans(AluAns_E_t)
	);
	
	MD module_md(
		.clk(clk),
		.reset(reset),
		.num1(RD1_E),
		.num2(RD2_E),
		.multiply(Multiply_E),
		.divide(Divide_E),
		.InstrType(InstrType_E),
		.req(req),
		.HI(HI_E),
		.LO(LO_E),
		.start(Start_E),
		.busy(Busy_E)
	);
	
	Reg_E module_Reg_E(
		.clk(clk),
		.reset(reset),
		.Pc_E(Pc_E),
		.AluAns_E(AluAns_E),
		.WR_E(WR_E),
		.RD2_E(RD2_E),
		.MemToReg_E(MemToReg_E),
		.RegWrite_E(RegWrite_E),
		.MemWrite_E(MemWrite_E),
		.InstrType_E(InstrType_E),
		.TNew_E(TNew_E),
		.Addr2_E(Addr2_E),
		.Exception_E(Exception_E),
		.rd_E(rd_E),
		.CP0_en_E(CP0_en_E),
		.BD_E(BD_E),
		.req(req),
		.EXLClr_E(EXLClr_E),
		
		.EXLClr_M(EXLClr_M),
		.BD_M(BD_M),
		.CP0_en_M(CP0_en_M),
		.rd_M(rd_M),
		.Exception_M_pre(Exception_M_pre),
		.Pc_M(Pc_M),
		.AluAns_M(AluAns_M),
		.WR_M(WR_M),
		.RD2_M(RD2_M_t),
		.MemToReg_M(MemToReg_M),
		.RegWrite_M(RegWrite_M),
		.MemWrite_M(MemWrite_M),
		.InstrType_M(InstrType_M),
		.TNew_M(TNew_M),
		.Addr2_M(Addr2_M)
	);
	//MMMMMMMMMMMMMMMMMMMMM
	
	//DM
	assign m_data_addr = AluAns_M;
	assign m_data_wdata = DmData_M;
	assign m_inst_addr = Pc_M;
	assign DmAns_M_t = m_data_rdata;
	assign m_data_byteen = ByteEn_M_t;
	
	CP0 module_CP0(
		.clk(clk),
		.reset(reset),
		.en(CP0_en_M),
		.CP0_Addr(rd_M),
		.CP0_In(RD2_M),
		.VPC(Pc_M),
		.BD_In(BD_M),
		.Exception(Exception_M),
		.HWInt(HWInt),
		.EXLClr(EXLClr_M),
		
		.CP0_Out(CP0_Out),
		.EPC_Out(EPC),
		.req(req)
	);
	
	Reg_M module_Reg_M(
		.clk(clk),
		.reset(reset),
		.Pc_M(Pc_M),
		.AluAns_M(AluAns_M),
		.WR_M(WR_M),
		.DmAns_M(DmAns_M),
		
		.MemToReg_M(MemToReg_M),
		.RegWrite_M(RegWrite_M),
		.InstrType_M(InstrType_M),
		.TNew_M(TNew_M),
		.req(req),
		
		.Pc_W(Pc_W),
		.AluAns_W(AluAns_W),
		.WR_W(WR_W),
		.DmAns_W(DmAns_W),
		.MemToReg_W(MemToReg_W),
		.RegWrite_W(RegWrite_W),
		.InstrType_W(InstrType_W),
		.TNew_W(TNew_W)
	);
	
	//FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	always@(*) begin
		if(Pc_F[1:0] != 2'b00 || Pc_F < 32'h00000000 || Pc_F > 32'h00006ffc) begin
			Exception_F = `AdEL;
		end else begin
			Exception_F = `Int;
		end
	end
	
	always@(*) begin
		if(InstrType_D == `beq 
		|| InstrType_D == `bne
		|| InstrType_D == `jal
		|| InstrType_D == `jr) begin
			BD_F = 1;
		end else begin
			BD_F = 0;
		end
	end
	
	always@(*) begin
		if(InstrType_D == `eret) begin
			eret_D = 1;
		end else begin
			eret_D = 0;
		end
	end
	
	//DDDDDDDDDDDDDDDDDDDDDDDDD
	always@(*) begin
		if(InstrType_D == `nop && Instruction_D != 32'd0) begin
			Exception_D_now = `RI;
		end else if(InstrType_D == `syscall) begin
			Exception_D_now = `Syscall;
		end else begin
			Exception_D_now = `Int;
		end
	end
	
	always@(*) begin
		if(Exception_D_pre != `Int) begin
			Exception_D = Exception_D_pre;
		end else if(Exception_D_now != `Int) begin
			Exception_D = Exception_D_now;
		end else begin
			Exception_D = `Int;
		end
	end
	
	always@(*) begin
		A1 = rs;
	end
	
	always@(*) begin
		A2 = rt;
	end
	
	assign rd_D = rd;
	
	always@(*) begin
		case(RegDst_D)
			2'b00: begin
				WR_D = rt;
			end
			2'b01: begin
				WR_D = rd;
			end
			2'b10: begin
				WR_D = 31;
			end
			2'b11: begin
				WR_D = 0;
			end
		endcase
	end
	
	always@(*) begin
		if(req == 1) begin
			PcOp = `REQ;
		end else begin
			if(PcSel_D == `BEQ && RD1_D == RD2_D) begin
				PcOp = `BEQ;
			end else if(PcSel_D == `JAL) begin
				PcOp = `JAL;
			end else if(PcSel_D == `JR) begin
				PcOp = `JR;
			end else if(PcSel_D == `BNE && RD1_D != RD2_D) begin
				PcOp = `BNE;
			end else if(PcSel_D == `ERET) begin
				PcOp = `ERET;
			end
			else begin
				PcOp = `NORMAL;
			end
		end
	end
	
	always@(*) begin
		BeqPc = Pc_D + 4 + ExtAns_D;
	end
	
	always@(*) begin
		BnePc = Pc_D + 4 + ExtAns_D;
	end
	
	always@(*) begin
		JalPc = ExtAns_D;
	end
	
	always@(*) begin
		JrPc = RD1_D;
	end
	
	always@(*) begin
		if(Addr1_D == 0) begin
			RD1_D = 0;
		end else begin
			if(Addr1_D == WR_E) begin
				RD1_D = Data_E;
			end else if(Addr1_D == WR_M) begin
				RD1_D = Data_M;
			end else if(Addr1_D == WR_W) begin
				RD1_D = Data_W;
			end else begin
				RD1_D = RD1_D_t;
			end
		end
	end
	
	always@(*) begin
		if(Addr2_D == 0) begin
			RD2_D = 0;
		end else begin
			if(Addr2_D == WR_E) begin
				RD2_D = Data_E;
			end else if(Addr2_D == WR_M) begin
				RD2_D = Data_M;
			end else if(Addr2_D == WR_W) begin
				RD2_D = Data_W;
			end else begin
				RD2_D = RD2_D_t;
			end
		end
	end
	
	assign Addr1_D = rs;
	assign Addr2_D = rt;
	
	always@(*) begin
		Sign1 = 0;
		if(Addr1_D != 0) begin
			if(Addr1_D == WR_E) begin
				if(TUse_D1 < TNew_E) begin
					Sign1 = 1;
				end
			end else if(Addr1_D == WR_M) begin
				if(TUse_D1 < TNew_M) begin
					Sign1 = 1;
				end
			end else if(Addr1_D == WR_W) begin
				if(TUse_D1 < TNew_W) begin
					Sign1 = 1;
				end
			end
		end
	end	
	
	always@(*) begin
		Sign2 = 0;
		if(Addr2_D != 0) begin
			if(Addr2_D == WR_E) begin
				if(TUse_D2 < TNew_E) begin
					Sign2 = 1;
				end
			end else if(Addr2_D == WR_M) begin
				if(TUse_D2 < TNew_M) begin
					Sign2 = 1;
				end
			end else if(Addr2_D == WR_W) begin
				if(TUse_D2 < TNew_W) begin
					Sign2 = 1;
				end
			end
		end
	end	
	
	always@(*) begin
		Sign3 = 0;
		if(Start_E == 1 || Busy_E == 1) begin
			if(InstrType_D == `mult
			|| InstrType_D == `multu
			|| InstrType_D == `div
			|| InstrType_D == `divu
			|| InstrType_D == `mfhi
			|| InstrType_D == `mflo
			|| InstrType_D == `mthi
			|| InstrType_D == `mtlo) begin
				Sign3 = 1;
			end
		end
	end
	
	always@(*) begin
		if(InstrType_D == `eret && ((InstrType_E == `mtc0 && rd_E == 5'd14) || (InstrType_M == `mtc0 && rd_M == 5'd14))) begin
			Sign4 = 1;
		end else begin
			Sign4 = 0;
		end
	end
	
	always@(*) begin
		if(Sign1 ==1 || Sign2 == 1 || Sign3 == 1 || Sign4 == 1) begin
			En_Pc = 0;
			En_F = 0;
			Clr_D = 1;
		end else begin
			En_Pc = 1;
			En_F = 1;
			Clr_D = 0;
		end
	end
	
	//EEEEEEEEEEEEEEEEEEEEEEEEEEEEE
	assign temp1 = {AluNum1[31], AluNum1};
	assign temp2 = {AluNum2[31], AluNum2};
	
	always@(*) begin
		add_temp = temp1 + temp2;
		sub_temp = temp1 - temp2;
		
		if(InstrType_E == `add || InstrType_E == `addi) begin
			if(add_temp[32] != add_temp[31]   ) begin
				Exception_E_now = `Ov;
			end else begin
				Exception_E_now = `Int;
			end
		end  else if(InstrType_E == `lw 
		|| InstrType_E == `lh
		|| InstrType_E == `lb) begin
			if(add_temp[32] != add_temp[31]   ) begin
				Exception_E_now = `AdEL;
			end else begin
				Exception_E_now = `Int;
			end
		end else if(InstrType_E == `sw 
		|| InstrType_E == `sh
		|| InstrType_E == `sb) begin
			if(add_temp[32] != add_temp[31]   ) begin
				Exception_E_now = `AdES;
			end else begin
				Exception_E_now = `Int;
			end
		end else if(InstrType_E == `sub) begin
			if(sub_temp[32] != sub_temp[31]) begin
				Exception_E_now = `Ov;
			end else begin
				Exception_E_now = `Int;
			end
		end else begin
			Exception_E_now = `Int;
		end
	end
	
	always@(*) begin
		if(Exception_E_pre != `Int) begin
			Exception_E = Exception_E_pre;
		end else if(Exception_E_now != `Int) begin
			Exception_E = Exception_E_now;
		end else begin
			Exception_E = `Int;
		end
	end
	
	always@(*) begin
		AluNum1 = RD1_E;
	end
	
	always@(*) begin
		case(AluSrc_E) 
			2'b00: begin
				AluNum2 = RD2_E;
			end
			2'b01: begin
				AluNum2 = ExtAns_E;
			end
		endcase
	end
	
	always@(*) begin
		if(InstrType_E == `mfhi) begin
			AluAns_E = HI_E;
		end else if(InstrType_E == `mflo) begin
			AluAns_E = LO_E;
		end else begin
			AluAns_E = AluAns_E_t;
		end
	end
	
	always@(*) begin
		if(Addr1_E == 0) begin
			RD1_E = 0;
		end else begin
			if(Addr1_E == WR_M) begin
				RD1_E = Data_M;
			end else if(Addr1_E == WR_W) begin
				RD1_E = Data_W;
			end else begin
				RD1_E = RD1_E_t;
			end
		end
	end
	
	always@(*) begin
		if(Addr2_E == 0) begin
			RD2_E = 0;
		end else begin
			if(Addr2_E == WR_M) begin
				RD2_E = Data_M;
			end else if(Addr2_E == WR_W) begin
				RD2_E = Data_W;
			end else begin
				RD2_E = RD2_E_t;
			end
		end
	end
	
	always@(*) begin
		if(InstrType_E == `jal) begin
			Data_E = Pc_E + 8;
		end else begin
			Data_E = 0;
		end
	end
	
	//MMMMMMMMMMMMMMMMMMMMMMMMMMM
	always@(*) begin
		if(InstrType_M == `lw) begin
			if(AluAns_M[1:0] != 2'b00 || 
			!((AluAns_M >= `Dm_Addr_start && AluAns_M <= `Dm_Addr_end)
			||(AluAns_M >= `TC1_Addr_start && AluAns_M <= `TC1_Addr_end)
			||(AluAns_M >= `TC2_Addr_start && AluAns_M <= `TC2_Addr_end)
			||(AluAns_M >= `Inter_Addr_start && AluAns_M <= `Inter_Addr_end)
			)) begin
				Exception_E_now = `AdEL;
			end else begin
				Exception_E_now = `Int;
			end
		end else if(InstrType_M == `lh) begin
			if(AluAns_M[0] != 1'b0 || 
			!((AluAns_M >= `Dm_Addr_start && AluAns_M <= `Dm_Addr_end)
			||(AluAns_M >= `TC1_Addr_start && AluAns_M <= `TC1_Addr_end)
			||(AluAns_M >= `TC2_Addr_start && AluAns_M <= `TC2_Addr_end)
			||(AluAns_M >= `Inter_Addr_start && AluAns_M <= `Inter_Addr_end)
			)
			||(AluAns_M >= `TC1_Addr_start && AluAns_M <= `TC1_Addr_end)
			||(AluAns_M >= `TC2_Addr_start && AluAns_M <= `TC2_Addr_end)
			) begin
				Exception_E_now = `AdEL;
			end else begin
				Exception_E_now = `Int;
			end
		end else if(InstrType_M == `lb) begin
			if(
			!((AluAns_M >= `Dm_Addr_start && AluAns_M <= `Dm_Addr_end)
			||(AluAns_M >= `TC1_Addr_start && AluAns_M <= `TC1_Addr_end)
			||(AluAns_M >= `TC2_Addr_start && AluAns_M <= `TC2_Addr_end)
			||(AluAns_M >= `Inter_Addr_start && AluAns_M <= `Inter_Addr_end)
			)
			||(AluAns_M >= `TC1_Addr_start && AluAns_M <= `TC1_Addr_end)
			||(AluAns_M >= `TC2_Addr_start && AluAns_M <= `TC2_Addr_end)
			) begin
				Exception_E_now = `AdEL;
			end else begin
				Exception_E_now = `Int;
			end
		end else if(InstrType_M == `sw) begin
			if(AluAns_M[1:0] != 2'b00 || 
			!((AluAns_M >= `Dm_Addr_start && AluAns_M <= `Dm_Addr_end)
			||(AluAns_M >= `TC1_Addr_start && AluAns_M <= `TC1_Addr_end)
			||(AluAns_M >= `TC2_Addr_start && AluAns_M <= `TC2_Addr_end)
			||(AluAns_M >= `Inter_Addr_start && AluAns_M <= `Inter_Addr_end)
			)
			||(AluAns_M >= 32'h00007f08 && AluAns_M <= 32'h00007f0b)
			||(AluAns_M >= 32'h00007f18 && AluAns_M <= 32'h00007f1b)
			) begin
				Exception_E_now = `AdES;
			end else begin
				Exception_E_now = `Int;
			end
		end else if(InstrType_M == `sh) begin
			if(AluAns_M[0] != 1'b0 || 
			!((AluAns_M >= `Dm_Addr_start && AluAns_M <= `Dm_Addr_end)
			||(AluAns_M >= `TC1_Addr_start && AluAns_M <= `TC1_Addr_end)
			||(AluAns_M >= `TC2_Addr_start && AluAns_M <= `TC2_Addr_end)
			||(AluAns_M >= `Inter_Addr_start && AluAns_M <= `Inter_Addr_end)
			)
			||(AluAns_M >= 32'h00007f08 && AluAns_M <= 32'h00007f0b)
			||(AluAns_M >= 32'h00007f18 && AluAns_M <= 32'h00007f1b)
			||(AluAns_M >= 32'h00007f08 && AluAns_M <= 32'h00007f0b)
			||(AluAns_M >= 32'h00007f18 && AluAns_M <= 32'h00007f1b)
			) begin
				Exception_E_now = `AdES;
			end else begin
				Exception_E_now = `Int;
			end
		end else if(InstrType_M == `sb) begin
			if(
			!((AluAns_M >= `Dm_Addr_start && AluAns_M <= `Dm_Addr_end)
			||(AluAns_M >= `TC1_Addr_start && AluAns_M <= `TC1_Addr_end)
			||(AluAns_M >= `TC2_Addr_start && AluAns_M <= `TC2_Addr_end)
			||(AluAns_M >= `Inter_Addr_start && AluAns_M <= `Inter_Addr_end)
			)
			||(AluAns_M >= 32'h00007f08 && AluAns_M <= 32'h00007f0b)
			||(AluAns_M >= 32'h00007f18 && AluAns_M <= 32'h00007f1b)
			||(AluAns_M >= 32'h00007f08 && AluAns_M <= 32'h00007f0b)
			||(AluAns_M >= 32'h00007f18 && AluAns_M <= 32'h00007f1b)
			) begin
				Exception_E_now = `AdES;
			end else begin
				Exception_E_now = `Int;
			end
		end else begin
			Exception_E_now = `Int;
		end
	end
	
	always@(*) begin
		if(Exception_M_pre != `Int) begin
			Exception_M = Exception_M_pre;
		end else if(Exception_E_now != `Int) begin
			Exception_M = Exception_M_now;
		end else begin
			Exception_M = `Int;
		end
	end
	
	always@(*) begin
		if(InstrType_M == `sw) begin
			DmData_M = RD2_M;
		end else if(InstrType_M == `sh) begin
			DmData_M[31:16] = RD2_M[15:0];
			DmData_M[15:0] = RD2_M[15:0];
		end else if(InstrType_M == `sb) begin
			DmData_M[31:24] = RD2_M[7:0];
			DmData_M[23:16] = RD2_M[7:0];
			DmData_M[15:8] = RD2_M[7:0];
			DmData_M[7:0] = RD2_M[7:0];
		end else begin	
			DmData_M = RD2_M;
		end
	end
	
	always@(*) begin
		if(InstrType_M == `sw) begin
			ByteEn_M = 4'b1111;
		end else if(InstrType_M == `sh) begin
			case(AluAns_M[1:0])
				2'b00: begin
					ByteEn_M = 4'b0011;
				end
				2'b10: begin
					ByteEn_M = 4'b1100;
				end
			endcase
		end else if(InstrType_M == `sb) begin
			case(AluAns_M[1:0])
				2'b00: begin
					ByteEn_M = 4'b0001;
				end
				2'b01: begin
					ByteEn_M = 4'b0010;
				end
				2'b10: begin
					ByteEn_M = 4'b0100;
				end
				2'b11: begin
					ByteEn_M = 4'b1000;
				end
			endcase
		end else begin
			ByteEn_M = MemWrite_M;
		end
	end
	
	always@(*) begin
		if(req == 0) begin
			ByteEn_M_t = ByteEn_M;
		end else if(req == 1) begin
			ByteEn_M_t = 0;
		end
	end
	
	always@(*) begin
		if(InstrType_M == `lw) begin
			DmAns_M = DmAns_M_t;
		end else if(InstrType_M == `lh) begin
			case(AluAns_M[1:0])
				2'b00: begin
					DmAns_M[15:0] =DmAns_M_t[15:0];
					DmAns_M[31:16] = {16{DmAns_M_t[15]}};
				end
				2'b10: begin
					DmAns_M[15:0] =DmAns_M_t[31:16];
					DmAns_M[31:16] = {16{DmAns_M_t[31]}};
				end
			endcase
		end else if(InstrType_M == `lb) begin
			case(AluAns_M[1:0])
				2'b00: begin
					DmAns_M[7:0] =DmAns_M_t[7:0];
					DmAns_M[31:8] = {24{DmAns_M_t[7]}};
				end
				2'b01: begin
					DmAns_M[7:0] =DmAns_M_t[15:8];
					DmAns_M[31:8] = {24{DmAns_M_t[15]}};
				end
				2'b10: begin
					DmAns_M[7:0] =DmAns_M_t[23:16];
					DmAns_M[31:8] = {24{DmAns_M_t[23]}};
				end
				2'b11: begin
					DmAns_M[7:0] =DmAns_M_t[31:24];
					DmAns_M[31:8] = {24{DmAns_M_t[31]}};
				end
			endcase
		end else if(InstrType_M == `mfc0) begin
			DmAns_M = CP0_Out;
		end else begin
			DmAns_M = DmAns_M_t;
		end
	end
	
	always@(*) begin
		if(Addr2_M == 0) begin
			RD2_M = 0;
		end else begin
			if(Addr2_M == WR_W) begin
				RD2_M = Data_W;
			end else begin
				RD2_M = RD2_M_t;
			end
		end
	end
	
	always@(*) begin
		if(InstrType_M == `add
		|| InstrType_M == `sub
		|| InstrType_M == `ori
		|| InstrType_M == `lui
		|| InstrType_M == `and
		|| InstrType_M == `or
		|| InstrType_M == `addi
		|| InstrType_M == `andi
		|| InstrType_M == `slt
		|| InstrType_M == `sltu
		|| InstrType_M == `mfhi
		|| InstrType_M == `mflo) begin
			Data_M = AluAns_M;
		end else if(InstrType_M == `jal) begin
			Data_M = Pc_M + 8;
		end else begin
			Data_M = 0;
		end
	end
	
	assign macroscopic_pc = Pc_M;
	
	//WWWWWWWWWWWWWWWWWWWWWWWWW
	
	always@(*) begin
		case(MemToReg_W) 
			2'b00: begin
				WD = AluAns_W;
			end
			2'b01: begin
				WD = DmAns_W;
			end
			2'b10: begin
				WD = Pc_W + 8;
			end
		endcase
	end
	
	always@(*) begin
		if(InstrType_W == `add
		|| InstrType_W == `sub
		|| InstrType_W == `ori
		|| InstrType_W == `lui
		|| InstrType_W == `and
		|| InstrType_W == `or
		|| InstrType_W == `addi
		|| InstrType_W == `andi
		|| InstrType_W == `slt
		|| InstrType_W == `sltu
		|| InstrType_W == `mfhi
		|| InstrType_W == `mflo) begin
			Data_W = AluAns_W;
		end else if(InstrType_W == `jal) begin
			Data_W = Pc_W + 8;
		end else if(InstrType_W == `lw
		|| InstrType_W == `lh
		|| InstrType_W == `lb
		|| InstrType_W == `mfc0) begin
			Data_W = DmAns_W;
		end else begin
			Data_W = 0;
		end
	end
	
endmodule
