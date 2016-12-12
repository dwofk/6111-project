module vram_flash_img #(parameter XOFFSET = 0, YOFFSET = 0) (reset,clk,hcount,vcount,vr_pixel,
		    vram_addr,vram_read_data);

   input reset, clk;
   input [10:0] hcount;
   input [9:0] 	vcount;
   output reg [29:0] vr_pixel;
   output [18:0] vram_addr;
   input [35:0]  vram_read_data;

	wire[10:0] x;
	wire[9:0] y;
	assign x = hcount - XOFFSET;
	assign y = vcount - YOFFSET;
//   //forecast hcount & vcount 2 clock cycles ahead to get data from ZBT
//   wire [10:0] hcount_f = (x >= 1048) ? x - 1048 : (x + 2);
//   wire [9:0] vcount_f = (x >= 1048) ? ((y == 805) ? 0 : y + 1) : y;
//   
//	reg [18:0] vram_addr;
//	always@(*) begin
//		if(hcount_f < 640 && vcount_f < 480) begin
//			vram_addr = {vcount_f[8:0], hcount_f[9:0]};
//			vr_pixel = vram_read_data[29:0];
//		end
//		else begin
//			vr_pixel = {10'd0,10'd512,10'd512};
//		end
//	end
   //forecast hcount & vcount 2 clock cycles ahead to get data from ZBT
   //wire [10:0] hcount_f =(x + 2);
	//wire [10:0] hcount_f = (x >= 1048) ? x - 1048 : (x + 2);
   //wire [8:0] vcount_f =  y;
	//wire [9:0] vcount_f = (x >= 1048) ? ((y == 805) ? 0 : y + 1) : y;

  wire [10:0] hcount_f = (x >= 840) ? x - 840 : (x + 2);
  wire [9:0] vcount_f = (x >= 840) ? ((y == 627) ? 0 : y + 1) : y;
	
	//wire [10:0] hcount_f = (x == 1342) ? 0 : (x == 1343) ? 1 : (x+2);
   //wire [9:0] vcount_f = (x == 1343) ? ( (y == 804) ? 0 : (y == 805) ? 1 : y+1 ) : y;
		
	//reg [10:0] hcount_fold=0;
	reg [18:0] vram_addr=0;
	//wire [9:0] vcount_f;
	//reg [14:0] hcount_next=0;
	always@(posedge clk) begin 
		if((hcount_f < 640) && vcount_f < 480) begin
//			if (~(vcount_f!=vcount_fold)&&((hcount_f!=hcount_fold)&&~(hcount_f==0)) //hcount changed
//				linecounter<=linecounter+1;
//			if (hcount_f==0) linecounter<=0;
//			if (vcount_f!=vcount_fold)&&vcount_f!=0) begin //vcount changed
//				linecounter<=0;
//				vertcount<=vertcount+640; end
//			if (vcount_f==0) begin
//				vertcount<=0;end
			//vram_addr = (vcount_f<<9)+(vcount_f<<7)+hcount_f[10:0];
			//vram_addr = ((({vcount_f[8:0], hcount_f[9:0]})<<3)-
				//{vcount_f[8:0], hcount_f[9:0]})>>3;
			vram_addr <= hcount_f[9:0]+vcount_f[8:0]*640;
			//hcount_next<=((hcount_f[9:0]+1)*5)>>2; 
			//vram_addr <= {vcount_f[8:0]>>1, hcount_next[9:0]};
			//vram_addr <= {vcount_f[8:0]>>1, hcount_f[9:0]};
			//if ((hcount_f==0)&&(vcount_f==0)) vram_addr<=0;
			//else vram_addr<=vram_addr+1;
			//vram_addr <= vertcount+linecounter;
			vr_pixel <= vram_read_data[29:0];
			//vram_addr <= {vcount_f[8:0]>>1, hcount_f[9:0]>>1};
			//vountnext<=640*(vcount_f+1)
		end
		else begin
			vr_pixel <= {10'd0,10'd0,10'd0};
		end
	end
	
endmodule // vram_display
