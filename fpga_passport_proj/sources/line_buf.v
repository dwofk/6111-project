`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    23:46:56 12/01/2016 
// Design Name: 
// Module Name:    line_buf 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Parameterized line buffer module. Creates 2 line buffers that can
//              each store up to ELEM_LEN elements. Also creates a 3-element
//              buffer. Useful when applying a 3x3 kernel on an image. Output is
//              a set of signals that correspond to the 3x3 matrix consisting of 
//              8 neighboring pixels surrounding a center pixel.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module line_buf #(parameter ELEM_LEN=1) (
    input clk, rst,
    input [ELEM_LEN-1:0] pixel_in,
    output [ELEM_LEN-1:0] a0, a1, a2,
    output [ELEM_LEN-1:0] a7, pix, a3,
    output [ELEM_LEN-1:0] a6, a5, a4
  );
    
  `include "param.v"
  
  // declare line buffers
  reg [ELEM_LEN-1:0] line1 [LINE_LEN-1:0];
  reg [ELEM_LEN-1:0] line2 [LINE_LEN-1:0];
  reg [ELEM_LEN-1:0] line3 [2:0];
  
  // registered outputs
  reg [ELEM_LEN-1:0] a0_q, a1_q, a2_q, a7_q, pix_q, a3_q, a6_q, a5_q, a4_q;
  
  // output assignments
  assign {a0, a1, a2} = {a0_q, a1_q, a2_q};
  assign {a7, pix, a3} = {a7_q, pix_q, a3_q};
  assign {a6, a5, a4} = {a6_q, a5_q, a4_q} ;
  
  integer i1, i2, i3;
  
  always @(posedge clk) begin
  
    // shift line1
    for (i1=1; i1<LINE_LEN; i1=i1+1) line1[i1] <= line1[i1-1];
    line1[0] <= line2[LINE_LEN-1];
    
    // shift line2
    for (i2=1; i2<LINE_LEN; i2=i2+1) line2[i2] <= line2[i2-1];
    line2[0] <= line3[2];
    
    // shift line3
    for (i3=1; i3<3; i3=i3+1) line3[i3] <= line3[i3-1];
    line3[0] <= pixel_in;
    
    //  a0    a1    a2
    //  a7   pix    a3
    //  a6    a5    a4  
    
    {a0_q, a1_q, a2_q} <= {line1[LINE_LEN-1], line1[LINE_LEN-2], line1[LINE_LEN-3]};
    {a7_q, pix_q, a3_q} <= {line2[LINE_LEN-1], line2[LINE_LEN-2], line2[LINE_LEN-3]};
    {a6_q, a5_q, a4_q} <= {line3[2], line3[1], line3[0]};
    
  end

endmodule
