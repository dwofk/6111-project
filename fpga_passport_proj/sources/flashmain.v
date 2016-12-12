///////////////////////////////////////////////////////////////////////////////
//
// Pushbutton Debounce Module (video version - 24 bits)  
//
///////////////////////////////////////////////////////////////////////////////

module debounce (input reset, clock, noisy,
                 output reg clean);

   reg [19:0] count;
   reg new;

   always @(posedge clock)
     if (reset) begin new <= noisy; clean <= noisy; count <= 0; end
     else if (noisy != new) begin new <= noisy; count <= 0; end
     else if (count == 650000) clean <= new;
     else count <= count+1;

endmodule

///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Template Toplevel Module
//
// For Labkit Revision 004
//
//
// Created: October 31, 2004, from revision 003 file
// Author: Nathan Ickes
//
///////////////////////////////////////////////////////////////////////////////
//
// CHANGES FOR BOARD REVISION 004
//
// 1) Added signals for logic analyzer pods 2-4.
// 2) Expanded "tv_in_ycrcb" to 20 bits.
// 3) Renamed "tv_out_data" to "tv_out_i2c_data" and "tv_out_sclk" to
//    "tv_out_i2c_clock".
// 4) Reversed disp_data_in and disp_data_out signals, so that "out" is an
//    output of the FPGA, and "in" is an input.
//
// CHANGES FOR BOARD REVISION 003
//
// 1) Combined flash chip enables into a single signal, flash_ce_b.
//
// CHANGES FOR BOARD REVISION 002
//
// 1) Added SRAM clock feedback path input and output
// 2) Renamed "mousedata" to "mouse_data"
// 3) Renamed some ZBT memory signals. Parity bits are now incorporated into 
//    the data bus, and the byte write enables have been combined into the
//    4-bit ram#_bwe_b bus.
// 4) Removed the "systemace_clock" net, since the SystemACE clock is now
//    hardwired on the PCB to the oscillator.
//
///////////////////////////////////////////////////////////////////////////////
//
// Complete change history (including bug fixes)
//
// 2012-Sep-15: Converted to 24bit RGB
//
// 2005-Sep-09: Added missing default assignments to "ac97_sdata_out",
//              "disp_data_out", "analyzer[2-3]_clock" and
//              "analyzer[2-3]_data".
//
// 2005-Jan-23: Reduced flash address bus to 24 bits, to match 128Mb devices
//              actually populated on the boards. (The boards support up to
//              256Mb devices, with 25 address lines.)
//
// 2004-Oct-31: Adapted to new revision 004 board.
//
// 2004-May-01: Changed "disp_data_in" to be an output, and gave it a default
//              value. (Previous versions of this file declared this port to
//              be an input.)
//
// 2004-Apr-29: Reduced SRAM address busses to 19 bits, to match 18Mb devices
//              actually populated on the boards. (The boards support up to
//              72Mb devices, with 21 address lines.)
//
// 2004-Apr-29: Change history started
//
///////////////////////////////////////////////////////////////////////////////

module lab3   (beep, audio_reset_b, ac97_sdata_out, ac97_sdata_in, ac97_synch,
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
   assign tv_in_i2c_clock = 1'b0;
   assign tv_in_fifo_read = 1'b0;
   assign tv_in_fifo_clock = 1'b0;
   assign tv_in_iso = 1'b0;
   assign tv_in_reset_b = 1'b0;
   assign tv_in_clock = 1'b0;
   assign tv_in_i2c_data = 1'bZ;
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
//
//   assign ram0_ce_b = 1'b0;
//   assign ram0_oe_b = 1'b0;
//   assign ram0_adv_ld = 1'b0;
//   assign ram0_bwe_b = 4'h0; 

/**********/

   //assign ram1_data = 36'hZ; 
   //assign ram1_address = 19'h0;
   //assign ram1_adv_ld = 1'b0;
   //assign ram1_clk = 1'b0;
   
   //These values have to be set to 0 like ram0 if ram1 is used.
   //assign ram1_cen_b = 1'b1;
   assign ram1_ce_b = 1'b0;
   assign ram1_oe_b = 1'b0;
   assign ram1_adv_ld = 1'b0;
   assign ram1_bwe_b = 4'h0;

   // clock_feedback_out will be assigned by ramclock
   // assign clock_feedback_out = 1'b0;  //2011-Nov-10
   // clock_feedback_in is an input
	
   assign ram0_data = 36'hZ;
   assign ram0_address = 19'h0;
   assign ram0_adv_ld = 1'b0;
   assign ram0_clk = 1'b0;
   assign ram0_cen_b = 1'b1;
   assign ram0_ce_b = 1'b1;
   assign ram0_oe_b = 1'b1;
   assign ram0_we_b = 1'b1;
   assign ram0_bwe_b = 4'hF;
//   assign ram1_data = 36'hZ; 
//   assign ram1_address = 19'h0;
//   assign ram1_adv_ld = 1'b0;
//   assign ram1_clk = 1'b0;
//   assign ram1_cen_b = 1'b1;
//   assign ram1_ce_b = 1'b1;
//   assign ram1_oe_b = 1'b1;
//   assign ram1_we_b = 1'b1;
//   assign ram1_bwe_b = 4'hF;
//   assign clock_feedback_out = 1'b0;
//   // clock_feedback_in is an input
   
   // Flash ROM
   //assign flash_data = 16'hZ;
   //assign flash_address = 24'h0;
   //assign flash_ce_b = 1'b1;
   //assign flash_oe_b = 1'b1;
   //assign flash_we_b = 1'b1;
   //assign flash_reset_b = 1'b0;
   //assign flash_byte_b = 1'b1;
   // flash_sts is an input

   // RS-232 Interface
   assign rs232_txd = 1'b1;
   assign rs232_rts = 1'b1;
   // rs232_rxd and rs232_cts are inputs

   // PS/2 Ports
   // mouse_clock, mouse_data, keyboard_clock, and keyboard_data are inputs

   // LED Displays
//   assign disp_blank = 1'b1;
//   assign disp_clock = 1'b0;
//   assign disp_rs = 1'b0;
//   assign disp_ce_b = 1'b1;
//   assign disp_reset_b = 1'b0;
//   assign disp_data_out = 1'b0;
   // disp_data_in is an input

   // Buttons, Switches, and Individual LEDs
   //lab3 assign led = 8'hFF;
   // button0, button1, button2, button3, button_enter, button_right,
   // button_left, button_down, button_up, and switches are inputs

   // User I/Os
   assign user1 = 32'hZ;
   assign user2 = 32'hZ;
   assign user3 = 32'hZ;
   assign user4[31:11] = 21'hZ;
	assign user4[10]=1'b1;
	

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

			    
   // use FPGA's digital clock manager to produce a
   // 65MHz clock (actually 64.8MHz)
   wire clock_65mhz_unbuf,clock_65mhz;
   DCM vclk1(.CLKIN(clock_27mhz),.CLKFX(clock_65mhz_unbuf));
   // synthesis attribute CLKFX_DIVIDE of vclk1 is 10
   // synthesis attribute CLKFX_MULTIPLY of vclk1 is 24
   // synthesis attribute CLK_FEEDBACK of vclk1 is NONE
   // synthesis attribute CLKIN_PERIOD of vclk1 is 37
   BUFG vclk2(.O(clock_65mhz),.I(clock_65mhz_unbuf));

   // power-on reset generation
   wire power_on_reset;    // remain high for first 16 clocks
   SRL16 reset_sr (.D(1'b0), .CLK(clock_65mhz), .Q(power_on_reset),
		   .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   defparam reset_sr.INIT = 16'hFFFF;

   // ENTER button is user reset
   wire reset,user_reset;
   debounce db1(.reset(power_on_reset),.clock(clock_65mhz),.noisy(~button_enter),.clean(user_reset));
   assign reset = user_reset | power_on_reset;
   
   // UP and DOWN buttons for pong paddle
   wire up,down,left,but3, but4;
   debounce db2(.reset(reset),.clock(clock_65mhz),.noisy(~button_up),.clean(up));
   debounce db3(.reset(reset),.clock(clock_65mhz),.noisy(~button_down),.clean(down));
	debounce db4(.reset(reset),.clock(clock_65mhz),.noisy(~button_left),.clean(left));
	debounce db5(.reset(reset),.clock(clock_65mhz),.noisy(~button3),.clean(but3));
	debounce db6(.reset(reset),.clock(clock_65mhz),.noisy(~button4),.clean(but4));


   
	
	//ALL THE FLASH STUFF OMG THIS IS THE WORST
	wire [15:0] wdata;
	wire [15:0] wdataold;
	wire writemode;
	wire dowrite;
	wire [22:0] raddr; // address of where we want to read from flash (playing from flash)
	reg [22:0] raddr_old;
	wire [15:0] frdata; 	//data being read
	wire doread; // tell flash to read from memory
	wire busy; // flash is busy, don't read/write when asserted
	wire [11:0] fsmstate; 
	wire dots;

	reg [4:0] flashcounter=0;
	reg [22:0] giant=0;
	wire flashreset;
	assign flashreset=switch[7]&&switch[6]&&switch[5]&&switch[4]&&switch[3]&&switch[2]&&switch[1]&&switch[0]&&up&&down&&but3&&but4;
	reg [2:0] pictsel=4;
//	assign pictsel=switch[2:0];
	always @(posedge clock_27mhz) pictsel<=switch[2:0];
	wire start;
	assign start=switch[5];
	//wire zbt_we;
	wire [22:0] flashaddr;
	wire fifo_rd_en, fifo_wr_en, fifo_empty, fifo_full;
	wire [35:0] write_data;
	reg [35:0] write_data_old;
	wire [18:0] 	display_addr;
	wire [35:0] vram_read_data;
	wire [15:0] fifodata;
	assign write_data={20'd0,frdata[15:0]};
	wire [18:0] zbtaddr;
	reg [18:0] zbtwrite=0;
	wire loaded;
	wire zbt_we;
	reg busy_old;
	reg readytostore=0;
	assign zbt_we= readytostore;
	wire image_loaded = (zbtwrite == 19'd307200);
   assign zbtaddr= loaded ? display_addr : zbtwrite;
	//assign 	vram_addr = sw_ntsc ? ntsc_addr : display_addr
	wire ram1_clk_not_used;
	reg [15:0] datatostore=0;
	zbt_6111 zbt_6111(clk, 1'b1,zbt_we,zbtaddr, {20'd0,datatostore}, vram_read_data,
							ram1_clk_not_used, ram1_we_b, ram1_address, ram1_data, ram1_cen_b);
							
	flash_manager flash(.clock(clock_27mhz), .reset(flashreset), .dots(dots), .writemode(writemode), .wdata(wdata), 
					  .dowrite(dowrite), .raddr(raddr), .frdata(frdata), .doread(doread), .busy(busy), 
					  .flash_data(flash_data), .flash_address(flash_address), .flash_ce_b(flash_ce_b), 
					  .flash_oe_b(flash_oe_b), .flash_we_b(flash_we_b), .flash_reset_b(flash_reset_b), 
					  .flash_sts(flash_sts), .flash_byte_b(flash_byte_b), .fsmstate(fsmstate));
					  
	flashreader flashreader(clock_27mhz,flashreset,busy,start,pictsel,raddr,
									writemode,dowrite,doread,wdata, loaded);
	//wire busyfalliing;
	//assign busyfalling = (~busy && busy_old);
	
	reg [15:0] frdata_q=0;
	reg [18:0] frdata_ctr_q = 0;
	reg [18:0] datathing=0;
	
	
	
//	always @(posedge clk) begin
//	  busy_old<=busy;
//	  if (~busy && busy_old) begin
//	always @(negedge busy) begin
//			if (start) frdata_ctr_q <= 0;
//			else if (~image_loaded) begin
//				frdata_q <= frdata;
//				frdata_ctr_q <= frdata_ctr_q+1;
//				datathing<=frdata_ctr_q;
//			end
//	end
//	
//	always @(posedge clk) begin
//		if (~image_loaded) readytostore <= 1;
//		else readytostore<=0;
//		zbtwrite <= frdata_ctr_q;
//		datatostore <= frdata_q;
//	end
//	
	
	
	
	always @(posedge clk) begin
		busy_old<=busy;
		if (start) zbtwrite<=0;
		if (~start && busy_old && ~busy && ~loaded) begin
				datatostore<=frdata;
				readytostore<=1;
				zbtwrite<=zbtwrite+1;
				datathing<=datathing+1;
			end 
		else readytostore<=0;
	end
		
		
//	reg countertry=0;
//	reg gotime;
//	reg started=0;
//	always @(posedge clock_27mhz) begin
//		//if (!busy)write_data_old<=write_data;
//		raddr_old<=raddr;
//		if  (raddr_old!=raddr) started<=1;
//		
//		if (started) countertry<=1;
//		//else countertry<=countertry+1;
//		//countertry<=countertry+1;
//		
//		if ((~loaded)&&countertry) gotime<=1;
//		else gotime<=0;
//		
//		if (gotime) begin
//			started<=0;
//			countertry<=0;
//			end
//		
//		//raddr_old<=raddr;
//		//busy_old<=busy;
//	end
//		
//	wire addchange;
//	reg readywrite=0;
//	reg triggered=0;
//	always @(posedge clk) begin
//		raddr_old<=raddr;
//		if (~addchange) begin //one clk later after not equal
//			triggered<=1;
//			readywrite<=0;end
//		if (triggered) begin //two
//			readywrite<=1;
//			triggered<=0;end
//		end
//   assign addchange	= raddr_old==raddr; //false if the address arent equal;

	
	
//	reg takeone;
//	assign fifo_rd_en = takeone;
//	assign fifo_wr_en = ~fifo_full && gotime; //three clocks after addr is changed
//	zbtfifo zbtfifo(.din(write_data[15:0]), .rd_clk(clk), .rd_en(fifo_rd_en), 
//						.rst(reset),.wr_clk(clock_27mhz),.wr_en(fifo_wr_en),
//						.dout(fifodata),.empty(fifo_empty),.full(fifo_full));
//   
	reg [23:0] counterzbt=0;
//   always @(posedge clk) begin
//		if (~fifo_empty) takeone<=1;
//		if (start) zbtwrite<=0;
//		if (!start&&takeone) begin
//			zbt_we <=1;
//			takeone<=0;
//			zbtwrite <= zbtwrite+1;
//			end
//		else zbt_we <=0;
			
//		//if (start)counterzbt<=0;
//		if (zbt_we) begin
//			zbtwrite <= zbtwrite+1;
//			counterzbt<=counterzbt+1; end
//	end
	 
	
   wire [29:0] 	vr_pixel; 
	// generate basic XVGA video signals
   wire [10:0] hcount;
   wire [9:0]  vcount;
   wire hsync,vsync,blank;
	vram_display #(0,0) vd1(reset,clk,hcount,vcount,vr_pixel,
		    display_addr,vram_read_data);
   xvga xvga1(clk,hcount,vcount,hsync,vsync,blank);
   // VGA Output.  In order to meet the setup and hold times of the
	reg [23:0] pixel;
	//reg hsync_delay[2:0];
	//reg blank_delay[2:0];
	//reg vsync_delay[2:0];
	//reg 	b,hs,vs;
   always @(posedge clk)
     begin
		pixel <= vr_pixel;
		//b <= blank; 
		//hs <= hsync;
		//vs <= vsync;
		//{hsync_delay[2],hsync_delay[1],hsync_delay[0]} <= {hsync_delay[1],hsync_delay[0], hs};
		//{vsync_delay[2],vsync_delay[1],vsync_delay[0]} <= {vsync_delay[1],vsync_delay[0], vs};
		//{blank_delay[2],blank_delay[1],blank_delay[0]} <= {blank_delay[1],blank_delay[0], b};
     end

   assign vga_out_red = {pixel[15:11],3'd0};
   assign vga_out_green = {pixel[10:5],2'd0};
   assign vga_out_blue = {pixel[4:0],3'd0};
   assign vga_out_sync_b = 1'b1;    // not used
   assign vga_out_pixel_clock = ~clock_65mhz;
   assign vga_out_blank_b = ~blank;
   assign vga_out_hsync = hsync;
   assign vga_out_vsync = vsync;


	
	
	assign led = ~{7'b0,loaded};
	wire [63:0] data_in_display; 
	assign data_in_display= {29'd0,datathing,datatostore};
	display_16hex display_16hex (power_on_reset, clk, data_in_display, 
										  disp_blank, disp_clock, disp_rs, disp_ce_b,
										  disp_reset_b, disp_data_out);
	
	
	assign analyzer1_data = 16'd0;//frdata[15:0];
   assign analyzer1_clock = 1'b1;
   assign analyzer2_data = 16'h0;
   assign analyzer2_clock = 1'b1;
   assign analyzer3_data = 16'd0; //{busy, writemode, dowrite, doread, wdata[7:0], raddr[3:0]};
   assign analyzer3_clock =  1'b1;//clock_27mhz;
   assign analyzer4_data = 16'h0;
   assign analyzer4_clock = 1'b1;
	ramclock rc(.ref_clock(clock_65mhz), .fpga_clock(clk),
					//.ram0_clock(ram0_clk), 
					.ram1_clock(ram1_clk),   //uncomment if ram1 is used
					.clock_feedback_in(clock_feedback_in),
					.clock_feedback_out(clock_feedback_out), .locked(locked));

endmodule

module vram_display #(parameter XOFFSET = 0, YOFFSET = 0) (reset,clk,hcount,vcount,vr_pixel,
		    vram_addr,vram_read_data);

   input reset, clk;
   input [10:0] hcount;
   input [9:0] 	vcount;
   output reg [29:0] vr_pixel;
   output [18:0] vram_addr;
   input [35:0]  vram_read_data;

	wire[10:0] x;
	wire[9:0] y;
	assign x = hcount - XOFFSET;
	assign y = vcount - YOFFSET;
//   //forecast hcount & vcount 2 clock cycles ahead to get data from ZBT
//   wire [10:0] hcount_f = (x >= 1048) ? x - 1048 : (x + 2);
//   wire [9:0] vcount_f = (x >= 1048) ? ((y == 805) ? 0 : y + 1) : y;
//   
//	reg [18:0] vram_addr;
//	always@(*) begin
//		if(hcount_f < 640 && vcount_f < 480) begin
//			vram_addr = {vcount_f[8:0], hcount_f[9:0]};
//			vr_pixel = vram_read_data[29:0];
//		end
//		else begin
//			vr_pixel = {10'd0,10'd512,10'd512};
//		end
//	end
   //forecast hcount & vcount 2 clock cycles ahead to get data from ZBT
   //wire [10:0] hcount_f =(x + 2);
	wire [10:0] hcount_f = (x >= 1048) ? x - 1048 : (x + 2);
   //wire [8:0] vcount_f =  y;
	wire [9:0] vcount_f = (x >= 1048) ? ((y == 805) ? 0 : y + 1) : y;
	
	//wire [10:0] hcount_f = (x == 1342) ? 0 : (x == 1343) ? 1 : (x+2);
   //wire [9:0] vcount_f = (x == 1343) ? ( (y == 804) ? 0 : (y == 805) ? 1 : y+1 ) : y;
		
	//reg [10:0] hcount_fold=0;
	reg [18:0] vram_addr=0;
	//wire [9:0] vcount_f;
	//reg [14:0] hcount_next=0;
	always@(posedge clk) begin 
		if((hcount_f < 640) && vcount_f < 480) begin
//			if (~(vcount_f!=vcount_fold)&&((hcount_f!=hcount_fold)&&~(hcount_f==0)) //hcount changed
//				linecounter<=linecounter+1;
//			if (hcount_f==0) linecounter<=0;
//			if (vcount_f!=vcount_fold)&&vcount_f!=0) begin //vcount changed
//				linecounter<=0;
//				vertcount<=vertcount+640; end
//			if (vcount_f==0) begin
//				vertcount<=0;end
			//vram_addr = (vcount_f<<9)+(vcount_f<<7)+hcount_f[10:0];
			//vram_addr = ((({vcount_f[8:0], hcount_f[9:0]})<<3)-
				//{vcount_f[8:0], hcount_f[9:0]})>>3;
			//vram_addr <= hcount_f[9:0]+vcount_f[8:0]*640;
			//hcount_next<=((hcount_f[9:0]+1)*5)>>2; 
			//vram_addr <= {vcount_f[8:0]>>1, hcount_next[9:0]};
			//vram_addr <= {vcount_f[8:0]>>1, hcount_f[9:0]};
			//if ((hcount_f==0)&&(vcount_f==0)) vram_addr<=0;
			//else vram_addr<=vram_addr+1;
			//vram_addr <= vertcount+linecounter;
			vr_pixel <= vram_read_data[29:0];
			vram_addr <= {vcount_f[8:0]>>1, hcount_f[9:0]>>1};
			//vountnext<=640*(vcount_f+1)
		end
		else begin
			vr_pixel <= {10'd0,10'd0,10'd0};
		end
	end
	
endmodule // vram_display
module ramclock(ref_clock, fpga_clock, ram0_clock, ram1_clock, 
	        clock_feedback_in, clock_feedback_out, locked);
   
   input ref_clock;                 // Reference clock input
   output fpga_clock;               // Output clock to drive FPGA logic
   output ram0_clock, ram1_clock;   // Output clocks for each RAM chip
   input  clock_feedback_in;        // Output to feedback trace
   output clock_feedback_out;       // Input from feedback trace
   output locked;                   // Indicates that clock outputs are stable
   
   wire  ref_clk, fpga_clk, ram_clk, fb_clk, lock1, lock2, dcm_reset;

   ////////////////////////////////////////////////////////////////////////////
   
   //To force ISE to compile the ramclock, this line has to be removed.
   //IBUFG ref_buf (.O(ref_clk), .I(ref_clock));
	
	assign ref_clk = ref_clock;
   
   BUFG int_buf (.O(fpga_clock), .I(fpga_clk));

   DCM int_dcm (.CLKFB(fpga_clock),
		.CLKIN(ref_clk),
		.RST(dcm_reset),
		.CLK0(fpga_clk),
		.LOCKED(lock1));
   // synthesis attribute DLL_FREQUENCY_MODE of int_dcm is "LOW"
   // synthesis attribute DUTY_CYCLE_CORRECTION of int_dcm is "TRUE"
   // synthesis attribute STARTUP_WAIT of int_dcm is "FALSE"
   // synthesis attribute DFS_FREQUENCY_MODE of int_dcm is "LOW"
   // synthesis attribute CLK_FEEDBACK of int_dcm  is "1X"
   // synthesis attribute CLKOUT_PHASE_SHIFT of int_dcm is "NONE"
   // synthesis attribute PHASE_SHIFT of int_dcm is 0
   
   BUFG ext_buf (.O(ram_clock), .I(ram_clk));
   
   IBUFG fb_buf (.O(fb_clk), .I(clock_feedback_in));
   
   DCM ext_dcm (.CLKFB(fb_clk), 
		    .CLKIN(ref_clk), 
		    .RST(dcm_reset),
		    .CLK0(ram_clk),
		    .LOCKED(lock2));
   // synthesis attribute DLL_FREQUENCY_MODE of ext_dcm is "LOW"
   // synthesis attribute DUTY_CYCLE_CORRECTION of ext_dcm is "TRUE"
   // synthesis attribute STARTUP_WAIT of ext_dcm is "FALSE"
   // synthesis attribute DFS_FREQUENCY_MODE of ext_dcm is "LOW"
   // synthesis attribute CLK_FEEDBACK of ext_dcm  is "1X"
   // synthesis attribute CLKOUT_PHASE_SHIFT of ext_dcm is "NONE"
   // synthesis attribute PHASE_SHIFT of ext_dcm is 0

   SRL16 dcm_rst_sr (.D(1'b0), .CLK(ref_clk), .Q(dcm_reset),
		     .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
   // synthesis attribute init of dcm_rst_sr is "000F";
   

   OFDDRRSE ddr_reg0 (.Q(ram0_clock), .C0(ram_clock), .C1(~ram_clock),
		      .CE (1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));
   OFDDRRSE ddr_reg1 (.Q(ram1_clock), .C0(ram_clock), .C1(~ram_clock),
		      .CE (1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));
   OFDDRRSE ddr_reg2 (.Q(clock_feedback_out), .C0(ram_clock), .C1(~ram_clock),
		      .CE (1'b1), .D0(1'b1), .D1(1'b0), .R(1'b0), .S(1'b0));

   assign locked = lock1 && lock2;
   
endmodule 

///////////////////////////////////////////////////////////////////////////////
// xvga: Generate XVGA display signals (1024 x 768 @ 60Hz)

module xvga(vclock,hcount,vcount,hsync,vsync,blank);
   input vclock;
   output [10:0] hcount;
   output [9:0] vcount;
   output 	vsync;
   output 	hsync;
   output 	blank;

   reg 	  hsync,vsync,hblank,vblank,blank;
   reg [10:0] 	 hcount;    // pixel number on current line
   reg [9:0] vcount;	 // line number

   // horizontal: 1344 pixels total
   // display 1024 pixels per line
   wire      hsyncon,hsyncoff,hreset,hblankon;
   assign    hblankon = (hcount == 1023);    
   assign    hsyncon = (hcount == 1047);
   assign    hsyncoff = (hcount == 1183);
   assign    hreset = (hcount == 1343);

   // vertical: 806 lines total
   // display 768 lines
   wire      vsyncon,vsyncoff,vreset,vblankon;
   assign    vblankon = hreset & (vcount == 767);    
   assign    vsyncon = hreset & (vcount == 776);
   assign    vsyncoff = hreset & (vcount == 782);
   assign    vreset = hreset & (vcount == 805);

   // sync and blanking
   wire      next_hblank,next_vblank;
   assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
   assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
   always @(posedge vclock) begin
      hcount <= hreset ? 0 : hcount + 1;
      hblank <= next_hblank;
      hsync <= hsyncon ? 0 : hsyncoff ? 1 : hsync;  // active low

      vcount <= hreset ? (vreset ? 0 : vcount + 1) : vcount;
      vblank <= next_vblank;
      vsync <= vsyncon ? 0 : vsyncoff ? 1 : vsync;  // active low

      blank <= next_vblank | (next_hblank & ~hreset);
   end
endmodule 