`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:33:36 11/09/2016
// Design Name:   hsv2rgb
// Module Name:   /afs/athena.mit.edu/user/d/i/diana96/Documents/6111-project/src//hsv2rgb_tb.v
// Project Name:  fpga_passport
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: hsv2rgb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module hsv2rgb_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] h;
	reg [7:0] s;
	reg [7:0] v;

	// Outputs
	wire [7:0] r;
	wire [7:0] g;
	wire [7:0] b;

	// Instantiate the Unit Under Test (UUT)
	hsv2rgb uut (
		.clk(clk), 
		.rst(rst), 
		.h(h), 
		.s(s), 
		.v(v), 
		.r(r), 
		.g(g), 
		.b(b)
	);

  initial begin
    clk = 0;
    forever #5 clk=~clk;
  end

  initial begin
    rst = 0;
    #5;
    
    h = 0;
    s = 0;
    v = 0;

    #10;
    
    h = 14;
    s = 153;
    v = 100;
    
    #10;
    
    h = 151;
    s = 155;
    v = 222;

    #10;
    
    h = 0;
    s = 0;
    v = 255;
 
    #10;
    
    h = 14;
    s = 153;
    v = 100;
    
    #10;
    
    h = 151;
    s = 155;
    v = 222;

    #10;
    
    h = 0;
    s = 0;
    v = 255;
 
    #10;

    h = 14;
    s = 153;
    v = 100;
    
    #10;
    
    h = 151;
    s = 155;
    v = 222;

    #10;
    
    h = 0;
    s = 0;
    v = 255;
 
    #10;
    
    h = 0;
    s = 0;
    v = 255;
 
    #10;

    h = 14;
    s = 153;
    v = 100;
    
    #10;
    
    h = 151;
    s = 155;
    v = 222;

    #10;
    
    h = 247;
    s = 78;
    v = 93;
    
    #10;
    
    h = 58;
    s = 76;
    v = 88;
 
    #10;

    h = 14;
    s = 153;
    v = 100;
    
    #10;
    
    h = 103;
    s = 75;
    v = 85;
    
    #1000 $stop;
  end
      
endmodule

