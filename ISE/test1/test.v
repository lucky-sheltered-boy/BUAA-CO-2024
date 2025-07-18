`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:37:36 09/28/2024 
// Design Name: 
// Module Name:    test 
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
module test(
	input [3:0] in,
	output a,
	output b,
	output c,
	output d,
	output e,
	output f,
	output g
    );
	
	wire x3,x2,x1,x0;
	
	assign {x3,x2,x1,x0} = in;
	
	//a
	wire sa1,sa2,sa3,sa4,sa5,sa6,sa7;
	
	and
		a1(sa1,x1,~x0),
		a2(sa2,~x3,x1),
		a3(sa3,x2,x1),
		a4(sa4,~x2,~x1,~x0),
		a5(sa5,x3,~x1,~x0),
		a6(sa6,x3,~x2,~x1),
		a7(sa7,~x3,x2,x0);
		
	or sa(a,sa1,sa2,sa3,sa4,sa5,sa6,sa7);

	//b
	wire sb1,sb2,sb3,sb4,sb5;
	
	and 
		b1(sb1,~x1,~x0),
		b2(sb2,x3,~x2),
		b3(sb3,x3,x1),
		b4(sb4,~x3,x2,~x1),
		b5(sb5,x2,x1,~x0);
		
	or sb(b,sb1,sb2,sb3,sb4,sb5);
	
	//c
	wire sc1,sc2,sc3,sc4;
	
	and
		c1(sc1,x1,~x0),
		c2(sc2,x3,x1),
		c3(sc3,x3,x2),
		c4(sc4,~x2,~x1,~x0);
		
	or sc(c,sc1,sc2,sc3,sc4);
	
	//d
	wire sd1,sd2,sd3,sd4,sd5;
	
	and
		d1(sd1,x3,~x1),
		d2(sd2,x2,x1,~x0),
		d3(sd3,~x3,~x2,~x0),
		d4(sd4,~x2,x1,x0),
		d5(sd5,x2,~x1,x0);
		
	or sd(d,sd1,sd2,sd3,sd4,sd5);
	
	//e
	wire se1,se2,se3,se4,se5;
	
	and
		e1(se1,x3,~x2),
		e2(se2,~x1,x0),
		e3(se3,~x3,x2),
		e4(se4,~x3,~x1),
		e5(se5,~x3,x0);
		
	or se(e,se1,se2,se3,se4,se5);
	
	//f
	wire sf1,sf2,sf3,sf4,sf5;
	
	and
		f1(sf1,~x3,~x2),
		f2(sf2,~x3,~x1,~x0),
		f3(sf3,~x3,x1,x0),
		f4(sf4,x3,~x2,~x0),
		f5(sf5,x3,~x1,x0);
		
	or sf(f,sf1,sf2,sf3,sf4,sf5);
	
	//g
	wire sg1,sg2,sg3,sg4,sg5;
	
	and
		g1(sg1,x3,~x2),
		g2(sg2,x1,~x0),
		g3(sg3,x3,x0),
		g4(sg4,~x3,x2,~x1),
		g5(sg5,~x3,~x2,x1);
		
	or sg(g,sg1,sg2,sg3,sg4,sg5);
endmodule
