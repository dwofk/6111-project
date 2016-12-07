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
         
  `include "param.v"

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
   assign user1[31:1] = 31'hZ;
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

/*   // use FPGA's digital clock manager to produce a
   // 65MHz clock (actually 64.8MHz)
   wire clock_65mhz_unbuf,clock_65mhz;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_65mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 10
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 24
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_65mhz),.I(clock_65mhz_unbuf));*/

//   wire clk = clock_65mhz;  // gph 2011-Nov-10

   ////////////////////////////////////////////////////////////////////////////
   // Demonstration of ZBT RAM as video memory
   // use FPGA's digital clock manager to produce a
   // 40MHz clock (actually 40.5MHz)
   wire clock_40mhz_unbuf,clock_40mhz;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_40mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 2
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 3
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_40mhz),.I(clock_40mhz_unbuf));
   //wire clk = clock_40mhz;

	wire locked;
	//assign clock_feedback_out = 0; // gph 2011-Nov-10
  
  wire clock_65mhz = clock_40mhz; // when switching from 1024x768 to 800x600
   
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

   // ENTER button is user reset ---> (DISABLED)
   wire reset,user_reset;
   //debounce db1(power_on_reset, clk, ~button_enter, user_reset);
	assign user_reset = 1'b0;
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

   vram_display #(1,0) /*#(192,144)*/ vd1(reset,clk,hcount,vcount,vr_pixel,
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
        
  ////////////////////////////////////////////////////////////////////////////
  //
  // Input Buttons & Switches
  //
  ////////////////////////////////////////////////////////////////////////////
  
  wire sw_ntsc, enhance_en, filters_en, store_bram;   // editing & storage
  wire text_en, graphics_en, move_sw, custom_text_en; // text & graphics
  wire up, down, left, right, enter;
  wire select0, select1, select2, select3;
  
  debounce db2(.reset(reset),.clk(clock_65mhz),.noisy(~switch[7]),.clean(sw_ntsc));
  debounce db3(.reset(reset),.clk(clock_65mhz),.noisy(switch[6]),.clean(enhance_en));
  debounce db4(.reset(reset),.clk(clock_65mhz),.noisy(switch[5]),.clean(filters_en));
  debounce db5(.reset(reset),.clk(clock_65mhz),.noisy(switch[4]),.clean(text_en));
  debounce db6(.reset(reset),.clk(clock_65mhz),.noisy(switch[3]),.clean(graphics_en));
  debounce db7(.reset(reset),.clk(clock_65mhz),.noisy(switch[2]),.clean(move_sw));
  debounce db8(.reset(reset),.clk(clock_65mhz),.noisy(switch[1]),.clean(custom_text_en));
  debounce db9(.reset(reset),.clk(clock_65mhz),.noisy(switch[0]),.clean(store_bram));

  debounce db10(.reset(reset),.clk(clock_65mhz),.noisy(~button_up),.clean(up));
  debounce db11(.reset(reset),.clk(clock_65mhz),.noisy(~button_down),.clean(down));
  debounce db12(.reset(reset),.clk(clock_65mhz),.noisy(~button_left),.clean(left));
  debounce db13(.reset(reset),.clk(clock_65mhz),.noisy(~button_right),.clean(right));
  debounce db14(.reset(reset),.clk(clock_65mhz),.noisy(~button_enter),.clean(enter));
   
  debounce db15(.reset(reset),.clk(clock_65mhz),.noisy(~button0),.clean(select0));
  debounce db16(.reset(reset),.clk(clock_65mhz),.noisy(~button1),.clean(select1));
  debounce db17(.reset(reset),.clk(clock_65mhz),.noisy(~button2),.clean(select2));
  debounce db18(.reset(reset),.clk(clock_65mhz),.noisy(~button3),.clean(select3));

  wire move_text_en;      // when move_sw is low
  wire move_graphics_en;  // when move_sw is high
  assign {move_text_en, move_graphics_en} = {~move_sw, move_sw};
  
  wire sw_ntsc_n = ~sw_ntsc;
  
  ////////////////////////////////////////////////////////////////////////////

   wire [35:0] 	write_data = ntsc_data;
	//address is either chosen by camera or display
   assign 	vram_addr = sw_ntsc ? ntsc_addr : display_addr;
	//write enable when in write mode and camera wants to write
   assign 	vram_we = sw_ntsc & ntsc_we;
   assign 	vram_write_data = write_data;

  ////////////////////////////////////////////////////////////////////////////
  //
  // Display Signals for BRAM Frame
  //
  ////////////////////////////////////////////////////////////////////////////
   
//  parameter H_OFFSET = 10'd40;
//  parameter V_OFFSET = 9'd0;
//  
//  parameter H_MAX_DISPLAY = 10'd640;
//  parameter V_MAX_DISPLAY = 9'd400;
  
  wire hcount_in_display_bram = (hcount >= H_OFFSET) && (hcount < (H_MAX_DISPLAY+H_OFFSET));
  wire vcount_in_display_bram = (vcount >= V_OFFSET) && (vcount < (V_MAX_DISPLAY+V_OFFSET));
  wire in_display_bram = hcount_in_display_bram && vcount_in_display_bram;
  
  ////////////////////////////////////////////////////////////////////////////
  //
  // Main FSM
  //
  ////////////////////////////////////////////////////////////////////////////
  
  wire [2:0] fsm_state;
  
  main_fsm fsm1(
    .clk        (clk),
    .rst        (reset),
    //.fsm_reset  (fsm_reset),
    .sw_ntsc    (sw_ntsc_n),
    .enter      (enter),
    .store_bram (store_bram),
    .fsm_state  (fsm_state)
  );
  
  ////////////////////////////////////////////////////////////////////////////
  //
  // Background Selection
  //
  ////////////////////////////////////////////////////////////////////////////   
   
  // determine which background was selected
  reg [2:0] background_q;
  wire [2:0] background = background_q;
  wire sel_all = select0 && select1 && select2 && select3;
  
  always @(posedge clk) begin
    if ((fsm_state == SEL_BKGD) && select0) background_q <= PARIS;
    if ((fsm_state == SEL_BKGD) && select1) background_q <= ROME;
    if ((fsm_state == SEL_BKGD) && select2) background_q <= AMAZON;
    if ((fsm_state == SEL_BKGD) && select3) background_q <= LONDON;
    if ((fsm_state == SEL_BKGD) && sel_all) background_q <= NO_BKD;
  end
  
  ////////////////////////////////////////////////////////////////////////////
  //
  // Custom Text
  //
  ////////////////////////////////////////////////////////////////////////////
  
  wire [CUSTOM_TEXT_MAXLEN*8-1:0] char_array;
  wire char_array_rdy;
  
  wire keyboard_waiting;
  wire [5:0] num_char;

  //wire [CUSTOM_TEXT_MAXLEN*5-1:0] letter_array;
  //wire letter_array_rdy;
  
  custom_text #(CUSTOM_TEXT_MAXLEN) custom_text1(
    .clock_27mhz          (clock_27mhz),
    .reset                (reset),
    .custom_text_en       (custom_text_en),
    .fsm_state            (fsm_state),
    .button_enter         (enter),
    .keyboard_clock       (keyboard_clock),
    .keyboard_data        (keyboard_data),
    .char_array           (char_array),
    //.letter_array         (letter_array),
    .keyboard_waiting     (keyboard_waiting),
    .char_array_rdy       (char_array_rdy),
    //.letter_array_rdy     (letter_array_rdy),
    .num_char             (num_char)
  );
  
  ////////////////////////////////////////////////////////////////////////////
  //
  // Output Pixel
  //
  ////////////////////////////////////////////////////////////////////////////
  
  wire [23:0] pixel_out;
  wire         blank_out;
  wire         hsync_out;
  wire         vsync_out;
  wire [7:0]  bram_dout;
  wire [1:0]  bram_state;
  
  wire [10:0] text_x_pos;
  wire [9:0] text_y_pos;
  wire [10:0] graphics_x_pos;
  wire [9:0] graphics_y_pos;
  
  wire [7:0] thr_range, h_thr, s_thr, v_thr;

  wire [7:0] s_offset, v_offset;
  wire s_dir, v_dir;
  
  wire [2:0] selected_filter;
  wire [1:0] selected_graphic;
  
  //wire [7:0] a0;
    
  pixel_sel #(CUSTOM_TEXT_MAXLEN) pixel_sel1(
    .clk          (clk),
    .reset        (reset),
    // states
    .fsm_state    (fsm_state),
    .bram_state   (bram_state),
    // user switch inputs
    .sw_ntsc      (sw_ntsc),
    .store_bram   (store_bram),
    .enhance_en   (enhance_en),
    .filters_en   (filters_en),
    .text_en      (text_en),
    .graphics_en  (graphics_en),
    .move_text_en (move_text_en),
    .move_graphics_en (move_graphics_en),
    .custom_text_en (custom_text_en),
    // user button inputs
    .up           (up),
    .down         (down),
    .left         (left),
    .right        (right),
    //.center       (enter),
    .select0      (select0),
    .select1      (select1),
    .select2      (select2),
    .select3      (select3),
    .background   (background),
    // custom text gen inputs
    .num_char         (num_char),
    .char_array_rdy   (char_array_rdy),
    .char_array       (char_array),
    // pixel value inputs
    .vr_pixel     (vr_pixel),
    .bram_dout    (bram_dout),
    // VGA timing signals
    .hcount       (hcount),
    //.hoffset      (H_OFFSET),
    //.hmax         (H_MAX_DISPLAY),
    .vcount       (vcount),
    //.voffset      (V_OFFSET),
    //.vmax         (V_MAX_DISPLAY),
    .blank        (blank),
    .hsync        (hsync),
    .vsync        (vsync),
    .in_display_bram(in_display_bram),
    // VGA outputs
    .pixel_out    (pixel_out),
    .blank_out    (blank_out),
    .hsync_out    (hsync_out),
    .vsync_out    (vsync_out),
    .text_x_pos   (text_x_pos),
    .text_y_pos   (text_y_pos),
    .graphics_x_pos   (graphics_x_pos),
    .graphics_y_pos   (graphics_y_pos),
    // Hex Display outputs
    .thr_range    (thr_range),
    .h_thr        (h_thr),
    .v_thr        (v_thr),
    .s_thr        (s_thr),
    // Image Enhancement outputs
    .s_offset           (s_offset),
    .v_offset           (v_offset),
    .s_dir              (s_dir),
    .v_dir              (v_dir),
    // User Selections
    .selected_filter    (selected_filter),
    .selected_graphic   (selected_graphic)
    //.a0           (a0)
  );
  
  ////////////////////////////////////////////////////////////////////////////
  //
  // BRAM-Based Frame Buffer
  //
  ////////////////////////////////////////////////////////////////////////////
  
  //wire [1:0] bram_state;
  wire [17:0] bram_tx_counter;
  //wire transmitting = (fsm_state == SEND_TO_PC);
  
  frame_bram_ifc frame_bram(
    .clk         (clk),
    .rst         (1'b0),
    .store_bram  (store_bram),
    .hcount      (hcount),
    .vcount      (vcount),
    .hoffset     (H_OFFSET),
    .voffset     (V_OFFSET),
    .in_display  (in_display_bram),
    .pixel_out   (pixel_out),
    .fsm_state   (fsm_state),
    .tx_counter  (bram_tx_counter),
    //.transmitting(transmitting),
    .bram_dout   (bram_dout),
    .bram_state  (bram_state)
  );
  
  ////////////////////////////////////////////////////////////////////////////
  //
  // UART TX
  //
  ////////////////////////////////////////////////////////////////////////////


  localparam TX_RED = 2;
  localparam TX_GREEN = 0;
  localparam TX_BLUE = 1;

  reg [17:0] uart_tx_counter_q = 0;
  assign bram_tx_counter = (uart_tx_counter_q < 18'd256000) ? uart_tx_counter_q : 0;
 
  reg [1:0] rgb_tx_state_q = 0;
  
  // UART signals
  wire uart_reset, uart_tx_en;
  wire [7:0] uart_tx_data_in;
  wire uart_tx_bit_out;
  wire [3:0] uart_tx_bit_ctr;
  wire uart_tx_busy;
  
  uart_tx uart_tx1(
    .clk      (clock_65mhz),
    .rst      (uart_reset),
    .tx_en    (uart_tx_en),
    .data_in  (uart_tx_data_in),
    .bit_out  (uart_tx_bit_out),
    .tx_busy  (uart_tx_busy),
    .bit_ctr  (uart_tx_bit_ctr)
   );
  
  assign uart_reset = (fsm_state == FSM_IDLE);
  
  wire frame_tx_done = (uart_tx_counter_q == 18'd256000);
  assign uart_tx_en = (fsm_state == SEND_TO_PC) && !frame_tx_done;

  assign uart_tx_data_in = (rgb_tx_state_q == TX_RED) ? {bram_dout[7:5], 5'd0} :
                            (rgb_tx_state_q == TX_GREEN) ? {bram_dout[4:2], 5'd0} :
                            (rgb_tx_state_q == TX_BLUE) ? {bram_dout[1:0], 6'd0} : 8'd0;
      
   always @(posedge clk) begin
      if (uart_reset) begin
        uart_tx_counter_q <= 0;
        rgb_tx_state_q <= 0;
      end else if (uart_tx_bit_ctr == 4'd1) begin
        if (uart_tx_en) rgb_tx_state_q <= (rgb_tx_state_q == 2'b10) ? 2'b00 : rgb_tx_state_q+1;
        if (rgb_tx_state_q == 2'b10) uart_tx_counter_q <= uart_tx_counter_q + 1'b1;
      end   
   end
   
   assign user1[0] = uart_tx_bit_out; 
   //assign user1[0] = uart_tx;
  
  ////////////////////////////////////////////////////////////////////////////
  //
  // VGA Output
  //
  ////////////////////////////////////////////////////////////////////////////

   // In order to meet the setup and hold times of the AD7125, we send it ~clk.
   assign vga_out_red = pixel_out[23:16];
   assign vga_out_green = pixel_out[15:8];
   assign vga_out_blue = pixel_out[7:0];
   assign vga_out_sync_b = 1'b1;    // not used
   assign vga_out_pixel_clock = ~clk;
   assign vga_out_blank_b = ~blank_out;
   assign vga_out_hsync = hsync_out;
   assign vga_out_vsync = vsync_out;

  ////////////////////////////////////////////////////////////////////////////
  //
  // LED and HEX16 Display
  //
  ////////////////////////////////////////////////////////////////////////////
  
   assign led = ~{bram_state, background[1:0], selected_filter[1:0], selected_graphic};

   // debugging
   //assign led = ~{vram_addr[18:13],reset,switch[0]};
   //assign led = ~{bram_state,store_bram,fsm_state,move_text_en,move_graphics_en};
   //assign led = ~{5'b00000, uart_wr_i, uart_busy, uart_tx};
   //assign led = ~{1'b0, num_char, char_array_rdy, keyboard_waiting};
   //assign led = ~{1'b0, num_char, letter_array_rdy, keyboard_waiting};

   //integer d;
   
	 //displayed on hex display for debugging
   always @(posedge clk) begin
     case (fsm_state)
      FSM_IDLE      : begin
                        dispdata[63:60] <= 4'hF;
                        dispdata[59:0] <= 0;
                      end
      SEL_BKGD      : begin
                        dispdata[63:60] <= 4'hD;
                        // output threshold range + hue + saturation + value/brightness thresholds
                        dispdata[59:0] <= {4'h0, thr_range, 4'h0, h_thr, 4'h0, s_thr, 4'h0, v_thr};
                      end
      COLOR_EDITS   : begin
                        dispdata[63:60] <= 4'hC;
                        dispdata[59:24] <= 0;
                        dispdata[23:0] <= {3'b000, s_dir, s_offset, 3'b000, v_dir, v_offset};
                      end
      ADD_EDITS     : begin
                        dispdata[63:60] <= 4'hA;
                        // output number of characters in custom text input
                        dispdata[59:48] <= {8'h00, 3'b000, num_char};
                        // output coordinates of overlapping text
                        dispdata[48:24] <= {1'b0, text_x_pos, 2'b00, text_y_pos};
                        // output coordinates of overlapping graphics
                        dispdata[23:0] <= {1'b0, graphics_x_pos, 2'b00, graphics_y_pos};
                      end
      SAVE_TO_BRAM  : begin
                        dispdata[63:60] <= 4'hB;
                        dispdata[59:0] <= 0;
                      end
      SEND_TO_PC    : begin
                        dispdata[63:60] <= 4'hE;
                        dispdata[59:24] <= 0;
                        dispdata[23:0] <= {4'h0, 2'b00, uart_tx_counter_q};   // num of RGB values transmitted
                      end
     endcase
     
     // dispdata <= {vram_read_data,9'b0,vram_addr};
     //dispdata <= hcount;
     //dispdata[63:56] <= {5'b00000, fsm_state};
     //dispdata[55:24] <= {thr_range, h_thr, s_thr, v_thr};
     //dispdata[23:0] <= {1'b0, text_x_pos, 2'b00, text_y_pos};
     //dispdata[63:60] <= bitcount;
     //dispdata[63:56] <= {6'b00, rgb_tx_state_q};
     //dispdata[55:0] <= {38'd0, uart_tx_counter_q};
     //dispdata[63:48] <= 0;
     //dispdata[47:0] <= (char_array_rdy) ? char_array[8*CUSTOM_TEXT_MAXLEN-1:8*(CUSTOM_TEXT_MAXLEN-6)] : 0;
     //dispdata[63:8] <= 0;
     //dispdata[7:0] <= a0;
     
   end
   
endmodule


