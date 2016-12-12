`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:02 12/07/2016 
// Design Name: 
// Module Name:    flashreader 
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
module flashreader(clk,flashreset,busy,start,pictsel, flashaddr,writemode,dowrite,doread,wdata,loaded);
		input clk;
		input flashreset;
		input busy;
		input start;
		input [2:0] pictsel;
		//output reg zbt_we;
		output reg loaded=0;
		output reg [22:0] flashaddr;
		//output reg [18:0] zbtaddr;
		output reg writemode, dowrite, doread, wdata;
		
		reg waitone=0;
		reg has=0;
		reg started=0;
		reg [18:0] flashcounter=0;
		always @(posedge clk) begin
			if (flashreset) begin
				writemode <=1; 
				dowrite <= 0; 
				doread <= 0;
				wdata <= 0; // initial write data = 0
				flashaddr <= 0; // initial read address = 0
				end
			if (start) started<=1;
			if (busy==0) begin
				if(started) begin
					//zbtaddr<=0;
					loaded<=0;
					//zbt_we<=1;
					writemode<=0;
					doread<=1;
					waitone<=0;
					has<=0;
					case (pictsel)
						0:begin //paris
							flashaddr<=22'd307201;
							flashcounter<=307200;
							end
						1:begin //rome
							flashaddr<=22'd614401;
							flashcounter<=307200;
							end
						2:begin //amazon
							flashaddr<=22'd1152001;
							flashcounter<=307200;
							end
						3:begin //london
							flashaddr<=22'd1;
							flashcounter<=307200;
							end 
						4:begin //start
							flashaddr<=22'd921601;
							flashcounter<=260400;
							end
					endcase
					started<=0;
				end
				else begin 
					if (flashcounter!=0) begin
						flashcounter<=flashcounter-1;
						flashaddr<=flashaddr+1;
						end
					else begin
						loaded<=1; 
						end
				end
			end
		end
//		else begin //aka busy
//		end
	//assign zbt_we=~busy;
	//module zbt_6111(clk, cen, we, addr, write_data, read_data,
		  //ram_clk, ram_we_b, ram_address, ram_data, ram_cen_b);
	

endmodule
