module bram_ifc(
    input clock,
    input reset,
    input store_frame,
    input [10:0] hcount,
    input [9:0] vcount,
    input [23:0] pixel_out,
    output [7:0] bram_dout
  );
  
  parameter IDLE = 0;
  parameter CAPTURE_FRAME = 1;
  parameter WRITING_FRAME = 2;
  parameter READING_FRAME = 3;
  
  // Edge Detection
  reg store_frame_d;
  always @(posedge clock) store_frame_d <= store_frame;
  //wire store_frame_rising

  
  wire in_display = hcount < 640 && vcount < 400;
  
  wire [7:0] frame_bram_din, frame_bram_dout;
  wire [17:0] frame_bram_addr;
  wire frame_bram_wea;
  
  reg [17:0] write_counter = 0; 
  reg [17:0] read_counter = 0; 

  reg [1:0] state = 0;
  
  wire frame_loaded = (write_counter == 18'd255999);

  wire switch_rising = !store_frame_d && store_frame;
  wire switch_falling = store_frame_d && !store_frame;
  
  bram_ip frame_bram(clk, my_din, frame_bram_addr, frame_bram_wea, frame_bram_dout);

  // inputs to BRAM instantiation
  assign my_din = {pixel_out[23:21],pixel_out[15:13],pixel_out[7:6]};
  assign frame_bram_wea = !frame_loaded && (state == WRITING_FRAME) && in_display;  
  assign frame_bram_addr = (!frame_loaded) ? write_counter : read_counter;

  always @(posedge clock) begin
    
    if (state == IDLE) begin
      write_counter <= 0;
      read_counter <= 0;
      if (switch_rising) state <= CAPTURE_FRAME;
    end else begin
      if (state == READING_FRAME) begin
        if (frame_loaded && in_display) read_counter <= (read_counter == 18'd255999) ? 0 : read_counter+1'b1;
        if (switch_falling) state <= IDLE;
      end
      
      if (state == WRITING_FRAME) begin
        if (frame_bram_wea) write_counter <= write_counter+1'b1;
        if (frame_loaded) state <= READING_FRAME;
      end else if ((state == CAPTURE_FRAME) && (hcount==100) && (vcount==100)) state <= WRITING_FRAME;
    end
  end
  
endmodule

    
