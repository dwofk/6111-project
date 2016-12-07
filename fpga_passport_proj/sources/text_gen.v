`timescale 1ns / 1ps
/*	always @(posedge vsync) begin
			if (right&&x_pos!=1000) x_pos<=x_pos+1; 
			if (left&&x_pos!=1) x_pos<=x_pos-1;
			if (up&&y_pos!=1) y_pos<=y_pos-1;
			if (down&&y_pos!=759) y_pos<=y_pos+1;  
	end  
	wire [71:0]string;
   assign string={8'h4F,8'h20,8'h51,8'h20,8'h58,8'h20,8'h4A,8'h20,8'h58};
	reg [5:0]numchar=9;
   stringmaker stringmaker(.clk(clock_65mhz),.x(x_pos),.hcount(hcount),.y(y_pos),
									.vcount(vcount),.numchar(numchar), .background(switch[7:6]),.custom(switch[5]),
									.ready(switch[4]),.string(string),.pixel(pixel));*/
module stringmaker #(parameter STRING_LENGTH=9)(input clk, 
				   input [10:0] x,hcount, 
				   input [9:0] y,vcount,
					input [1:0] background,
					input [5:0] numchar,//, numchar is string_length?
					input ready,
					input [STRING_LENGTH*8-1:0]string,
					input custom,
				   output[23:0] pixel); 
   //FIX ALL THE LETTERS
	parameter ARRAY_LEN=8*STRING_LENGTH;
	parameter leftmax=1023;
	parameter bottommax=759;
	reg [7:0] letter=8'h57;
	wire [10:0] xpos;
	reg [10:0] xshift;
	reg hcountold;
	reg vcountold;
	reg [10:0] linecount=1;
	reg [10:0] condition;
	reg [5:0]countershift;
	reg [8:0]letterfind;
	reg [9:0]letterfindnext;
	reg valid;
	reg [5:0] numcounter;
	reg [ARRAY_LEN-1:0]stringhold;
	
	always @(posedge clk) begin
		
		//letter generator
		if(custom)begin
			if (ready) stringhold<=string;
				hcountold<=hcount[0];
				vcountold<=vcount[0];
				if ((hcount[0]!=hcountold)&&!(vcount[0]!=vcountold)) linecount<=1+linecount;
				if (vcount[0]!=vcountold) begin//reset and first letter
					linecount<=0; 
					letter<=stringhold[ARRAY_LEN-1:ARRAY_LEN-8];
					xshift<=0;
					countershift<=1;
					letterfind<=8;
					condition<=18;
					numcounter<=numchar-1;
				end
				if ((linecount==condition+x)&&numcounter!=0) begin //each loop it will move 18 pixels over
					numcounter<=numcounter-1;
					if (countershift+2<numchar)countershift<=1+countershift; 
					//all look ahead multiplications
					condition<=18*(countershift+1); //look ahead one because it will be the condition for the next letter
					letterfind<=(countershift+1)*8; //look ahead one becuase it will be used to find the next letter which is inherently one larger than countershift
					letterfindnext<=(countershift+2)*8;
					xshift<=(condition+3);
					if ((letterfind-8)<ARRAY_LEN)begin
						letter<={stringhold[ARRAY_LEN-(1+letterfind)],
									stringhold[ARRAY_LEN-(2+letterfind)],
									stringhold[ARRAY_LEN-(3+letterfind)],
									stringhold[ARRAY_LEN-(4+letterfind)],
									stringhold[ARRAY_LEN-(5+letterfind)],
									stringhold[ARRAY_LEN-(6+letterfind)],
									stringhold[ARRAY_LEN-(7+letterfind)],
									stringhold[ARRAY_LEN-(8+letterfind)]};
						end
				end		
			end
		else begin
			hcountold<=hcount[0];
			vcountold<=vcount[0];
			if ((hcount[0]!=hcountold)&&!(vcount[0]!=vcountold)) linecount<=1+linecount;
			if (vcount[0]!=vcountold) begin//reset and G
				linecount<=0; 
				letter<=8'h47;
				xshift<=0;
				end
			if (linecount==18+x) begin//R
				xshift<=20;
				letter<=8'h52;
			end
			if (linecount==36+x) begin //E
				xshift<=38;
				letter<=8'h45;
				end
			if (linecount==54+x) begin //E
				xshift<=56;
				letter<=8'h45;
				end
			if (linecount==72+x) begin //T
				xshift<=74;
				letter<=8'h54;
				end
			if (linecount==90+x) begin //I
				xshift<=92;
				letter<=8'h49;
				end
			if (linecount==108+x) begin //N
				xshift<=111;
				letter<=8'h4E;
				end
			if (linecount==126+x) begin //G
				xshift<=129;
				letter<=8'h47;
				end
			if (linecount==144+x) begin //S
				xshift<=146;
				letter<=8'h53;
				end
			if (linecount==168+x) begin //F (extra for the space
				xshift<=170;
				letter<=8'h46;
				end
			if (linecount==186+x) begin //R
				xshift<=188;
				letter<=8'h52;
				end
			if (linecount==204+x) begin //O
				xshift<=206;
				letter<=8'h4F;
				end
			if (linecount==222+x) begin //M
				xshift<=224;
				letter<=8'h4D;
				end
			case(background)
				0:begin//Paris
					if (linecount==246+x) begin //P
						xshift<=248;
						letter<=8'h50;
						end
					if (linecount==264+x) begin //A
						xshift<=266;
						letter<=8'h41;
						end
					if (linecount==282+x) begin //R
						xshift<=284;
						letter<=8'h52;
						end
					if (linecount==300+x) begin //I
						xshift<=302;
						letter<=8'h49;
						end
					if (linecount==318+x) begin //S
						xshift<=321;
						letter<=8'h53;
						end
					end
				1:begin//Rome
					if (linecount==246+x) begin //R
						xshift<=248;
						letter<=8'h52;
						end
					if (linecount==264+x) begin //O
						xshift<=266;
						letter<=8'h4F;
						end
					if (linecount==282+x) begin //M
						xshift<=284;
						letter<=8'h4D;
						end
					if (linecount==300+x) begin //E
						xshift<=302;
						letter<=8'h45;
						end
					end
				
				2:begin//(the)Amazon
					if (linecount==245+x) begin //T
						xshift<=248;
						letter<=8'h54;
						end
					if (linecount==264+x) begin //H
						xshift<=266;
						letter<=8'h48;
						end
					if (linecount==282+x) begin //E
						xshift<=284;
						letter<=8'h45;
						end
					if (linecount==306+x) begin //A ADD SPACE
						xshift<=308;
						letter<=8'h41;
						end
					if (linecount==324+x) begin //M
						xshift<=326;
						letter<=8'h4D;
						end
					if (linecount==342+x) begin //A
						xshift<=346;
						letter<=8'h41;
						end
					if (linecount==360+x) begin //Z
						xshift<=362;
						letter<=8'h5A;
						end
					if (linecount==378+x) begin //O
						xshift<=380;
						letter<=8'h4F;
						end
					if (linecount==396+x) begin //N
						xshift<=398;
						letter<=8'h4E;
						end
						
					end
				3:begin//London
					if (linecount==246+x) begin //L
						xshift<=248;
						letter<=8'h4C;
						end
					if (linecount==264+x) begin //O
						xshift<=266;
						letter<=8'h4F;
						end
					if (linecount==282+x) begin //N
						xshift<=284;
						letter<=8'h4E;
						end
					if (linecount==300+x) begin //D
						xshift<=302;
						letter<=8'h44;
						end
					if (linecount==318+x) begin //O
						xshift<=320;
						letter<=8'h4F;
						end
					if (linecount==336+x) begin //N
						xshift<=338;
						letter<=8'h4E;
						end
					end
				endcase
			end
		
	end
	assign xpos=x+xshift;
	textcaller lettermaker(clk,xpos,hcount,y,vcount,letter,pixel);
endmodule  

module textcaller #(parameter WIDTH = 15,HEIGHT =17)
	(input pixel_clk, 
	input [10:0] x,hcount, 
   input [9:0] y,vcount,
   input [7:0] letter,
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
   				8'h41:image_addr<=0; //A
	   			8'h42:image_addr<=17;//B
   				8'h43:image_addr<=34;//C
   				8'h44:image_addr<=51;//D
   				8'h45:image_addr<=68;//E
	   			8'h46:image_addr<=85;//F
   				8'h47:image_addr<=102;//G
   				8'h48:image_addr<=119;//H
   				8'h49:image_addr<=136;//I
	   			8'h4A:image_addr<=153;//J
   				8'h4B:image_addr<=170;//K
   				8'h4C:image_addr<=187;//L
					8'h4D:image_addr<=204;//M
   				8'h4E:image_addr<=221;//N
					8'h4F:image_addr<=238;//O
   				8'h50:image_addr<=255;//P
   				8'h51:image_addr<=272;//Q
   				8'h52:image_addr<=289;//R
   				8'h53:image_addr<=306;//S
   				8'h54:image_addr<=323;//T
   				8'h55:image_addr<=340;//U
   				8'h56:image_addr<=357;//V
   				8'h57:image_addr<=374;//W
   				8'h58:image_addr<=391;//X
   				8'h59:image_addr<=408;//Y
   				8'h5A:image_addr<=425;//Z
					8'h20:image_addr<=442;//SPACE
					default: image_addr<=442;//
   			endcase

			hcountold<=hcount[0];
			vcountold<=vcount[0]; 

			if (vcount==y) mem_iter<=0;
			if ((~(vcount==y))&&(vcount[0]!=vcountold)&&(vcount>y)&&(vcount<HEIGHT+y)) mem_iter<=mem_iter+1;
			if ((hcount[0]!=hcountold)&&(hcount>=x)&&(hcount<=WIDTH+x)) hdelay<=hdelay+1;
			if (image_bits[15-hdelay[3:0]]==1)pixel <= 24'hFF0000; 
			else pixel <= 24'hFFFFFF;
		end
	assign image_mem=image_addr+mem_iter;
	font_rom alphabet(pixel_clk,image_mem,image_bits);  
  
endmodule
