`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:     
// Design Name: 
// Module Name:    frame_bram_ifc 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Module interfacing with BRAM IP. Stores what is currently being
//              displayed via VGA into BRAM; can only store 600*400 bytes. Only
//              600x400 8-bit RGB values are saved of the 640x480 24-bit image.
//              A user input switch enables writing to BRAM; data is read out
//              automatically after it a frame/image has been fully written.
//              Turning switch off resets BRAM FSM and allows stored data to be 
//              over-written with new data the next time the switch is raised.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module frame_bram_ifc(
    input clk, rst,
    input store_bram,
    input [10:0] hcount,
    input [9:0] vcount,
    input [10:0] hoffset,
    input [9:0] voffset,
    input [17:0] tx_counter, // read address when transmitting stored data to PC
    input in_display,         
    input [23:0] pixel_out,  // pixel displayed via VGA
    input [2:0] fsm_state,
    output [7:0] bram_dout,
    output [1:0] bram_state
  );  
  
  `include "param.v"
  
  reg [1:0] state_q = BRAM_IDLE;
  assign bram_state = state_q;
  
  // edge detection on store_bram switch
  reg store_bram_d_q; // delayed store_bram signal
  always @(posedge clk) store_bram_d_q <= store_bram;
  
  wire bram_sw_rising = !store_bram_d_q && store_bram;
  wire bram_sw_falling = store_bram_d_q && !store_bram;
  
  // read and write addresses
  reg [17:0] write_counter_q = 0; 
  reg [17:0] read_counter_q = 0; 
  
  // control signals for progressing through BRAM FSM states
  wire frame_loaded = (write_counter_q == 18'd255999);      // 600*400 = 256000
  wire at_origin = (hcount==hoffset) && (vcount==voffset);
  
  // BRAM signal declarations
  wire [7:0] frame_bram_din;
  wire [17:0] frame_bram_addr;
  wire frame_bram_wea;
  
  bram_ip frame_bram(clk, frame_bram_din, frame_bram_addr, frame_bram_wea, bram_dout);
  
  // inputs to BRAM instantiation
  assign frame_bram_din = {pixel_out[23:21],pixel_out[15:13],pixel_out[7:6]};		// 8-bit color
  assign frame_bram_wea = (state_q == WRITING_FRAME) && in_display && !frame_loaded;  
  assign frame_bram_addr = (fsm_state == SEND_TO_PC) ? tx_counter :
                            (state_q == WRITING_FRAME) ? write_counter_q : 
                            (state_q == READING_FRAME) ? read_counter_q : 0;
  
  always @(posedge clk) begin
    case (state_q)
      BRAM_IDLE     : begin
                        write_counter_q <= 0;
                        read_counter_q <= 0;
                        state_q <= (bram_sw_rising) ? CAPTURE_FRAME : BRAM_IDLE;
                       end
                       
      CAPTURE_FRAME : state_q <= (at_origin) ? WRITING_FRAME : CAPTURE_FRAME;
                      // waiting to begin writing frame into BRAM; begin writing when h&vcount match
                      // offsets, i.e. when pixel_out corresponds to the first (top left) pixel of frame
      
      WRITING_FRAME : begin
                        if (frame_bram_wea) write_counter_q <= write_counter_q+1'b1;
                        state_q <= (frame_loaded) ? READING_FRAME : WRITING_FRAME;
                      end
      
      READING_FRAME : begin
                        // continuously read out from BRAM and output stored data when in the 640x480 display area
                        if (in_display) read_counter_q <= (read_counter_q == 18'd255999) ? 0 : read_counter_q+1'b1;
                        state_q <= (bram_sw_falling) ? BRAM_IDLE : READING_FRAME;
                      end
    endcase
  end
  
endmodule

    
