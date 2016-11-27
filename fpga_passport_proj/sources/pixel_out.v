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
    input clk, reset,
    // states
    input [2:0] fsm_state,
    input [1:0] bram_state,
    // user switch inputs
    input sw_ntsc,
    input store_bram,
    input enhance_en,
    input filters_en,
    input text_en,
    input graphics_en,
    input move_text_en,
    input move_graphics_en,
    //input [1:0] filter,
    // user button inputs
    input up, down, left, right,
    input select0, select1, select2, select3,
    // pixel value inputs
    input [29:0] vr_pixel,
    input [7:0] bram_dout,
    // VGA timing signals
    input [10:0] hcount, //hoffset, hmax,
    input [9:0] vcount, //voffset, vmax,
    input blank,
    input hsync,
    input vsync,
    input in_display,
    // VGA outputs
    output [23:0] pixel_out,
    output blank_out,
    output hsync_out,
    output vsync_out,
    output [10:0] text_x_pos,
    output [9:0] text_y_pos,
    // Hex Display outputs
    output [7:0] thr_range, h_thr, s_thr, v_thr
  );
  
  // FSM states
  localparam FSM_IDLE = 3'b000;
  localparam SEL_BKGD = 3'b001;
  localparam COLOR_EDITS = 3'b010;
  localparam ADD_EDITS = 3'b011;
  localparam SAVE_TO_BRAM = 3'b100;
  localparam SEND_TO_PC = 3'b101;
  
  // BRAM states
  localparam BRAM_IDLE = 2'b00;
  localparam CAPTURE_FRAME = 2'b01;
  localparam WRITING_FRAME = 2'b10;
  localparam READING_FRAME = 2'b11;
  
  wire [1:0] selected_filter;  // used in determining filter module latency
  wire [23:0] vga_rgb_out;     // connected to VGA pixel output
  
  // Filter Types
  parameter SEPIA = 2'b00;
  parameter INVERT = 2'b01;
  
  // Delay Parameters
  parameter YCRCB2RGB_DLY = 4;
  parameter RGB2HSV_DLY = 23;
  parameter THRESHOLD_DLY = 1;
  parameter HSV2RGB_DLY = 10;
  parameter ENHANCE_DLY = 1;
  
  parameter INVERT_DLY = 1;
  parameter SEPIA_DLY = 4;
  
  //parameter FILTER_DLY = (!filters_en) ? 0 :
  //                         (selected_filter == INVERT) ? INVERT_DLY : SEPIA_DLY;
  
  //parameter FILTER_DLY = SEPIA_DLY;
  
  //parameter COLOR_PIXEL_DLY = RGB2HSV_DLY + THRESHOLD_DLY;
  parameter SYNC_DLY = YCRCB2RGB_DLY + RGB2HSV_DLY + THRESHOLD_DLY + 
                        HSV2RGB_DLY + ENHANCE_DLY + SEPIA_DLY + 1;
                          
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
  //reg [23:0] pixel_hsv_in_q;
  //assign pixel_hsv_in = pixel_hsv_in_q;
  //always @(posedge clk) pixel_hsv_in_q <= pixel_hsv_out;
  
  wire chroma_key_match;
  wire [23:0] hsv_chr_out;
  //wire [7:0] h_thr, s_thr, v_thr;
  
  wire adjust_thr_en = (fsm_state == SEL_BKGD);
  
  chroma_key chroma_key1(
    .clk              (clk),
    .rst              (reset),
    .vsync            (vsync),
    .hsv_chr_in       (pixel_hsv_out),
    .up               (up),
    .down             (down),
    .left             (left),
    .right            (right),
    .adjust_thr_en    (adjust_thr_en),
    .range            (thr_range),
    .h_nom            (h_thr),
    .s_nom            (s_thr),
    .v_nom            (v_thr),
    .hsv_chr_out      (hsv_chr_out),
    .chroma_key_match (chroma_key_match)
  );
  
  wire [23:0] chr_pixel_out;    // chroma-keyed pixel
  assign chr_pixel_out = (chroma_key_match) ? 24'hD5FFFF : hsv_chr_out;
  
  // Image Enhancement
  //wire enhance_enable = enhance_en && (fsm_state == COLOR_EDITS);
  wire enhance_user_in_en = enhance_en && (fsm_state == COLOR_EDITS);
  
  enhance enhance1(
    .clk                (clk),
    .rst                (reset),
	  .vsync              (vsync),
    //.fsm_state          (fsm_state),
    .enhance_en         (enhance_en),
    .enhance_user_in_en (enhance_user_in_en),
    .inc_saturation     (up),
    .dec_saturation     (down),
    .inc_brightness     (right),
    .dec_brightness     (left),
    //.reset_enhance      (center),
    .hsv_in             (chr_pixel_out),
    .hsv_out            (pixel_hsv_in)
  );
  
  // Filter Effects
  wire [23:0] pixel_filtered;
  //wire filters_enable = filters_en && (fsm_state == COLOR_EDITS);
  wire filters_user_in_en = filters_en && (fsm_state == COLOR_EDITS);
  
  filters filters1(
    .clk                  (clk),
    .rst                  (reset),
    .filters_en           (filters_en),
    .filters_user_in_en   (filters_user_in_en),
    .select0              (select0),
    .select1              (select1),
    .select2              (select2),
    .select3              (select3),
    .rgb_in               (pixel_rgb_out),
    .rgb_out              (pixel_filtered),
    .filter               (selected_filter)
  );
    
  // Text Movement
  //wire [10:0] text_x_pos;
  //wire [9:0] text_y_pos;
  wire text_move_enable = text_en && move_text_en && (fsm_state == ADD_EDITS);
  
  mover text_mover(
    .clk      (clk),
    .rst      (reset),
    .move_en  (text_move_enable),
    .up       (up),
    .down     (down),
    .left     (left),
    .right    (right),
    .vsync    (vsync),
    //.hoffset  (hoffset),
    //.voffset  (voffset),
    //.hmax     (hmax),
    //.vmax     (vmax),
    .x_pos    (text_x_pos),
    .y_pos    (text_y_pos)
  );
  
  // Text Generation
  wire [2:0] text_sel = 2'b01;
  wire [23:0] text_gen_pixel;
  
  stringmaker text_gen(
    .clk        (clk),
    .x          (text_x_pos),
    .hcount     (hcount),
    .y          (text_y_pos),
    .vcount     (vcount), 
    .background (text_sel),
    .pixel      (text_gen_pixel)
  );
    
  // Graphics Movement
  wire [10:0] graphics_x_pos;
  wire [9:0] graphics_y_pos;
  wire graphics_move_enable = graphics_en && move_graphics_en && (fsm_state == ADD_EDITS);

  mover graphics_mover(
    .clk      (clk),
    .rst      (reset),
    .move_en  (graphics_move_enable),
    .up       (up),
    .down     (down),
    .left     (left),
    .right    (right),
    .vsync    (vsync),
    //.hoffset  (hoffset),
    //.voffset  (voffset),
    //.hmax     (hmax),
    //.vmax     (vmax),
    .x_pos    (graphics_x_pos),
    .y_pos    (graphics_y_pos)
  );
  
  // Text Crosshair
  reg [23:0] text_crosshair_pixel_q;
  always @(posedge clk) begin
    if (text_en && ((hcount == text_x_pos) || (vcount == text_y_pos)))
      text_crosshair_pixel_q <= 24'hFF0000;
    else text_crosshair_pixel_q <= 24'h000000;
  end
  
  // Graphics Crosshair
  reg [23:0] graphics_crosshair_pixel_q;
  always @(posedge clk) begin
    if (graphics_en && ((hcount == graphics_x_pos) || (vcount == graphics_y_pos)))
      graphics_crosshair_pixel_q <= 24'h0000FF;
    else graphics_crosshair_pixel_q <= 24'h000000;
  end
  
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
  
  // Output Pixel
  //assign vga_rgb_out = pixel_filtered + text_crosshair_pixel_q + graphics_crosshair_pixel_q;
  
  //assign vga_rgb_out = (text_en && (text_crosshair_pixel_q != 24'd0)) ? text_crosshair_pixel_q :
  //                      (graphics_en && (graphics_crosshair_pixel_q != 24'd0)) ? graphics_crosshair_pixel_q : pixel_filtered;
  
  assign vga_rgb_out = (text_en && (text_gen_pixel != 24'd0)) ? text_gen_pixel :
                        (graphics_en && (graphics_crosshair_pixel_q != 24'd0)) ? graphics_crosshair_pixel_q : pixel_filtered;
                                              
  reg [23:0] pixel_out_q;
  //wire in_display_rd = hcount < 640 && vcount < 400;
  
  always @(posedge clk) begin
    //pixel_out_q <= sw_ntsc ? 0 : pixel_hsv_out;
    //pixel_out_q <= sw_ntsc ? 0 : store_bram ? (in_display ? {bram_dout[7:5],5'd0,bram_dout[4:2],5'd0,bram_dout[1:0],6'd0} : 24'hFFFFFF) : vga_rgb_out;
    if (bram_state == READING_FRAME) pixel_out_q <= in_display ? {bram_dout[7:5],5'd0,bram_dout[4:2],5'd0,bram_dout[1:0],6'd0} : 24'hFFFFFF;
    else pixel_out_q <= sw_ntsc ? 0 : vga_rgb_out;
    //pixel_out_q <= sw_ntsc ? 0 : (in_display ? {bram_dout[7:5],5'd0,bram_dout[4:2],5'd0,bram_dout[1:0],6'd0} : 24'hFFFFFF);
    //pixel_out_q <= sw_ntsc ? 0 : vr_pixel_color;
  end  
  
  // Output Signal Assignments
  assign pixel_out = pixel_out_q;
  assign blank_out = blank_shift_reg[SYNC_DLY-1];
  assign hsync_out = hsync_shift_reg[SYNC_DLY-1];
  assign vsync_out = vsync_shift_reg[SYNC_DLY-1];

endmodule
