`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:43:57 11/30/2024 
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
	input reset,
	input interrupt,
	output [31:0] macroscopic_pc,
	
	output [31:0] i_inst_addr,
	input [31:0] i_inst_rdata,
	
	output [31:0] m_data_addr,
	input [31:0] m_data_rdata,
	output [31:0] m_data_wdata,
	output [3:0] m_data_byteen,
	
	output [31:0] m_int_addr,
	output [3:0] m_int_byteen,
	
	output [31:0] m_inst_addr,
	
	output w_grf_we,
	output [4:0] w_grf_addr,
	output [31:0] w_grf_wdata,
	
	output [31:0] w_inst_addr
    );

	wire [5:0] HWInt;
	wire IRQ_TC1, IRQ_TC2;
	
	wire [31:0] i_inst_rdata_cpu;
	wire [31:0] i_inst_addr_cpu;
	
	wire [31:0] m_data_addr_cpu;
	wire [31:0] m_data_rdata_cpu;
	wire [31:0] m_data_wdata_cpu;
	wire [3 :0] m_data_byteen_cpu;
	wire [31:0] m_inst_addr_cpu;
	
	wire w_grf_we_cpu;
	wire [4 :0] w_grf_addr_cpu;
	wire [31:0] w_grf_wdata_cpu;
	wire [31:0] w_inst_addr_cpu;
	
	wire [31:0] macroscopic_pc_cpu;
	
	wire [31:0] TC1_Addr, TC2_Addr;
   wire TC1_WE, TC2_WE;
   wire [31:0] TC1_Din, TC2_Din;
   wire [31:0] TC1_Dout, TC2_Dout;
	
	wire [31:0] m_data_addr_b;
	wire [31:0] m_data_wdata_b;
	wire [3:0] m_data_byteen_b;
	wire [31:0] m_data_rdata_b;
	
	wire [31:0] m_int_addr_b;
	wire [3:0] m_int_byteen_b;
	
	CPU module_CPU(
		.clk(clk),
		.reset(reset),
		
		.i_inst_rdata(i_inst_rdata_cpu),
		.i_inst_addr(i_inst_addr_cpu),
		
		.m_data_rdata(m_data_rdata_cpu),
		.m_data_addr(m_data_addr_cpu),
		.m_data_wdata(m_data_wdata_cpu),
		.m_data_byteen(m_data_byteen_cpu),
		.m_inst_addr(m_inst_addr_cpu),
		
		.w_grf_we(w_grf_we_cpu),
		.w_grf_addr(w_grf_addr_cpu),
		.w_grf_wdata(w_grf_wdata_cpu),
		.w_inst_addr(w_inst_addr_cpu),
		
		.HWInt(HWInt),
		.macroscopic_pc(macroscopic_pc_cpu)
	);
	
	TC1 module_TC1(
		.clk(clk),
		.reset(reset),
		.Addr(TC1_Addr[31:2]),
		.WE(TC1_WE),
		.Din(TC1_Din),
		.Dout(TC1_Dout),
		.IRQ(IRQ_TC1)
	);
	
	TC2 module_TC2(
		.clk(clk),
		.reset(reset),
		.Addr(TC2_Addr[31:2]),
		.WE(TC2_WE),
		.Din(TC2_Din),
		.Dout(TC2_Dout),
		.IRQ(IRQ_TC2)
	);
	
	Bridge module_Bridge(
		.m_data_addr(m_data_addr_b),
		.m_data_wdata(m_data_wdata_b),
		.m_data_byteen(m_data_byteen_b),
		.m_data_rdata(m_data_rdata_b),
		
		.temp_m_data_addr(m_data_addr_cpu),
		.temp_m_data_wdata(m_data_wdata_cpu),
		.temp_m_data_byteen(m_data_byteen_cpu),
		.temp_m_data_rdata(m_data_rdata_cpu),
		
		.TC1_Addr(TC1_Addr),
		.TC1_WE(TC1_WE),
		.TC1_Din(TC1_Din),
		.TC1_Dout(TC1_Dout),
		
		.TC2_Addr(TC2_Addr),
		.TC2_WE(TC2_WE),
		.TC2_Din(TC2_Din),
		.TC2_Dout(TC2_Dout),
		
		.m_int_addr(m_int_addr_b),
		.m_int_byteen(m_int_byteen_b)
	);
	
	assign i_inst_addr = i_inst_addr_cpu;
	assign i_inst_rdata_cpu = i_inst_rdata;
	
	assign m_data_addr = m_data_addr_b;
	assign m_data_wdata = m_data_wdata_b;
	assign m_data_byteen = m_data_byteen_b;
	assign m_data_rdata_b = m_data_rdata;
	//assign m_data_addr = m_data_addr_cpu;
	//assign m_data_wdata = m_data_wdata_cpu;
	//assign m_data_byteen = m_data_byteen_cpu;
	//assign m_data_rdata_cpu = m_data_rdata;
	
	assign m_inst_addr = m_inst_addr_cpu;
	
	assign m_int_addr = m_int_addr_b;
	assign m_int_byteen = m_int_byteen_b;
	
	assign  w_grf_we =  w_grf_we_cpu;
	assign w_grf_addr = w_grf_addr_cpu;
	assign w_grf_wdata = w_grf_wdata_cpu;
	assign w_inst_addr = w_inst_addr_cpu;
	
	assign macroscopic_pc = macroscopic_pc_cpu;
	
	
	assign HWInt = {3'b000, interrupt, IRQ_TC2, IRQ_TC1};


endmodule
