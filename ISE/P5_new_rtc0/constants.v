`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:54:08 07/02/2025 
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
`define BNE 4'b0100
`define REQ 4'b0101
`define ERET 4'b0110

// ALUop type
`define ADD 8'b00010001
`define SUB 8'b00010010 
`define AND 8'b00010011
`define OR 8'b00010100
`define XOR 8'b00010101
`define EQUAL 8'b00010110
`define BIGGERUNSIGNED 8'b00010111
`define SMALLERUNSIGNED 8'b00011000
`define BIGGERSIGNED 8'b00011001
`define SMALLERSIGNED 8'b00011010

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
`define and 8'b10001010
`define or 8'b10001011
`define addi 8'b10001100
`define andi 8'b10001101
`define slt 8'b10001110
`define sltu 8'b10001111
`define bne 8'b11000000
`define mult 8'b11000001
`define multu 8'b11000010
`define div 8'b11000011
`define divu 8'b11000100
`define mfhi 8'b11000101
`define mflo 8'b11000110
`define mthi 8'b11000111
`define mtlo 8'b11001000
`define sb 8'b11001001
`define sh 8'b11001010
`define lb 8'b11001011
`define lh 8'b11001100
`define syscall 8'b11001101
`define mfc0 8'b11001110
`define mtc0 8'b11001111
`define eret 8'b11010000
`define rtc0 8'b11010001

//exception type
`define Int 5'd0
`define AdEL 5'd4
`define AdES 5'd5
`define Syscall 5'd8
`define RI 5'd10
`define Ov 5'd12

`define Dm_Addr_start 32'h00000000
`define Dm_Addr_end 32'h00002fff

//`default_nettype none