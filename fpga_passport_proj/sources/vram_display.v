module vram_display #(parameter XOFFSET = 0, YOFFSET = 0) (reset,clk,hcount,vcount,vr_pixel,
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
  
    //forecast hcount & vcount 2 clock cycles ahead to get data from ZBT

    // for 1024x720 resolution:
    //wire [10:0] hcount_f = (x >= 1048) ? x - 1048 : (x + 2);
    //wire [9:0] vcount_f = (x >= 1048) ? ((y == 805) ? 0 : y + 1) : y;

    // for 800x600 resolution:
    wire [10:0] hcount_f = (x >= 840) ? x - 840 : (x + 2);
    wire [9:0] vcount_f = (x >= 840) ? ((y == 627) ? 0 : y + 1) : y;
  
    reg [18:0] vram_addr;
    always@(*) begin
      if(hcount_f < 640 && vcount_f < 480) begin
        vram_addr = {vcount_f[8:0], hcount_f[9:0]};
        vr_pixel = vram_read_data[29:0];
      end
      else begin
        vr_pixel = {10'd0,10'd512,10'd512};
      end
    end

endmodule // vram_display