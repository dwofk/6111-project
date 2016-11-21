`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:14:16 11/20/2016 
// Design Name: 
// Module Name:    invert 
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
module invert(
    input clk, rst,
    //input invert_en,
    input [7:0] r_in, g_in, b_in,
    output [7:0] r_out, g_out, b_out
  );
  
  // latency = 1 clk cycle
  
  reg [7:0] r_out_q, g_out_q, b_out_q;
  
  always @(posedge clk) begin
    r_out_q <= 8'd255 - r_in;
    g_out_q <= 8'd255 - g_in;
    b_out_q <= 8'd255 - b_in;
  end
  
  assign {r_out, g_out, b_out} = {r_out_q, g_out_q, b_out_q};

endmodule
