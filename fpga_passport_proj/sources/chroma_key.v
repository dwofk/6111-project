`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    15:30:49 11/22/2016 
// Design Name: 
// Module Name:    chroma_key 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Determines whether the HSV values of the input pixel fall into a
//              pre-defined range and if so, marks that pixel as having matched
//              the chroma key. Nominal HSV threshholds are defined as parameters,
//              but threshholds used in color detection can be adjusted by user.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module chroma_key(
    input clk, rst,
    input vsync,
    input [23:0] hsv_chr_in,
    input up, down, left, right,
    input adjust_thr_en,  // allows user to adjust threshholds
    output [7:0] range, h_nom, s_nom, v_nom,
    output reg [23:0] hsv_chr_out,
    output reg chroma_key_match
  );
  
  localparam H_NOMINAL = 8'd85;
  //localparam H_RANGE_POS = 8'd50;
  //localparam H_RANGE_NEG = 8'd50;
  
  localparam S_NOMINAL = 8'd94;
  //localparam S_RANGE_POS = 8'd50;
  //localparam S_RANGE_NEG = 8'd50;
  
  localparam V_NOMINAL = 8'd202;
  localparam V_RANGE_POS = 8'd50;
  localparam V_RANGE_NEG = 8'd100;
  
  localparam RANGE_NOMINAL = 8'd50;
  
  // HSV threshholds that can all be adjusted by user
  reg [7:0] h_nom_q = H_NOMINAL;
  reg [7:0] s_nom_q = S_NOMINAL;
  reg [7:0] v_nom_q = V_NOMINAL;
  reg [7:0] range_q = RANGE_NOMINAL; // threshhold +/- range for H and S
  
  assign {range, h_nom, s_nom, v_nom} = {range_q, h_nom_q, s_nom_q, v_nom_q};
  
  // max and min for H
  wire [7:0] h_max = h_nom_q+range_q;
  wire [7:0] h_min = h_nom_q-range_q;
  
  // max and min for S
  wire [7:0] s_max = s_nom_q+range_q;
  wire [7:0] s_min = s_nom_q-range_q;
  
  // max and min for V
  wire [7:0] v_max = v_nom_q+V_RANGE_POS;
  wire [7:0] v_min = v_nom_q-V_RANGE_NEG;
  
  // HSV values of input pixel
  wire [7:0] h_chr_in = hsv_chr_in[23:16];
  wire [7:0] s_chr_in = hsv_chr_in[15:8];
  wire [7:0] v_chr_in = hsv_chr_in[7:0];
  
  // determine whether HSV values are in range
  wire h_in_range = (h_chr_in >= h_min) && (h_chr_in <= h_max);
  wire s_in_range = (s_chr_in >= s_min) && (s_chr_in <= s_max);
  wire v_in_range = (v_chr_in >= v_min) && (v_chr_in <= v_max);
  wire in_range = h_in_range && s_in_range && v_in_range;
  
  // detect falling edge of vsync
  reg vsync_q;
  always @(posedge clk) vsync_q <= vsync;
  
  wire vsync_falling;
  assign vsync_falling = (vsync !== vsync_q) && (vsync === 1'b0);
  
  reg [3:0] vsync_counter = 0;
  
  always @(posedge clk) begin
    hsv_chr_out <= hsv_chr_in;
    chroma_key_match <= (in_range) ? 1 : 0;
    
    if (rst) begin
      h_nom_q <= H_NOMINAL;
      s_nom_q <= S_NOMINAL;
      v_nom_q <= V_NOMINAL;
      range_q <= RANGE_NOMINAL;
    end else if (vsync_falling && adjust_thr_en) begin
      vsync_counter <= vsync_counter+1'b1; // to slow down adjustment speed
      if (vsync_counter == 4'd15) begin
        if (!left && !right) begin              // change H threshold
          if (up && (h_nom_q < 8'd255)) h_nom_q <= h_nom_q+1'b1;
          if (down && (h_nom_q > 8'd0)) h_nom_q <= h_nom_q-1'b1;
        end else if (left && !right) begin      // change S threshold
          if (up && (s_nom_q < 8'd255)) s_nom_q <= s_nom_q+1'b1;
          if (down && (s_nom_q > 8'd0)) s_nom_q <= s_nom_q-1'b1;
        end else if (!left && right) begin      // change V threshold
          if (up && (v_nom_q < 8'd255)) v_nom_q <= v_nom_q+1'b1;
          if (down && (v_nom_q > 8'd0)) v_nom_q <= v_nom_q-1'b1;
        end else if (left && right) begin      // change threshold range
          if (up && (range_q < 8'd255)) range_q <= range_q+1'b1;
          if (down && (range_q > 8'd0)) range_q <= range_q-1'b1;
        end
      end
    end
  end

endmodule
