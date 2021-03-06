`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk (diana96@mit.edu)
// 
// Create Date:    11:51:35 11/21/2016 
// Design Name: 
// Module Name:    main_fsm 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Main FSM for the system.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module main_fsm(
    input clk, rst,
    input sw_ntsc,
    input enter,
    input store_bram,
    output [2:0] fsm_state,
    output sw_ntsc_falling
  );
  
  `include "param.v"
  
  reg [2:0] fsm_state_q = 3'b000;
  reg [2:0] next_state;
  
  assign fsm_state = fsm_state_q;
  
  ///////////////////////////////////////////////////////////////////////////////
  //
  // INPUT SIGNAL EDGE DETECTION
  //
  ////////////////////////////////////////////////////////////////////////////////

  // latched signals for edge detection
  reg sw_ntsc_d_q, enter_d_q, store_bram_d_q;

  // edge signal declarations
  wire sw_ntsc_rising; // sw_ntsc_falling; -> an output
  wire enter_rising, enter_falling;
  wire store_bram_rising, store_bram_falling;

  // edge detection for ntsc switch
  always @(posedge clk) sw_ntsc_d_q <= sw_ntsc;
  assign sw_ntsc_rising = sw_ntsc && !sw_ntsc_d_q;
  assign sw_ntsc_falling = !sw_ntsc && sw_ntsc_d_q;
  
  // edge detection for enter button
  always @(posedge clk) enter_d_q <= enter;
  assign enter_rising = enter && !enter_d_q;
  assign enter_falling = !enter && enter_d_q;

  // edge detection for bram switch
  always @(posedge clk) store_bram_d_q <= store_bram;
  assign store_bram_rising = store_bram && !store_bram_d_q;
  assign store_bram_falling = !store_bram && store_bram_d_q;
  
  ///////////////////////////////////////////////////////////////////////////////
  //
  // STATE TRANSITIONS
  //
  ////////////////////////////////////////////////////////////////////////////////

  always @(*) begin
    case (fsm_state_q)
      FSM_IDLE      : next_state = (sw_ntsc_rising) ? SEL_BKGD : FSM_IDLE;

      SEL_BKGD      : next_state = (enter_rising) ? COLOR_EDITS : 
                                     (sw_ntsc_falling) ? FSM_IDLE : SEL_BKGD;
      
      COLOR_EDITS   : next_state = (enter_rising) ? ADD_EDITS : 
                                     (sw_ntsc_falling) ? FSM_IDLE : COLOR_EDITS;
                                     
      ADD_EDITS     : next_state = (store_bram_rising) ? SAVE_TO_BRAM : 
                                     (sw_ntsc_falling) ? FSM_IDLE : ADD_EDITS;
                                     
      SAVE_TO_BRAM  : next_state = (enter_rising) ? SEND_TO_PC : 
                                     (sw_ntsc_falling) ? FSM_IDLE : SAVE_TO_BRAM;
      
      SEND_TO_PC    : next_state = (sw_ntsc_falling) ? FSM_IDLE : SEND_TO_PC;
      
      default       : next_state = fsm_state_q;
    endcase
  end
  
  always @(posedge clk) begin
    if (rst) fsm_state_q <= FSM_IDLE;
    else fsm_state_q <= next_state;
  end

endmodule
