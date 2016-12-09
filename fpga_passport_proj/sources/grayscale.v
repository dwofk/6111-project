`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    21:21:21 12/01/2016 
// Design Name: 
// Module Name:    grayscale 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Implements conversion from RGB color to grayscale.
//              Pipelined with 3 stages.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module grayscale(
    input clk, rst,
    input [7:0] r_in, g_in, b_in,
    output [7:0] r_out, g_out, b_out
  );
  
  // Conversion from RGB color to grayscale
  // RGB(gray) = 0.2989R + 0.5870G + 0.1140B
  
  localparam R = 76;    // 0.2989
  localparam G = 150;   // 0.5870
  localparam B = 29;    // 0.1140
  
  reg [7:0] r0_q, g0_q, b0_q;     // latched inputs
  reg [15:0] r1_q, g1_q, b1_q;    // multiplied by R/G/B multipliers
  reg [7:0] r2_q, g2_q, b2_q;     // registered outputs
  
  // output assignment
  assign {r_out, g_out, b_out} = {r2_q, g2_q, b2_q};
  
  always @(posedge clk) begin
  
    // clock 1: latch inputs
    {r0_q, g0_q, b0_q} <= {r_in, g_in, b_in};
    
    // clock 2: multiply by R/G/B multipliers
    {r1_q, g1_q, b1_q} <= {R*r0_q, G*g0_q, B*b0_q};
    
    // clock 3: divide by 256 and add
    r2_q <= r1_q[15:8] + g1_q[15:8] + b1_q[15:8];
    g2_q <= r1_q[15:8] + g1_q[15:8] + b1_q[15:8];
    b2_q <= r1_q[15:8] + g1_q[15:8] + b1_q[15:8];
    
  end

endmodule
