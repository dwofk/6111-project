`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    16:16:22 11/21/2016 
// Design Name: 
// Module Name:    mover 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Generates x and y coordinate offsets given user button inputs.
//              Offset values are updated on the falling edge of vsync. When
//              connected to a module that generates pixel values, the outputs
//              from this module allow the user to control the movement of
//              pixel(s) across the screen. In this project, this module is
//              connected to text and graphics generator modules.
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
    input [10:0] h_offset,
    output [10:0] x_pos,
    output [9:0] y_pos
  );
  
  `include "param.v"
  
  // The parameters below take into account timing delays from the preceding
  // modules (e.g. color space conversion modules, image enhancement). H_MIN is
  // offset to ensure that H_MIN corresponds to the top leftmost pixel on screen.
  
  // Display area for movement defined to be (0<x<640, 0<y<480).
  
  // horizontal position parameters
  //localparam H_MIN = h_offset; -> can't do this!
  localparam H_MAX = 10'd640;
  //localparam H_INIT = H_MIN;  // initial x-coordinate
  
  // vertical position parameters
  localparam V_MIN = 10'd0;
  localparam V_MAX = 10'd480;
  localparam V_INIT = V_MIN;  // initial y-coordinate
  
  // detect falling edge of vsync
  reg vsync_q;
  always @(posedge clk) vsync_q <= vsync;
  
  wire vsync_falling;
  assign vsync_falling = (vsync !== vsync_q) && (vsync === 1'b0);
  
  // registered outputs (init to approx. center)
  reg [10:0] x_pos_q = 320;
  reg [9:0] y_pos_q = 240;
  
  // output assignments
  assign {x_pos, y_pos} = {x_pos_q, y_pos_q};
  
  // determine whether current (x,y) is in defined display area
  wire x_pos_in_disp = (x_pos >= h_offset) && (x_pos < H_MAX);
  wire y_pos_in_disp = (y_pos >= V_MIN) && (y_pos < V_MAX);
  
  always @(posedge clk) begin
    if (rst) {x_pos_q, y_pos_q} <= {h_offset, V_INIT};
    else if (vsync_falling && move_en) begin
      // if up and down are pressed together, do nothing; otherwise, adjust vertical position pixel
      if (up && ~down && y_pos_in_disp) y_pos_q <= (y_pos_q == V_MIN) ? y_pos_q : y_pos_q-1'b1;
      if (down && ~up && y_pos_in_disp) y_pos_q <= (y_pos_q == (V_MAX-1)) ? y_pos_q : y_pos_q+1'b1;
      // if left and right are pressed together, do nothing; otherwise, adjust horizontal position pixel
      if (left && ~right && x_pos_in_disp) x_pos_q <= (x_pos_q == h_offset) ? x_pos_q : x_pos_q-1'b1;
      if (right && ~left && x_pos_in_disp) x_pos_q <= (x_pos_q == (H_MAX-1)) ? x_pos_q : x_pos_q+1'b1;
    end
  end
  
endmodule
