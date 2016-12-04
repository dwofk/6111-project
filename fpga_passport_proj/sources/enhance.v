`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:02:04 11/18/2016 
// Design Name: 
// Module Name:    enhance 
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
module enhance(
    input clk, rst,
    input vsync,
    //input [2:0] fsm_state,
    input enhance_en,
    input enhance_user_in_en,
    input inc_saturation,
    input dec_saturation,
    input inc_brightness,
    input dec_brightness,
    //input reset_enhance,
    input [23:0] hsv_in,
    output reg [23:0] hsv_out,
    output [7:0] s_offset, v_offset,
    output s_dir, v_dir
  );

  parameter S_DEV = 1; // SATURATION
  parameter V_DEV = 1; // BRIGHTNESS
  
  reg [7:0] s_offset_q, v_offset_q;
  reg s_dir_q, v_dir_q;
  
  assign {s_dir, s_offset} = {s_dir_q, s_offset_q};
  assign {v_dir, v_offset} = {v_dir_q, v_offset_q};
                               
  // detect falling edge of vsync
  reg vsync_q;
  always @(posedge clk) vsync_q <= vsync;
  
  wire vsync_falling;
  assign vsync_falling = (vsync !== vsync_q) && (vsync === 1'b0);
  
  wire zero_saturation = inc_saturation && dec_saturation;
  wire zero_brightness = inc_brightness && dec_brightness;
  wire reset_enhance = enhance_user_in_en && zero_saturation && zero_brightness; 
  
  // adjust S/V offsets based on user input
  always @(posedge clk) begin
    if (reset_enhance) begin
      s_offset_q <= 0;
      v_offset_q <= 0;
      s_dir_q <= 0;
      v_dir_q <= 0;
    end else if (vsync_falling && enhance_user_in_en) begin
 
      // adjust saturation offset
      case ({inc_saturation, dec_saturation, s_dir_q})
        3'b100 : begin
                    if (s_offset_q < S_DEV) begin
                      s_offset_q <= S_DEV - s_offset_q;
                      s_dir_q <= 1'b1;  // switch to positive offset
                    end else s_offset_q <= s_offset_q - S_DEV;
                  end
        3'b101  : begin
                    if (s_offset_q < (8'd255-S_DEV)) s_offset_q <= s_offset_q + S_DEV;
                    else s_offset_q <= 8'd255;
                  end
        3'b011  : begin
                    if (s_offset_q < S_DEV) begin
                      s_offset_q <= S_DEV - s_offset_q;
                      s_dir_q <= 1'b0;  // switch to negative offset
                    end else s_offset_q <= s_offset_q - S_DEV;
                  end
        3'b010  : begin
                    if (s_offset_q < (8'd255-S_DEV)) s_offset_q <= s_offset_q + S_DEV;
                    else s_offset_q <= 8'd255;
                  end
        default : ;   // simultaneous inc/dec produces no change in offset
      endcase
      
      // adjust brightness offset
      case ({inc_brightness, dec_brightness, v_dir_q})
        3'b100 : begin
                    if (v_offset_q < V_DEV) begin
                      v_offset_q <= V_DEV - v_offset_q;
                      v_dir_q <= 1'b1;  // switch to positive offset
                    end else v_offset_q <= v_offset_q - V_DEV;
                  end
        3'b101  : begin
                    if (v_offset_q < (8'd255-V_DEV)) v_offset_q <= v_offset_q + V_DEV;
                    else v_offset_q <= 8'd255;
                  end
        3'b011  : begin
                    if (v_offset_q < V_DEV) begin
                      v_offset_q <= V_DEV - v_offset_q;
                      v_dir_q <= 1'b0;  // switch to negative offset
                    end else v_offset_q <= v_offset_q - V_DEV;
                  end
        3'b010  : begin
                    if (v_offset_q < (8'd255-V_DEV)) v_offset_q <= v_offset_q + V_DEV;
                    else v_offset_q <= 8'd255;
                  end
        default : ;   // simultaneous inc/dec produces no change in offset
      endcase
      
    end
  end
  
  // apply S/V offsets to HSV input; latency = 1 clk cycle
  always @(posedge clk) begin
    if (!enhance_en) hsv_out <= hsv_in;
    else begin
      hsv_out[23:16] <= hsv_in[23:16];  // hue stays the same
      
      // apply saturation offset
      if (s_dir_q) begin
        if (hsv_in[15:8] < (8'd255 - s_offset_q))
          hsv_out[15:8] <= hsv_in[15:8] + s_offset_q;
        else hsv_out[15:8] <= 8'd255;
      end else begin
        if (hsv_in[15:8] > s_offset_q)
          hsv_out[15:8] <= hsv_in[15:8] - s_offset_q;
        else hsv_out[15:8] <= 8'd0;
      end
      
      // apply brightness offset
      if (v_dir_q) begin
        if (hsv_in[7:0] < (8'd255 - v_offset_q))
          hsv_out[7:0] <= hsv_in[7:0] + v_offset_q;
        else hsv_out[7:0] <= 8'd255;
      end else begin
        if (hsv_in[7:0] > v_offset_q)
          hsv_out[7:0] <= hsv_in[7:0] - v_offset_q;
        else hsv_out[7:0] <= 8'd0;
      end
      
    end
  end
  
endmodule
