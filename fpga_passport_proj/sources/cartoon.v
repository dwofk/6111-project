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
    input [10:0] hcount,
    input [9:0] vcount,
    input [7:0] rgb_gray,
    input [23:0] rgb_in,
    output [23:0] rgb_edge,
    output [23:0] rgb_cartoon
  );
  
  `include "param.v"
  
  ////////////////////////////////////////////////////////////////////////////////
  // SOBEL EDGE DETECTION
  ////////////////////////////////////////////////////////////////////////////////
  
  wire [7:0] a0, a1, a2, a7, pix, a3, a6, a5, a4;
  line_buf #(8) sobel_line_buf(clk, rst, rgb_gray, a0, a1, a2, a7, pix, a3, a6, a5, a4);
  
  wire [15:0] gradient;
  sobel_op sobel_op1(clk, rst, a0, a1, a2, a7, a3, a6, a5, a4, gradient);
  
  wire pixel_edge, cartoon_edge;
  edge_det edge_det1(clk, rst, gradient, pixel_edge, cartoon_edge);
  
  ////////////////////////////////////////////////////////////////////////////////
  // GAUSSIAN BLUR
  ////////////////////////////////////////////////////////////////////////////////
  
  wire [2:0] a0r, a1r, a2r, a7r, pix_r, a3r, a6r, a5r, a4r;
  line_buf #(3) gauss_r_buf(clk, rst, rgb_in[23:21], a0r, a1r, a2r, a7r, pix_r, a3r, a6r, a5r, a4r);
  
  wire [2:0] a0g, a1g, a2g, a7g, pix_g, a3g, a6g, a5g, a4g;
  line_buf #(3) gauss_g_buf(clk, rst, rgb_in[15:13], a0g, a1g, a2g, a7g, pix_g, a3g, a6g, a5g, a4g);

  wire [1:0] a0b, a1b, a2b, a7b, pix_b, a3b, a6b, a5b, a4b;
  line_buf #(2) gauss_b_buf(clk, rst, rgb_in[7:6], a0b, a1b, a2b, a7b, pix_b, a3b, a6b, a5b, a4b);

  wire [7:0] rgb_gauss;
  gaussian gauss_blur(clk, rst, a0r, a1r, a2r, a7r, pix_r, a3r, a6r, a5r, a4r,
                       a0g, a1g, a2g, a7g, pix_g, a3g, a6g, a5g, a4g,
                       a0b, a1b, a2b, a7b, pix_b, a3b, a6b, a5b, a4b, rgb_gauss);
  
  ////////////////////////////////////////////////////////////////////////////////
  // RGB OUTPUT
  ////////////////////////////////////////////////////////////////////////////////
  
  localparam CARTOON_RGB_DLY = SOBEL_DLY-LINE_BUF_DLY-GAUSSIAN_DLY;
  //localparam CARTOON_RGB_DLY = SOBEL_DLY;
  
  reg [7:0] rgb_color_reg[CARTOON_RGB_DLY-1:0];

  integer i;
  
  // delay blur RGB to sync with edge pixel output
  always @(posedge clk) begin
    //rgb_color_reg[0] <= {rgb_in[23:21], rgb_in[15:13], rgb_in[7:6]};
    rgb_color_reg[0] <= rgb_gauss;
    for (i=1; i<(CARTOON_RGB_DLY); i=i+1)
      rgb_color_reg[i] <= rgb_color_reg[i-1];
  end
  
  wire [7:0] rgb_color = rgb_color_reg[CARTOON_RGB_DLY-1];
  
//  wire h_border_pixel = (hcount == HCOUNT_MAX) || (hcount == H_MAX_NTSC-1);
//  wire v_border_pixel = (vcount == VCOUNT_MAX) || (vcount == V_MAX_NTSC-1);
//  wire border_pixel = h_border_pixel && v_border_pixel;
  
  assign rgb_edge = pixel_edge ? 24'h000000 : 24'hFFFFFF;
  assign rgb_cartoon = cartoon_edge ? 24'h000000 : {rgb_color[7:5],5'd0,rgb_color[4:2],5'd0,rgb_color[1:0],6'd0};

endmodule
