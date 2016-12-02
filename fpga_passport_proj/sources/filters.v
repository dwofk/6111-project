`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:17:14 11/20/2016 
// Design Name: 
// Module Name:    filters 
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
module filters(
    input clk, rst,
    input filters_en,
    input filters_user_in_en,
    input select0,
    input select1,
    input select2,
    input select3,
    input [23:0] rgb_in,
    output [23:0] rgb_out,
    output [1:0] filter,
    output [7:0] a0
  );
  
  `include "param.v"
  
  reg [1:0] filter_q = SOBEL;
  
  // determine which filter was selected
  always @(posedge clk) begin
    if (filters_en && filters_user_in_en && select0) filter_q <= SEPIA;
    if (filters_en && filters_user_in_en && select1) filter_q <= INVERT;
    if (filters_en && filters_user_in_en && select2) filter_q <= GRAYSCALE;
    if (filters_en && filters_user_in_en && select3) filter_q <= SOBEL;
  end

  // FILTER INSTANTIATIONS
  wire [23:0] rgb_invert;
  wire [23:0] rgb_sepia;
  wire [23:0] rgb_gray;
  wire [23:0] rgb_edge;
  wire [23:0] rgb_cartoon;
  
  sepia sepia_filter(
    .clk    (clk),
    .rst    (rst),
    .r_in   (rgb_in[23:16]),
    .g_in   (rgb_in[15:8]),
    .b_in   (rgb_in[7:0]),
    .r_out  (rgb_sepia[23:16]),
    .g_out  (rgb_sepia[15:8]),
    .b_out  (rgb_sepia[7:0])
  );
  
  invert invert_filter(
    .clk    (clk),
    .rst    (rst),
    .r_in   (rgb_in[23:16]),
    .g_in   (rgb_in[15:8]),
    .b_in   (rgb_in[7:0]),
    .r_out  (rgb_invert[23:16]),
    .g_out  (rgb_invert[15:8]),
    .b_out  (rgb_invert[7:0])
  );
  
  grayscale grayscale_filter(
    .clk    (clk),
    .rst    (rst),
    .r_in   (rgb_in[23:16]),
    .g_in   (rgb_in[15:8]),
    .b_in   (rgb_in[7:0]),
    .r_out  (rgb_gray[23:16]),
    .g_out  (rgb_gray[15:8]),
    .b_out  (rgb_gray[7:0])
  );
  
  cartoon cartoon_filter(
    .clk          (clk),
    .rst          (rst),
    .rgb_gray     (rgb_gray[7:0]),
    .rgb_in       (rgb_in),
    .rgb_edge     (rgb_edge),
    .rgb_cartoon  (rgb_cartoon)
  );
  
  assign filter = filter_q;
  assign rgb_out = (!filters_en) ? rgb_in :
                    (filter_q == SEPIA) ? rgb_sepia :
                    (filter_q == INVERT) ? rgb_invert : 
                    (filter_q == GRAYSCALE) ? rgb_gray : 
                    (filter_q == SOBEL) ? rgb_cartoon : rgb_in;
  
endmodule
