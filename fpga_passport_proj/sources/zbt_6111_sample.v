module zbt_6111_sample(beep, audio_reset_b, 
		       ac97_sdata_out, ac97_sdata_in, ac97_synch,
	       ac97_bit_clock,
	       
	       vga_out_red, vga_out_green, vga_out_blue, vga_out_sync_b,
	       vga_out_blank_b, vga_out_pixel_clock, vga_out_hsync,
	       vga_out_vsync,

	       tv_out_ycrcb, tv_out_reset_b, tv_out_clock, tv_out_i2c_clock,
	       tv_out_i2c_data, tv_out_pal_ntsc, tv_out_hsync_b,
	       tv_out_vsync_b, tv_out_blank_b, tv_out_subcar_reset,

	       tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1,
	       tv_in_line_clock2, tv_in_aef, tv_in_hff, tv_in_aff,
	       tv_in_i2c_clock, tv_in_i2c_data, tv_in_fifo_read,
	       tv_in_fifo_clock, tv_in_iso, tv_in_reset_b, tv_in_clock,

	       ram0_data, ram0_address, ram0_adv_ld, ram0_clk, ram0_cen_b,
	       ram0_ce_b, ram0_oe_b, ram0_we_b, ram0_bwe_b, 

	       ram1_data, ram1_address, ram1_adv_ld, ram1_clk, ram1_cen_b,
	       ram1_ce_b, ram1_oe_b, ram1_we_b, ram1_bwe_b,

	       clock_feedback_out, clock_feedback_in,

	       flash_data, flash_address, flash_ce_b, flash_oe_b, flash_we_b,
	       flash_reset_b, flash_sts, flash_byte_b,

	       rs232_txd, rs232_rxd, rs232_rts, rs232_cts,

	       mouse_clock, mouse_data, keyboard_clock, keyboard_data,

	       clock_27mhz, clock1, clock2,

	       disp_blank, disp_data_out, disp_clock, disp_rs, disp_ce_b,
	       disp_reset_b, disp_data_in,

	       button0, button1, button2, button3, button_enter, button_right,
	       button_left, button_down, button_up,

	       switch,

	       led,
	       
	       user1, user2, user3, user4,
	       
	       daughtercard,

	       systemace_data, systemace_address, systemace_ce_b,
	       systemace_we_b, systemace_oe_b, systemace_irq, systemace_mpbrdy,
	       
	       analyzer1_data, analyzer1_clock,
 	       analyzer2_data, analyzer2_clock,
 	       analyzer3_data, analyzer3_clock,
 	       analyzer4_data, analyzer4_clock);

   output beep, audio_reset_b, ac97_synch, ac97_sdata_out;
   input  ac97_bit_clock, ac97_sdata_in;
   
   output [7:0] vga_out_red, vga_out_green, vga_out_blue;
   output vga_out_sync_b, vga_out_blank_b, vga_out_pixel_clock,
	  vga_out_hsync, vga_out_vsync;

   output [9:0] tv_out_ycrcb;
   output tv_out_reset_b, tv_out_clock, tv_out_i2c_clock, tv_out_i2c_data,
	  tv_out_pal_ntsc, tv_out_hsync_b, tv_out_vsync_b, tv_out_blank_b,
	  tv_out_subcar_reset;
   
   input  [19:0] tv_in_ycrcb;
   input  tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, tv_in_aef,
	  tv_in_hff, tv_in_aff;
   output tv_in_i2c_clock, tv_in_fifo_read, tv_in_fifo_clock, tv_in_iso,
	  tv_in_reset_b, tv_in_clock;
   inout  tv_in_i2c_data;
        
   inout  [35:0] ram0_data;
   output [18:0] ram0_address;
   output ram0_adv_ld, ram0_clk, ram0_cen_b, ram0_ce_b, ram0_oe_b, ram0_we_b;
   output [3:0] ram0_bwe_b;
   
   inout  [35:0] ram1_data;
   output [18:0] ram1_address;
   output ram1_adv_ld, ram1_clk, ram1_cen_b, ram1_ce_b, ram1_oe_b, ram1_we_b;
   output [3:0] ram1_bwe_b;

   input  clock_feedback_in;
   output clock_feedback_out;
   
   inout  [15:0] flash_data;
   output [23:0] flash_address;
   output flash_ce_b, flash_oe_b, flash_we_b, flash_reset_b, flash_byte_b;
   input  flash_sts;
   
   output rs232_txd, rs232_rts;
   input  rs232_rxd, rs232_cts;

   input  mouse_clock, mouse_data, keyboard_clock, keyboard_data;

   input  clock_27mhz, clock1, clock2;

   output disp_blank, disp_clock, disp_rs, disp_ce_b, disp_reset_b;  
   input  disp_data_in;
   output  disp_data_out;
   
   input  button0, button1, button2, button3, button_enter, button_right,
	  button_left, button_down, button_up;
   input  [7:0] switch;
   output [7:0] led;

   inout [31:0] user1, user2, user3, user4;
   
   inout [43:0] daughtercard;

   inout  [15:0] systemace_data;
   output [6:0]  systemace_address;
   output systemace_ce_b, systemace_we_b, systemace_oe_b;
   input  systemace_irq, systemace_mpbrdy;

   output [15:0] analyzer1_data, analyzer2_data, analyzer3_data, 
		 analyzer4_data;
   output analyzer1_clock, analyzer2_clock, analyzer3_clock, analyzer4_clock;

   ////////////////////////////////////////////////////////////////////////////
   //
   // I/O Assignments
   //
   ////////////////////////////////////////////////////////////////////////////
   
   // Audio Input and Output
   assign beep= 1'b0;
   assign audio_reset_b = 1'b0;
   assign ac97_synch = 1'b0;
   assign ac97_sdata_out = 1'b0;
/*
*/
   // ac97_sdata_in is an input

   // Video Output
   assign tv_out_ycrcb = 10'h0;
   assign tv_out_reset_b = 1'b0;
   assign tv_out_clock = 1'b0;
   assign tv_out_i2c_clock = 1'b0;
   assign tv_out_i2c_data = 1'b0;
   assign tv_out_pal_ntsc = 1'b0;
   assign tv_out_hsync_b = 1'b1;
   assign tv_out_vsync_b = 1'b1;
   assign tv_out_blank_b = 1'b1;
   assign tv_out_subcar_reset = 1'b0;
   
   // Video Input
   //assign tv_in_i2c_clock = 1'b0;
   assign tv_in_fifo_read = 1'b1;
   assign tv_in_fifo_clock = 1'b0;
   assign tv_in_iso = 1'b1;
   //assign tv_in_reset_b = 1'b0;
   assign tv_in_clock = clock_27mhz;//1'b0;
   //assign tv_in_i2c_data = 1'bZ;
   // tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, 
   // tv_in_aef, tv_in_hff, and tv_in_aff are inputs
   
   // SRAMs

/* change lines below to enable ZBT RAM bank0 */

/*
   assign ram0_data = 36'hZ;
   assign ram0_address = 19'h0;
   assign ram0_clk = 1'b0;
   assign ram0_we_b = 1'b1;
   assign ram0_cen_b = 1'b0;	// clock enable
*/

/* enable RAM pins */

   assign ram0_ce_b = 1'b0;
   assign ram0_oe_b = 1'b0;
   assign ram0_adv_ld = 1'b0;
   assign ram0_bwe_b = 4'h0; 

/**********/

   assign ram1_data = 36'hZ; 
   assign ram1_address = 19'h0;
   assign ram1_adv_ld = 1'b0;
   assign ram1_clk = 1'b0;
   
   //These values has to be set to 0 like ram0 if ram1 is used.
   assign ram1_cen_b = 1'b1;
   assign ram1_ce_b = 1'b1;
   assign ram1_oe_b = 1'b1;
   assign ram1_we_b = 1'b1;
   assign ram1_bwe_b = 4'hF;

   // clock_feedback_out will be assigned by ramclock
   // assign clock_feedback_out = 1'b0;  //2011-Nov-10
   // clock_feedback_in is an input
   
   // Flash ROM
   assign flash_data = 16'hZ;
   assign flash_address = 24'h0;
   assign flash_ce_b = 1'b1;
   assign flash_oe_b = 1'b1;
   assign flash_we_b = 1'b1;
   assign flash_reset_b = 1'b0;
   assign flash_byte_b = 1'b1;
   // flash_sts is an input

   // RS-232 Interface
   assign rs232_txd = 1'b1;
   assign rs232_rts = 1'b1;
   // rs232_rxd and rs232_cts are inputs

   // PS/2 Ports
   // mouse_clock, mouse_data, keyboard_clock, and keyboard_data are inputs

   // LED Displays
/*
   assign disp_blank = 1'b1;
   assign disp_clock = 1'b0;
   assign disp_rs = 1'b0;
   assign disp_ce_b = 1'b1;
   assign disp_reset_b = 1'b0;
   assign disp_data_out = 1'b0;
*/
   // disp_data_in is an input

   // Buttons, Switches, and Individual LEDs
   //lab3 assign led = 8'hFF;
   // button0, button1, button2, button3, button_enter, button_right,
   // button_left, button_down, button_up, and switches are inputs

   // User I/Os
   assign user1 = 32'hZ;
   assign user2 = 32'hZ;
   assign user3 = 32'hZ;
   assign user4 = 32'hZ;

   // Daughtercard Connectors
   assign daughtercard = 44'hZ;

   // SystemACE Microprocessor Port
   assign systemace_data = 16'hZ;
   assign systemace_address = 7'h0;
   assign systemace_ce_b = 1'b1;
   assign systemace_we_b = 1'b1;
   assign systemace_oe_b = 1'b1;
   // systemace_irq and systemace_mpbrdy are inputs

   // Logic Analyzer
   assign analyzer1_data = 16'h0;
   assign analyzer1_clock = 1'b1;
   assign analyzer2_data = 16'h0;
   assign analyzer2_clock = 1'b1;
   assign analyzer3_data = 16'h0;
   assign analyzer3_clock = 1'b1;
   assign analyzer4_data = 16'h0;
   assign analyzer4_clock = 1'b1;
			    
   ////////////////////////////////////////////////////////////////////////////
   // Demonstration of ZBT RAM as video memory

   // use FPGA's digital clock manager to produce a
   // 65MHz clock (actually 64.8MHz)
   wire clock_65mhz_unbuf,clock_65mhz;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_65mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 10
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 24
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_65mhz),.I(clock_65mhz_unbuf));

//   wire clk = clock_65mhz;  // gph 2011-Nov-10

/*   ////////////////////////////////////////////////////////////////////////////
   // Demonstration of ZBT RAM as video memory
   // use FPGA's digital clock manager to produce a
   // 40MHz clock (actually 40.5MHz)
//   wire clock_40mhz_unbuf,clock_40mhz;
//   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_40mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 2
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 3
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
//   BUFG vclk2(.O(clock_40mhz),.I(clock_40mhz_unbuf));
   //wire clk = clock_40mhz;
   */

	wire locked;
	//assign clock_feedback_out = 0; // gph 2011-Nov-10
  
//  wire clock_65mhz = clock_40mhz;
   
   ramclock rc(.ref_clock(clock_65mhz), .fpga_clock(clk),
					.ram0_clock(ram0_clk), 
					//.ram1_clock(ram1_clk),   //uncomment if ram1 is used
					.clock_feedback_in(clock_feedback_in),
					.clock_feedback_out(clock_feedback_out), .locked(locked));

   
   // power-on reset generation
   wire power_on_reset;    // remain high for first 16 clocks
   SRL16 reset_sr (.D(1'b0), .CLK(clk), .Q(power_on_reset),
		   .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   defparam reset_sr.INIT = 16'hFFFF;

   // ENTER button is user reset
   wire reset,user_reset;
   debounce db1(power_on_reset, clk, ~button_enter, user_reset);
   assign reset = user_reset | power_on_reset;

   // display module for debugging
   reg [63:0] dispdata;
   display_16hex hexdisp1(reset, clk, dispdata,
			  disp_blank, disp_clock, disp_rs, disp_ce_b,
			  disp_reset_b, disp_data_out);

   // generate basic XVGA video signals
   wire [10:0] hcount;
   wire [9:0]  vcount;
   wire hsync,vsync,blank;
   xvga xvga1(clk,hcount,vcount,hsync,vsync,blank);

   // wire up to ZBT ram
   wire [35:0] vram_write_data;
   wire [35:0] vram_read_data;
   wire [18:0] vram_addr;
   wire vram_we;

   wire ram0_clk_not_used;
   zbt_6111 zbt1(clk, 1'b1, vram_we, vram_addr,
		   vram_write_data, vram_read_data,
		   ram0_clk_not_used,   //to get good timing, don't connect ram_clk to zbt_6111
		   ram0_we_b, ram0_address, ram0_data, ram0_cen_b);

   // generate pixel value from reading ZBT memory
   wire [29:0] 	vr_pixel;
   wire [18:0] 	display_addr;

   vram_display #(100,100) /*#(192,144)*/ vd1(reset,clk,hcount,vcount,vr_pixel,
		    display_addr,vram_read_data);

   // ADV7185 NTSC decoder interface code
   // adv7185 initialization module
   adv7185init adv7185(.reset(reset), .clock_27mhz(clock_27mhz), 
		       .source(1'b0), .tv_in_reset_b(tv_in_reset_b), 
		       .tv_in_i2c_clock(tv_in_i2c_clock), 
		       .tv_in_i2c_data(tv_in_i2c_data));

   wire [29:0] ycrcb;	// video data (luminance, chrominance)
   wire [2:0] fvh;	// sync for field, vertical, horizontal
   wire       dv;	// data valid
   
   ntsc_decode decode (.clk(tv_in_line_clock1), .reset(reset),
		       .tv_in_ycrcb(tv_in_ycrcb[19:10]), 
		       .ycrcb(ycrcb), .f(fvh[2]),
		       .v(fvh[1]), .h(fvh[0]), .data_valid(dv));

   // code to write NTSC data to video memory
   wire [18:0] ntsc_addr;
   wire [35:0] ntsc_data;
   wire ntsc_we;
   ntsc_to_zbt n2z (clk, tv_in_line_clock1, fvh, dv, ycrcb[29:0],
		    ntsc_addr, ntsc_data, ntsc_we);

   // mux selecting read/write to memory based on which write-enable is chosen

	//switch between write and read mode
  //wire 	sw_ntsc = ~switch[7];
  //wire 	stored;
  
  wire sw_ntsc, stored;
  
  debounce db2(.reset(reset),.clk(clock_65mhz),.noisy(~switch[7]),.clean(sw_ntsc));
  debounce db3(.reset(reset),.clk(clock_65mhz),.noisy(switch[6]),.clean(stored));

//	wire 	sw_ntsc;
//	reg [20:0] hope=0;
//	reg clicker=0;
//	always @(posedge clk) begin
//		if (hope==0) begin
//			clicker<=!clicker; 
//			hope<=1;
//			end
//		else begin
//			hope<=hope+1;
//		end
//	end
//	assign sw_ntsc = clicker;

   wire [35:0] 	write_data = ntsc_data;
	//address is either chosen by camera or display
   assign 	vram_addr = sw_ntsc ? ntsc_addr : display_addr;
	//write enable when in write mode and camera wants to write
   assign 	vram_we = sw_ntsc & ntsc_we;
   assign 	vram_write_data = write_data;

//	wire [23:0] vr_pixel_color;
//
//  zbt_6111_wrapper zbt_wrapper(
//    .clock_27mhz        (clock_27mhz),
//    .clock_65mhz        (clock_65mhz),
//    .clk                (clk),
//    .reset              (reset),
//    .tv_in_reset_b      (tv_in_reset_b),
//		.tv_in_i2c_clock    (tv_in_i2c_clock),
//		.tv_in_i2c_data     (tv_in_i2c_data),
//    .tv_in_line_clock1  (tv_in_line_clock1),
//    //.clock_feedback_in  (clock_feedback_in),
//    
//    .sw_ntsc            (sw_ntsc),
//    .stored             (stored),
//    
//    .hcount             (hcount),
//    .vcount             (vcount),
//    
//    .ram0_we_b          (ram0_we_b),
//    .ram0_address       (ram0_address),
//    .ram0_data          (ram0_data),
//    .ram0_cen_b         (ram0_cen_b),
//    
//    //.clock_feedback_out (clock_feedback_out),
//    .vr_pixel_color     (vr_pixel_color),
//    .dispdata           (dispdata)
//  );

   // select output pixel data
   reg [23:0] pixel=0;
	 wire [23:0] vr_pixel_color;
   reg 	b,hs,vs;
	//wire [7:0] my_din, my_dout;
	//wire [17:0] my_addr;
	//wire my_wea;
  //wire [23:0] rgb_out;
	//wire [7:0] rgbhope;
	//assign my_din=rgbhope[7:0];
   
	ycrcb2rgb colCvt(vr_pixel[29:20],vr_pixel[19:10],vr_pixel[9:0],
							vr_pixel_color[23:16],vr_pixel_color[15:8],vr_pixel_color[7:0], clk, 1'b0); 
  
  wire [23:0] pixel_hsv, pixel_rgb;
  wire [10:0] hcount_d1, hcount_d2;
  wire [9:0] vcount_d1, vcount_d2;
  
  reg [23:0] vr_pixel_color_reg; // change here...
  
  always @(negedge clk) vr_pixel_color_reg <= vr_pixel_color; // change here...
  
  rgb2hsv rgb2hsv_conv(.clock(clk), .reset(reset),
    .r(vr_pixel_color[23:16]), .b(vr_pixel_color[15:8]), .g(vr_pixel_color[7:0]),
    .h(pixel_hsv[23:16]), .s(pixel_hsv[15:8]), .v(pixel_hsv[7:0]));
    
  //wire is_green = (pixel_hsv[23:16] > 8'd40) && (pixel_hsv[23:16] < 8'd90);
  
  reg [23:0] pixel_hsv_in;
  
  always @(posedge clk) begin
    pixel_hsv_in <= ((pixel_hsv[23:16] > 8'd60) && (pixel_hsv[23:16] < 8'd130)) ? 0 : pixel_hsv;
  end
      
  hsv2rgb hsv2rgb_conv(.clk(clk), .rst(reset),
      .h(pixel_hsv_in[23:16]), .s(pixel_hsv_in[15:8]), .v(pixel_hsv_in[7:0]),
      .r(pixel_rgb[23:16]), .g(pixel_rgb[15:8]), .b(pixel_rgb[7:0]));
      
  //delay#(.DELAY(32), .SIZE(24)) hcount_delay1(.clk(clk), .din(vr_pixel_color), .dout(pixel_rgb));
  
  //delay#(.DELAY(32), .SIZE(11)) hcount_delay1(.clk(clk), .din(hcount), .dout(hcount_d2));
  //delay#(.DELAY(9), .SIZE(11)) hcount_delay2(.clk(clk), .din(hcount_d1), .dout(hcount_d2));

  //delay#(.DELAY(32), .SIZE(10)) vcount_delay1(.clk(clk), .din(vcount), .dout(vcount_d2));
  //delay#(.DELAY(9), .SIZE(10)) vcount_delay2(.clk(clk), .din(vcount_d1), .dout(vcount_d2));
    
  //wire in_display_wr = hcount_d2 < 640 && vcount_d2 < 400;
  wire in_display_wr = hcount < 640 && vcount < 400;
  wire in_display_rd = hcount < 640 && vcount < 400;
  
  wire [7:0] my_din, my_dout;
//  wire [17:0] my_addr;

  reg [17:0] my_addr = 0;
//  wire my_wea;
  reg my_wea;
  reg switch_high = 0;
  reg started = 0;
  reg started_wr = 0;
  reg started_rd = 0;
  reg [17:0] my_addr_q = 0;
  reg pixel_d = 0;
  
  reg sw_ntsc_d;

  
  //reg loading_bram = 0;
  //reg frame_loaded_q;
  
  reg [17:0] write_counter = 0; 
  reg [17:0] read_counter = 0; 
  reg bram_loaded = 0;
  
  wire [17:0] write_counter_d2;
  wire started_d2;
  
  wire frame_loaded = (write_counter == 18'd255999);
  
  reg [31*18-1:0] my_addr_shift_reg = 0;
  reg [31:0] my_wea_shift_reg = 0;
  
  //bram_ip mybram(clk, my_din, my_addr, my_wea_shift_reg[0], my_dout);  
  bram_ip mybram(clk, my_din, my_addr_shift_reg[31*18-1:30*18], my_wea_shift_reg[31], my_dout);
  //bram_ip mybram(clk, my_din, my_addr, my_wea, my_dout);
  
////  assign my_wea = !frame_loaded && started && in_display_wr;  
//  assign my_addr = (!frame_loaded) ? write_counter : read_counter;
  
  assign my_din = {pixel_rgb[23:21],pixel_rgb[15:13],pixel_rgb[7:6]};
  //assign my_din = {vr_pixel_color[23:21],vr_pixel_color[15:13],vr_pixel_color[7:6]};
  
  always @(posedge clk) begin
    sw_ntsc_d <= sw_ntsc;

  my_addr <= (!frame_loaded) ? write_counter : read_counter;
  my_wea <= !frame_loaded && started && in_display_wr;  
  
    my_wea_shift_reg <= {my_wea_shift_reg[31:1], my_wea};
    my_addr_shift_reg <= {my_addr_shift_reg[31*18-1:18], my_addr};
    
    if (!switch_high) begin
      write_counter <= 0;
      read_counter <= 0;
      if (sw_ntsc_d && !sw_ntsc) switch_high <= 1;
    end else begin
      if (frame_loaded && in_display_rd) read_counter <= (read_counter == 18'd255999) ? 0 : read_counter+1'b1;
      if (!sw_ntsc_d && sw_ntsc) switch_high <= 0;
      
      if (started) begin
        if (my_wea) write_counter <= write_counter+1'b1;
        if (frame_loaded) started <= 0;
      end else if ((hcount==0) && (vcount==0)) started <= 1;
    end
  end
    
	reg hsync_delay[2:0];
	reg blank_delay[2:0];
	reg vsync_delay[2:0];
  
  wire hs_d, vs_d, b_d;
  
  //delay#(.DELAY(31), .SIZE(1)) hs_delay1(.clk(clk), .din(hs), .dout(hs_d));
  //delay#(.DELAY(31), .SIZE(1)) vs_delay1(.clk(clk), .din(vs), .dout(vs_d));
  //delay#(.DELAY(31), .SIZE(1)) b_delay1(.clk(clk), .din(b), .dout(b_d));
  
  parameter YCRCB2RGB_PD = 4;
  parameter RGB2HSV_PD = 23;
  parameter HSV2RGB_PD = 10;
  
  parameter SHIFT_DELAY = YCRCB2RGB_PD + RGB2HSV_PD + HSV2RGB_PD + 1;
  
  reg [0:0] hsync_shift_reg[SHIFT_DELAY-1:0];
  reg [0:0] vsync_shift_reg[SHIFT_DELAY-1:0];
  reg [0:0] blank_shift_reg[SHIFT_DELAY-1:0];
  
  integer i;

  always @(posedge clk) begin
		//pixel <= sw_ntsc ? 0 : (in_display_rd ? {my_dout[7:5],5'd0,my_dout[4:2],5'd0,my_dout[1:0],6'd0} : 24'hFFFFFF);
    pixel <= sw_ntsc ? 0 : pixel_rgb;
    //pixel <= sw_ntsc ? 0 : vr_pixel_color;
		//pixel <= vr_pixel_color;
		//pixel <= hope ? 0 : vr_pixel_color;
		//b <= blank;
		//hs <= hsync;
		//vs <= vsync;
		//{hsync_delay[2],hsync_delay[1],hsync_delay[0]} <= {hsync_delay[1],hsync_delay[0], hs};
		//{vsync_delay[2],vsync_delay[1],vsync_delay[0]} <= {vsync_delay[1],vsync_delay[0], vs};
		//{blank_delay[2],blank_delay[1],blank_delay[0]} <= {blank_delay[1],blank_delay[0], b};
    
    //hsync_shift_reg[31:0] <= {hsync_shift_reg[31:1], hsync_delay[2]};
    //vsync_shift_reg[31:0] <= {vsync_shift_reg[31:1], vsync_delay[2]};
    //blank_shift_reg[31:0] <= {blank_shift_reg[31:1], blank_delay[2]};

    
    hsync_shift_reg[0] <= hsync; //_delay[2];
    vsync_shift_reg[0] <= vsync; //_delay[2];
    blank_shift_reg[0] <= blank; //_delay[2];
    
    for (i=1; i<SHIFT_DELAY; i=i+1) begin
      hsync_shift_reg[i] <= hsync_shift_reg[i-1];
      vsync_shift_reg[i] <= vsync_shift_reg[i-1];
      blank_shift_reg[i] <= blank_shift_reg[i-1];
    end
  end

   // VGA Output.  In order to meet the setup and hold times of the
   // AD7125, we send it ~clk.
   assign vga_out_red = pixel[23:16];
   assign vga_out_green = pixel[15:8];
   assign vga_out_blue = pixel[7:0];
   assign vga_out_sync_b = 1'b1;    // not used
   assign vga_out_pixel_clock = ~clk;
   assign vga_out_blank_b = ~blank_shift_reg[SHIFT_DELAY-1];
   assign vga_out_hsync = hsync_shift_reg[SHIFT_DELAY-1];
   assign vga_out_vsync = vsync_shift_reg[SHIFT_DELAY-1];

   // debugging
   //assign led = ~{vram_addr[18:13],reset,switch[0]};
   assign led = ~{6'b000000,reset,switch[0]};

	 //displayed on hex display for debugging
   always @(posedge clk)
     // dispdata <= {vram_read_data,9'b0,vram_addr};
     dispdata <= hcount;

endmodule


