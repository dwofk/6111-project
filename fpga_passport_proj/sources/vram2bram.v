module vram_to_bram(
    input clock,
    input focus_switch,     // stores still frame in bram
    input [10:0] hcount,
    input [9:0] vcount,
    input [23:0] vr_pixel_color,
    output [7:0] bram_dout,
    output in_display,
    output 
  );
  
  parameter IDLE = 0; // when focus switch is off
  parameter CAPTURE_FRAME = 1;
  parameter WRITING_FRAME = 2;
  parameter READING_FRAME = 3;
  
  assign in_display = hcount < 640 && vcount < 400;
  
  wire [7:0] frame_bram_din, frame_bram_dout;
  wire [17:0] frame_bram_addr;
  wire frame_bram_wea;
  
  //reg switch_high = 0;
  //reg started = 0;
  //reg [17:0] my_addr_q = 0;
  //reg pixel_d = 0;
  
  reg sw_ntsc_d;
  
  reg [17:0] write_counter = 0; 
  reg [17:0] read_counter = 0; 

  reg [1:0] state = 0;
  
  wire frame_loaded = (write_counter == 18'd255999);

  wire switch_rising = sw_ntsc_d && !sw_ntsc;
  wire switch_falling = !sw_ntsc_d && sw_ntsc;
  
  bram_ip frame_bram(clk, my_din, frame_bram_addr, frame_bram_wea, frame_bram_dout);

  // inputs to BRAM instantiation
  assign my_din = {vr_pixel_color[23:21],vr_pixel_color[15:13],vr_pixel_color[7:6]};
  assign frame_bram_wea = !frame_loaded && started && in_display;  
  assign frame_bram_addr = (!frame_loaded) ? write_counter : read_counter;

  always @(posedge clk) begin
    sw_ntsc_d <= sw_ntsc;
    
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
        if (my_wea) write_counter <= write_counter+1'b1;
        if (frame_loaded) state <= READING_FRAME;
      end else if ((hcount==0) && (vcount==0)) state <= WRITING_FRAME;
    end
  end
  
endmodule

    
