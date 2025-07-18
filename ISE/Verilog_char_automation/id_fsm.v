`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:38 08/29/2024 
// Design Name: 
// Module Name:    id_fsm 
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
`define s0 2'b00
`define s1 2'b01
`define s2 2'b10

module id_fsm(
	input [7:0] char,
	input clk,
	output out
    );

reg [1:0] status;	
reg [1:0] next_status;

initial begin
	status<=`s0;
	next_status<=`s0;
end

always@(posedge clk) begin
	status<=next_status;
end

always@(*) begin
	case(status)
		`s0: begin
			if(char>="a"&&char<="z"||char>="A"&&char<="Z") begin
				next_status<=	`s1;
			end
			else begin
				next_status<=`s0;
			end
		end
		`s1: begin
			if(char>="0"&&char<="9") begin
				next_status<=`s2;
			end
			else if(char>="a"&&char<="z"||char>="A"&&char<="Z") begin
				next_status<=`s1;
			end
			else next_status<=	`s0;
		end
		`s2: begin
			if(char>="0"&&char<="9") begin
				next_status<=`s2;
			end
			else if(char>="a"&&char<="z"||char>="A"&&char<="Z") begin
				next_status<=	`s1;
			end
			else next_status<=`s0;
		end
		default: begin
		
		end
	endcase
end

	assign out= status==`s2 ? 1 : 0;
	
endmodule
