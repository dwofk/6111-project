`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:30 12/02/2016 
// Design Name: 
// Module Name:    edge_det 
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
module edge_det(
    input clk, rst,
    input [15:0] gradient,
    output reg pixel_edge,
    output reg cartoon_edge
  );

  `include "param.v"
  
  always @(posedge clk) begin
    pixel_edge <= (gradient > GRADIENT_EDGE_THRESHOLD);
    cartoon_edge <= (gradient > CARTOON_EDGE_THRESHOLD);
  end
  
endmodule
