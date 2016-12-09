`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    18:13:32 11/29/2016 
// Design Name: 
// Module Name:    param 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Defines values for various system parameters.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// Display Parameters
parameter H_MAX_NTSC = 11'd640;      // frame size of NTSC camera input
parameter V_MAX_NTSC = 10'd480;      // frame size of NTSC camera input
//parameter HCOUNT_MAX = 11'd1056;     // for 800x600 resolution
//parameter VCOUNT_MAX = 10'd628;      // for 800x600 resolution

// FSM States
parameter FSM_IDLE = 3'b000;
parameter SEL_BKGD = 3'b001;
parameter COLOR_EDITS = 3'b010;
parameter ADD_EDITS = 3'b011;
parameter SAVE_TO_BRAM = 3'b100;
parameter SEND_TO_PC = 3'b101;

// BRAM States
parameter BRAM_IDLE = 2'b00;
parameter CAPTURE_FRAME = 2'b01;
parameter WRITING_FRAME = 2'b10;
parameter READING_FRAME = 2'b11;

// Backgrounds
parameter PARIS = 3'b000;
parameter ROME = 3'b001;
parameter AMAZON = 3'b010;
parameter LONDON = 3'b011;
parameter NO_BKD = 3'b100;

// Graphics
parameter MUSTACHE = 2'b00;
parameter SUNGLASSES = 2'b01;
parameter SAFARI_HAT = 2'b10;
parameter CROWN = 2'b11;

// Constants
parameter CUSTOM_TEXT_MAXLEN = 20;

// Filter Types
parameter SEPIA = 3'b000;
parameter INVERT = 3'b001;
parameter EDGE = 3'b010;
parameter CARTOON = 3'b011;
parameter GRAYSCALE = 3'b100;

// Pipeline Stages
parameter YCRCB2RGB_DLY = 4;
parameter RGB2HSV_DLY = 23;
parameter THRESHOLD_DLY = 1;
parameter HSV2RGB_DLY = 10;
parameter ENHANCE_DLY = 1;

parameter INVERT_DLY = 1;
parameter SEPIA_DLY = 4;
parameter GRAYSCALE_DLY = 3;

parameter LINE_LEN = 1056;
parameter LINE_BUF_DLY = LINE_LEN*2 + 3 + 1;
parameter SOBEL_OP_DLY = 4;
parameter EDGE_DET_DLY = 1;
parameter GAUSSIAN_DLY = 3;

parameter SOBEL_DLY = GRAYSCALE_DLY + LINE_BUF_DLY + SOBEL_OP_DLY + EDGE_DET_DLY;

// Edge Detection
parameter GRADIENT_EDGE_THRESHOLD = 15'd50; // for sketch filter effect
parameter CARTOON_EDGE_THRESHOLD = 15'd100; // for cartoon filter effect

// Sync Delay Values
parameter SYNC_DLY = YCRCB2RGB_DLY + RGB2HSV_DLY + THRESHOLD_DLY + HSV2RGB_DLY + ENHANCE_DLY + 1;
                      
parameter SYNC_DLY_SEP = SYNC_DLY + SEPIA_DLY;                              
parameter SYNC_DLY_INV = SYNC_DLY + INVERT_DLY;
parameter SYNC_DLY_GRY = SYNC_DLY + GRAYSCALE_DLY;
parameter SYNC_DLY_SBL = SYNC_DLY + SOBEL_DLY; // applies to both sketch and cartoon filter effects
                            
parameter MAX_SYNC_DLY = SYNC_DLY_SBL; // max # of stages in pipelined design

// BRAM Storage
//parameter H_OFFSET = SYNC_DLY;       // -> redefined as conditional assignment in zbt_6111_sample
parameter V_OFFSET = 10'd0;
parameter H_MAX_DISPLAY = 11'd640;   // for storage in BRAM
parameter V_MAX_DISPLAY = 10'd400;   // for storage in BRAM