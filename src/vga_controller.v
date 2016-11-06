// Diana Wofk
// 1 November 2016

// contains counters for VGA output timing
module vga_controller(input clk,
                      output reg [9:0] hcount = 0,   // pixel number on a line
                      output reg [9:0] vcount = 0,	 // line number
                      output vsync, hsync,
                      output in_display_area
                     );

    // 640x480 display
    localparam FRAME_WIDTH = 640;
    localparam FRAME_HEIGHT = 480;

    localparam H_SYNC = 96;             // H sync time (pixels)
    localparam H_BP = 48;               // H back porch (pixels)
    localparam H_FP = 16;               // H front porch (pixels)

    localparam V_SYNC = 2;              // V sync time (lines)
    localparam V_BP = 33;               // V back porch (lines)
    localparam V_FP = 10;               // V front porch (lines)

    // hcount min and max for addressable video
    localparam DISPLAY_H_MIN = H_SYNC+H_BP;
    localparam DISPLAY_H_MAX = DISPLAY_H_MIN+FRAME_WIDTH;

    // vcount min and max for addressable video
    localparam DISPLAY_V_MIN = V_SYNC+V_BP;
    localparam DISPLAY_V_MAX = DISPLAY_V_MIN+FRAME_HEIGHT;

    // signals indicating whether hcount and vcount are in display area
    wire h_in_display, v_in_display;
    assign h_in_display = (hcount >= DISPLAY_H_MIN) && (hcount < DISPLAY_H_MAX);
    assign v_in_display = (vcount >= DISPLAY_V_MIN) && (vcount < DISPLAY_V_MIN);

    // signals inidicating whether NEXT hcount and vcount are in display area
    // used as data enable signal in pixel_mixer when reading out from BRAM
    wire h_next_in_display, v_next_in_display;
    assign h_next_in_display = ((hcount+1) >= DISPLAY_H_MIN) && ((hcount+1) < DISPLAY_H_MAX);
    assign v_next_in_display = ((vcount+1) >= DISPLAY_V_MIN) && ((vcount+1) < DISPLAY_V_MIN);

    // maximum values for HCOUNT and VCOUNT
    wire h_count_max, v_count_max;
    assign h_count_max = FRAME_WIDTH + H_SYNC + H_BP + H_FP;
    assign v_count_max = FRAME_HEIGHT + V_SYNC + V_BP + V_FP;

    // output wire assignments
    assign hsync = (hcount < H_SYNC);
    assign vsync = (vcount < V_SYNC);
    assign in_display_area = h_in_display && v_in_display;
    assign next_in_display_area = h_next_in_display && v_next_in_display;

    always @(posedge clk) begin
        if (hcount == (h_count_max - 1)) hcount <= 0;
        else hcount <= hcount + 1;

        if (vcount == (v_count_max - 1)) vcount <= 0;
        else if (hcount == (h_count_max - 1)) vcount <= vcount + 1;
    end

endmodule
