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
    output char_array_rdy,
    output accepting_kbd_input
  );
  
  `include "param.v"
  
  // Keyboard Signals
  //wire keyboard_clock;
  //wire keyboard_data;
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
  //reg processing_input_q = 1'b0;
  
  reg [5:0] char_ctr_q = TEXT_LEN_MAX;
  //reg [7:0] char_byte_q = 8'd0;
  
  wire kbd_input_en = (fsm_state == ADD_EDITS) && custom_text_en;
  wire reset_kbd_input = (fsm_state == ADD_EDITS) && !custom_text_en;
  
  //output assignments
  assign char_array = char_array_q;
  assign char_array_rdy = ~accepting_kbd_input_q;
  assign accepting_kbd_input = accepting_kbd_input_q;
  
  integer i;
  
  always @(posedge clock_27mhz) begin
    if (reset_kbd_input) begin
      accepting_kbd_input_q <= 1'b0;
      //processing_input_q <= 1'b0;
      char_ctr_q <= TEXT_LEN_MAX;
    end else if (kbd_input_en) begin
      if (button_enter) accepting_kbd_input_q <= 1'b0;
      else accepting_kbd_input_q <= 1'b1;
      
      if (accepting_kbd_input_q && char_rdy) begin
        //char_ctr_q <= char_rdy ? char_ctr_q-1'b1 : char_ctr_q;
        //char_byte_q <= char_rdy ? ascii : char_byte_q;
        
//        if (char_ctr_q > 0)
//          char_array_q[(char_ctr_q-1)+:8] <= ascii;
        char_ctr_q <= char_ctr_q - 1'b1;

        
        //case (char_ctr_q) begin
        for (i=TEXT_LEN_MAX; i>0; i=i-1)
           if (char_ctr_q==i) char_array_q[(8*(i-1))+:8] <= ascii;
        //processing_input_q <= 1'b1;
        //end
        
      end
    end
  end

endmodule

module char2letter #(parameter TEXT_LEN_MAX=20) (
    input clk, rst,
    input [TEXT_LEN_MAX*8-1:0] char_array,
    input char_array_rdy,
    output [TEXT_LEN_MAX*5-1:0] letter_array,
    output letter_array_rdy
  );
  
  reg [TEXT_LEN_MAX*8-1:0] char_array_q = 0;
  reg [TEXT_LEN_MAX*8-1:0] letter_array_q = 0;
  
  reg letter_array_rdy_q = 1'b1;
  
  // output assignments
  assign letter_array_rdy = letter_array_rdy_q;
  assign letter_array = letter_array_q;
  
  integer i;
  
  always @(posedge clk) begin
    if (char_array_rdy && letter_array_rdy_q) begin
    
      // latch incoming character array
      for (i=0; i<TEXT_LEN_MAX; i=i+1)
        char_array_q[(8*i)+:8] <= char_array[(8*i)+:8];
        
      // deassert letter array rdy signal
      letter_array_rdy_q <= 1'b0;
      
    end else if (~letter_array_rdy_q) begin
      
      // convert each character to letter encoding
      for (i=0; i<TEXT_LEN_MAX; i=i+1) begin
        case (char_array_q[(8*i)+:8])
          8'h1C: letter_array_q[(5*i)+:5] <= 5'd0;		//A
          8'h32: letter_array_q[(5*i)+:5] <= 5'd1;		//B
          8'h21: letter_array_q[(5*i)+:5] <= 5'd2;		//C
          8'h23: letter_array_q[(5*i)+:5] <= 5'd3;		//D
          8'h24: letter_array_q[(5*i)+:5] <= 5'd4;		//E
          8'h2B: letter_array_q[(5*i)+:5] <= 5'd5;		//F
          8'h34: letter_array_q[(5*i)+:5] <= 5'd6;		//G
          8'h33: letter_array_q[(5*i)+:5] <= 5'd7;		//H
          8'h43: letter_array_q[(5*i)+:5] <= 5'd8;		//I
          8'h3B: letter_array_q[(5*i)+:5] <= 5'd9;		//J
          8'h42: letter_array_q[(5*i)+:5] <= 5'd10;		//K
          8'h4B: letter_array_q[(5*i)+:5] <= 5'd11;		//L
          8'h3A: letter_array_q[(5*i)+:5] <= 5'd12;		//M
          8'h31: letter_array_q[(5*i)+:5] <= 5'd13;		//N
          8'h44: letter_array_q[(5*i)+:5] <= 5'd14;		//O
          8'h4D: letter_array_q[(5*i)+:5] <= 5'd15;		//P
          8'h15: letter_array_q[(5*i)+:5] <= 5'd16;		//Q
          8'h2D: letter_array_q[(5*i)+:5] <= 5'd17;		//R
          8'h1B: letter_array_q[(5*i)+:5] <= 5'd18;		//S
          8'h2C: letter_array_q[(5*i)+:5] <= 5'd19;		//T
          8'h3C: letter_array_q[(5*i)+:5] <= 5'd20;		//U
          8'h2A: letter_array_q[(5*i)+:5] <= 5'd21;		//V
          8'h1D: letter_array_q[(5*i)+:5] <= 5'd22;		//W
          8'h22: letter_array_q[(5*i)+:5] <= 5'd23;		//X
          8'h35: letter_array_q[(5*i)+:5] <= 5'd24;		//Y
          8'h1A: letter_array_q[(5*i)+:5] <= 5'd25;		//Z
          8'h29: letter_array_q[(5*i)+:5] <= 5'd26;		// (space)
          default: letter_array_q[(5*i)+:5] <= 5'd26;
        endcase
      end
      
      // assert letter array rdy signal
      letter_array_rdy_q <= 1'b1;
      
    end
  end
  
endmodule
