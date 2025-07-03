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
	output [31:0] m_data_addr,
	output [31:0] m_data_wdata,
	output [3:0] m_data_byteen,
	input [31:0] m_data_rdata,
	
	input [31:0] temp_m_data_addr,
	input [31:0] temp_m_data_wdata,
	input [3:0] temp_m_data_byteen,
	output [31:0] temp_m_data_rdata,
	
	output [31:0] TC1_Addr,
	output TC1_WE,
	output [31:0] TC1_Din,
	input [31:0] TC1_Dout,
	
	output [31:0] TC2_Addr,
	output TC2_WE,
	output [31:0] TC2_Din,
	input [31:0] TC2_Dout
    );

	always@(*) begin
		
	end

endmodule
