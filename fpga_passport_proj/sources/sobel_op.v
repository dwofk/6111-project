`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    14:44:07 12/02/2016 
// Design Name: 
// Module Name:    sobel_op 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Implements and applies a 3x3 Sobel operator to an input matrix of
//              values. Outputs a gradient value. Pipelined with 4 stages.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sobel_op(
    input clk, rst,
    input [7:0] a0, a1, a2,
    input [7:0] a7, a3,
    input [7:0] a6, a5, a4,
    output [15:0] gradient
  );
  
  // Sobel 3x3 operator
  
  // convolutional masks for Sobel operator
  //   Gx = ( -1 0 1 )   Gy = (  1  2  1 )
  //        ( -2 0 2 )        (  0  0  0 )
  //        ( -1 0 1 )        ( -1 -2 -1 )
  
  //  labeling of pixels
  //    a0    a1    a2
  //    a7   pix    a3
  //    a6    a5    a4  
  
  // partial derivatives
  // gx = (a0+2a1+a2)-(a6+2a5+a4)
  // gy = (a2+2a3+a4)-(a0+2a7+a6)
  
  // gradient computation: G = sqrt(gx^2 + gy^2)
  // approximation: G = abs(gx) + abs(gy)
  
  reg [7:0] a0_q, a1_q, a2_q, a7_q, a3_q, a6_q, a5_q, a4_q;  // to latch inputs
  
  reg signed [15:0] gx_q, gy_q;   // partial derivatives
  reg [15:0] abs_gx_q, abs_gy_q;  // absolute values
  reg [15:0] gradient_q;
  
  assign gradient = gradient_q;
  
  always @(posedge clk) begin  
    // clock 1: latch inputs
    {a0_q, a1_q, a2_q} <= {a0, a1, a2};
    {a7_q, a3_q} <= {a7, a3};
    {a6_q, a5_q, a4_q} <= {a6, a5, a4};
    
    // clock 2: compute partial derivatives
    gx_q <= (a0_q+(a1_q<<1)+a2_q)-(a6_q+(a5_q<<1)+a4_q);
    gy_q <= (a2_q+(a3_q<<1)+a4_q)-(a0_q+(a7_q<<1)+a6_q);
    
    // clock 3: compute absolute values
    abs_gx_q <= gx_q[15] ? (~gx_q)+1'b1 : gx_q;
    abs_gy_q <= gy_q[15] ? (~gy_q)+1'b1 : gy_q;
    
    // clock 4: compute gradient
    gradient_q <= abs_gx_q + abs_gy_q;
  end

endmodule
