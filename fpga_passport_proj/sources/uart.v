`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:17 11/27/2016 
// Design Name: 
// Module Name:    uart 
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
module uart_tx(
    );
  
  localparam BAUD_RATE = 115200;
  localparam CLK_IN = 40000000;  // 40MHz input clock

  reg [25:0] tx_clk_ctr_q = 0;  // counter used in generating tx_clk
  wire tx_clk = ((CLK_IN-tx_clk_ctr_q) < BAUD_RATE);  // for serial transmission
    
  always @(posedge clk)
    tx_clk_ctr_q <= ((CLK_IN-tx_clk_ctr_q) < BAUD_RATE) ? 0 : tx_clk_ctr_q+BAUD_RATE;
    
endmodule
