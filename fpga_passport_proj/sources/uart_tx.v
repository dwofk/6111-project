`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Diana Wofk
// 
// Create Date:    14:44:01 11/26/2016 
// Design Name: 
// Module Name:    uart_tx 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Simple parameterized UART TX module. Default baudrate is 115200.
//              Default TX settings: 1 start bit, 8 data bits, 2 stop bits. This
//              implementation does not support RTS/CTS flow control.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module uart_tx #(
    parameter BAUD_RATE = 115200,
    parameter CLK_IN = 40000000,     // 40MHz input clock
    parameter START_BITS = 1,
    parameter DATA_BITS = 8,
    parameter STOP_BITS = 2
  )(
    input clk, rst,           // 40 MHz input clk
    input tx_en,              // raise to transmit
    input [7:0] data_in,     // 8-bit data input
    output bit_out,           // UART transmit wire
    output tx_busy,           // asserted when transmitting
    output [3:0] bit_ctr     // bit counter for transmitting bytes
  );
  
  localparam BITCOUNT = START_BITS + DATA_BITS + STOP_BITS;

  reg bit_out_q;  // data bit being sent out on wire
  reg [3:0] bit_ctr_q;  // counter for shifting data bits
  reg [(BITCOUNT-1):0] tx_shifter_q;  // acts as a data buffer

  // output assignments
  assign tx_busy = bit_ctr > 0;
  assign bit_ctr = bit_ctr_q;
  assign bit_out = bit_out_q;

  // ***********************************************
  // TX clock Generation (for 115200 baud)
  // ***********************************************
  
  reg [25:0] tx_clk_ctr_q = 0;  // counter used in generating tx_clk
  wire tx_clk = ((CLK_IN-tx_clk_ctr_q) < BAUD_RATE);  // for serial transmission
  
  always @(posedge clk)
    tx_clk_ctr_q <= ((CLK_IN-tx_clk_ctr_q) < BAUD_RATE) ? 0 : tx_clk_ctr_q+BAUD_RATE;
    
  // *********************************
  // Data Transmission
  // *********************************

  always @(posedge clk) begin
    if (rst) begin
      bit_out_q <= 1'b1;
      bit_ctr_q <= 0;
      tx_shifter_q <= 0;
    end else begin
    
      // there is a byte available for transmission
      if (tx_en & (bit_ctr_q <= 1)) begin
        bit_out_q <= 1'b1; // can be interpreted as a stop bit if necessary
        bit_ctr_q <= BITCOUNT;  // num of bits to be transmitted for this byte
        tx_shifter_q <= {{STOP_BITS{1'b1}}, data_in[7:0], {START_BITS{1'b0}}};
      end

      // transmit the start/data/stop bits
      if (tx_clk && (bit_ctr_q > 1)) begin
        bit_out_q <= tx_shifter_q[0];
        bit_ctr_q <= bit_ctr_q-1'b1;
        tx_shifter_q <= {1'b1, tx_shifter_q[(BITCOUNT-1):1]};
      end
      
    end
  end

endmodule

