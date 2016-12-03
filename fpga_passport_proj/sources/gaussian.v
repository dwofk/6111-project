`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:57:54 12/02/2016 
// Design Name: 
// Module Name:    gaussian 
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
module gaussian(
    input clk, rst,
    // red channel
    input [2:0] a0r, a1r, a2r,
    input [2:0] a7r, pix_r, a3r,
    input [2:0] a6r, a5r, a4r,
    // green channel
    input [2:0] a0g, a1g, a2g,
    input [2:0] a7g, pix_g, a3g,
    input [2:0] a6g, a5g, a4g,
    // blue channel
    input [1:0] a0b, a1b, a2b,
    input [1:0] a7b, pix_b, a3b,
    input [1:0] a6b, a5b, a4b,
    // rgb output
    output [7:0] rgb_out
  );
  
  // Gaussian 3x3 kernel
  
  //        ( 1 2 1 )
  //  1/16  ( 2 4 2 )
  //        ( 1 2 1 )
  
  // blur each channel separately
  
  reg [2:0] a0r_q, a1r_q, a2r_q, a7r_q, pix_r_q, a3r_q, a6r_q, a5r_q, a4r_q;
  reg [2:0] a0g_q, a1g_q, a2g_q, a7g_q, pix_g_q, a3g_q, a6g_q, a5g_q, a4g_q;
  reg [1:0] a0b_q, a1b_q, a2b_q, a7b_q, pix_b_q, a3b_q, a6b_q, a5b_q, a4b_q;

  reg [6:0] r_sum_q;
  reg [6:0] g_sum_q;
  reg [5:0] b_sum_q;
  
  reg [2:0] r_out_q;
  reg [2:0] g_out_q;
  reg [1:0] b_out_q;  // registered outputs
  
  assign rgb_out = {r_out_q, g_out_q, b_out_q}; 
  
  always @(posedge clk) begin
  
    // clock 1: latch inputs
    
    // red channel
    {a0r_q, a1r_q, a2r_q} <= {a0r, a1r, a2r};
    {a7r_q, pix_r_q, a3r_q} <= {a7r, pix_r, a3r};
    {a6r_q, a5r_q, a4r_q} <= {a6r, a5r, a4r};
    // green channel
    {a0g_q, a1g_q, a2g_q} <= {a0g, a1g, a2g};
    {a7g_q, pix_g_q, a3g_q} <= {a7g, pix_g, a3g};
    {a6g_q, a5g_q, a4g_q} <= {a6g, a5g, a4g};
    // blue channel
    {a0b_q, a1b_q, a2b_q} <= {a0b, a1b, a2b};
    {a7b_q, pix_b_q, a3b_q} <= {a7b, pix_b, a3b};
    {a6b_q, a5b_q, a4b_q} <= {a6b, a5b, a4b};
    
    // clock 2: multiply by kernel values
    
    r_sum_q <= a0r_q+(a1r_q<<1)+a2r_q+(a7r_q<<1)+(pix_r_q<<2)+(a3r_q<<1)+a6r_q+(a5r_q<<1)+a4r_q;
    g_sum_q <= a0g_q+(a1g_q<<1)+a2g_q+(a7g_q<<1)+(pix_g_q<<2)+(a3g_q<<1)+a6g_q+(a5g_q<<1)+a4g_q;
    b_sum_q <= a0b_q+(a1b_q<<1)+a2b_q+(a7b_q<<1)+(pix_b_q<<2)+(a3b_q<<1)+a6b_q+(a5b_q<<1)+a4b_q;

    // clock 3: divide by 16
    
    r_out_q <= r_sum_q[6:4];
    g_out_q <= g_sum_q[6:4];
    b_out_q <= b_sum_q[5:4];
    
  end


endmodule
