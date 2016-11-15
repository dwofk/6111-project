`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:33:38 11/07/2016 
// Design Name: 
// Module Name:    hsv2rgb 
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
module hsv2rgb(
    input clk,
    input rst,
    input [7:0] h,
    input [7:0] s,
    input [7:0] v,
    output [7:0] r,
    output [7:0] g,
    output [7:0] b
    );
    
    // HSV to RGB conversion using integer math
    // algorith referenced from following source:
    // http://web.mit.edu/storborg/Public/hsvtorgb.c
    
    // latched inputs
    reg [7:0] h_q, s_q, v_q;
    
    reg [3:0] hue_region_q;        // divide hue range into 6 regions (255/6)
    reg [5:0] hue_remainder_q;     // remainder of hue_reg/43
    reg [7:0] hue_remainder255_q;  // hue_remainder*6, in [0:255] range
    
    reg [10:0] h6_q;
    reg [7:0] hue_sum_q;

    //reg [3:0] hue_div_ctr_q;
    //reg [7:0] hue_div_sum_q;       // running sum for hue region calculation
    
    // temporary variables
    reg [15:0] p0_q, q0_q, t0_q;
    reg [15:0] p1_q, q1_q, t1_q;
    reg [15:0] p2_q, q2_q, t2_q;
    reg [15:0] p3_q, q3_q, t3_q;
    
    // delayed signals
    reg [7:0] h1_q, h2_q;
    reg [7:0] s1_q, s2_q, s3_q, s4_q, s5_q;
    reg [7:0] v1_q, v2_q, v3_q, v4_q, v5_q, v6_q, v7_q, v8_q;
    reg [3:0] hue_region1_q, hue_region2_q, hue_region3_q, hue_region4_q, hue_region5_q, hue_region6_q;
    
    // latched output values
    reg [7:0] r_q, g_q, b_q;
    
    assign {r, g, b} = {r_q, g_q, b_q};
    
    //p = (v * (255 - s)) >> 8;
    //q = (v * (255 - ((s * fpart) >> 8))) >> 8;
    //t = (v * (255 - ((s * (255 - fpart)) >> 8))) >> 8;
    
    always @(posedge clk) begin
      //if (rst) begin
      //end else begin
      
      // clock 1: latch inputs, reset counters
      {h_q, s_q, v_q} <= {h, s, v};

      // clock 2: multiply
      h6_q <= 6 * h_q;
      {h1_q, s1_q, v1_q} <= {h_q, s_q, v_q};
      
      // clock 3: calc hue region
      hue_region_q <= h6_q[10:8];
      hue_sum_q <= 6'd43 * h6_q[10:8];
      {h2_q, s2_q, v2_q} <= {h1_q, s1_q, v1_q};
      
      // clock 4: calc remainder
      hue_remainder_q <= h2_q - hue_sum_q;
      {s3_q, v3_q} <= {s2_q, v2_q};
      hue_region1_q <= hue_region_q;
      
      // clock 5: multiply remainder
      hue_remainder255_q <= 6 * hue_remainder_q;
      {s4_q, v4_q} <= {s3_q, v3_q};
      hue_region2_q <= hue_region1_q;
      
      // clocks 6: calculate temporary variables
      p0_q <= 8'd255 - s4_q;
      q0_q <= hue_remainder255_q;
      t0_q <= 8'd255 - hue_remainder255_q;
      {s5_q, v5_q} <= {s4_q, v4_q};
      hue_region3_q <= hue_region2_q;
      
      // clock 7
      p1_q <= v5_q * p0_q;
      q1_q <= s5_q * q0_q;
      t1_q <= s5_q * t0_q;
      v6_q <= v5_q;
      hue_region4_q <= hue_region3_q;
      
      // clock 8
      p2_q <= p1_q;
      q2_q <= 8'd255 - q1_q[15:8];
      t2_q <= 8'd255 - t1_q[15:8];
      v7_q <= v6_q;
      hue_region5_q <= hue_region4_q;
      
      // clock 9
      p3_q <= p2_q;
      q3_q <= v7_q * q2_q;
      t3_q <= v7_q * t2_q;
      v8_q <= v7_q;
      hue_region6_q <= hue_region5_q;
      
      // clock 10: output values
      
      case (hue_region6_q)
        0       : begin
                    r_q <= v8_q;
                    g_q <= t3_q[15:8];
                    b_q <= p3_q[15:8];
                  end
        1       : begin
                    r_q <= q3_q[15:8];
                    g_q <= v8_q;
                    b_q <= p3_q[15:8];
                  end
        2       : begin
                    r_q <= p3_q[15:8];
                    g_q <= v8_q;
                    b_q <= t3_q[15:8];
                  end
        3       : begin
                    r_q <= p3_q[15:8];
                    g_q <= q3_q[15:8];
                    b_q <= v8_q;
                  end
        4       : begin
                    r_q <= t3_q[15:8];
                    g_q <= p3_q[15:8];
                    b_q <= v8_q;
                  end 
        default : begin
                    r_q <= v8_q;
                    g_q <= p3_q[15:8];
                    b_q <= q3_q[15:8];
                  end            
      endcase
      
    end
      
endmodule

/*      // clocks 2-6: iterative division of hue
        if (hue_div_sum + 8'd43 < h_q) begin
          hue_div_sum_q <= hue_div_sum_q + 8'd43;
          hue_region_q <= hue_region_q + 1'b1;
          hue_remainder_q <= h_q - hue_div_sum_q;
          hue_div_ctr_q <= hue_div_ctr_q + 1'b1;
        end else if (hue_div_ctr_q < 6'd6) begin
          hue_div_ctr_q <= hue_div_ctr_q + 1'b1;
          case (hue_region_q)
            0 : begin
                hue_region_d_q <= hue_region_d5;
                hue_remainder_d_q <= hue_remainder_d5;
                end
            1 : begin
                  hue_region_d_q <= hue_region_d4;
                  hue_remainder_d_q <= hue_remainder_d4;
                end
            2 : begin
                  hue_region_d_q <= hue_region_d3;
                  hue_remainder_d_q <= hue_remainder_d3;
                end
            3 : begin
                  hue_region_d_q <= hue_region_d2;
                  hue_remainder_d_q <= hue_remainder_d2;
                end
            4 : begin
                  hue_region_d_q <= hue_region_d1;
                  hue_remainder_d_q <= hue_remainder_d1;
                end
            5 : begin
                  hue_region_d_q <= hue_region_q;
                  hue_remainder_d_q <= hue_remainder_q;
                end
            default : ;
          endcase
        end
        
      // clock 7: multiply remainder
        hue_remainder255_q <= hue_remainder_d_q * 6;

      // clocks 8-11: calculate temporary variables
        
        // calculate p
        p0_q <= 8'd255 - s_q;
        p1_q <= v_q * p0_q;
        p2_q <= p1_q;
        p3_q <= p2_q;
        
        // calculate q
        q0_q <= hue_remainder255_q;
        q1_q <= s_q * q0_q;
        q2_q <= 8'd255 - q1_q[15:8];
        q3_q <= v_q * q2_q;
        
        // calculate t
        t0_q <= 8'd255 - hue_remainder255_q;
        t1_q <= s_q * t0_q;
        t2_q <= 8'd255 - t1_q[15:8];
        t3_q <= v_q * t2_q;
        
      // clock 12: latch output values
        case (*/
        
//    delay8 hue_region_d1 #(.DELAY(1)(
//      .clk    (clk),
//      .din    (hue_region),
//      .dout   (hue_region_d1)
//    );
//    
//    delay8 hue_region_d2 #(.DELAY(2)(
//      .clk    (clk),
//      .din    (hue_region),
//      .dout   (hue_region_d2)
//    );
//    
//    delay8 hue_region_d3 #(.DELAY(3)(
//      .clk    (clk),
//      .din    (hue_region),
//      .dout   (hue_region_d3)
//    );

    
