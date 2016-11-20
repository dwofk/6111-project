`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:53:18 11/07/2016
// Design Name:   rgb2hsv
// Module Name:   /afs/athena.mit.edu/user/d/i/diana96/Documents/6111-project/src//rgb2hsv_tb.v
// Project Name:  fpga_passport
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rgb2hsv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module rgb2hsv_tb;

	// Inputs
	reg clock;
	reg reset;
	reg [7:0] r;
	reg [7:0] g;
	reg [7:0] b;

	// Outputs
	wire [7:0] h;
	wire [7:0] s;
	wire [7:0] v;

	// Instantiate the Unit Under Test (UUT)
	rgb2hsv uut (
		.clock(clock), 
		.reset(reset), 
		.r(r), 
		.g(g), 
		.b(b), 
		.h(h), 
		.s(s), 
		.v(v)
	);
  
  initial begin
    clock = 0;
    forever #5 clock=~clock;
  end

	initial begin
		// Initialize Inputs
		reset = 0;
    #5;
    
		r = 0;
		g = 0;
		b = 0;

    #200;
    
    r = 87;
		g = 149;
		b = 222;
    
    #10;
    
		r = 100;
		g = 60;
		b = 40;

    #10;
    
    r = 87;
		g = 149;
		b = 222;
    
    #10;
    
		r = 100;
		g = 60;
		b = 40;

    #10;
    
    r = 87;
		g = 149;
		b = 222;
    
    #10;
    
		r = 100;
		g = 60;
		b = 40;

    #10;
    
    r = 87;
		g = 149;
		b = 222;
    
    #10;

		r = 100;
		g = 60;
		b = 40;

    #10;
    
    r = 87;
		g = 149;
		b = 222;
    
    #10;
    
		r = 100;
		g = 60;
		b = 40;

    #10;
    
    r = 87;
		g = 149;
		b = 222;
    
    #10;
    
		r = 100;
		g = 60;
		b = 40;

    #10;
    
    r = 87;
		g = 149;
		b = 222;
    
    #10;
    
		r = 100;
		g = 60;
		b = 40;

    #10;
    
    r = 0;
		g = 0;
		b = 255;
 
		// Add stimulus here
    #1000 $stop;
	end
      
endmodule

