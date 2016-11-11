///*/**************************************************************************
// ** 
// ** Module: ycrcb2rgb
// **
// ** Generic Equations:
// ***************************************************************************/
//
module ycrcb2rgb (Y, Cr, Cb, R, G, B, clk, rst);

output [7:0]  R, G, B;

input clk,rst;
input[9:0] Y, Cr, Cb;

wire [7:0] R,G,B;
reg [20:0] R_int,G_int,B_int,X_int,A_int,B1_int,B2_int,C_int; 
reg [9:0] const1,const2,const3,const4,const5;
reg[9:0] Y_reg, Cr_reg, Cb_reg;
 
//registering constants
always @ (posedge clk)
begin
 const1 = 10'b 0100101010; //1.164 = 01.00101010
 const2 = 10'b 0110011000; //1.596 = 01.10011000
 const3 = 10'b 0011010000; //0.813 = 00.11010000
 const4 = 10'b 0001100100; //0.392 = 00.01100100
 const5 = 10'b 1000000100; //2.017 = 10.00000100
end

always @ (posedge clk or posedge rst)
   if (rst)
      begin
      Y_reg <= 0; Cr_reg <= 0; Cb_reg <= 0;
      end
   else  
      begin
	  Y_reg <= Y; Cr_reg <= Cr; Cb_reg <= Cb;
      end

always @ (posedge clk or posedge rst)
   if (rst)
      begin
       A_int <= 0; B1_int <= 0; B2_int <= 0; C_int <= 0; X_int <= 0;
      end
   else  
     begin
     X_int <= (const1 * (Y_reg - 'd64)) ;
     A_int <= (const2 * (Cr_reg - 'd512));
     B1_int <= (const3 * (Cr_reg - 'd512));
     B2_int <= (const4 * (Cb_reg - 'd512));
     C_int <= (const5 * (Cb_reg - 'd512));
     end

always @ (posedge clk or posedge rst)
   if (rst)
      begin
       R_int <= 0; G_int <= 0; B_int <= 0;
      end
   else  
     begin
     R_int <= X_int + A_int;  
     G_int <= X_int - B1_int - B2_int; 
     B_int <= X_int + C_int; 
     end
	 


/*always @ (posedge clk or posedge rst)
   if (rst)
      begin
       R_int <= 0; G_int <= 0; B_int <= 0;
      end
   else  
     begin
     X_int <= (const1 * (Y_reg - 'd64)) ;
     R_int <= X_int + (const2 * (Cr_reg - 'd512));  
     G_int <= X_int - (const3 * (Cr_reg - 'd512)) - (const4 * (Cb_reg - 'd512)); 
     B_int <= X_int + (const5 * (Cb_reg - 'd512)); 
     end

*/
/* limit output to 0 - 4095, <0 equals o and >4095 equals 4095 */
assign R = (R_int[20]) ? 0 : (R_int[19:18] == 2'b0) ? R_int[17:10] : 8'b11111111;
assign G = (G_int[20]) ? 0 : (G_int[19:18] == 2'b0) ? G_int[17:10] : 8'b11111111;
assign B = (B_int[20]) ? 0 : (B_int[19:18] == 2'b0) ? B_int[17:10] : 8'b11111111;

endmodule
//
//
//
//
//

//module ycrcb2rgb(y, cr, cb, r, g, b, clk, rst);
//    input clk, rst;
//    input [9:0] y, cr, cb;
//    output [7:0] r, g, b;
//
//    reg [31:0] r_y_q, r_cr_q;
//    reg [31:0] g_y_q, g_cr_q, g_cb_q;
//    reg [31:0] b_y_q, b_cb_q;
//    reg [31:0] r_sum_q, g_sum_q, b_sum_q;
//    reg [7:0] r_q, g_q, b_q;
//
//    // assignments to outputs
//    //assign r = r_sum_q[15:8];
//    //assign g = g_sum_q[15:8];
//    //assign b = b_sum_q[15:8];
//
//    assign {r, g, b} = {r_q, g_q, b_q};
//
//    always @(posedge(clk)) begin
//
//        if (rst) begin
//
//          r_y_q <= 0;
//          r_cr_q <= 0;
//
//          g_y_q <= 0;
//          g_cr_q <= 0;
//          g_cb_q <= 0;
//
//          b_y_q <= 0;
//          b_cb_q <= 0;
//
//          r_sum_q <= 0;
//          g_sum_q <= 0;
//          b_sum_q <= 0;
//
//        end else begin
//
//          // clock 1
//
//          r_y_q <= 298 * y[9:2];
//          r_cr_q <= 394 * cr[9:2];
//
//          g_y_q <= 298 * y[9:2];
//          g_cr_q <= 117 * cr[9:2];
//          g_cb_q <= 47 * cb[9:2];
//
//          b_y_q <= 298 * y[9:2];
//          b_cb_q <= 465 * cb[9:2];
//
//          // clock 2
//
//          r_sum_q <= r_y_q + r_cr_q - 16'd55200;
//          g_sum_q <= 16'd16224 + g_y_q - g_cr_q - g_cb_q;
//          b_sum_q <= b_y_q + b_cb_q - 16'd64288;
//
//          // clock 3
//
//          {r_q, g_q, b_q} <= {r_sum_q[15:8], g_sum_q[15:8], b_sum_q[15:8]};
//
//      end
//    end
//
//endmodule