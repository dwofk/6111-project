`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    17:44:19 11/30/2016 
// Design Name: 
// Module Name:    custom_text 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: When custom text is enabled, this module takes in keyboard data
//              from ps2_ascii_input and outputs a string containing the user-
//              entered characters. Default maximum string length is 20.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module custom_text #(parameter TEXT_LEN_MAX=20) (
    input clock_27mhz, reset,
    input custom_text_en,
    input [2:0] fsm_state,
    input button_enter,       // "done" signal
    // Keyboard Signals
    input keyboard_clock,
    input keyboard_data,
    // Outputs
    output [TEXT_LEN_MAX*8-1:0] char_array,
    output char_array_rdy,
    output [5:0] num_char
  );
  
  `include "param.v"
  
  // Keyboard Signals
  wire [7:0] ascii;
  wire char_rdy;
  
  ps2_ascii_input keyboard(
    .clock_27mhz      (clock_27mhz),
    .reset            (reset), 
    .clock            (keyboard_clock), 
		.data             (keyboard_data), 
    .ascii            (ascii), 
    .ascii_ready      (char_rdy)
  );
  
  reg [TEXT_LEN_MAX*8-1:0] char_array_q = 0;
  
  // states for keyboard input
  reg accepting_kbd_input_q = 1'b0;
  reg processing_input_q = 1'b0;
  
  reg [5:0] char_ctr_q = TEXT_LEN_MAX;  // # of available char left
  reg [5:0] num_char_q = 0;             // # of char user has entered
  
  // enable keyboard input processing when custom_text_en is asserted
  wire kbd_input_en = (fsm_state == ADD_EDITS) && custom_text_en;
  // clear char array and reset counter when custom_text_en is deasserted
  wire reset_kbd_input = (fsm_state == ADD_EDITS) && !custom_text_en;
  
  //output assignments
  assign char_array = char_array_q;
  assign char_array_rdy = processing_input_q;
  assign num_char = num_char_q;
  
  integer i;
  
  always @(posedge clock_27mhz) begin
    num_char_q <= TEXT_LEN_MAX-char_ctr_q;
    if (reset_kbd_input) begin
      accepting_kbd_input_q <= 1'b0;
      processing_input_q <= 1'b0;
      char_array_q <= 0;
      char_ctr_q <= TEXT_LEN_MAX;
    end else if (kbd_input_en) begin
      if (button_enter) begin
        // user input is done; enable ready signal 
        accepting_kbd_input_q <= 1'b0;
        processing_input_q <= 1'b1;     // connected to char array rdy
      end else accepting_kbd_input_q <= ~processing_input_q;
      if (accepting_kbd_input_q && char_rdy && (char_ctr_q > 0)) begin
        // new char byte has been entered by the user
        // store new byte in array and decrement char counter
        char_ctr_q <= char_ctr_q - 1'b1;
        // this array is flipped, meaning that the first user character
        // entered will be written as leftmost byte in array
        for (i=TEXT_LEN_MAX; i>0; i=i-1)
           if (char_ctr_q==i) char_array_q[(8*(i-1))+:8] <= ascii;
      end      
    end
  end
  
endmodule
