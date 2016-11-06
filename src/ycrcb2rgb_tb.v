module ycrcb2rgb_tb();

  reg clock, reset;
  reg [7:0] y, cr, cb;
  wire [7:0] r, g, b;

  ycrcb2rgb dut(
    .clk    (clock),
    .rst    (reset),
    .y      (y),
    .cr     (cr),
    .cb     (cb),
    .r      (r),
    .g      (g),
    .b      (b)
    );

  initial begin
    clock = 1'b1;
    forever begin
      #5 clock = ~clock;   // 10ns period
    end
  end

  initial begin

    // first stimulus
    y = 72;
    cb = 130;
    cr = 173;

    // global reset
    reset = 1'b1;
    #100 reset = 1'b0;

    #20     // wait for output

    // second stimulus
    y = 98;
    cb = 184;
    cr = 93;

    #20     // wait for output

    #100 $stop;
  end

endmodule
