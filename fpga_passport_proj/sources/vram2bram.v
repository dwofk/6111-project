module frame_bram_ifc(
    input clk, rst,
    input store_bram,
    input [10:0] hcount,
    input [9:0] vcount,
    input [10:0] hoffset,
    input [9:0] voffset,
    input in_display,
    input [23:0] pixel_out,
    input [17:0] tx_counter,
    input transmitting,
    output [7:0] bram_dout,
    output [1:0] bram_state
  );  
  
  localparam BRAM_IDLE = 2'b00;
  localparam CAPTURE_FRAME = 2'b01;
  localparam WRITING_FRAME = 2'b10;
  localparam READING_FRAME = 2'b11;
  
  reg [1:0] state_q = 2'b00;
  assign bram_state = state_q;
  
  reg store_bram_d_q; // delayed store_bram signal
  always @(posedge clk) store_bram_d_q <= store_bram;
  
  wire bram_sw_rising = !store_bram_d_q && store_bram;
  wire bram_sw_falling = store_bram_d_q && !store_bram;
  
  // read and write addresses
  reg [17:0] write_counter_q = 0; 
  reg [17:0] read_counter_q = 0; 
  
  //wire in_display_rd = hcount < 640 && vcount < 400;
  wire frame_loaded = (write_counter_q == 18'd255999);
  wire at_origin = (hcount==hoffset) && (vcount==voffset);
  
  // BRAM signal declarations
  wire [7:0] frame_bram_din;
  wire [17:0] frame_bram_addr;
  wire frame_bram_wea;
  
  bram_ip frame_bram(clk, frame_bram_din, frame_bram_addr, frame_bram_wea, bram_dout);
  
  // inputs to BRAM instantiation
  assign frame_bram_din = {pixel_out[23:21],pixel_out[15:13],pixel_out[7:6]};		// 8-bit color
  assign frame_bram_wea = (state_q == WRITING_FRAME) && in_display && !frame_loaded;  
  assign frame_bram_addr = (transmitting) ? tx_counter :
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
      
      WRITING_FRAME : begin
                        if (frame_bram_wea) write_counter_q <= write_counter_q+1'b1;
                        state_q <= (frame_loaded) ? READING_FRAME : WRITING_FRAME;
                      end
      
      READING_FRAME : begin
                        if (in_display) read_counter_q <= (read_counter_q == 18'd255999) ? 0 : read_counter_q+1'b1;
                        state_q <= (bram_sw_falling) ? BRAM_IDLE : READING_FRAME;
                      end
    endcase
  end
  
endmodule

    
