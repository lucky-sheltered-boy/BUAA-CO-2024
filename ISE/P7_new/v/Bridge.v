`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:12:16 11/30/2024 
// Design Name: 
// Module Name:    Bridge 
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

module Bridge(
	output reg [31:0] m_data_addr,
	output reg[31:0] m_data_wdata,
	output reg [3:0] m_data_byteen,
	input [31:0] m_data_rdata,
	
	input [31:0] temp_m_data_addr,
	input [31:0] temp_m_data_wdata,
	input [3:0] temp_m_data_byteen,
	output reg [31:0] temp_m_data_rdata,
	
	output reg [31:0] TC1_Addr,
	output reg TC1_WE,
	output reg [31:0] TC1_Din,
	input [31:0] TC1_Dout,
	
	output reg [31:0] TC2_Addr,
	output reg TC2_WE,
	output reg [31:0] TC2_Din,
	input [31:0] TC2_Dout,
	
	output reg [31:0] m_int_addr,
	output reg [3:0] m_int_byteen
    );

	always@(*) begin
		m_data_addr = temp_m_data_addr;
		m_data_wdata = temp_m_data_wdata;
		TC1_Addr = temp_m_data_addr;
		TC1_Din = temp_m_data_wdata;
		TC2_Addr = temp_m_data_addr;
		TC2_Din = temp_m_data_wdata;
		m_int_addr = temp_m_data_addr;
		
		if(temp_m_data_addr >= `Dm_Addr_start && temp_m_data_addr <= `Dm_Addr_end) begin
			m_data_byteen = temp_m_data_byteen;
			TC1_WE = 0;
			TC2_WE = 0;
			temp_m_data_rdata = m_data_rdata;
			m_int_byteen = 0;
		end else if(temp_m_data_addr >= `TC1_Addr_start && temp_m_data_addr <= `TC1_Addr_end) begin
			m_data_byteen = 0;
			TC1_WE = |temp_m_data_byteen;
			TC2_WE = 0;
			temp_m_data_rdata = TC1_Dout;
			m_int_byteen = 0;
		end else if(temp_m_data_addr >= `TC2_Addr_start && temp_m_data_addr <= `TC2_Addr_end) begin
			m_data_byteen = 0;
			TC1_WE = 0;
			TC2_WE = |temp_m_data_byteen;
			temp_m_data_rdata = TC2_Dout;
			m_int_byteen = 0;
		end else if(temp_m_data_addr >= `Inter_Addr_start && temp_m_data_addr <= `Inter_Addr_end) begin
			m_data_byteen = 0;
			TC1_WE = 0;
			TC2_WE = 0;
			temp_m_data_rdata = 0;
			m_int_byteen = temp_m_data_byteen;
		end else begin
			m_data_byteen = 0;
			TC1_WE = 0;
			TC2_WE = 0;
			temp_m_data_rdata = 0;
			m_int_byteen = 0;
		end
	end

endmodule
