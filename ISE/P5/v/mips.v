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
	
	//FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	
	//F_PC
	reg [3:0] PcOp;
	reg [31:0] BeqPc;
	reg [31:0] JalPc;
	reg [31:0] JrPc;
	wire [31:0] Pc_F;
	reg En_Pc;
	
	//F_IM
	wire [31:0] Instruction_F;
	
	//Reg_F
	reg En_F;
	
	//DDDDDDDDDDDDDDDDDDDDDDDDD
	
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
	
	reg Sign1, Sign2;
	//EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
	
	//ALU
	reg [31:0] AluNum1, AluNum2;
	wire [31:0] AluAns_E;
	
	//Reg_D
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
	
	//transfer
	reg [31:0] Data_E;
	
	//MMMMMMMMMMMMMMMMMMMMM
	
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
	wire[31:0] DmAns_M;
	reg [31:0] DmData_M;
	
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
		.JalPc(JalPc),
		.JrPc(JrPc),
		.clk(clk),
		.reset(reset),
		.En_Pc(En_Pc),
		.Pc_F(Pc_F)
	);

	IM module_im(
		.Pc_F(Pc_F),
		.Instruction(Instruction_F)
	);

	Reg_F module_Reg_F(
		.clk(clk),
		.reset(reset),
		.Pc_F(Pc_F),
		.Instruction_F(Instruction_F),
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
		.TUse_D2(TUse_D2)
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
		.Addr2_E(Addr2_E)
	);
	
	//EEEEEEEEEEEEEEEEEEEEEEEEE
	
	ALU module_alu(
		.num1(AluNum1),
		.num2(AluNum2),
		.ALUop(AluOp_E),
		.ans(AluAns_E)
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
	
	DM module_dm(
		.addr(AluAns_M),
		.WD(DmData_M),
		.clk(clk),
		.reset(reset),
		.WE(MemWrite_M),
		.PC(Pc_M),
		.data(DmAns_M)
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
		
		.Pc_W(Pc_W),
		.AluAns_W(AluAns_W),
		.WR_W(WR_W),
		.DmAns_W(DmAns_W),
		.MemToReg_W(MemToReg_W),
		.RegWrite_W(RegWrite_W),
		.InstrType_W(InstrType_W),
		.TNew_W(TNew_W)
	);
	
	//DDDDDDDDDDDDDDDDDDDDDDDDD
	
	always@(*) begin
		A1 = rs;
	end
	
	always@(*) begin
		A2 = rt;
	end
	
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
		if(PcSel_D == `BEQ && RD1_D == RD2_D) begin
			PcOp = `BEQ;
		end else if(PcSel_D == `JAL) begin
			PcOp = `JAL;
		end else if(PcSel_D == `JR) begin
			PcOp = `JR;
		end else begin
			PcOp = `NORMAL;
		end
	end
	
	always@(*) begin
		BeqPc = Pc_D + 4 + ExtAns_D;
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
		if(Sign1 ==1 || Sign2 == 1) begin
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
		DmData_M = RD2_M;
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
		|| InstrType_M == `lui) begin
			Data_M = AluAns_M;
		end else if(InstrType_M == `jal) begin
			Data_M = Pc_M + 8;
		end else begin
			Data_M = 0;
		end
	end
	
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
		|| InstrType_W == `lui) begin
			Data_W = AluAns_W;
		end else if(InstrType_W == `jal) begin
			Data_W = Pc_W + 8;
		end else if(InstrType_W == `lw) begin
			Data_W = DmAns_W;
		end else begin
			Data_W = 0;
		end
	end
	
endmodule
