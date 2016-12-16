`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    22:29:17 11/17/2016 
// Design Name: 
// Module Name:    pixel_sel 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Pixel selector module. Instantiates and interconnects the
//              color space conversion modules, the image enhacenment and
//              filter effects modules, as well as the text and graphics
//              generation modules. Processes user button and switch inputs
//              and selects output VGA pixels accordingly.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pixel_sel #(parameter TEXT_LEN_MAX=20) (
    input clk, reset,
    // states
    input [2:0] fsm_state,
    input [1:0] bram_state,
    // user switches
    input sw_ntsc,
    input store_bram,
    input enhance_en,
    input filters_en,
    input text_en,
    input graphics_en,
    input move_text_en,
    input move_graphics_en,
    input custom_text_en,
    // user buttons
    input up, down, left, right,
    input select0, select1, select2, select3,
    input [2:0] background,
    // custom text gen
    input [5:0] num_char,
    input char_array_rdy,
    input [TEXT_LEN_MAX*8-1:0] char_array,
    // pixel values
    input [29:0] vr_pixel,
    input [7:0] bram_dout,
    input [23:0] vr_bkgd_color,
    // VGA timing
    input [10:0] hcount,
    input [9:0] vcount,
    input blank,
    input hsync,
    input vsync,
    input [10:0] h_offset,
    input in_display_bram,
    // VGA outputs
    output [23:0] pixel_out,
    output blank_out,
    output hsync_out,
    output vsync_out,
    output [10:0] text_x_pos,
    output [9:0] text_y_pos,
    output [10:0] graphics_x_pos,
    output [9:0] graphics_y_pos,
    // hex display
    output [7:0] thr_range, h_thr, s_thr, v_thr,
    // image enhacement
    output [7:0] s_offset, v_offset,
    output s_dir, v_dir,
    // user selections
    output[2:0] selected_filter,
    output [1:0] selected_graphic
  );
  
  `include "param.v"
  
  //wire [2:0] selected_filter;  // used in determining filter module latency -> output
  wire [23:0] vga_rgb_out;     // connected to VGA pixel output
  
  // ***********************************************
  // YCrCb to RGB Conversion
  // ***********************************************
  
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

  // ***********************************************
  // RGB to HSV Conversion
  // ***********************************************
  
  wire [23:0] pixel_hsv_out;
  wire [23:0] bkgd_hsv_out;
  
  rgb2hsv rgb2hsv_conv1(
    .clock(clk), 
    .reset(reset),
    .r(vr_pixel_color[23:16]), 
    .g(vr_pixel_color[15:8]), 
    .b(vr_pixel_color[7:0]),
    .h(pixel_hsv_out[23:16]), 
    .s(pixel_hsv_out[15:8]), 
    .v(pixel_hsv_out[7:0])
  );
  
  rgb2hsv rgb2hsv_conv2(
    .clock(clk), 
    .reset(reset),
    .r(vr_bkgd_color[23:16]), 
    .g(vr_bkgd_color[15:8]), 
    .b(vr_bkgd_color[7:0]),
    .h(bkgd_hsv_out[23:16]), 
    .s(bkgd_hsv_out[15:8]), 
    .v(bkgd_hsv_out[7:0])
  );

  // ***********************************************
  // HSV to RGB Conversion
  // ***********************************************
  
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

  // ***********************************************
  // Chroma-Key Compositing
  // ***********************************************
    
  wire chroma_key_match; // HSV values match threshholds
  wire [23:0] hsv_chr_out;
  
  // signal allowing users to adjust HSV threshholds
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
  
  wire [23:0] bkgd_pixel_out = (background == NO_BKD) ? 24'h000000 : bkgd_hsv_out;
  
  wire [23:0] chr_pixel_out;    // chroma-keyed pixel
  //assign chr_pixel_out = (chroma_key_match) ? 24'hD5FFFF : hsv_chr_out;
  assign chr_pixel_out = (chroma_key_match) ? bkgd_pixel_out : hsv_chr_out;

  // ***********************************************
  // Image Enhancement
  // ***********************************************
  
  // signal allowing users to adjust saturation and brightness values
  wire enhance_user_in_en = enhance_en && (fsm_state == COLOR_EDITS);
  
  enhance enhance1(
    .clk                (clk),
    .rst                (reset),
	  .vsync              (vsync),
    .enhance_en         (enhance_en),
    .enhance_user_in_en (enhance_user_in_en),
    .inc_saturation     (up),
    .dec_saturation     (down),
    .inc_brightness     (right),
    .dec_brightness     (left),
    .hsv_in             (chr_pixel_out),
    .hsv_out            (pixel_hsv_in),
    .s_offset           (s_offset),
    .v_offset           (v_offset),
    .s_dir              (s_dir),
    .v_dir              (v_dir)
  );

  // ***********************************************
  // Filter Effects
  // ***********************************************
  
  wire [23:0] pixel_filtered; // pixel output after filter effects
  
  // signal allowing users to select filter effect
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
    .hcount               (hcount),
    .vcount               (vcount),
    .rgb_in               (pixel_rgb_out),
    .rgb_out              (pixel_filtered),
    .filter               (selected_filter)
  );

  // ***********************************************
  // Text Overlay
  // ***********************************************
  
  // Text Movement
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
    .h_offset (h_offset),
    .x_pos    (text_x_pos),
    .y_pos    (text_y_pos)
  );
  
  // Text Crosshair
  reg [23:0] text_crosshair_pixel_q;
  always @(posedge clk) begin
    if (text_en && ((hcount == text_x_pos) || (vcount == text_y_pos)))
      text_crosshair_pixel_q <= 24'hFF0000;
    else text_crosshair_pixel_q <= 24'h000000;
  end

  // Text Generation
  wire [23:0] text_gen_pixel;
  
  stringmaker #(CUSTOM_TEXT_MAXLEN) text_gen(
    .clk        (clk),
    .x          (text_x_pos),
    .hcount     (hcount),
    .y          (text_y_pos),
    .vcount     (vcount), 
    .background (background[1:0]),
    .numchar    (num_char),
    .ready      (char_array_rdy),
    .string     (char_array),
    .custom     (custom_text_en),
    .pixel      (text_gen_pixel)
  );

  // ***********************************************
  // Graphics Overlay
  // ***********************************************
  
  // Graphics Movement
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
    .h_offset (h_offset),
    .x_pos    (graphics_x_pos),
    .y_pos    (graphics_y_pos)
  );
  
  // Graphics Crosshair
  reg [23:0] graphics_crosshair_pixel_q;
  always @(posedge clk) begin
    if (graphics_en && ((hcount == graphics_x_pos) || (vcount == graphics_y_pos)))
      graphics_crosshair_pixel_q <= 24'h0000FF;
    else graphics_crosshair_pixel_q <= 24'h000000;
  end
  
  // Graphics Generation
  wire [23:0] graphics_gen_pixel;
  wire [1:0] graphics_sel;
  
  reg [1:0] graphics_sel_q = 0;
  assign selected_graphic = graphics_sel_q;
  
  always @(posedge clk) begin
    if ((fsm_state == ADD_EDITS) && select0) graphics_sel_q <= MUSTACHE;
    if ((fsm_state == ADD_EDITS) && select1) graphics_sel_q <= SUNGLASSES;
    if ((fsm_state == ADD_EDITS) && select2) graphics_sel_q <= SAFARI_HAT;
    if ((fsm_state == ADD_EDITS) && select3) graphics_sel_q <= CROWN;
  end

  graphicsmaker graphics_gen(
    .pixel_clk  (clk),
    .x          (graphics_x_pos),
    .hcount     (hcount),
    .y          (graphics_y_pos),
    .vcount     (vcount), 
    .graphic    (selected_graphic),
    .pixel      (graphics_gen_pixel)
  );
  
  // ***********************************************
  // Delay Sync Signals (Shift Registers)
  // ***********************************************
  
  // VGA sync timing signals are delayed in order to take into account
  // the pipelined nature of all of the image processing modules; the
  // length of the delay required depends on which filter is selected.
  // Delays are defined in the parameters file - param.v
  
  // shift registers that can accomodate longest possible delay
  reg [0:0] hsync_shift_reg[MAX_SYNC_DLY-1:0];
  reg [0:0] vsync_shift_reg[MAX_SYNC_DLY-1:0];
  reg [0:0] blank_shift_reg[MAX_SYNC_DLY-1:0];

  integer i;
  
  always @(posedge clk) begin
    hsync_shift_reg[0] <= hsync;
    vsync_shift_reg[0] <= vsync;
    blank_shift_reg[0] <= blank;
    
    for (i=1; i<MAX_SYNC_DLY; i=i+1) begin
      hsync_shift_reg[i] <= hsync_shift_reg[i-1];
      vsync_shift_reg[i] <= vsync_shift_reg[i-1];
      blank_shift_reg[i] <= blank_shift_reg[i-1];
    end
  end
  
  // ***********************************************
  // Output VGA Pixel
  // ***********************************************
  
  // overlapping pixels: text > graphics > filtered/processed pixel
  
  // text and graphics are generated separately on a white background, so the
  // non-white pixels correspond to the text and graphics being overlayed
  
  assign vga_rgb_out = (text_en && (text_gen_pixel != 24'hFFFFFF)) ? text_gen_pixel :
                        (graphics_en && (graphics_gen_pixel != 24'hFFFFFF)) ? graphics_gen_pixel : pixel_filtered;
                                              
  reg [23:0] pixel_out_q; // registered output
  
  wire [23:0] bram_dout_24bit = {bram_dout[7:5],5'd0,bram_dout[4:2],5'd0,bram_dout[1:0],6'd0};
  
  always @(posedge clk) begin
    // if reading from BRAM and displaying stored data, display 24-bit BRAM output
    // otherwise, if reading from BRAM and transmitting data to PC, display black screen
    // otherwise, display VGA RGB pixel or the start splash screen 
    if ((bram_state == READING_FRAME) && !(fsm_state == SEND_TO_PC))
      pixel_out_q <= in_display_bram ? bram_dout_24bit : 24'hFFFFFF;
    else pixel_out_q <= sw_ntsc ? 24'h000000 : (fsm_state == SEND_TO_PC) ? 24'h000000 : vga_rgb_out;
  end  
  
  // Output Signal Assignments
  assign pixel_out = pixel_out_q;
  
  // ***********************************************
  // Delay Sync Signals (Assignments)
  // ***********************************************
  
  // VGA sync signals are delayed according to which filter is selected.

  assign blank_out = (!filters_en) ? blank_shift_reg[SYNC_DLY-1] :
                        (selected_filter == SEPIA) ? blank_shift_reg[SYNC_DLY_SEP-1] :
                        (selected_filter == INVERT) ? blank_shift_reg[SYNC_DLY_INV-1] :
                        (selected_filter == GRAYSCALE) ? blank_shift_reg[SYNC_DLY_GRY-1] :
                        (selected_filter == EDGE) ? blank_shift_reg[SYNC_DLY_SBL-1] :
                        (selected_filter == CARTOON) ? blank_shift_reg[SYNC_DLY_SBL-1] :
                         blank_shift_reg[SYNC_DLY-1];
                         
  assign hsync_out = (!filters_en) ? hsync_shift_reg[SYNC_DLY-1] :
                        (selected_filter == SEPIA) ? hsync_shift_reg[SYNC_DLY_SEP-1] :
                        (selected_filter == INVERT) ? hsync_shift_reg[SYNC_DLY_INV-1] :
                        (selected_filter == GRAYSCALE) ? hsync_shift_reg[SYNC_DLY_GRY-1] :
                        (selected_filter == EDGE) ? hsync_shift_reg[SYNC_DLY_SBL-1] :
                        (selected_filter == CARTOON) ? hsync_shift_reg[SYNC_DLY_SBL-1] :
                         hsync_shift_reg[SYNC_DLY-1];
                         
  assign vsync_out = (!filters_en) ? vsync_shift_reg[SYNC_DLY-1] :
                        (selected_filter == SEPIA) ? vsync_shift_reg[SYNC_DLY_SEP-1] :
                        (selected_filter == INVERT) ? vsync_shift_reg[SYNC_DLY_INV-1] :
                        (selected_filter == GRAYSCALE) ? vsync_shift_reg[SYNC_DLY_GRY-1] :
                        (selected_filter == EDGE) ? vsync_shift_reg[SYNC_DLY_SBL-1] :
                        (selected_filter == CARTOON) ? vsync_shift_reg[SYNC_DLY_SBL-1] :
                         vsync_shift_reg[SYNC_DLY-1];                            
endmodule
