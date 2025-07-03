`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:57 11/11/2024 
// Design Name: 
// Module Name:    main 
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
module main(
	input [7:0] num1, num2,
	output [7:0] ans1, ans2
    );
	 
	 assign ans1 = ~num1 + 1;
	 assign ans2 = ~num2 + 1 + num2;


endmodule
