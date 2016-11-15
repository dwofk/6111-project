`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:31:18 11/14/2016
// Design Name:   delay
// Module Name:   /afs/athena.mit.edu/user/d/i/diana96/Documents/6111-project/fpga_passport_proj/sources//delay_tb.v
// Project Name:  fpga_passport
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: delay
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module delay_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [0:0] din;

	// Outputs
	wire [0:0] dout;

	// Instantiate the Unit Under Test (UUT)
	delay #(.DELAY(12)) uut (
		.clk(clk), 
		.rst(rst), 
		.din(din), 
		.dout(dout)
	);
  
  initial begin
    clk = 0;
    forever #5 clk=~clk;
  end

	initial begin
		// Initialize Inputs
		rst = 1;

		// Wait 100 ns for global reset to finish
		#105 rst = 0;
    
    #50;
    
		// Add stimulus here
    din = 1;
    #10 din = 0;
    
    #1000 $stop;
	end
      
endmodule

