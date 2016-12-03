`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:46:56 12/01/2016 
// Design Name: 
// Module Name:    line_buf 
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
module line_buf #(parameter ELEM_LEN=1) (
    input clk, rst,
    input [ELEM_LEN-1:0] pixel_in,
    output [ELEM_LEN-1:0] a0, a1, a2,
    output [ELEM_LEN-1:0] a7, pix, a3,
    output [ELEM_LEN-1:0] a6, a5, a4
  );
    
  `include "param.v"
  
  reg [ELEM_LEN-1:0] line1 [LINE_LEN-1:0];
  reg [ELEM_LEN-1:0] line2 [LINE_LEN-1:0];
  reg [ELEM_LEN-1:0] line3 [2:0];
  
  reg [ELEM_LEN-1:0] a0_q, a1_q, a2_q, a7_q, pix_q, a3_q, a6_q, a5_q, a4_q;
  
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
    
    {a0_q, a1_q, a2_q} <= {line1[LINE_LEN-1], line1[LINE_LEN-2], line1[LINE_LEN-3]};
    {a7_q, pix_q, a3_q} <= {line2[LINE_LEN-1], line2[LINE_LEN-2], line2[LINE_LEN-3]};
    {a6_q, a5_q, a4_q} <= {line3[2], line3[1], line3[0]};
  end

endmodule

module line_buf3(
    input clk, rst,
    input [2:0] pixel_in,
    output [2:0] a0, a1, a2,
    output [2:0] a7, pix, a3,
    output [2:0] a6, a5, a4
  );
    
  `include "param.v"
  
  reg [2:0] line1 [LINE_LEN-1:0];
  reg [2:0] line2 [LINE_LEN-1:0];
  reg [2:0] line3 [2:0];
  
//  integer n1, n2, n3;
//  
//  initial begin
//    for (n1=0; n1<LINE_LEN; n1=n1+1) line1[n1] <= 0;
//    for (n2=0; n2<LINE_LEN; n2=n2+1) line1[n2] <= 0;
//    for (n3=0; n3<3; n3=n3+1) line3[n3] <= 0;
//  end
  
  reg [2:0] a0_q, a1_q, a2_q, a7_q, pix_q, a3_q, a6_q, a5_q, a4_q;
  
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
    
    {a0_q, a1_q, a2_q} <= {line1[LINE_LEN-1], line1[LINE_LEN-2], line1[LINE_LEN-3]};
    {a7_q, pix_q, a3_q} <= {line2[LINE_LEN-1], line2[LINE_LEN-2], line2[LINE_LEN-3]};
    {a6_q, a5_q, a4_q} <= {line3[2], line3[1], line3[0]};
  end

endmodule

module line_buf2(
    input clk, rst,
    input [1:0] pixel_in,
    output [1:0] a0, a1, a2,
    output [1:0] a7, pix, a3,
    output [1:0] a6, a5, a4
  );
    
  `include "param.v"
  
  reg [1:0] line1 [LINE_LEN-1:0];
  reg [1:0] line2 [LINE_LEN-1:0];
  reg [1:0] line3 [2:0];
  
//  integer n1, n2, n3;
//  
//  initial begin
//    for (n1=0; n1<LINE_LEN; n1=n1+1) line1[n1] <= 0;
//    for (n2=0; n2<LINE_LEN; n2=n2+1) line1[n2] <= 0;
//    for (n3=0; n3<3; n3=n3+1) line3[n3] <= 0;
//  end
  
  reg [1:0] a0_q, a1_q, a2_q, a7_q, pix_q, a3_q, a6_q, a5_q, a4_q;
  
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
    
    {a0_q, a1_q, a2_q} <= {line1[LINE_LEN-1], line1[LINE_LEN-2], line1[LINE_LEN-3]};
    {a7_q, pix_q, a3_q} <= {line2[LINE_LEN-1], line2[LINE_LEN-2], line2[LINE_LEN-3]};
    {a6_q, a5_q, a4_q} <= {line3[2], line3[1], line3[0]};
  end

endmodule
