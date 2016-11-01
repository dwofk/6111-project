module charactermaker
   #(parameter WIDTH = 64,            // default width: 64 pixels
               HEIGHT = 64,           // default height: 64 pixels
               COLOR = 24'hFF_FF_FF)  // default color: white
   (input [10:0] x,hcount,
    input [9:0] y,vcount,
    input [4:0] lettersel,
    output reg [23:0] pixel);
always @ * begin
	case(lettersel) //0-25 is alphabet 26=! 27=
      if ((hcount >= x && hcount < (x+WIDTH)) &&
	 (vcount >= y && vcount < (y+HEIGHT)))
	pixel = COLOR;
      else pixel = 0;
   end
endmodule
`timescale 1ns/1ps

module font_rom(
	addr,
	clk,
	dout);


input [10 : 0] addr;
input clk;
output [7 : 0] dout;

// synopsys translate_off

      BLKMEMSP_V6_1 #(
		11,	// c_addr_width
		"0",	// c_default_data
		1536,	// c_depth
		0,	// c_enable_rlocs
		0,	// c_has_default_data
		0,	// c_has_din
		0,	// c_has_en
		0,	// c_has_limit_data_pitch
		0,	// c_has_nd
		0,	// c_has_rdy
		0,	// c_has_rfd
		0,	// c_has_sinit
		0,	// c_has_we
		18,	// c_limit_data_pitch
		"font_rom.mif",	// c_mem_init_file
		0,	// c_pipe_stages
		0,	// c_reg_inputs
		"0",	// c_sinit_value
		8,	// c_width
		0,	// c_write_mode
		"0",	// c_ybottom_addr
		1,	// c_yclk_is_rising
		1,	// c_yen_is_high
		"hierarchy1",	// c_yhierarchy
		0,	// c_ymake_bmm
		"16kx1",	// c_yprimitive_type
		1,	// c_ysinit_is_high
		"1024",	// c_ytop_addr
		0,	// c_yuse_single_primitive
		1,	// c_ywe_is_high
		1)	// c_yydisable_warnings
	inst (
		.ADDR(addr),
		.CLK(clk),
		.DOUT(dout),
		.DIN(),
		.EN(),
		.ND(),
		.RFD(),
		.RDY(),
		.SINIT(),
		.WE());


// synopsys translate_on

// FPGA Express black box declaration
// synopsys attribute fpga_dont_touch "true"
// synthesis attribute fpga_dont_touch of font_rom is "true"

// XST black box declaration
// box_type "black_box"
// synthesis attribute box_type of font_rom is "black_box"

endmodule

// Display an ASCII encoded character string in a video window at some
// specified x,y pixel location.
//
// INPUTS:
//
//   vclock       - video pixel clock
//   hcount       - horizontal (x) location of current pixel
//   vcount       - vertical (y) location of current pixel
//   cstring      - character string to display (8 bit ASCII for each char)
//   cx,cy        - pixel location (upper left corner) to display string at
//
// OUTPUT:
//
//   pixel        - video pixel value to display at current location
//
// PARAMETERS:
//
//   NCHAR        - number of characters in string to display
//   NCHAR_BITS   - number of bits to specify NCHAR
//
// pixel should be OR'ed (or XOR'ed) to your video data for display.
//
// Each character is 8x12, but pixels are doubled horizontally and vertically
// so fonts are magnified 2x.  On an XGA screen (1024x768) you can fit
// 64 x 32 such characters.
//
// Needs font_rom.v and font_rom.ngo
//
// For different fonts, you can change font_rom.  For different string 
// display colors, change the assignment to cpixel.


//////////////////////////////////////////////////////////////////////////////
//
// video character string display
//
//////////////////////////////////////////////////////////////////////////////

module char_string_display (vclock,hcount,vcount,pixel,cstring,cx,cy);

   parameter NCHAR = 8;	// number of 8-bit characters in cstring
   parameter NCHAR_BITS = 3; // number of bits in NCHAR

   input vclock;	// 65MHz clock
   input [10:0] hcount;	// horizontal index of current pixel (0..1023)
   input [9:0] 	vcount; // vertical index of current pixel (0..767)
   output [2:0] pixel;	// char display's pixel
   input [NCHAR*8-1:0] cstring;	// character string to display
   input [10:0] cx;
   input [9:0] 	cy;

   // 1 line x 8 character display (8 x 12 pixel-sized characters)

   wire [10:0] 	hoff = hcount-1-cx;
   wire [9:0] 	voff = vcount-cy;
   wire [NCHAR_BITS-1:0] column = NCHAR-1-hoff[NCHAR_BITS-1+4:4];  // < NCHAR
   wire [2:0] 	h = hoff[3:1];            // 0 .. 7
   wire [3:0] 	v = voff[4:1];		  // 0 .. 11

   // look up character to display (from character string)
   reg [7:0]  char;
   integer  n;
   always @(*) 
     for (n=0 ; n<8 ; n = n+1 )		// 8 bits per character (ASCII)
       char[n] <= cstring[column*8+n];

   // look up raster row from font rom
   wire reverse = char[7];
   wire [10:0] font_addr = char[6:0]*12 + v;    // 12 bytes per character
   wire [7:0]  font_byte;
   font_rom f(font_addr,vclock,font_byte);

   // generate character pixel if we're in the right h,v area
   wire [2:0] cpixel = (font_byte[7 - h] ^ reverse) ? 7 : 0;
   wire dispflag = ((hcount > cx) & (vcount >= cy) & (hcount <= cx+NCHAR*16)
		    & (vcount < cy + 24));
   wire [2:0] pixel = dispflag ? cpixel : 0;

endmodule