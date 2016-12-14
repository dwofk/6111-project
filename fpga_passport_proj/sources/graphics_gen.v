`timescale 1ns / 1ps

module graphicsmaker(input pixel_clk, 
					  input [10:0] x,hcount, 
					  input [9:0] y,vcount,
					  input [1:0] graphic,
					  output reg[23:0] pixel);  
     
	reg [8:0] image_addr;
	wire [8:0] image_mem;
    wire [239:0] image_bits;
    reg [7:0] mem_iter=0; 
	reg [7:0] hdelay=0;
	reg hcountold;
	reg vcountold;
	reg [7:0] HEIGHT;
	reg [23:0] color;
	reg [7:0] WIDTH=240;

    always @(posedge pixel_clk) begin
   			case(graphic)
   				0:begin
   					image_addr<=0; //Crown
   					HEIGHT<=144; //height in memory of the COE
   					color<=24'hF7DB24; //gold
   				 end
	   			1:begin
	   				image_addr<=144;//Sunglasses
	   				HEIGHT<=44;
	   				color<=24'h070706;//jet black 
	   			 end 
   				2:begin
   					image_addr<=192;//Mustache
   					HEIGHT<=38;
   					color<=24'h331900; //dark brown
   				 end 
   				3:begin 
   					image_addr<=231;//Safari Hat
   					HEIGHT<=97;
   					color<=24'h193300;//green brown
   				 end
   			endcase

			hcountold<=hcount[0];//for check when hcount changes
			vcountold<=vcount[0]; //for check when vcount changes

			if (vcount==y) mem_iter<=0; 
			if ((~(vcount==y))&&(vcount[0]!=vcountold)&&(vcount>y)&&(vcount<HEIGHT+y)) mem_iter<=mem_iter+1; 
			//if we are within range and vcount has changed. then go get the next line in memory

			if ((hcount[0]!=hcountold)&&(hdelay!=240)&&(hcount>=x)&&(hcount<=WIDTH+x)) hdelay<=hdelay+1;
			//if we are within range and hcount has changed. then look at the next pixel

			if ((hcount[0]!=hcountold)&&(hdelay==240)&&(hcount>=x)&&(hcount<=WIDTH+x)) hdelay<=0; 
			//need to reset so it doesnt wrap

			if (graphic==0) begin
				if ((mem_iter<=16)&&(image_bits[239-hdelay[7:0]]==1)) pixel <= 24'hCC0000; //red for jewels
				else if ((mem_iter>=118)&&(image_bits[239-hdelay[7:0]]==1)) pixel <= 24'hF0D520;//Slightly sarker brim
				else if (image_bits[239-hdelay[7:0]]==1)pixel <= color; //check for zero or one. see if we should assign color
				else pixel <= 24'hFFFFFF;  
				end
			else if (graphic==1) begin
				if ((mem_iter>=7&&mem_iter<=28)&&((hdelay>=52&hdelay<=96)||((hdelay>=143&&hdelay<=185)))&&(image_bits[239-hdelay[7:0]]==1)) pixel <= 24'h404040; //make differnt black so Diana can alpha blend
				else if (image_bits[239-hdelay[7:0]]==1)pixel <= color; 
				else pixel <= 24'hFFFFFF;
				end
			else if (graphic==3) begin
				if ((mem_iter>=63)&&(image_bits[239-hdelay[7:0]]==1)) pixel <= 24'h994C00; //brown string
				else if (image_bits[239-hdelay[7:0]]==1)pixel <= color; 
				else pixel <= 24'hFFFFFF;  
				end
			else begin
				if (image_bits[239-hdelay[7:0]]==1)pixel <= color; 
				else pixel <= 24'hFFFFFF;
				end
		end
	assign image_mem=image_addr+mem_iter; //combination of the offest for specific graphic and the iterator
	graphics_rom graphicholder(pixel_clk,image_mem,image_bits);  
  
endmodule 