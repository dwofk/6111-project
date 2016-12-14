`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lorenzo Vigano
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
		output reg loaded=0;
		output reg [22:0] flashaddr;
		output reg writemode, dowrite, doread, wdata;
		
		reg waitone=0;
		reg has=0;
		reg started=0;
		reg [18:0] flashcounter=0;
		always @(posedge clk) begin
			if (flashreset) begin //shouldn't ever happen
				writemode <=1; 
				dowrite <= 0; 
				doread <= 0;
				wdata <= 0; // initial write data = 0
				flashaddr <= 0; // initial read address = 0
				end
			if (start) started<=1; //if given signal to start caching an image
			if (busy==0) begin //only do things when flash isnt busy
				if(started) begin
					loaded<=0;
					writemode<=0;
					doread<=1;
					waitone<=0;
					has<=0;
					case (pictsel)
						0:begin //paris
							flashaddr<=22'd307201;
							flashcounter<=307200; //640*480
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
							flashcounter<=260400;//640*360
							end
					endcase
					started<=0; //done intializing things. now go to steady state code
				end
				else begin //steady state code
					if (flashcounter!=0) begin
						flashcounter<=flashcounter-1;
						flashaddr<=flashaddr+1;
						end
					else begin //picture has been sent to zbt
						loaded<=1; 
						end
				end
			end
		end

endmodule
