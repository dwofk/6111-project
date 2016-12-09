`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    14:54:30 12/02/2016 
// Design Name: 
// Module Name:    edge_det 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Compares input gradient to a pre-defined threshold. If the
//              gradient exceeds the threshold, pixel is marked as an edge;
//              correct operation requires the output of this module to be
//              in sync with the pixel it applies to (the center pixel whose
//              neighboring pixels were processed in the sobel_op module).
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module edge_det(
    input clk, rst,
    input [15:0] gradient,
    output reg pixel_edge,
    output reg cartoon_edge
  );

  `include "param.v"
  
  always @(posedge clk) begin
    pixel_edge <= (gradient > GRADIENT_EDGE_THRESHOLD);   // for sketch effect
    cartoon_edge <= (gradient > CARTOON_EDGE_THRESHOLD);  // for cartoon effect
  end
  
endmodule
