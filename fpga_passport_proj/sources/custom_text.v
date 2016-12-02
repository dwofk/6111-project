`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:44:19 11/30/2016 
// Design Name: 
// Module Name:    custom_text 
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
module custom_text #(parameter TEXT_LEN_MAX=20) (
    input clock_27mhz, reset,
    input custom_text_en,
    input [2:0] fsm_state,
    input button_enter,
    // Keyboard Signals
    input keyboard_clock,
    input keyboard_data,
    output [TEXT_LEN_MAX*8-1:0] char_array,
    //output [TEXT_LEN_MAX*5-1:0] letter_array,
    output keyboard_waiting,
    output char_array_rdy,
    //output letter_array_rdy,
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
  
  reg accepting_kbd_input_q = 1'b0;
  reg processing_input_q = 1'b0;
  
  reg [5:0] char_ctr_q = TEXT_LEN_MAX;
  reg [5:0] num_char_q = 0;
  
  wire kbd_input_en = (fsm_state == ADD_EDITS) && custom_text_en;
  wire reset_kbd_input = (fsm_state == ADD_EDITS) && !custom_text_en;
  
  //output assignments
  assign char_array = char_array_q;
  assign char_array_rdy = processing_input_q;
  assign num_char = num_char_q;
  assign keyboard_waiting = accepting_kbd_input_q;
  
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
        accepting_kbd_input_q <= 1'b0;
        processing_input_q <= 1'b1;
      end else accepting_kbd_input_q <= ~processing_input_q;
      if (accepting_kbd_input_q && char_rdy && (char_ctr_q > 0)) begin
        char_ctr_q <= char_ctr_q - 1'b1;
        for (i=TEXT_LEN_MAX; i>0; i=i-1)
           if (char_ctr_q==i) char_array_q[(8*(i-1))+:8] <= ascii;
      end      
    end
  end
  
/*  
  //wire [TEXT_LEN_MAX*5-1:0] letter_array;
  //wire letter_array_rdy;
  
  char2letter #(TEXT_LEN_MAX) conv_char(
    .clk                (clock_27mhz),
    .rst                (reset),
    .char_array         (char_array_q),
    .char_array_rdy     (processing_input_q),
    .letter_array       (letter_array),
    .letter_array_rdy   (letter_array_rdy)
  );
*/

endmodule

/*module char2letter #(parameter TEXT_LEN_MAX=20) (
    input clk, rst,
    input [TEXT_LEN_MAX*8-1:0] char_array,
    input char_array_rdy,
    output [TEXT_LEN_MAX*5-1:0] letter_array,
    output letter_array_rdy
  );
  
  reg [TEXT_LEN_MAX*8-1:0] char_array_q = 0;
  reg [TEXT_LEN_MAX*5-1:0] letter_array_q = 0;
  
  reg letter_array_rdy_q = 1'b0;
  reg encoding_char_q = 1'b0;
  
  // output assignments
  assign letter_array_rdy = letter_array_rdy_q;
  assign letter_array = letter_array_q;
  
  // edge detection on char rdy signal
  reg char_array_rdy_d_q; // delayed store_bram signal
  always @(posedge clk) char_array_rdy_d_q <= char_array_rdy;
  
  wire char_array_rdy_rising = !char_array_rdy_d_q && char_array_rdy;
  wire char_array_rdy_falling = char_array_rdy_d_q && !char_array_rdy;
  
  integer i;
  
  always @(posedge clk) begin
    letter_array_rdy_q <= char_array_rdy_falling ? 1'b0 : letter_array_rdy_q;
    
    if (char_array_rdy_rising && ~encoding_char_q) begin
      encoding_char_q <= 1'b1;
      
      // latch incoming character array
      for (i=0; i<TEXT_LEN_MAX; i=i+1)
        char_array_q[(8*i)+:8] <= char_array[(8*i)+:8];
        
      // deassert letter array rdy signal
      letter_array_rdy_q <= 1'b0;
      
    end else if (~letter_array_rdy_q && encoding_char_q) begin
      
      // convert each character to letter encoding
      for (i=TEXT_LEN_MAX; i>0; i=i-1) begin
        case (char_array_q[(8*(i-1))+:8])
          8'h41: letter_array_q[(5*(i-1))+:5] <= 5'd0;		  //A
          8'h42: letter_array_q[(5*(i-1))+:5] <= 5'd1;		  //B
          8'h43: letter_array_q[(5*(i-1))+:5] <= 5'd2;		  //C
          8'h44: letter_array_q[(5*(i-1))+:5] <= 5'd3;		  //D
          8'h45: letter_array_q[(5*(i-1))+:5] <= 5'd4;		  //E
          8'h46: letter_array_q[(5*(i-1))+:5] <= 5'd5;		  //F
          8'h47: letter_array_q[(5*(i-1))+:5] <= 5'd6;		  //G
          8'h48: letter_array_q[(5*(i-1))+:5] <= 5'd7;		  //H
          8'h49: letter_array_q[(5*(i-1))+:5] <= 5'd8;		  //I
          8'h4A: letter_array_q[(5*(i-1))+:5] <= 5'd9;		  //J
          8'h4B: letter_array_q[(5*(i-1))+:5] <= 5'd10;		//K
          8'h4C: letter_array_q[(5*(i-1))+:5] <= 5'd11;		//L
          8'h4D: letter_array_q[(5*(i-1))+:5] <= 5'd12;		//M
          8'h4E: letter_array_q[(5*(i-1))+:5] <= 5'd13;		//N
          8'h4F: letter_array_q[(5*(i-1))+:5] <= 5'd14;		//O
          8'h50: letter_array_q[(5*(i-1))+:5] <= 5'd15;		//P
          8'h51: letter_array_q[(5*(i-1))+:5] <= 5'd16;		//Q
          8'h52: letter_array_q[(5*(i-1))+:5] <= 5'd17;		//R
          8'h53: letter_array_q[(5*(i-1))+:5] <= 5'd18;		//S
          8'h54: letter_array_q[(5*(i-1))+:5] <= 5'd19;		//T
          8'h55: letter_array_q[(5*(i-1))+:5] <= 5'd20;		//U
          8'h56: letter_array_q[(5*(i-1))+:5] <= 5'd21;		//V
          8'h57: letter_array_q[(5*(i-1))+:5] <= 5'd22;		//W
          8'h58: letter_array_q[(5*(i-1))+:5] <= 5'd23;		//X
          8'h59: letter_array_q[(5*(i-1))+:5] <= 5'd24;		//Y
          8'h5A: letter_array_q[(5*(i-1))+:5] <= 5'd25;		//Z
          8'h29: letter_array_q[(5*(i-1))+:5] <= 5'd26;		// (space)
          default: letter_array_q[(5*(i-1))+:5] <= 5'd26;
        endcase
      end
      
      // assert letter array rdy signal
      letter_array_rdy_q <= 1'b1;
      
      encoding_char_q <= 1'b0;
      
    end
  end
  
endmodule*/
