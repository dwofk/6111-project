`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:13:32 11/29/2016 
// Design Name: 
// Module Name:    param 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// FSM states
parameter FSM_IDLE = 3'b000;
parameter SEL_BKGD = 3'b001;
parameter COLOR_EDITS = 3'b010;
parameter ADD_EDITS = 3'b011;
parameter SAVE_TO_BRAM = 3'b100;
parameter SEND_TO_PC = 3'b101;

// BRAM states
parameter BRAM_IDLE = 2'b00;
parameter CAPTURE_FRAME = 2'b01;
parameter WRITING_FRAME = 2'b10;
parameter READING_FRAME = 2'b11;

// Constants
parameter CUSTOM_TEXT_MAXLEN = 20;

// Filter Types
parameter SEPIA = 2'b00;
parameter INVERT = 2'b01;
parameter GRAYSCALE = 2'b10;

// Delay Parameters
parameter YCRCB2RGB_DLY = 4;
parameter RGB2HSV_DLY = 23;
parameter THRESHOLD_DLY = 1;
parameter HSV2RGB_DLY = 10;
parameter ENHANCE_DLY = 1;

// Filter Module Latencies
parameter INVERT_DLY = 1;
parameter SEPIA_DLY = 4;
parameter GRAYSCALE_DLY = 3;
