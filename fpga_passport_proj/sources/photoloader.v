`timescale 1ns / 1ps

module stringmaker(input clk, 
				   input [10:0] x,hcount, 
				   input [9:0] y,vcount,
					input [1:0] background,
				   output[23:0] pixel); 
   
	
	reg [4:0] letter=0;
	wire [10:0] xpos;
	reg [10:0] xshift;
	reg hcountold;
	reg vcountold;
	reg [10:0] linecount=1;
	
	always @(posedge clk) begin
		hcountold<=hcount[0];
		vcountold<=vcount[0];
		if ((hcount[0]!=hcountold)&&!(vcount[0]!=vcountold)) linecount<=1+linecount;
		if (vcount[0]!=vcountold) begin//reset and G
			linecount<=0; 
			letter<=6;
			xshift<=0;
			end
		if (linecount==18+x) begin//R
			xshift<=20;
			letter<=17;
		end
		if (linecount==36+x) begin //E
			xshift<=38;
			letter<=4;
			end
		if (linecount==54+x) begin //E
			xshift<=56;
			letter<=4;
			end
		if (linecount==72+x) begin //T
			xshift<=74;
			letter<=19;
			end
		if (linecount==90+x) begin //I
			xshift<=92;
			letter<=8;
			end
		if (linecount==108+x) begin //N
			xshift<=110;
			letter<=13;
			end
		if (linecount==126+x) begin //G
			xshift<=128;
			letter<=6;
			end
		if (linecount==144+x) begin //S
			xshift<=146;
			letter<=18;
			end
		if (linecount==168+x) begin //F (extra for the space
			xshift<=170;
			letter<=5;
			end
		if (linecount==186+x) begin //R
			xshift<=188;
			letter<=17;
			end
		if (linecount==204+x) begin //O
			xshift<=206;
			letter<=14;
			end
		if (linecount==222+x) begin //M
			xshift<=224;
			letter<=12;
			end
		case(background)
			0:begin//Paris
				if (linecount==246+x) begin //P
					xshift<=248;
					letter<=15;
					end
				if (linecount==264+x) begin //A
					xshift<=268;
					letter<=0;
					end
				if (linecount==282+x) begin //R
					xshift<=284;
					letter<=17;
					end
				if (linecount==300+x) begin //I
					xshift<=302;
					letter<=8;
					end
				if (linecount==318+x) begin //S
					xshift<=320;
					letter<=18;
					end
				end
			1:begin//Rome
				if (linecount==246+x) begin //R
					xshift<=248;
					letter<=17;
					end
				if (linecount==264+x) begin //O
					xshift<=266;
					letter<=14;
					end
				if (linecount==282+x) begin //M
					xshift<=284;
					letter<=12;
					end
				if (linecount==300+x) begin //E
					xshift<=302;
					letter<=4;
					end
				end
			
			2:begin//(the)Amazon
				if (linecount==246+x) begin //T
					xshift<=248;
					letter<=19;
					end
				if (linecount==264+x) begin //H
					xshift<=266;
					letter<=7;
					end
				if (linecount==282+x) begin //E
					xshift<=284;
					letter<=4;
					end
				if (linecount==306+x) begin //A ADD SPACE
					xshift<=308;
					letter<=0;
					end
				if (linecount==324+x) begin //M
					xshift<=326;
					letter<=12;
					end
				if (linecount==342+x) begin //A
					xshift<=346;
					letter<=0;
					end
				if (linecount==360+x) begin //Z
					xshift<=362;
					letter<=25;
					end
				if (linecount==378+x) begin //O
					xshift<=380;
					letter<=14;
					end
				if (linecount==396+x) begin //N
					xshift<=398;
					letter<=13;
					end
					
				end
			3:begin//London
				if (linecount==246+x) begin //L
					xshift<=248;
					letter<=11;
					end
				if (linecount==264+x) begin //O
					xshift<=266;
					letter<=14;
					end
				if (linecount==282+x) begin //N
					xshift<=284;
					letter<=13;
					end
				if (linecount==300+x) begin //D
					xshift<=302;
					letter<=3;
					end
				if (linecount==318+x) begin //O
					xshift<=320;
					letter<=14;
					end
				if (linecount==336+x) begin //N
					xshift<=338;
					letter<=13;
					end
				end
			endcase
		
	end
	assign xpos=x+xshift;
	textcaller lettermaker(clk,xpos,hcount,y,vcount,letter,pixel);
endmodule  

module textcaller #(parameter WIDTH = 15,HEIGHT =17)
	(input pixel_clk, 
	input [10:0] x,hcount, 
   input [9:0] y,vcount,
   input [4:0] letter,
   output reg[23:0] pixel); 
     
	reg [8:0] image_addr;
	wire [8:0] image_mem;
   wire [14:0] image_bits;
   reg [3:0] mem_iter=0; 
	reg [3:0] hdelay=0;
	reg hcountold;
	reg vcountold;

   always @(posedge pixel_clk) begin
   			case(letter)
   				0:image_addr<=0; //A
	   			1:image_addr<=17;//B
   				2:image_addr<=34;//C
   				3:image_addr<=51;//D
   				4:image_addr<=68;//E
	   			5:image_addr<=85;//F
   				6:image_addr<=102;//G
   				7:image_addr<=119;//H
   				8:image_addr<=136;//I
	   			9:image_addr<=153;//J
   				10:image_addr<=170;//K
   				11:image_addr<=187;//L
   				12:image_addr<=204;//M
   				13:image_addr<=221;//N
   				14:image_addr<=238;//O
   				15:image_addr<=255;//P
   				16:image_addr<=272;//Q
   				17:image_addr<=289;//R
   				18:image_addr<=306;//S
   				19:image_addr<=323;//T
   				20:image_addr<=340;//U
   				21:image_addr<=357;//V
   				22:image_addr<=374;//W
   				23:image_addr<=391;//X
   				24:image_addr<=408;//Y
   				25:image_addr<=425;//Z
   			endcase

			hcountold<=hcount[0];
			vcountold<=vcount[0];

			if (vcount==y) mem_iter<=0;
			if ((~(vcount==y))&&(vcount[0]!=vcountold)&&(vcount>y)&&(vcount<HEIGHT+y)) mem_iter<=mem_iter+1;
			if ((hcount[0]!=hcountold)&&(hcount>=x)&&(hcount<=WIDTH+x)) hdelay<=hdelay+1;
			if (image_bits[15-hdelay[3:0]]==1)pixel <= 24'hFF0000; 
			else pixel <= 24'h000000;
		end
	assign image_mem=image_addr+mem_iter;
	font_rom alphabet(pixel_clk,image_mem,image_bits);  
  
endmodule
