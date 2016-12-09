`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    20:17:14 11/20/2016 
// Design Name: 
// Module Name:    filters 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Instantiates 4 filter effects modules. Processes user
//              button input to determine which filter has been selected. 
//              Chooses output pixel based on the selected filter. 
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
    input filters_en,           // enable filters
    input filters_user_in_en,   // assert to allow users to change filter
    input select0,
    input select1,
    input select2,
    input select3,
    input [10:0] hcount,
    input [9:0] vcount,
    input [23:0] rgb_in,
    output [23:0] rgb_out,
    output [2:0] filter
  );
  
  `include "param.v"
  
  reg [2:0] filter_q = GRAYSCALE;   // default to grayscale
  
  wire sel_all = select0 && select1 && select2 && select3;  // all buttons pressed
  
  // determine which filter was selected
  always @(posedge clk) begin
    if (filters_en && filters_user_in_en && select0) filter_q <= SEPIA;
    if (filters_en && filters_user_in_en && select1) filter_q <= INVERT;
    if (filters_en && filters_user_in_en && select2) filter_q <= EDGE;
    if (filters_en && filters_user_in_en && select3) filter_q <= CARTOON;
    if (filters_en && filters_user_in_en && sel_all) filter_q <= GRAYSCALE;
  end

  // Filter Instantiations
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
    .hcount       (hcount),
    .vcount       (vcount),
    .rgb_gray     (rgb_gray[7:0]),
    .rgb_in       (rgb_in),
    .rgb_edge     (rgb_edge),
    .rgb_cartoon  (rgb_cartoon)
  );
  
  // Output Assignments
  assign filter = filter_q;
  assign rgb_out = (!filters_en) ? rgb_in :
                    (filter_q == SEPIA) ? rgb_sepia :
                    (filter_q == INVERT) ? rgb_invert : 
                    (filter_q == EDGE) ? rgb_edge : 
                    (filter_q == CARTOON) ? rgb_cartoon : 
                    (filter_q == GRAYSCALE) ? rgb_gray : rgb_in;
  
endmodule
