`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:36:11 09/23/2024 
// Design Name: 
// Module Name:    for 
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
module for(
	output [31:0] out
    );
	reg [31:0] sum;
	
	initial begin
		for (integer i = 0; i < 31 ; i = i + 1) begin
			sum <= sum +1;
		end
	end

	assign out = sum;
endmodule
