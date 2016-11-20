`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:29:17 11/17/2016 
// Design Name: 
// Module Name:    pixel_sel 
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
module pixel_sel(
    input clk, 
    input rst,
    //input [1:0] editor_fsm_state,
    input sw_ntsc,
    input store_frame,
    input enhance_en,
    input up, down,
    input left, right,
    input center,
    input [29:0] vr_pixel,
    input [10:0] hcount,
    input [9:0] vcount,
    input blank,
    input hsync,
    input vsync,
    input [7:0] bram_dout,
    output [23:0] pixel_out,
    output blank_out,
    output hsync_out,
    output vsync_out
  );
  
  // Delay Parameters
  parameter YCRCB2RGB_DLY = 4;
  parameter RGB2HSV_DLY = 23;
  parameter THRESHOLD_DLY = 1;
  parameter HSV2RGB_DLY = 10;
  parameter ENHANCE_DLY = 1;
  
  parameter SYNC_DLY = YCRCB2RGB_DLY + RGB2HSV_DLY + THRESHOLD_DLY + HSV2RGB_DLY + ENHANCE_DLY;
  //parameter COLOR_PIXEL_DLY = RGB2HSV_DLY + THRESHOLD_DLY;

  // YCrCb to RGB Conversion
  wire [23:0] vr_pixel_color;
  
  ycrcb2rgb ycrcb2rgb_conv(
    .Y    (vr_pixel[29:20]),
    .Cr   (vr_pixel[19:10]), 
    .Cb   (vr_pixel[9:0]),
    .R    (vr_pixel_color[23:16]), 
    .G    (vr_pixel_color[15:8]), 
    .B    (vr_pixel_color[7:0]),
    .clk  (clk), 
    .rst  (1'b0)
   );
  
  // RGB to HSV Conversion
  wire [23:0] pixel_hsv_out;
  
  rgb2hsv rgb2hsv_conv(
    .clock(clk), 
    .reset(reset),
    .r(vr_pixel_color[23:16]), 
    .g(vr_pixel_color[15:8]), 
    .b(vr_pixel_color[7:0]),
    .h(pixel_hsv_out[23:16]), 
    .s(pixel_hsv_out[15:8]), 
    .v(pixel_hsv_out[7:0])
  );
  
  // HSV to RGB Conversion
  wire [23:0] pixel_hsv_in;
  wire [23:0] pixel_rgb_out;
  
  hsv2rgb hsv2rgb_conv(
    .clk(clk), 
    .rst(reset),
    .h(pixel_hsv_in[23:16]), 
    .s(pixel_hsv_in[15:8]), 
    .v(pixel_hsv_in[7:0]),
    .r(pixel_rgb_out[23:16]), 
    .g(pixel_rgb_out[15:8]), 
    .b(pixel_rgb_out[7:0])
  );
  
  // Thresholding & Compositing
  reg [23:0] pixel_hsv_in_q;
  //assign pixel_hsv_in = pixel_hsv_in_q;
  
  //always @(posedge clk) pixel_hsv_in_q <= pixel_hsv_out;
  
  // Image Enhancement
  enhance enhance1(
    .clk(clk),
    .rst(reset),
	 .vsync(vsync),
    .enhance_en(enhance_en),
    .inc_saturation(up),
    .dec_saturation(down),
    .inc_brightness(right),
    .dec_brightness(left),
    .reset_enhance(center),
    .hsv_in(pixel_hsv_out),
    .hsv_out(pixel_hsv_in)
  );
  
  // Delay Sync Signals
  reg [0:0] hsync_shift_reg[SYNC_DLY-1:0];
  reg [0:0] vsync_shift_reg[SYNC_DLY-1:0];
  reg [0:0] blank_shift_reg[SYNC_DLY-1:0];
  /*reg [23:0] color_pixel_shift_reg[COLOR_PIXEL_DLY-1:0];*/

  integer i;
  
  always @(posedge clk) begin
    hsync_shift_reg[0] <= hsync;
    vsync_shift_reg[0] <= vsync;
    blank_shift_reg[0] <= blank;
    
    for (i=1; i<SYNC_DLY; i=i+1) begin
      hsync_shift_reg[i] <= hsync_shift_reg[i-1];
      vsync_shift_reg[i] <= vsync_shift_reg[i-1];
      blank_shift_reg[i] <= blank_shift_reg[i-1];
    end
    /*for (i=1; i<COLOR_PIXEL_DLY; i=i+1)
      color_pixel_shift_reg[i] <= color_pixel_shift_reg[i-1];*/
  end
  
  // Select Output Pixel
  reg [23:0] pixel_out_q;
  wire in_display = hcount < 640 && vcount < 400;
  
  always @(posedge clk) begin
    //pixel_out_q <= sw_ntsc ? 0 : pixel_hsv_out;
    pixel_out_q <= sw_ntsc ? 0 : store_frame ? (in_display ? {bram_dout[7:5],5'd0,bram_dout[4:2],5'd0,bram_dout[1:0],6'd0} : 24'hFFFFFF) : pixel_rgb_out;
    //pixel_out_q <= sw_ntsc ? 0 : vr_pixel_color;
  end  
  
  // Output Signal Assignments
  assign pixel_out = pixel_out_q;
  assign blank_out = blank_shift_reg[SYNC_DLY-1];
  assign hsync_out = hsync_shift_reg[SYNC_DLY-1];
  assign vsync_out = vsync_shift_reg[SYNC_DLY-1];

endmodule
