module ycrcb2rgb(clk, rst, y, cr, cb, r, g, b);
    input clk, rst;
    input [7:0] y, cr, cb;
    output [7:0] r, g, b;

    reg [31:0] r_y_q, r_cr_q;
    reg [31:0] g_y_q, g_cr_q, g_cb_q;
    reg [31:0] b_y_q, b_cb_q;
    reg [31:0] r_sum_q, g_sum_q, b_sum_q;

    // assignments to outputs
    assign r = r_sum_q[15:8];
    assign g = g_sum_q[15:8];
    assign b = b_sum_q[15:8];

    always @(posedge(clk)) begin

        if (rst) begin

          r_y_q <= 0;
          r_cr_q <= 0;

          g_y_q <= 0;
          g_cr_q <= 0;
          g_cb_q <= 0;

          b_y_q <= 0;
          b_cb_q <= 0;

          r_sum_q <= 0;
          g_sum_q <= 0;
          b_sum_q <= 0;

        end else begin

          // first stage: multiplications

          r_y_q <= 298 * y;
          r_cr_q <= 394 * cr;

          g_y_q <= 298 * y;
          g_cr_q <= 117 * cr;
          g_cb_q <= 47 * cb;

          b_y_q <= 298 * y;
          b_cb_q <= 465 * cb;

          // second stage: additions, subtractions

          r_sum_q <= r_y_q + r_cr_q - 16'd55200;
          g_sum_q <= 16'd16224 + g_y_q - g_cr_q - g_cb_q;
          b_sum_q <= b_y_q + b_cb_q - 16'd64288;

      end
    end

endmodule
