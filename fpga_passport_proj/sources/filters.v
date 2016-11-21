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
    input select0,
    input select1,
    input select2,
    input select3,
    input [23:0] rgb_in,
    output [23:0] rgb_out,
    output [1:0] filter
  );
  
  localparam SEPIA = 2'b00;
  localparam INVERT = 2'b01;

  reg [1:0] filter_q = 0;
  
  // determine which filter was selected
  always @(posedge clk) begin
    if (filters_en && select0) filter_q <= SEPIA;
    if (filters_en && select1) filter_q <= INVERT;
  end

  // FILTER INSTANTIATIONS
  wire [23:0] rgb_invert;
  wire [23:0] rgb_sepia;
  
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
  
  assign filter = filter_q;
  assign rgb_out = (!filters_en) ? rgb_in :
                    (filter_q == INVERT) ? rgb_invert : rgb_sepia;
  
endmodule
