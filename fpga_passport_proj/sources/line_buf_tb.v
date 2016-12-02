`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:05:02 12/02/2016
// Design Name:   line_buf
// Module Name:   /afs/athena.mit.edu/user/d/i/diana96/Documents/6111-project/fpga_passport_proj/sources//line_buf_tb.v
// Project Name:  fpga_passport
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: line_buf
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module line_buf_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] rgb_gray;

	// Outputs
	wire [7:0] a0;
	wire [7:0] a1;
	wire [7:0] a2;
	wire [7:0] a7;
	wire [7:0] a3;
	wire [7:0] a6;
	wire [7:0] a5;
	wire [7:0] a4;

	// Instantiate the Unit Under Test (UUT)
	line_buf uut (
		.clk(clk), 
		.rst(rst), 
		.rgb_gray(rgb_gray), 
		.a0(a0), 
		.a1(a1), 
		.a2(a2), 
		.a7(a7), 
		.a3(a3), 
		.a6(a6), 
		.a5(a5), 
		.a4(a4)
	);
  
  initial begin
    clk = 0;
    forever #5 clk=~clk;  // 10 ns period
  end

	initial begin
		rst = 0;
    
    #100
    
		rgb_gray = 8'd125;

		#1000000;
     
	end
      
endmodule

