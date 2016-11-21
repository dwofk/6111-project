`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:37:40 11/20/2016
// Design Name:   sepia
// Module Name:   /afs/athena.mit.edu/user/d/i/diana96/Documents/6111-project/fpga_passport_proj/sources//sepia_tb.v
// Project Name:  fpga_passport
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sepia
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sepia_tb;

	// Inputs
	reg clk;
	reg rst;
	//reg sepia_en;
	reg [7:0] r_in;
  reg [7:0] g_in;
  reg [7:0] b_in;

	// Outputs
	wire [7:0] r_out;
  wire [7:0] g_out;
  wire [7:0] b_out;

	// Instantiate the Unit Under Test (UUT)
	sepia uut (
		.clk(clk), 
		.rst(rst), 
		//.sepia_en(sepia_en), 
		.r_in(r_in), 
    .g_in(g_in), 
    .b_in(b_in), 
    .r_out(r_out), 
    .g_out(g_out), 
    .b_out(b_out) 
	);
  
  initial begin
    clk = 1;
    forever #5 clk = ~clk;    // 10ns period
  end

	initial begin
		// Initialize Inputs
		//clk = 0;
		rst = 0;
		//sepia_en = 0;
		//rgb_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
    
    // Add stimulus here
    
    r_in = 0;
    g_in = 0;
    b_in = 0;
    
    #50;
    
    r_in = 100;
    g_in = 150;
    b_in = 200;
    
    #10;
    
    r_in = 150;
    g_in = 175;
    b_in = 100;
    
    #10;

    r_in = 100;
    g_in = 150;
    b_in = 200;
    
    #10;
    
    r_in = 150;
    g_in = 175;
    b_in = 100;
    
    #10;
    
    r_in = 100;
    g_in = 150;
    b_in = 200;
    
    #10;
    
    #1000;
        
	end
      
endmodule

