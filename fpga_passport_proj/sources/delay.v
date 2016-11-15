`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:38:56 11/09/2016 
// Design Name: 
// Module Name:    delay 
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
module delay #(parameter DELAY=1, SIZE=1) (
    input clk, rst,
    input [SIZE-1:0] din,
    output [SIZE-1:0] dout
  );
    
  reg [SIZE-1:0] shift_reg [DELAY-1:0];
  
  assign dout = shift_reg[DELAY-1];
  
  integer i;
  
  always @(posedge clk) begin
    //if (DELAY==1) shift_reg[0] <= din;
    //else shift_reg[DELAY-1:0] <= {shift_reg[DELAY-2:0], din};
    if (rst) for (i=(DELAY-1); i>=0; i=i-1) shift_reg[i] <= 0;
    
    if (DELAY==1) shift_reg[0] <= din;
    else for (i=(DELAY-1); i>0; i=i-1) shift_reg[i] <= shift_reg[i-1];
  end

endmodule
