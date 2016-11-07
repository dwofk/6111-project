// BRAM module with distinct read and write addresses

module frame_bram #(parameter LOGSIZE=16, WIDTH=24)
                   (input clk, re, we,
                    input [LOGSIZE-1:0] rd_addr,
                    input [LOGSIZE-1:0] wr_addr,
                    input [WIDTH-1:0] din,
                    output reg [WIDTH-1:0] dout
                   );

    (* ram_style = "block" *)
    reg [WIDTH-1:0] mem [(1<<LOGSIZE)-1:0];

    always @(posedge clk) begin
        if (we) mem[wr_addr] <= din;
        dout <= mem[rd_addr];
    end

endmodule
