//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2024 Fall
//   Lab01 Exercise		: Snack Shopping Calculator
//   Author     		  : Yu-Hsiang Wang
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SSC.v
//   Module Name : SSC
//   Release version : V1.0 (Release Date: 2024-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module SSC(
    // Input signals
    card_num,
    input_money,
    snack_num,
    price, 
    // Output signals
    out_valid,
    out_change
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [63:0] card_num;
input [8:0] input_money;
input [31:0] snack_num;
input [31:0] price;
output out_valid;
output [8:0] out_change;    

//================================================================
//    Wire & Registers 
//================================================================
// Declare the wire/reg you would use in your circuit
// remember 
// wire for port connection and cont. assignment
// reg for proc. assignment
wire [3:0]map[0:7];
//wire [3:0]map0,map1,map2,map3,map4,map5,map6,map7;
wire [8:0]sum;
wire [7:0]price_total[0:7];
wire [7:0]sort_out[0:7];
reg  [8:0]out_change_;
reg out_valid_;

wire signed [9:0]s2,s5,s4,s7;
wire signed [8:0]s1,s6,s3,s8;
//wire [8:0]m[0:7];

//================================================================
//    DESIGN
//================================================================

assign map[0] = (card_num[63:60] > 4) ? (card_num[63:60] << 1) + 4'b0111 : (card_num[63:60] << 1);
assign map[1] = (card_num[55:52] > 4) ? (card_num[55:52] << 1) + 4'b0111 : (card_num[55:52] << 1);
assign map[2] = (card_num[47:44] > 4) ? (card_num[47:44] << 1) + 4'b0111 : (card_num[47:44] << 1);
assign map[3] = (card_num[39:36] > 4) ? (card_num[39:36] << 1) + 4'b0111 : (card_num[39:36] << 1);
assign map[4] = (card_num[31:28] > 4) ? (card_num[31:28] << 1) + 4'b0111 : (card_num[31:28] << 1);
assign map[5] = (card_num[23:20] > 4) ? (card_num[23:20] << 1) - 9 : (card_num[23:20] << 1);
assign map[6] = (card_num[15:12] > 4) ? (card_num[15:12] << 1) + 4'b0111 : (card_num[15:12] << 1);
assign map[7] = (card_num[7:4]   > 4) ? (card_num[7:4]   << 1) - 9 : (card_num[7:4]   << 1);

assign sum = map[0] + card_num[59:56] +
             map[1] + card_num[51:48] +
             map[2] + card_num[43:40] +
             map[3] + card_num[35:32] +
             map[4] + card_num[27:24] +
             map[5] + card_num[19:16] +
             map[6] + card_num[11:8]  +
             map[7] + card_num[3:0];

always@(*) begin
    case(sum)
        50,60,70,80,90,100,110,120 : out_valid_ = 1;
        default : out_valid_ = 0;
    endcase
end
assign out_valid = out_valid_;

multiplier mul0(price[3:0],   snack_num[3:0],   price_total[0]);
multiplier mul1(price[7:4],   snack_num[7:4],   price_total[1]);
multiplier mul2(price[11:8],  snack_num[11:8],  price_total[2]);
multiplier mul3(price[15:12], snack_num[15:12], price_total[3]);
multiplier mul4(price[19:16], snack_num[19:16], price_total[4]);
multiplier mul5(price[23:20], snack_num[23:20], price_total[5]);
multiplier mul6(price[27:24], snack_num[27:24], price_total[6]);
multiplier mul7(price[31:28], snack_num[31:28], price_total[7]);

Sort_8_element sort(.in0(price_total[0]), .in1(price_total[1]), .in2(price_total[2]), .in3(price_total[3]), 
                    .in4(price_total[4]), .in5(price_total[5]), .in6(price_total[6]), .in7(price_total[7]),
                    .out0(sort_out[0]) , .out1(sort_out[1]) , .out2(sort_out[2]) , .out3(sort_out[3]), 
                    .out4(sort_out[4]) , .out5(sort_out[5]) , .out6(sort_out[6]) , .out7(sort_out[7]) );

assign s1 = input_money + ~sort_out[0] + 1'b1;
assign s2 = s1 + ~sort_out[1] + 1'b1;
assign s3 = s2 + ~sort_out[2] + 1'b1;
assign s4 = s3 + ~sort_out[3] + 1'b1;
assign s5 = s4 + ~sort_out[4] + 1'b1;
assign s6 = s5 + ~sort_out[5] + 1'b1;
assign s7 = s6 + ~sort_out[6] + 1'b1;
assign s8 = s7 + ~sort_out[7] + 1'b1;

always@(*) begin
    if(sort_out[0] > input_money || !out_valid) begin
        out_change_ = input_money;
    end
    else if(sort_out[2] > s2) begin
        out_change_ = s2;
    end
    else if(sort_out[1] > s1) begin
        out_change_ = s1;
    end
    else if(sort_out[3] > s3) begin
        out_change_ = s3;
    end
    else if(sort_out[4] > s4) begin
        out_change_ = s4;
    end
    else if(sort_out[5] > s5) begin
        out_change_ = s5;
    end
    else if(sort_out[6] > s6) begin
        out_change_ = s6;
    end
    else if(sort_out[7] > s7) begin
        out_change_ = s7;
    end
    else begin
        out_change_ = s8;
    end

end

assign out_change = out_change_;

endmodule

module Sort_8_element(
	in0, in1, in2, in3, in4, in5, in6, in7,
	
	out0, out1, out2, out3, out4, out5, out6, out7
);

input [7:0] in0, in1, in2, in3, in4, in5, in6, in7;
output [7:0] out0, out1, out2, out3, out4, out5, out6, out7;

wire [7:0] a[0:7], b[0:7], c[0:7], d[0:3], e[0:3], f[0:5];

assign a[0] = ( in2>in0 ) ? in2 : in0 ;
assign a[2] = ( in2>in0 ) ? in0 : in2 ;
assign a[1] = ( in3>in1 ) ? in3 : in1 ;
assign a[3] = ( in3>in1 ) ? in1 : in3 ;
assign a[4] = ( in6>in4 ) ? in6 : in4 ;
assign a[6] = ( in6>in4 ) ? in4 : in6 ;
assign a[5] = ( in5>in7 ) ? in5 : in7 ;
assign a[7] = ( in5>in7 ) ? in7 : in5 ;
//
assign b[0] = ( a[0]>a[4] ) ? a[0] : a[4] ;
assign b[4] = ( a[0]>a[4] ) ? a[4] : a[0] ;
assign b[1] = ( a[5]>a[1] ) ? a[5] : a[1] ;
assign b[5] = ( a[5]>a[1] ) ? a[1] : a[5] ;
assign b[2] = ( a[6]>a[2] ) ? a[6] : a[2] ;
assign b[6] = ( a[6]>a[2] ) ? a[2] : a[6] ;
assign b[3] = ( a[3]>a[7] ) ? a[3] : a[7] ;
assign b[7] = ( a[3]>a[7] ) ? a[7] : a[3] ;
//
assign c[0] = ( b[0]>b[1] ) ? b[0] : b[1] ;
assign c[1] = ( b[0]>b[1] ) ? b[1] : b[0] ;
assign c[2] = ( b[3]>b[2] ) ? b[3] : b[2] ;
assign c[3] = ( b[3]>b[2] ) ? b[2] : b[3] ;
assign c[4] = ( b[4]>b[5] ) ? b[4] : b[5] ;
assign c[5] = ( b[4]>b[5] ) ? b[5] : b[4] ;
assign c[6] = ( b[6]>b[7] ) ? b[6] : b[7] ;
assign c[7] = ( b[6]>b[7] ) ? b[7] : b[6] ;
//
assign out0 = c[0] ;
assign out7 = c[7] ;
//
assign d[0] = ( c[2]>c[4] ) ? c[2] : c[4] ;
assign d[2] = ( c[2]>c[4] ) ? c[4] : c[2] ;
assign d[1] = ( c[5]>c[3] ) ? c[5] : c[3] ;
assign d[3] = ( c[5]>c[3] ) ? c[3] : c[5] ;
//
assign e[0] = ( c[1]>d[2] ) ? c[1] : d[2] ;
assign e[2] = ( c[1]>d[2] ) ? d[2] : c[1] ;
assign e[1] = ( d[1]>c[6] ) ? d[1] : c[6] ;
assign e[3] = ( d[1]>c[6] ) ? c[6] : d[1] ;
//
assign f[0] = ( e[0]>d[0] ) ? e[0] : d[0] ;
assign f[1] = ( e[0]>d[0] ) ? d[0] : e[0] ;
assign f[2] = ( e[1]>e[2] ) ? e[1] : e[2] ;
assign f[3] = ( e[1]>e[2] ) ? e[2] : e[1] ;
assign f[4] = ( d[3]>e[3] ) ? d[3] : e[3] ;
assign f[5] = ( d[3]>e[3] ) ? e[3] : d[3] ;
//
assign out1 = f[0] ;
assign out2 = f[1] ;
assign out3 = f[2] ;
assign out4 = f[3] ;
assign out5 = f[4] ;
assign out6 = f[5] ;

endmodule


module multiplier (
    input [3:0] A,       // 4-bit input A
    input [3:0] B,       // 4-bit input B
    output [7:0] OUT     // 8-bit output product
);

    wire [7:0] products [3:0];

    assign products[0] = A & {8{B[0]}};
    assign products[1] = (A & {8{B[1]}}) << 1;
    assign products[2] = (A & {8{B[2]}}) << 2;
    assign products[3] = (A & {8{B[3]}}) << 3;

    assign OUT = (products[3] + products[2]) + (products[0] + products[1]);

endmodule
