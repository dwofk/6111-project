`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:38:38 12/02/2016 
// Design Name: 
// Module Name:    cartoon_filter 
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
module cartoon(
    input clk, rst,
    input [7:0] rgb_gray,
    input [23:0] rgb_in,
    output [23:0] rgb_edge,
    output [23:0] rgb_cartoon
  );
  
  `include "param.v"
  
  wire [7:0] a0, a1, a2;
  wire [7:0] a7, pix, a3;
  wire [7:0] a6, a5, a4;
  
  line_buf line_buf1(
    .clk      (clk),
    .rst      (rst),
    .rgb_gray (rgb_gray),
    .a0       (a0),
    .a1       (a1),
    .a2       (a2),
    .a7       (a7),
    .pix      (pix),
    .a3       (a3),
    .a6       (a6),
    .a5       (a5),
    .a4       (a4)    
  );
  
  wire [15:0] gradient;
  
  sobel_op sobel_op1(
    .clk      (clk),
    .rst      (rst),
    .a0       (a0),
    .a1       (a1),
    .a2       (a2),
    .a7       (a7),
    .a3       (a3),
    .a6       (a6),
    .a5       (a5),
    .a4       (a4),
    .gradient (gradient)
  );
  
  wire pixel_edge;
  
  edge_det edge_det1(
    .clk        (clk),
    .rst        (rst),
    .gradient   (gradient),
    .pixel_edge (pixel_edge)
  );
    
  // Delay RGB Color Signals
  reg [7:0] rgb_color_reg[SOBEL_DLY-1:0];

  integer i;
  
  always @(posedge clk) begin
    rgb_color_reg[0] <= {rgb_in[23:21], rgb_in[15:13], rgb_in[7:6]};
    for (i=1; i<(SOBEL_DLY); i=i+1)
      rgb_color_reg[i] <= rgb_color_reg[i-1];
  end
  
  wire [7:0] rgb_color = rgb_color_reg[SOBEL_DLY-1];
  
  assign rgb_edge = pixel_edge ? 24'h000000 : 24'hFFFFFF;
  assign rgb_cartoon = pixel_edge ? 24'h000000 : {rgb_color[7:5],5'd0,rgb_color[4:2],5'd0,rgb_color[1:0],6'd0};

endmodule
