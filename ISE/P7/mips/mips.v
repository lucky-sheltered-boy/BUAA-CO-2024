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


endmodule
