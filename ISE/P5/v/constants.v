`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:47:11 11/06/2024 
// Design Name: 
// Module Name:    constants 
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

//`default_nettype none
