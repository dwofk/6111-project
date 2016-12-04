`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:16:22 11/21/2016 
// Design Name: 
// Module Name:    mover 
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
module mover(
    input clk, rst,
    input move_en,
    input up, down, left, right,
    input vsync,
    //input [10:0] hoffset, hmax,
    //input [9:0] voffset, vmax,
    output [10:0] x_pos,
    output [9:0] y_pos
  );
  
  `include "param.v"
  
  localparam H_MIN = SYNC_DLY-1;
  localparam H_MAX = 10'd640;
  localparam H_INIT = H_MIN;
  
  localparam V_MIN = 10'd0;
  localparam V_MAX = 10'd480;
  localparam V_INIT = V_MIN;
  
  // detect falling edge of vsync
  reg vsync_q;
  always @(posedge clk) vsync_q <= vsync;
  
  wire vsync_falling;
  assign vsync_falling = (vsync !== vsync_q) && (vsync === 1'b0);
  
  reg [10:0] x_pos_q = 0;
  reg [9:0] y_pos_q = 0;
  
  // output assignments
  assign {x_pos, y_pos} = {x_pos_q, y_pos_q};
  
  wire x_pos_in_disp = (x_pos >= H_MIN) && (x_pos < H_MAX);
  wire y_pos_in_disp = (y_pos >= V_MIN) && (y_pos < V_MAX);
  
  always @(posedge clk) begin
    if (rst) {x_pos_q, y_pos_q} <= {H_INIT, V_INIT};
    else if (vsync_falling && move_en) begin
      if (up && y_pos_in_disp) y_pos_q <= (y_pos_q == V_MIN) ? y_pos_q : y_pos_q-1'b1;
      if (down && y_pos_in_disp) y_pos_q <= (y_pos_q == (V_MAX-1)) ? y_pos_q : y_pos_q+1'b1;
      if (left && x_pos_in_disp) x_pos_q <= (x_pos_q == H_MIN) ? x_pos_q : x_pos_q-1'b1;
      if (right && x_pos_in_disp) x_pos_q <= (x_pos_q == (H_MAX-1)) ? x_pos_q : x_pos_q+1'b1;
    end
  end
  
endmodule
