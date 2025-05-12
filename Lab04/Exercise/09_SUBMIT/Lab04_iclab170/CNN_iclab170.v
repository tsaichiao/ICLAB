//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Convolution Neural Network 
//   Author     		: Yu-Chi Lin (a6121461214.st12@nycu.edu.tw)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : CNN.v
//   Module Name : CNN
//   Release version : V1.0 (Release Date: 2024-10)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module CNN(
    //Input Port
    clk,
    rst_n,
    in_valid,
    Img,
    Kernel_ch1,
    Kernel_ch2,
	Weight,
    Opt,

    //Output Port
    out_valid,
    out
    );


//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------

// IEEE floating point parameter
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;


input rst_n, clk, in_valid;
input [inst_sig_width+inst_exp_width:0] Img, Kernel_ch1, Kernel_ch2, Weight;
input Opt;

output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;



//---------------------------------------------------------------------
//   Reg & Wires
//---------------------------------------------------------------------

reg [3:0] c_state, n_state;

reg [6:0] cnt, n_cnt;

reg [31:0] ker1[0:11], n_ker1[0:11];
reg [31:0] ker2[0:11], n_ker2[0:11];

reg [31:0] wei[0:23], n_wei[0:23];

// Opt[1] : 0 -> Sigmoid, Zero
// Opt[0] : 0 -> tanh, Replication 
reg Opt_reg, n_Opt_reg;

// original image
reg [31:0] ori_img[0:24], n_ori_img[0:24];

// feature map
reg [31:0] feature_map1[0:35];
reg [31:0] feature_map2[0:35];

reg [31:0] max_pooling1[0:3];
reg [31:0] max_pooling2[0:3];

// activation
// reg [31:0] activation_result1[0:7];
// reg [31:0] activation_result2[0:3];

// full connected
// reg [31:0] full_connected_result1;
// reg [31:0] full_connected_result2;
// reg [31:0] full_connected_result3;

// // normalization
// reg [31:0] normalized_result[0:7];

// reg [5:0] index;
integer i;

// reg [31:0]sum, exp1, exp2, exp3;

//---------------------------------------------------------------------
// Design
//---------------------------------------------------------------------
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 0;
    end
    else begin
        cnt <= n_cnt;
    end
end
always@(*) begin
    if(!in_valid && cnt == 0) begin
        n_cnt = 0;
    end
    else if(cnt == 90/*91*/) begin
        n_cnt = 0;
    end
    else begin
        n_cnt = cnt + 1;
    end
end

always@(posedge clk) begin

    ori_img <= n_ori_img;
    ker1 <= n_ker1;
    ker2 <= n_ker2;
    wei <= n_wei;
    Opt_reg <= n_Opt_reg;
end


always@(*) begin
    n_ori_img = ori_img;
    case (cnt)
        0,25,50 : n_ori_img[0] = Img;
        1,26,51 : n_ori_img[1] = Img;
        2,27,52 : n_ori_img[2] = Img;
        3,28,53 : n_ori_img[3] = Img;
        4,29,54 : n_ori_img[4] = Img;
        5,30,55 : n_ori_img[5] = Img;
        6,31,56 : n_ori_img[6] = Img;
        7,32,57 : n_ori_img[7] = Img;
        8,33,58 : n_ori_img[8] = Img;
        9,34,59 : n_ori_img[9] = Img;
        10,35,60 : n_ori_img[10] = Img;
        11,36,61 : n_ori_img[11] = Img;//
        12,37,62 : n_ori_img[12] = Img;
        13,38,63 : n_ori_img[13] = Img;
        14,39,64 : n_ori_img[14] = Img;
        15,40,65 : n_ori_img[15] = Img;
        16,41,66 : n_ori_img[16] = Img;
        17,42,67 : n_ori_img[17] = Img;
        18,43,68 : n_ori_img[18] = Img;
        19,44,69 : n_ori_img[19] = Img;
        20,45,70 : n_ori_img[20] = Img;
        21,46,71 : n_ori_img[21] = Img;
        22,47,72 : n_ori_img[22] = Img;
        23,48,73 : n_ori_img[23] = Img;
        24,49,74 : n_ori_img[24] = Img;
        default : n_ori_img = ori_img;
    endcase
end


always@(*) begin
    n_ker1 = ker1;
    n_ker2 = ker2;
    if (in_valid && cnt < 12) begin
        n_ker1[cnt] = Kernel_ch1;
        n_ker2[cnt] = Kernel_ch2;
    end
    else if(cnt == 33 || cnt == 58)begin
        n_ker1[0] = ker1[4];
        n_ker1[1] = ker1[5];
        n_ker1[2] = ker1[6];
        n_ker1[3] = ker1[7];
        n_ker1[4] = ker1[8];
        n_ker1[5] = ker1[9];
        n_ker1[6] = ker1[10];
        n_ker1[7] = ker1[11];

        n_ker2[0] = ker2[4];
        n_ker2[1] = ker2[5];
        n_ker2[2] = ker2[6];
        n_ker2[3] = ker2[7];
        n_ker2[4] = ker2[8];
        n_ker2[5] = ker2[9];
        n_ker2[6] = ker2[10];
        n_ker2[7] = ker2[11];
    end
    /*else if()begin
        n_ker1[3:0] = ker1[11:8];
        n_ker2[3:0] = ker2[11:8];
    end*/
    else begin
        n_ker1 = ker1;
        n_ker2 = ker2;
    end
end

/*always@(posedge clk) begin
    if(cnt < 24)begin
        wei[23] <= Weight;
        wei[22] <= wei[23];
        wei[21] <= wei[22];
        wei[20] <= wei[21];
        wei[19] <= wei[20];
        wei[18] <= wei[19];
        wei[17] <= wei[18];
        wei[16] <= wei[17];
        wei[15] <= wei[16];
        wei[14] <= wei[15];
        wei[13] <= wei[14];
        wei[12] <= wei[13];
        wei[11] <= wei[12];
        wei[10] <= wei[11];
        wei[9] <= wei[10];
        wei[8] <= wei[9];
        wei[7] <= wei[8];
        wei[6] <= wei[7];
        wei[5] <= wei[6];
        wei[4] <= wei[5];
        wei[3] <= wei[4];
        wei[2] <= wei[3];
        wei[1] <= wei[2];
        wei[0] <= wei[1];
    end
    
end*/
// read data - Weight
always@(*) begin
    n_wei = wei;
    if(in_valid && cnt < 24) 
        n_wei[23] = Weight;
    else begin
        n_wei[23] = wei[0];
    end
    n_wei[0] = wei[1];
    n_wei[1] = wei[2];
    n_wei[2] = wei[3];
    n_wei[3] = wei[4];
    n_wei[4] = wei[5];
    n_wei[5] = wei[6];
    n_wei[6] = wei[7];
    n_wei[7] = wei[8];
    n_wei[8] = wei[9];
    n_wei[9] = wei[10];
    n_wei[10] = wei[11];
    n_wei[11] = wei[12];
    n_wei[12] = wei[13];
    n_wei[13] = wei[14];
    n_wei[14] = wei[15];
    n_wei[15] = wei[16];
    n_wei[16] = wei[17];
    n_wei[17] = wei[18];
    n_wei[18] = wei[19];
    n_wei[19] = wei[20];
    n_wei[20] = wei[21];
    n_wei[21] = wei[22];
    n_wei[22] = wei[23];

end
/*always@(*) begin
    n_wei = wei;
    if(in_valid && cnt < 24) 
        n_wei[cnt] = Weight;
    else if(cnt == 79 || cnt == 80 || cnt == 81) begin
        n_wei[0] = wei[1];
        n_wei[1] = wei[2];
        n_wei[2] = wei[3];
        //n_wei[3] = wei[4];
        n_wei[4] = wei[5];
        n_wei[5] = wei[6];
        n_wei[6] = wei[7];
        //n_wei[7] = wei[8];
        n_wei[8] = wei[9];
        n_wei[9] = wei[10];
        n_wei[10] = wei[11];
        //n_wei[11] = wei[12];
        n_wei[12] = wei[13];
        n_wei[13] = wei[14];
        n_wei[14] = wei[15];
        //n_wei[15] = wei[16];
        n_wei[16] = wei[17];
        n_wei[17] = wei[18];
        n_wei[18] = wei[19];
        //n_wei[19] = wei[20];
        n_wei[20] = wei[21];
        n_wei[21] = wei[22];
        n_wei[22] = wei[23];
    end
    else begin
        n_wei = wei;
    end
end*/

always@(*) begin
    n_Opt_reg = (cnt == 0  && in_valid) ? Opt : Opt_reg;
end

//==============================================//
//                 multipliers                  //
//==============================================//
reg [31:0] mul00_op1, mul00_op2;
wire [31:0] mul00_result;
reg [31:0] mul00_result_reg;
reg [31:0] mul01_op1, mul01_op2;
wire [31:0] mul01_result;
reg [31:0] mul01_result_reg;
reg [31:0] mul02_op1, mul02_op2;
wire [31:0] mul02_result;
reg [31:0] mul02_result_reg;
reg [31:0] mul03_op1, mul03_op2;
wire [31:0] mul03_result;
reg [31:0] mul03_result_reg;
reg [31:0] mul04_op1, mul04_op2;
wire [31:0] mul04_result;
reg [31:0] mul04_result_reg;
reg [31:0] mul05_op1, mul05_op2;  
wire [31:0] mul05_result;
reg [31:0] mul05_result_reg;
reg [31:0] mul06_op1, mul06_op2;
wire [31:0] mul06_result;
reg [31:0] mul06_result_reg;
reg [31:0] mul07_op1, mul07_op2;
wire [31:0] mul07_result;
reg [31:0] mul07_result_reg;

reg [31:0] mul10_op1, mul10_op2;
wire [31:0] mul10_result;
reg [31:0] mul10_result_reg;
reg [31:0] mul11_op1, mul11_op2;
wire [31:0] mul11_result;
reg [31:0] mul11_result_reg;
reg [31:0] mul12_op1, mul12_op2;
wire [31:0] mul12_result;
reg [31:0] mul12_result_reg;
reg [31:0] mul13_op1, mul13_op2;
wire [31:0] mul13_result;
reg [31:0] mul13_result_reg;
reg [31:0] mul14_op1, mul14_op2;
wire [31:0] mul14_result;
reg [31:0] mul14_result_reg;
reg [31:0] mul15_op1, mul15_op2;  
wire [31:0] mul15_result;
reg [31:0] mul15_result_reg;
reg [31:0] mul16_op1, mul16_op2;
wire [31:0] mul16_result;
reg [31:0] mul16_result_reg;
reg [31:0] mul17_op1, mul17_op2;
wire [31:0] mul17_result;
reg [31:0] mul17_result_reg;
//reg [31:0] mul8_op1, mul8_op2;
//wire [31:0] mul8_result;
fp_mult mult00(.inst_a(mul00_op1), .inst_b(mul00_op2), .inst_rnd(3'b000), .z_inst(mul00_result));//k1
fp_mult mult01(.inst_a(mul01_op1), .inst_b(mul01_op2), .inst_rnd(3'b000), .z_inst(mul01_result));
fp_mult mult02(.inst_a(mul02_op1), .inst_b(mul02_op2), .inst_rnd(3'b000), .z_inst(mul02_result));
fp_mult mult03(.inst_a(mul03_op1), .inst_b(mul03_op2), .inst_rnd(3'b000), .z_inst(mul03_result));
fp_mult mult04(.inst_a(mul04_op1), .inst_b(mul04_op2), .inst_rnd(3'b000), .z_inst(mul04_result));
fp_mult mult05(.inst_a(mul05_op1), .inst_b(mul05_op2), .inst_rnd(3'b000), .z_inst(mul05_result));
fp_mult mult06(.inst_a(mul06_op1), .inst_b(mul06_op2), .inst_rnd(3'b000), .z_inst(mul06_result));
fp_mult mult07(.inst_a(mul07_op1), .inst_b(mul07_op2), .inst_rnd(3'b000), .z_inst(mul07_result));

fp_mult mult10(.inst_a(mul10_op1), .inst_b(mul10_op2), .inst_rnd(3'b000), .z_inst(mul10_result));//k2
fp_mult mult11(.inst_a(mul11_op1), .inst_b(mul11_op2), .inst_rnd(3'b000), .z_inst(mul11_result));
fp_mult mult12(.inst_a(mul12_op1), .inst_b(mul12_op2), .inst_rnd(3'b000), .z_inst(mul12_result));
fp_mult mult13(.inst_a(mul13_op1), .inst_b(mul13_op2), .inst_rnd(3'b000), .z_inst(mul13_result));
fp_mult mult14(.inst_a(mul14_op1), .inst_b(mul14_op2), .inst_rnd(3'b000), .z_inst(mul14_result));
fp_mult mult15(.inst_a(mul15_op1), .inst_b(mul15_op2), .inst_rnd(3'b000), .z_inst(mul15_result));
fp_mult mult16(.inst_a(mul16_op1), .inst_b(mul16_op2), .inst_rnd(3'b000), .z_inst(mul16_result));
fp_mult mult17(.inst_a(mul17_op1), .inst_b(mul17_op2), .inst_rnd(3'b000), .z_inst(mul17_result));
//fp_mult mult8(.inst_a(mul8_op1), .inst_b(mul8_op2), .inst_rnd(3'b000), .z_inst(mul8_result));

always@(posedge clk) begin

    mul00_result_reg <= mul00_result;//k1
    mul01_result_reg <= mul01_result;
    mul02_result_reg <= mul02_result;
    mul03_result_reg <= mul03_result;
    mul04_result_reg <= mul04_result;
    mul05_result_reg <= mul05_result;
    mul06_result_reg <= mul06_result;
    mul07_result_reg <= mul07_result;

    mul10_result_reg <= mul10_result;//k2
    mul11_result_reg <= mul11_result;
    mul12_result_reg <= mul12_result;
    mul13_result_reg <= mul13_result;
    mul14_result_reg <= mul14_result;
    mul15_result_reg <= mul15_result;
    mul16_result_reg <= mul16_result;
    mul17_result_reg <= mul17_result;
end

//==============================================//
//                    adders                    //
//==============================================//
reg [31:0] add00_op1, add00_op2;
wire [31:0] add00_result;
reg [31:0] add01_op1, add01_op2;
wire [31:0] add01_result;
reg [31:0] add02_op1, add02_op2;
wire [31:0] add02_result;
reg [31:0] add03_op1, add03_op2;
wire [31:0] add03_result;
reg [31:0] add04_op1, add04_op2;
wire [31:0] add04_result;
reg [31:0] add05_op1, add05_op2;
wire [31:0] add05_result;
reg [31:0] add06_op1, add06_op2;
wire [31:0] add06_result;
reg [31:0] add07_op1, add07_op2;
wire [31:0] add07_result;

reg [31:0] add10_op1, add10_op2;
wire [31:0] add10_result;
reg [31:0] add11_op1, add11_op2;
wire [31:0] add11_result;
reg [31:0] add12_op1, add12_op2;
wire [31:0] add12_result;
reg [31:0] add13_op1, add13_op2;
wire [31:0] add13_result;
reg [31:0] add14_op1, add14_op2;
wire [31:0] add14_result;
reg [31:0] add15_op1, add15_op2;
wire [31:0] add15_result;
reg [31:0] add16_op1, add16_op2;
wire [31:0] add16_result;
reg [31:0] add17_op1, add17_op2;
wire [31:0] add17_result;
// reg [31:0] add8_op1, add8_op2;
//wire [31:0] add8_result;

// k1
fp_add add00(.inst_a(add00_op1), .inst_b(add00_op2), .inst_rnd(3'b000), .z_inst(add00_result));// k1
fp_add add01(.inst_a(add01_op1), .inst_b(add01_op2), .inst_rnd(3'b000), .z_inst(add01_result));
fp_add add02(.inst_a(add02_op1), .inst_b(add02_op2), .inst_rnd(3'b000), .z_inst(add02_result));
fp_add add03(.inst_a(add03_op1), .inst_b(add03_op2), .inst_rnd(3'b000), .z_inst(add03_result));
fp_add add04(.inst_a(add04_op1), .inst_b(add04_op2), .inst_rnd(3'b000), .z_inst(add04_result));
fp_add add05(.inst_a(add05_op1), .inst_b(add05_op2), .inst_rnd(3'b000), .z_inst(add05_result));
fp_add add06(.inst_a(add06_op1), .inst_b(add06_op2), .inst_rnd(3'b000), .z_inst(add06_result));
fp_add add07(.inst_a(add07_op1), .inst_b(add07_op2), .inst_rnd(3'b000), .z_inst(add07_result));
// fp_add add8(.inst_a(add7_result), .inst_b(add6_result), .inst_rnd(3'b000), .z_inst(add8_result));

// k2
fp_add add10(.inst_a(add10_op1), .inst_b(add10_op2), .inst_rnd(3'b000), .z_inst(add10_result));// k2
fp_add add11(.inst_a(add11_op1), .inst_b(add11_op2), .inst_rnd(3'b000), .z_inst(add11_result));
fp_add add12(.inst_a(add12_op1), .inst_b(add12_op2), .inst_rnd(3'b000), .z_inst(add12_result));
fp_add add13(.inst_a(add13_op1), .inst_b(add13_op2), .inst_rnd(3'b000), .z_inst(add13_result));
fp_add add14(.inst_a(add14_op1), .inst_b(add14_op2), .inst_rnd(3'b000), .z_inst(add14_result));
fp_add add15(.inst_a(add15_op1), .inst_b(add15_op2), .inst_rnd(3'b000), .z_inst(add15_result));
fp_add add16(.inst_a(add16_op1), .inst_b(add16_op2), .inst_rnd(3'b000), .z_inst(add16_result));
fp_add add17(.inst_a(add17_op1), .inst_b(add17_op2), .inst_rnd(3'b000), .z_inst(add17_result));

reg  [31:0] exp0_input, exp1_input;
wire [31:0] exp0_result, exp1_result;
reg  [31:0] exp0_result_reg, exp1_result_reg;
fp_exp exp00(.inst_a(exp0_input), .z_inst(exp0_result));
fp_exp exp01(.inst_a(exp1_input), .z_inst(exp1_result));

always@(posedge clk) begin
    exp0_result_reg <= exp0_result;
    exp1_result_reg <= exp1_result;
end

reg  [31:0] div0_op1, div0_op2;
wire [31:0] div0_result;
// reg  [31:0] div0_result_reg;
reg  [31:0] div1_op1, div1_op2;
wire [31:0] div1_result;
// reg  [31:0] div1_result_reg;
fp_div div0(.inst_a(div0_op1), .inst_b(div0_op2), .inst_rnd(3'b000), .z_inst(div0_result));
fp_div div1(.inst_a(div1_op1), .inst_b(div1_op2), .inst_rnd(3'b000), .z_inst(div1_result));

// always@(posedge clk) begin
//     div0_result_reg <= div0_result;
//     div1_result_reg <= div1_result;
// end

always@(*) begin
        //k1
        add00_op1 = mul00_result_reg; add00_op2 = mul01_result_reg;
        add01_op1 = mul02_result_reg; add01_op2 = mul03_result_reg;
        add02_op1 = add00_result;     add02_op2 = feature_map1[0];
        add03_op1 = add02_result;     add03_op2 = add01_result;
        add04_op1 = mul04_result_reg; add04_op2 = mul05_result_reg;
        add05_op1 = mul06_result_reg; add05_op2 = mul07_result_reg;
        add06_op1 = add04_result;     add06_op2 = feature_map1[1];
        add07_op1 = add06_result;     add07_op2 = add05_result;
        //k2
        add10_op1 = mul10_result_reg; add10_op2 = mul11_result_reg;
        add11_op1 = mul12_result_reg; add11_op2 = mul13_result_reg;
        add12_op1 = add10_result;     add12_op2 = feature_map2[0];
        add13_op1 = add12_result;     add13_op2 = add11_result;
        add14_op1 = mul14_result_reg; add14_op2 = mul15_result_reg;
        add15_op1 = mul16_result_reg; add15_op2 = mul17_result_reg;
        add16_op1 = add14_result;     add16_op2 = feature_map2[1];
        add17_op1 = add16_result;     add17_op2 = add15_result;
    // activation
    if(cnt == 80) begin
        add01_op1 = mul00_result_reg; add01_op2 = mul01_result_reg;
        add03_op1 = mul02_result_reg; add03_op2 = mul03_result_reg;
        add05_op1 = mul10_result_reg; add05_op2 = mul11_result_reg;//04 05
    end
    else if(cnt == 81 || cnt == 82 || cnt == 83) begin
        add00_op1 = mul00_result_reg; add00_op2 = feature_map1[33];
        add01_op1 = add00_result;     add01_op2 = mul01_result_reg; //full_connected_result1
        add02_op1 = mul02_result_reg; add02_op2 = feature_map1[34];
        add03_op1 = add02_result;     add03_op2 = mul03_result_reg; //full_connected_result2
        add04_op1 = mul10_result_reg; add04_op2 = feature_map1[35];
        add05_op1 = add04_result;     add05_op2 = mul11_result_reg; //full_connected_result3
    end
    // softmax
    else if(cnt == 85) begin
        add01_op1 = exp0_result_reg; 
        add01_op2 = exp1_result_reg;
    end
    else if(cnt == 86) begin
        add01_op1 = exp0_result_reg; 
        add01_op2 = feature_map1[35];//sum
    end
end

always@(posedge clk) begin
    if(cnt == 0) begin
        for(i = 0; i < 36; i = i + 1) begin
            feature_map1[i] <= 0;
            feature_map2[i] <= 0;
        end
    end
    else if((cnt > 9 && cnt < 28) || (cnt > 34 && cnt < 53) || (cnt > 59 && cnt < 78)) begin
        feature_map1[0] <= feature_map1[2];
        feature_map1[1] <= feature_map1[3];
        feature_map1[2] <= feature_map1[4];
        feature_map1[3] <= feature_map1[5];
        feature_map1[4] <= feature_map1[6];
        feature_map1[5] <= feature_map1[7];
        feature_map1[6] <= feature_map1[8];
        feature_map1[7] <= feature_map1[9];
        feature_map1[8] <= feature_map1[10];
        feature_map1[9] <= feature_map1[11];
        feature_map1[10] <= feature_map1[12];
        feature_map1[11] <= feature_map1[13];
        feature_map1[12] <= feature_map1[14];
        feature_map1[13] <= feature_map1[15];
        feature_map1[14] <= feature_map1[16];
        feature_map1[15] <= feature_map1[17];
        feature_map1[16] <= feature_map1[18];
        feature_map1[17] <= feature_map1[19];
        feature_map1[18] <= feature_map1[20];
        feature_map1[19] <= feature_map1[21];
        feature_map1[20] <= feature_map1[22];
        feature_map1[21] <= feature_map1[23];
        feature_map1[22] <= feature_map1[24];
        feature_map1[23] <= feature_map1[25];
        feature_map1[24] <= feature_map1[26];
        feature_map1[25] <= feature_map1[27];
        feature_map1[26] <= feature_map1[28];
        feature_map1[27] <= feature_map1[29];
        feature_map1[28] <= feature_map1[30];
        feature_map1[29] <= feature_map1[31];
        feature_map1[30] <= feature_map1[32];
        feature_map1[31] <= feature_map1[33];
        feature_map1[32] <= feature_map1[34];
        feature_map1[33] <= feature_map1[35];
        feature_map1[34] <= add03_result;
        feature_map1[35] <= add07_result;

        feature_map2[0] <= feature_map2[2];
        feature_map2[1] <= feature_map2[3];
        feature_map2[2] <= feature_map2[4];
        feature_map2[3] <= feature_map2[5];
        feature_map2[4] <= feature_map2[6];
        feature_map2[5] <= feature_map2[7];
        feature_map2[6] <= feature_map2[8];
        feature_map2[7] <= feature_map2[9];
        feature_map2[8] <= feature_map2[10];
        feature_map2[9] <= feature_map2[11];
        feature_map2[10] <= feature_map2[12];
        feature_map2[11] <= feature_map2[13];
        feature_map2[12] <= feature_map2[14];
        feature_map2[13] <= feature_map2[15];
        feature_map2[14] <= feature_map2[16];
        feature_map2[15] <= feature_map2[17];
        feature_map2[16] <= feature_map2[18];
        feature_map2[17] <= feature_map2[19];
        feature_map2[18] <= feature_map2[20];
        feature_map2[19] <= feature_map2[21];
        feature_map2[20] <= feature_map2[22];
        feature_map2[21] <= feature_map2[23];
        feature_map2[22] <= feature_map2[24];
        feature_map2[23] <= feature_map2[25];
        feature_map2[24] <= feature_map2[26];
        feature_map2[25] <= feature_map2[27];
        feature_map2[26] <= feature_map2[28];
        feature_map2[27] <= feature_map2[29];
        feature_map2[28] <= feature_map2[30];
        feature_map2[29] <= feature_map2[31];
        feature_map2[30] <= feature_map2[32];
        feature_map2[31] <= feature_map2[33];
        feature_map2[32] <= feature_map2[34];
        feature_map2[33] <= feature_map2[35];
        feature_map2[34] <= add13_result;
        feature_map2[35] <= add17_result;
    end
    else if(cnt == 78 || cnt == 79 || cnt == 80 || cnt == 81) begin
        feature_map1[0] <= div0_result; //activation_result1[0]
        feature_map2[0] <= div1_result; //activation_result1[4]
        feature_map1[33] <= add01_result; //full_connected_result1
        feature_map1[34] <= add03_result; //full_connected_result2
        feature_map1[35] <= add05_result; //full_connected_result3
    end
    if(cnt == 82 || cnt == 83) begin
        feature_map1[33] <= add01_result; //full_connected_result1
        feature_map1[34] <= add03_result; //full_connected_result2
        feature_map1[35] <= add05_result; //full_connected_result3
    end
    if(cnt == 84) begin
        feature_map1[32] <= exp0_result;//exp1
        feature_map1[33] <= exp1_result;//exp2
    end
    else if(cnt == 85) begin
        feature_map1[34] <= exp0_result;//exp3
        feature_map1[35] <= add01_result;//sum
    end
    else if(cnt == 86) begin
        feature_map1[35] <= add01_result;//sum
    end
    else if(cnt == 87 || cnt == 88 || cnt == 89) begin
        feature_map1[0] <= div0_result; //output
    end

end

always@(*) begin
    mul00_op1 = 0; mul01_op1 = 0; 
    mul02_op1 = 0; mul03_op1 = 0;
    mul04_op1 = 0; mul05_op1 = 0;
    mul06_op1 = 0; mul07_op1 = 0;
    // row 0
    if(cnt == 9 || cnt == 34 || cnt == 59) begin
        mul00_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul01_op1 = (Opt_reg) ? ori_img[ 0] : 0; 
        mul02_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul03_op1 =             ori_img[ 0]; 
        mul04_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul05_op1 = (Opt_reg) ? ori_img[ 1] : 0;
        mul06_op1 =             ori_img[ 0];     mul07_op1 =             ori_img[ 1];
    end else if(cnt == 10 || cnt == 35 || cnt == 60) begin
        mul00_op1 = (Opt_reg) ? ori_img[ 1] : 0; mul01_op1 = (Opt_reg) ? ori_img[ 2] : 0; 
        mul02_op1 =             ori_img[ 1];     mul03_op1 =             ori_img[ 2]; 
        mul04_op1 = (Opt_reg) ? ori_img[ 2] : 0; mul05_op1 = (Opt_reg) ? ori_img[ 3] : 0;
        mul06_op1 =             ori_img[ 2];     mul07_op1 =             ori_img[ 3];
    end else if(cnt == 11 || cnt == 36 || cnt == 61) begin 
        mul00_op1 = (Opt_reg) ? ori_img[ 3] : 0; mul01_op1 = (Opt_reg) ? ori_img[ 4] : 0; 
        mul02_op1 =             ori_img[ 3];     mul03_op1 =             ori_img[ 4]; 
        mul04_op1 = (Opt_reg) ? ori_img[ 4] : 0; mul05_op1 = (Opt_reg) ? ori_img[ 4] : 0;
        mul06_op1 =             ori_img[ 4];     mul07_op1 = (Opt_reg) ? ori_img[ 4] : 0; 
    end 
    // row 1
    else if(cnt == 12 || cnt == 37 || cnt == 62) begin
        mul00_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul01_op1 =             ori_img[ 0]; 
        mul02_op1 = (Opt_reg) ? ori_img[ 5] : 0; mul03_op1 =             ori_img[ 5]; 
        mul04_op1 =             ori_img[ 0];     mul05_op1 =             ori_img[ 1];
        mul06_op1 =             ori_img[ 5];     mul07_op1 =             ori_img[ 6];  
    end else if(cnt == 13 || cnt == 38 || cnt == 63) begin 
        mul00_op1 =             ori_img[ 1];     mul01_op1 =             ori_img[ 2]; 
        mul02_op1 =             ori_img[ 6];     mul03_op1 =             ori_img[ 7]; 
        mul04_op1 =             ori_img[ 2];     mul05_op1 =             ori_img[ 3];
        mul06_op1 =             ori_img[ 7];     mul07_op1 =             ori_img[ 8];                 
    end else if(cnt == 14 || cnt == 39 || cnt == 64) begin
        mul00_op1 =             ori_img[ 3];     mul01_op1 =             ori_img[ 4]; 
        mul02_op1 =             ori_img[ 8];     mul03_op1 =             ori_img[ 9]; 
        mul04_op1 =             ori_img[ 4];     mul05_op1 = (Opt_reg) ? ori_img[ 4] : 0;
        mul06_op1 =             ori_img[ 9];     mul07_op1 = (Opt_reg) ? ori_img[ 9] : 0; 
    end
    // row 2
    else if(cnt == 15 || cnt == 40 || cnt == 65) begin
        mul00_op1 = (Opt_reg) ? ori_img[ 5] : 0; mul01_op1 =             ori_img[ 5]; 
        mul02_op1 = (Opt_reg) ? ori_img[10] : 0; mul03_op1 =             ori_img[10]; 
        mul04_op1 =             ori_img[ 5];     mul05_op1 =             ori_img[ 6];
        mul06_op1 =             ori_img[10];     mul07_op1 =             ori_img[11];
    end else if(cnt == 16 || cnt == 41 || cnt == 66) begin
        mul00_op1 =             ori_img[ 6];     mul01_op1 =             ori_img[ 7]; 
        mul02_op1 =             ori_img[11];     mul03_op1 =             ori_img[12]; 
        mul04_op1 =             ori_img[ 7];     mul05_op1 =             ori_img[ 8];
        mul06_op1 =             ori_img[12];     mul07_op1 =             ori_img[13];
    end else if(cnt == 17 || cnt == 42 || cnt == 67) begin    
        mul00_op1 =             ori_img[ 8];     mul01_op1 =             ori_img[ 9]; 
        mul02_op1 =             ori_img[13];     mul03_op1 =             ori_img[14]; 
        mul04_op1 =             ori_img[ 9];     mul05_op1 = (Opt_reg) ? ori_img[ 9] : 0;
        mul06_op1 =             ori_img[14];     mul07_op1 = (Opt_reg) ? ori_img[14] : 0;                
    end 
    // row 3
    else if(cnt == 18 || cnt == 43 || cnt == 68) begin    
        mul00_op1 = (Opt_reg) ? ori_img[10] : 0; mul01_op1 =             ori_img[10]; 
        mul02_op1 = (Opt_reg) ? ori_img[15] : 0; mul03_op1 =             ori_img[15]; 
        mul04_op1 =             ori_img[10];     mul05_op1 =             ori_img[11];
        mul06_op1 =             ori_img[15];     mul07_op1 =             ori_img[16];
    end else if(cnt == 19 || cnt == 44 || cnt == 69) begin    
        mul00_op1 =             ori_img[11];     mul01_op1 =             ori_img[12]; 
        mul02_op1 =             ori_img[16];     mul03_op1 =             ori_img[17]; 
        mul04_op1 =             ori_img[12];     mul05_op1 =             ori_img[13];
        mul06_op1 =             ori_img[17];     mul07_op1 =             ori_img[18];            
    end else if(cnt == 20 || cnt == 45 || cnt == 70) begin
        mul00_op1 =             ori_img[13];     mul01_op1 =             ori_img[14]; 
        mul02_op1 =             ori_img[18];     mul03_op1 =             ori_img[19]; 
        mul04_op1 =             ori_img[14];     mul05_op1 = (Opt_reg) ? ori_img[14] : 0;
        mul06_op1 =             ori_img[19];     mul07_op1 = (Opt_reg) ? ori_img[19] : 0; 
    end
    // last row 
    else if(cnt == 21 || cnt == 46 || cnt == 71) begin
        mul00_op1 = (Opt_reg) ? ori_img[15] : 0; mul01_op1 =             ori_img[15]; 
        mul02_op1 = (Opt_reg) ? ori_img[20] : 0; mul03_op1 =             ori_img[20]; 
        mul04_op1 = (Opt_reg) ? ori_img[20] : 0; mul05_op1 =             ori_img[20];
        mul06_op1 = (Opt_reg) ? ori_img[20] : 0; mul07_op1 = (Opt_reg) ? ori_img[20] : 0; 
    end else if(cnt == 22 || cnt == 47 || cnt == 72) begin
        mul00_op1 =             ori_img[15];     mul01_op1 =             ori_img[16]; 
        mul02_op1 =             ori_img[20];     mul03_op1 =             ori_img[21]; 
        mul04_op1 =             ori_img[20];     mul05_op1 =             ori_img[21];
        mul06_op1 = (Opt_reg) ? ori_img[20] : 0; mul07_op1 = (Opt_reg) ? ori_img[21] : 0; 
    end else if(cnt == 23 || cnt == 48 || cnt == 73) begin    
        mul00_op1 =             ori_img[16];     mul01_op1 =             ori_img[17]; 
        mul02_op1 =             ori_img[21];     mul03_op1 =             ori_img[22]; 
        mul04_op1 =             ori_img[21];     mul05_op1 =             ori_img[22];
        mul06_op1 = (Opt_reg) ? ori_img[21] : 0; mul07_op1 = (Opt_reg) ? ori_img[22] : 0;             
    end else if(cnt == 24 || cnt == 49 || cnt == 74) begin    
        mul00_op1 =             ori_img[17];     mul01_op1 =             ori_img[18]; 
        mul02_op1 =             ori_img[22];     mul03_op1 =             ori_img[23]; 
        mul04_op1 =             ori_img[22];     mul05_op1 =             ori_img[23];
        mul06_op1 = (Opt_reg) ? ori_img[22] : 0; mul07_op1 = (Opt_reg) ? ori_img[23] : 0; 
    end else if(cnt == 25 || cnt == 50 || cnt == 75) begin    
        mul00_op1 =             ori_img[18];     mul01_op1 =             ori_img[19]; 
        mul02_op1 =             ori_img[23];     mul03_op1 =             ori_img[24]; 
        mul04_op1 =             ori_img[23];     mul05_op1 =             ori_img[24];
        mul06_op1 = (Opt_reg) ? ori_img[23] : 0; mul07_op1 = (Opt_reg) ? ori_img[24] : 0;            
    end else if(cnt == 26 || cnt == 51 || cnt == 76) begin   
        mul00_op1 =             ori_img[19];     mul01_op1 = (Opt_reg) ? ori_img[19] : 0;
        mul02_op1 =             ori_img[24];     mul03_op1 = (Opt_reg) ? ori_img[24] : 0;
        mul04_op1 =             ori_img[24];     mul05_op1 = (Opt_reg) ? ori_img[24] : 0;
        mul06_op1 = (Opt_reg) ? ori_img[24] : 0; mul07_op1 = (Opt_reg) ? ori_img[24] : 0; 
    end 
    // activation
    else if(cnt == 79 || cnt == 80 || cnt == 81 || cnt == 82) begin
        mul00_op1 = feature_map1[0]; mul01_op1 = feature_map2[0];//activation_result1[0] [4]
        mul02_op1 = feature_map1[0]; mul03_op1 = feature_map2[0];
        //mul10_op1 = feature_map1[0]; mul11_op1 = feature_map2[0];//mul04_op1 = feature_map1[0]; mul05_op1 = feature_map2[0];
    end
end
always@(*) begin
    mul10_op1 = mul00_op1; 
    mul11_op1 = mul01_op1; 
    mul12_op1 = mul02_op1; 
    mul13_op1 = mul03_op1;
    mul14_op1 = mul04_op1; 
    mul15_op1 = mul05_op1;
    mul16_op1 = mul06_op1; 
    mul17_op1 = mul07_op1;
end
/*always@(*) begin
    mul00_op1 = 0; mul01_op1 = 0; 
    mul02_op1 = 0; mul03_op1 = 0;
    mul04_op1 = 0; mul05_op1 = 0;
    mul06_op1 = 0; mul07_op1 = 0;
    mul10_op1 = 0; mul11_op1 = 0; 
    mul12_op1 = 0; mul13_op1 = 0;
    mul14_op1 = 0; mul15_op1 = 0;
    mul16_op1 = 0; mul17_op1 = 0;
    // row 0
    if(cnt == 9 || cnt == 34 || cnt == 59) begin
        mul00_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul01_op1 = (Opt_reg) ? ori_img[ 0] : 0; 
        mul02_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul03_op1 =             ori_img[ 0]; 
        mul04_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul05_op1 = (Opt_reg) ? ori_img[ 1] : 0;
        mul06_op1 =             ori_img[ 0];     mul07_op1 =             ori_img[ 1];

        mul10_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul11_op1 = (Opt_reg) ? ori_img[ 0] : 0; 
        mul12_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul13_op1 =             ori_img[ 0]; 
        mul14_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul15_op1 = (Opt_reg) ? ori_img[ 1] : 0;
        mul16_op1 =             ori_img[ 0];     mul17_op1 =             ori_img[ 1];
    end else if(cnt == 10 || cnt == 35 || cnt == 60) begin
        mul00_op1 = (Opt_reg) ? ori_img[ 1] : 0; mul01_op1 = (Opt_reg) ? ori_img[ 2] : 0; 
        mul02_op1 =             ori_img[ 1];     mul03_op1 =             ori_img[ 2]; 
        mul04_op1 = (Opt_reg) ? ori_img[ 2] : 0; mul05_op1 = (Opt_reg) ? ori_img[ 3] : 0;
        mul06_op1 =             ori_img[ 2];     mul07_op1 =             ori_img[ 3];

        mul10_op1 = (Opt_reg) ? ori_img[ 1] : 0; mul11_op1 = (Opt_reg) ? ori_img[ 2] : 0; 
        mul12_op1 =             ori_img[ 1];     mul13_op1 =             ori_img[ 2]; 
        mul14_op1 = (Opt_reg) ? ori_img[ 2] : 0; mul15_op1 = (Opt_reg) ? ori_img[ 3] : 0;
        mul16_op1 =             ori_img[ 2];     mul17_op1 =             ori_img[ 3];
    end else if(cnt == 11 || cnt == 36 || cnt == 61) begin 
        mul00_op1 = (Opt_reg) ? ori_img[ 3] : 0; mul01_op1 = (Opt_reg) ? ori_img[ 4] : 0; 
        mul02_op1 =             ori_img[ 3];     mul03_op1 =             ori_img[ 4]; 
        mul04_op1 = (Opt_reg) ? ori_img[ 4] : 0; mul05_op1 = (Opt_reg) ? ori_img[ 4] : 0;
        mul06_op1 =             ori_img[ 4];     mul07_op1 = (Opt_reg) ? ori_img[ 4] : 0; 

        mul10_op1 = (Opt_reg) ? ori_img[ 3] : 0; mul11_op1 = (Opt_reg) ? ori_img[ 4] : 0; 
        mul12_op1 =             ori_img[ 3];     mul13_op1 =             ori_img[ 4]; 
        mul14_op1 = (Opt_reg) ? ori_img[ 4] : 0; mul15_op1 = (Opt_reg) ? ori_img[ 4] : 0;
        mul16_op1 =             ori_img[ 4];     mul17_op1 = (Opt_reg) ? ori_img[ 4] : 0; 
    end 
    // row 1
    else if(cnt == 12 || cnt == 37 || cnt == 62) begin
        mul00_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul01_op1 =             ori_img[ 0]; 
        mul02_op1 = (Opt_reg) ? ori_img[ 5] : 0; mul03_op1 =             ori_img[ 5]; 
        mul04_op1 =             ori_img[ 0];     mul05_op1 =             ori_img[ 1];
        mul06_op1 =             ori_img[ 5];     mul07_op1 =             ori_img[ 6];  

        mul10_op1 = (Opt_reg) ? ori_img[ 0] : 0; mul11_op1 =             ori_img[ 0]; 
        mul12_op1 = (Opt_reg) ? ori_img[ 5] : 0; mul13_op1 =             ori_img[ 5]; 
        mul14_op1 =             ori_img[ 0];     mul15_op1 =             ori_img[ 1];
        mul16_op1 =             ori_img[ 5];     mul17_op1 =             ori_img[ 6]; 
    end else if(cnt == 13 || cnt == 38 || cnt == 63) begin 
        mul00_op1 =             ori_img[ 1];     mul01_op1 =             ori_img[ 2]; 
        mul02_op1 =             ori_img[ 6];     mul03_op1 =             ori_img[ 7]; 
        mul04_op1 =             ori_img[ 2];     mul05_op1 =             ori_img[ 3];
        mul06_op1 =             ori_img[ 7];     mul07_op1 =             ori_img[ 8];   

        mul10_op1 =             ori_img[ 1];     mul11_op1 =             ori_img[ 2]; 
        mul12_op1 =             ori_img[ 6];     mul13_op1 =             ori_img[ 7]; 
        mul14_op1 =             ori_img[ 2];     mul15_op1 =             ori_img[ 3];
        mul16_op1 =             ori_img[ 7];     mul17_op1 =             ori_img[ 8];               
    end else if(cnt == 14 || cnt == 39 || cnt == 64) begin
        mul00_op1 =             ori_img[ 3];     mul01_op1 =             ori_img[ 4]; 
        mul02_op1 =             ori_img[ 8];     mul03_op1 =             ori_img[ 9]; 
        mul04_op1 =             ori_img[ 4];     mul05_op1 = (Opt_reg) ? ori_img[ 4] : 0;
        mul06_op1 =             ori_img[ 9];     mul07_op1 = (Opt_reg) ? ori_img[ 9] : 0; 

        mul10_op1 =             ori_img[ 3];     mul11_op1 =             ori_img[ 4]; 
        mul12_op1 =             ori_img[ 8];     mul13_op1 =             ori_img[ 9]; 
        mul14_op1 =             ori_img[ 4];     mul15_op1 = (Opt_reg) ? ori_img[ 4] : 0;
        mul16_op1 =             ori_img[ 9];     mul17_op1 = (Opt_reg) ? ori_img[ 9] : 0; 
    end
    // row 2
    else if(cnt == 15 || cnt == 40 || cnt == 65) begin
        mul00_op1 = (Opt_reg) ? ori_img[ 5] : 0; mul01_op1 =             ori_img[ 5]; 
        mul02_op1 = (Opt_reg) ? ori_img[10] : 0; mul03_op1 =             ori_img[10]; 
        mul04_op1 =             ori_img[ 5];     mul05_op1 =             ori_img[ 6];
        mul06_op1 =             ori_img[10];     mul07_op1 =             ori_img[11];

        mul10_op1 = (Opt_reg) ? ori_img[ 5] : 0; mul11_op1 =             ori_img[ 5]; 
        mul12_op1 = (Opt_reg) ? ori_img[10] : 0; mul13_op1 =             ori_img[10]; 
        mul14_op1 =             ori_img[ 5];     mul15_op1 =             ori_img[ 6];
        mul16_op1 =             ori_img[10];     mul17_op1 =             ori_img[11];
    end else if(cnt == 16 || cnt == 41 || cnt == 66) begin
        mul00_op1 =             ori_img[ 6];     mul01_op1 =             ori_img[ 7]; 
        mul02_op1 =             ori_img[11];     mul03_op1 =             ori_img[12]; 
        mul04_op1 =             ori_img[ 7];     mul05_op1 =             ori_img[ 8];
        mul06_op1 =             ori_img[12];     mul07_op1 =             ori_img[13];

        mul10_op1 =             ori_img[ 6];     mul11_op1 =             ori_img[ 7]; 
        mul12_op1 =             ori_img[11];     mul13_op1 =             ori_img[12]; 
        mul14_op1 =             ori_img[ 7];     mul15_op1 =             ori_img[ 8];
        mul16_op1 =             ori_img[12];     mul17_op1 =             ori_img[13];
    end else if(cnt == 17 || cnt == 42 || cnt == 67) begin    
        mul00_op1 =             ori_img[ 8];     mul01_op1 =             ori_img[ 9]; 
        mul02_op1 =             ori_img[13];     mul03_op1 =             ori_img[14]; 
        mul04_op1 =             ori_img[ 9];     mul05_op1 = (Opt_reg) ? ori_img[ 9] : 0;
        mul06_op1 =             ori_img[14];     mul07_op1 = (Opt_reg) ? ori_img[14] : 0;      

        mul10_op1 =             ori_img[ 8];     mul11_op1 =             ori_img[ 9]; 
        mul12_op1 =             ori_img[13];     mul13_op1 =             ori_img[14]; 
        mul14_op1 =             ori_img[ 9];     mul15_op1 = (Opt_reg) ? ori_img[ 9] : 0;
        mul16_op1 =             ori_img[14];     mul17_op1 = (Opt_reg) ? ori_img[14] : 0;             
    end 
    // row 3
    else if(cnt == 18 || cnt == 43 || cnt == 68) begin    
        mul00_op1 = (Opt_reg) ? ori_img[10] : 0; mul01_op1 =             ori_img[10]; 
        mul02_op1 = (Opt_reg) ? ori_img[15] : 0; mul03_op1 =             ori_img[15]; 
        mul04_op1 =             ori_img[10];     mul05_op1 =             ori_img[11];
        mul06_op1 =             ori_img[15];     mul07_op1 =             ori_img[16];

        mul10_op1 = (Opt_reg) ? ori_img[10] : 0; mul11_op1 =             ori_img[10]; 
        mul12_op1 = (Opt_reg) ? ori_img[15] : 0; mul13_op1 =             ori_img[15]; 
        mul14_op1 =             ori_img[10];     mul15_op1 =             ori_img[11];
        mul16_op1 =             ori_img[15];     mul17_op1 =             ori_img[16];
    end else if(cnt == 19 || cnt == 44 || cnt == 69) begin    
        mul00_op1 =             ori_img[11];     mul01_op1 =             ori_img[12]; 
        mul02_op1 =             ori_img[16];     mul03_op1 =             ori_img[17]; 
        mul04_op1 =             ori_img[12];     mul05_op1 =             ori_img[13];
        mul06_op1 =             ori_img[17];     mul07_op1 =             ori_img[18];        

        mul10_op1 =             ori_img[11];     mul11_op1 =             ori_img[12]; 
        mul12_op1 =             ori_img[16];     mul13_op1 =             ori_img[17]; 
        mul14_op1 =             ori_img[12];     mul15_op1 =             ori_img[13];
        mul16_op1 =             ori_img[17];     mul17_op1 =             ori_img[18];         
    end else if(cnt == 20 || cnt == 45 || cnt == 70) begin
        mul00_op1 =             ori_img[13];     mul01_op1 =             ori_img[14]; 
        mul02_op1 =             ori_img[18];     mul03_op1 =             ori_img[19]; 
        mul04_op1 =             ori_img[14];     mul05_op1 = (Opt_reg) ? ori_img[14] : 0;
        mul06_op1 =             ori_img[19];     mul07_op1 = (Opt_reg) ? ori_img[19] : 0; 

        mul10_op1 =             ori_img[13];     mul11_op1 =             ori_img[14]; 
        mul12_op1 =             ori_img[18];     mul13_op1 =             ori_img[19]; 
        mul14_op1 =             ori_img[14];     mul15_op1 = (Opt_reg) ? ori_img[14] : 0;
        mul16_op1 =             ori_img[19];     mul17_op1 = (Opt_reg) ? ori_img[19] : 0; 
    end
    // last row 
    else if(cnt == 21 || cnt == 46 || cnt == 71) begin
        mul00_op1 = (Opt_reg) ? ori_img[15] : 0; mul01_op1 =             ori_img[15]; 
        mul02_op1 = (Opt_reg) ? ori_img[20] : 0; mul03_op1 =             ori_img[20]; 
        mul04_op1 = (Opt_reg) ? ori_img[20] : 0; mul05_op1 =             ori_img[20];
        mul06_op1 = (Opt_reg) ? ori_img[20] : 0; mul07_op1 = (Opt_reg) ? ori_img[20] : 0; 

        mul10_op1 = (Opt_reg) ? ori_img[15] : 0; mul11_op1 =             ori_img[15]; 
        mul12_op1 = (Opt_reg) ? ori_img[20] : 0; mul13_op1 =             ori_img[20]; 
        mul14_op1 = (Opt_reg) ? ori_img[20] : 0; mul15_op1 =             ori_img[20];
        mul16_op1 = (Opt_reg) ? ori_img[20] : 0; mul17_op1 = (Opt_reg) ? ori_img[20] : 0; 
    end else if(cnt == 22 || cnt == 47 || cnt == 72) begin
        mul00_op1 =             ori_img[15];     mul01_op1 =             ori_img[16]; 
        mul02_op1 =             ori_img[20];     mul03_op1 =             ori_img[21]; 
        mul04_op1 =             ori_img[20];     mul05_op1 =             ori_img[21];
        mul06_op1 = (Opt_reg) ? ori_img[20] : 0; mul07_op1 = (Opt_reg) ? ori_img[21] : 0; 

        mul10_op1 =             ori_img[15];     mul11_op1 =             ori_img[16]; 
        mul12_op1 =             ori_img[20];     mul13_op1 =             ori_img[21]; 
        mul14_op1 =             ori_img[20];     mul15_op1 =             ori_img[21];
        mul16_op1 = (Opt_reg) ? ori_img[20] : 0; mul17_op1 = (Opt_reg) ? ori_img[21] : 0; 
    end else if(cnt == 23 || cnt == 48 || cnt == 73) begin    
        mul00_op1 =             ori_img[16];     mul01_op1 =             ori_img[17]; 
        mul02_op1 =             ori_img[21];     mul03_op1 =             ori_img[22]; 
        mul04_op1 =             ori_img[21];     mul05_op1 =             ori_img[22];
        mul06_op1 = (Opt_reg) ? ori_img[21] : 0; mul07_op1 = (Opt_reg) ? ori_img[22] : 0; 

        mul10_op1 =             ori_img[16];     mul11_op1 =             ori_img[17]; 
        mul12_op1 =             ori_img[21];     mul13_op1 =             ori_img[22]; 
        mul14_op1 =             ori_img[21];     mul15_op1 =             ori_img[22];
        mul16_op1 = (Opt_reg) ? ori_img[21] : 0; mul17_op1 = (Opt_reg) ? ori_img[22] : 0;              
    end else if(cnt == 24 || cnt == 49 || cnt == 74) begin    
        mul00_op1 =             ori_img[17];     mul01_op1 =             ori_img[18]; 
        mul02_op1 =             ori_img[22];     mul03_op1 =             ori_img[23]; 
        mul04_op1 =             ori_img[22];     mul05_op1 =             ori_img[23];
        mul06_op1 = (Opt_reg) ? ori_img[22] : 0; mul07_op1 = (Opt_reg) ? ori_img[23] : 0; 

        mul10_op1 =             ori_img[17];     mul11_op1 =             ori_img[18]; 
        mul12_op1 =             ori_img[22];     mul13_op1 =             ori_img[23]; 
        mul14_op1 =             ori_img[22];     mul15_op1 =             ori_img[23];
        mul16_op1 = (Opt_reg) ? ori_img[22] : 0; mul17_op1 = (Opt_reg) ? ori_img[23] : 0; 
    end else if(cnt == 25 || cnt == 50 || cnt == 75) begin    
        mul00_op1 =             ori_img[18];     mul01_op1 =             ori_img[19]; 
        mul02_op1 =             ori_img[23];     mul03_op1 =             ori_img[24]; 
        mul04_op1 =             ori_img[23];     mul05_op1 =             ori_img[24];
        mul06_op1 = (Opt_reg) ? ori_img[23] : 0; mul07_op1 = (Opt_reg) ? ori_img[24] : 0; 

        mul10_op1 =             ori_img[18];     mul11_op1 =             ori_img[19]; 
        mul12_op1 =             ori_img[23];     mul13_op1 =             ori_img[24]; 
        mul14_op1 =             ori_img[23];     mul15_op1 =             ori_img[24];
        mul16_op1 = (Opt_reg) ? ori_img[23] : 0; mul17_op1 = (Opt_reg) ? ori_img[24] : 0;              
    end else if(cnt == 26 || cnt == 51 || cnt == 76) begin   
        mul00_op1 =             ori_img[19];     mul01_op1 = (Opt_reg) ? ori_img[19] : 0;
        mul02_op1 =             ori_img[24];     mul03_op1 = (Opt_reg) ? ori_img[24] : 0;
        mul04_op1 =             ori_img[24];     mul05_op1 = (Opt_reg) ? ori_img[24] : 0;
        mul06_op1 = (Opt_reg) ? ori_img[24] : 0; mul07_op1 = (Opt_reg) ? ori_img[24] : 0; 

        mul10_op1 =             ori_img[19];     mul11_op1 = (Opt_reg) ? ori_img[19] : 0;
        mul12_op1 =             ori_img[24];     mul13_op1 = (Opt_reg) ? ori_img[24] : 0;
        mul14_op1 =             ori_img[24];     mul15_op1 = (Opt_reg) ? ori_img[24] : 0;
        mul16_op1 = (Opt_reg) ? ori_img[24] : 0; mul17_op1 = (Opt_reg) ? ori_img[24] : 0; 
    end 
    // activation
    else if(cnt == 79 || cnt == 80 || cnt == 81 || cnt == 82) begin
        mul00_op1 = feature_map1[0]; mul01_op1 = feature_map2[0];//activation_result1[0] [4]
        mul02_op1 = feature_map1[0]; mul03_op1 = feature_map2[0];
        mul04_op1 = feature_map1[0]; mul05_op1 = feature_map2[0];
    end*/
    /*else if(cnt == 79) begin
        mul00_op1 = activation_result1[0]; mul01_op1 = activation_result1[4];//activation_result1[0] [4]
        mul02_op1 = activation_result1[0]; mul03_op1 = activation_result1[4];
        mul04_op1 = activation_result1[0]; mul05_op1 = activation_result1[4];
    end else if(cnt == 80) begin
        mul00_op1 = activation_result1[1]; mul01_op1 = activation_result1[5];//1 5
        mul02_op1 = activation_result1[1]; mul03_op1 = activation_result1[5];
        mul04_op1 = activation_result1[1]; mul05_op1 = activation_result1[5];
    end else if(cnt == 81) begin
        mul00_op1 = activation_result1[2]; mul01_op1 = activation_result1[6];//2 6
        mul02_op1 = activation_result1[2]; mul03_op1 = activation_result1[6];
        mul04_op1 = activation_result1[2]; mul05_op1 = activation_result1[6];
    end else if(cnt == 82) begin
        mul00_op1 = activation_result1[3]; mul01_op1 = activation_result1[7];//3 7
        mul02_op1 = activation_result1[3]; mul03_op1 = activation_result1[7];
        mul04_op1 = activation_result1[3]; mul05_op1 = activation_result1[7];
    end*/
// end
always@(*) begin
    mul04_op2 = mul00_op2; 
    mul05_op2 = mul01_op2;
    mul06_op2 = mul02_op2; 
    mul07_op2 = mul03_op2;

    mul14_op2 = mul10_op2; 
    mul15_op2 = mul11_op2;
    mul16_op2 = mul12_op2; 
    mul17_op2 = mul13_op2;
end

always@(*) begin
    mul00_op2 = 0; mul01_op2 = 0;
    mul02_op2 = 0; mul03_op2 = 0;
    //mul04_op2 = 0; mul05_op2 = 0;
    //mul06_op2 = 0; mul07_op2 = 0;

    mul10_op2 = 0; mul11_op2 = 0;
    mul12_op2 = 0; mul13_op2 = 0;
    //mul14_op2 = 0; mul15_op2 = 0;
    //mul16_op2 = 0; mul17_op2 = 0;
    if((cnt > 8 && cnt < 27) || (cnt > 33 && cnt < 52) || (cnt > 58 && cnt < 77)) begin
        mul00_op2 = ker1[0]; mul01_op2 = ker1[1];
        mul02_op2 = ker1[2]; mul03_op2 = ker1[3];
        //mul04_op2 = ker1[0]; mul05_op2 = ker1[1];
        //mul06_op2 = ker1[2]; mul07_op2 = ker1[3];

        mul10_op2 = ker2[0]; mul11_op2 = ker2[1];
        mul12_op2 = ker2[2]; mul13_op2 = ker2[3];
        //mul14_op2 = ker2[0]; mul15_op2 = ker2[1];
        //mul16_op2 = ker2[2]; mul17_op2 = ker2[3];
    end
    /*else if((cnt > 33 && cnt < 52)) begin
        mul00_op2 = ker1[4]; mul01_op2 = ker1[5];
        mul02_op2 = ker1[6]; mul03_op2 = ker1[7];
        mul04_op2 = ker1[4]; mul05_op2 = ker1[5];
        mul06_op2 = ker1[6]; mul07_op2 = ker1[7];

        mul10_op2 = ker2[4]; mul11_op2 = ker2[5];
        mul12_op2 = ker2[6]; mul13_op2 = ker2[7];
        mul14_op2 = ker2[4]; mul15_op2 = ker2[5];
        mul16_op2 = ker2[6]; mul17_op2 = ker2[7];
    end
    else if((cnt > 58 && cnt < 77)) begin
        mul00_op2 = ker1[8]; mul01_op2 = ker1[9];
        mul02_op2 = ker1[10];mul03_op2 = ker1[11];
        mul04_op2 = ker1[8]; mul05_op2 = ker1[9];
        mul06_op2 = ker1[10];mul07_op2 = ker1[11];

        mul10_op2 = ker2[8]; mul11_op2 = ker2[9];
        mul12_op2 = ker2[10];mul13_op2 = ker2[11];
        mul14_op2 = ker2[8]; mul15_op2 = ker2[9];
        mul16_op2 = ker2[10];mul17_op2 = ker2[11];
    end*/
    // activation
    else if(cnt == 79 || cnt == 80 || cnt == 81 || cnt == 82) begin
        mul00_op2 = wei[17]; mul01_op2 = wei[21];
        mul02_op2 = wei[1]; mul03_op2 = wei[5];
        mul10_op2 = wei[9]; mul11_op2 = wei[13];
        /*mul00_op2 = wei[0]; mul01_op2 = wei[4];
        mul02_op2 = wei[8]; mul03_op2 = wei[12];
        mul10_op2 = wei[16]; mul11_op2 = wei[20];*/ //mul04_op2 = wei[16]; mul05_op2 = wei[20];
    end
    /*else if(cnt == 80) begin
        mul00_op2 = wei[1]; mul01_op2 = wei[5];
        mul02_op2 = wei[9]; mul03_op2 = wei[13];
        mul04_op2 = wei[17]; mul05_op2 = wei[21];
    end
    else if(cnt == 81) begin
        mul00_op2 = wei[2]; mul01_op2 = wei[6];
        mul02_op2 = wei[10]; mul03_op2 = wei[14];
        mul04_op2 = wei[18]; mul05_op2 = wei[22];
    end
    else if(cnt == 82) begin
        mul00_op2 = wei[3]; mul01_op2 = wei[7];
        mul02_op2 = wei[11]; mul03_op2 = wei[15];
        mul04_op2 = wei[19]; mul05_op2 = wei[23];
    end*/
end

//==============================================//
//                 max pooling                  //
//==============================================//
reg [31:0] com00_op1, com00_op2;
wire [31:0] com00_result;
reg [31:0] com00_result_reg;
reg [31:0] com01_op1, com01_op2;
wire [31:0] com01_result;
reg [31:0] com01_result_reg;

reg [31:0] com10_op1, com10_op2;
wire [31:0] com10_result;
reg [31:0] com10_result_reg;
reg [31:0] com11_op1, com11_op2;
wire [31:0] com11_result;
reg [31:0] com11_result_reg;

fp_cmp  cmp00(.inst_a(com00_op1), .inst_b(com00_op2), .inst_zctr(1'b1), .aeqb_inst(), .altb_inst(), .agtb_inst(), .unordered_inst(), .z0_inst(com00_result), .z1_inst());
fp_cmp  cmp01(.inst_a(com01_op1), .inst_b(com01_op2), .inst_zctr(1'b1), .aeqb_inst(), .altb_inst(), .agtb_inst(), .unordered_inst(), .z0_inst(com01_result), .z1_inst());

fp_cmp  cmp10(.inst_a(com10_op1), .inst_b(com10_op2), .inst_zctr(1'b1), .aeqb_inst(), .altb_inst(), .agtb_inst(), .unordered_inst(), .z0_inst(com10_result), .z1_inst());
fp_cmp  cmp11(.inst_a(com11_op1), .inst_b(com11_op2), .inst_zctr(1'b1), .aeqb_inst(), .altb_inst(), .agtb_inst(), .unordered_inst(), .z0_inst(com11_result), .z1_inst());

always@(*) begin
    com00_op1 = feature_map1[34];
    com01_op1 = feature_map1[35];
    com10_op1 = feature_map2[34]; 
    com11_op1 = feature_map2[35];
end

always@(*) begin
    com00_op2 = 0;
    com01_op2 = 0;

    com10_op2 = 0;
    com11_op2 = 0;
    if(cnt == 61 || cnt == 64 || cnt == 67) begin // 1 
        com00_op2 = max_pooling1[0];
        com01_op2 = com00_result;

        com10_op2 = max_pooling2[0];
        com11_op2 = com10_result;
    end
    else if(cnt == 62 || cnt == 65 || cnt == 68) begin // 2
        com00_op2 = max_pooling1[0];
        com01_op2 = max_pooling1[1];

        com10_op2 = max_pooling2[0];
        com11_op2 = max_pooling2[1];
    end
    else if(cnt == 63 || cnt == 66 || cnt == 69) begin // 3
        com00_op2 = max_pooling1[1];
        com01_op2 = com00_result;

        com10_op2 = max_pooling2[1];
        com11_op2 = com10_result;
    end
    else if(cnt == 70 || cnt == 73 || cnt == 74 || cnt == 75) begin // 10
        com00_op2 = max_pooling1[2];
        com01_op2 = com00_result;

        com10_op2 = max_pooling2[2];
        com11_op2 = com10_result;
    end
    else if(cnt == 71) begin // 11
        com00_op2 = max_pooling1[2];
        com01_op2 = max_pooling1[3];

        com10_op2 = max_pooling2[2];
        com11_op2 = max_pooling2[3];
    end
    else if(cnt == 72 || cnt == 76 || cnt == 77 || cnt == 78) begin // 12
        com00_op2 = max_pooling1[3];
        com01_op2 = com00_result;

        com10_op2 = max_pooling2[3];
        com11_op2 = com10_result;
    end
end
/*always@(*) begin
    com00_op1 = 0; com00_op2 = 0;
    com01_op1 = 0; com01_op2 = 0;

    com10_op1 = 0; com10_op2 = 0;
    com11_op1 = 0; com11_op2 = 0;
    if(cnt == 61) begin // 1 
        com01_op1 = feature_map1[34]; com01_op2 = feature_map1[35];

        com11_op1 = feature_map2[34]; com11_op2 = feature_map2[35];
    end
    else if(cnt == 62) begin // 2
        com00_op1 = feature_map1[34]; com00_op2 = max_pooling1[0];

        com10_op1 = feature_map2[34]; com10_op2 = max_pooling2[0];
    end
    else if(cnt == 63 || cnt == 66 || cnt == 69) begin // 3
        com00_op1 = feature_map1[34]; com00_op2 = max_pooling1[1];
        com01_op1 = feature_map1[35]; com01_op2 = com00_result;

        com10_op1 = feature_map2[34]; com10_op2 = max_pooling2[1];
        com11_op1 = feature_map2[35]; com11_op2 = com10_result;
    end
    else if(cnt == 64 || cnt == 67) begin // 4
        com00_op1 = feature_map1[34]; com00_op2 = max_pooling1[0];
        com01_op1 = feature_map1[35]; com01_op2 = com00_result;

        com10_op1 = feature_map2[34]; com10_op2 = max_pooling2[0];
        com11_op1 = feature_map2[35]; com11_op2 = com10_result;
    end
    else if(cnt == 65 || cnt == 68) begin // 5
        com00_op1 = feature_map1[34]; com00_op2 = max_pooling1[0];
        com01_op1 = feature_map1[35]; com01_op2 = max_pooling1[1];

        com10_op1 = feature_map2[34]; com10_op2 = max_pooling2[0];
        com11_op1 = feature_map2[35]; com11_op2 = max_pooling2[1];
    end
    else if(cnt == 70) begin // 10
        com01_op1 = feature_map1[34]; com01_op2 = feature_map1[35];

        com11_op1 = feature_map2[34]; com11_op2 = feature_map2[35];
    end
    else if(cnt == 71) begin // 11
        com00_op1 = feature_map1[34]; com00_op2 = max_pooling1[2];

        com10_op1 = feature_map2[34]; com10_op2 = max_pooling2[2];
    end
    else if(cnt == 72) begin // 12
        com00_op1 = feature_map1[34]; com00_op2 = max_pooling1[3];
        com01_op1 = feature_map1[35]; com01_op2 = com00_result;

        com10_op1 = feature_map2[34]; com10_op2 = max_pooling2[3];
        com11_op1 = feature_map2[35]; com11_op2 = com10_result;
    end
    else if(cnt == 73 || cnt == 74 || cnt == 75) begin // 13
        com00_op1 = feature_map1[34]; com00_op2 = max_pooling1[2];
        com01_op1 = feature_map1[35]; com01_op2 = com00_result;

        com10_op1 = feature_map2[34]; com10_op2 = max_pooling2[2];
        com11_op1 = feature_map2[35]; com11_op2 = com10_result;
    end
    else if(cnt == 76 || cnt == 77 || cnt == 78) begin // 14
        com00_op1 = feature_map1[34]; com00_op2 = max_pooling1[3];
        com01_op1 = feature_map1[35]; com01_op2 = com00_result;

        com10_op1 = feature_map2[34]; com10_op2 = max_pooling2[3];
        com11_op1 = feature_map2[35]; com11_op2 = com10_result;
    end
    
end*/

// always@(posedge clk) begin
//     com00_result_reg <= com00_result;
//     com01_result_reg <= com01_result;
//     com10_result_reg <= com10_result;
//     com11_result_reg <= com11_result;
// end
always@(posedge clk) begin
    if(cnt == 0) begin
        max_pooling1[0] <= 32'b1111_1111_0111_1111_1111_1111_1111_1111;
        max_pooling1[1] <= 32'b1111_1111_0111_1111_1111_1111_1111_1111;
        max_pooling1[2] <= 32'b1111_1111_0111_1111_1111_1111_1111_1111;
        max_pooling1[3] <= 32'b1111_1111_0111_1111_1111_1111_1111_1111;
        max_pooling2[0] <= 32'b1111_1111_0111_1111_1111_1111_1111_1111;
        max_pooling2[1] <= 32'b1111_1111_0111_1111_1111_1111_1111_1111;
        max_pooling2[2] <= 32'b1111_1111_0111_1111_1111_1111_1111_1111;
        max_pooling2[3] <= 32'b1111_1111_0111_1111_1111_1111_1111_1111;
    end
    if(cnt == 61 || cnt == 64 || cnt == 67) begin
        max_pooling1[0] <= com01_result;

        max_pooling2[0] <= com11_result;
    end
    else if(cnt == 63 || cnt == 66 || cnt == 69) begin
        max_pooling1[1] <= com01_result;

        max_pooling2[1] <= com11_result;
    end
    else if(cnt == 70 || cnt == 73 || cnt == 74 || cnt == 75) begin
        max_pooling1[2] <= com01_result;

        max_pooling2[2] <= com11_result;
    end
    else if(cnt == 72 || cnt == 76 || cnt == 77 || cnt == 78) begin
        max_pooling1[3] <= com01_result;

        max_pooling2[3] <= com11_result;
    end
    else if(cnt == 62 || cnt == 65 || cnt == 68)begin
        max_pooling1[0] <= com00_result;
        max_pooling1[1] <= com01_result;

        max_pooling2[0] <= com10_result;
        max_pooling2[1] <= com11_result;
    end
    else if(cnt == 71) begin
        max_pooling1[2] <= com00_result;
        max_pooling1[3] <= com01_result;

        max_pooling2[2] <= com10_result;
        max_pooling2[3] <= com11_result;
    end 
      
end
/*always@(posedge clk) begin
    if(cnt == 61 || cnt == 64 || cnt == 67) begin
        max_pooling1[0] <= com01_result;

        max_pooling2[0] <= com11_result;
    end
    else if(cnt == 63 || cnt == 66 || cnt == 69) begin
        max_pooling1[1] <= com01_result;

        max_pooling2[1] <= com11_result;
    end
    else if(cnt == 70 || cnt == 73 || cnt == 74 || cnt == 75) begin
        max_pooling1[2] <= com01_result;

        max_pooling2[2] <= com11_result;
    end
    else if(cnt == 72 || cnt == 76 || cnt == 77 || cnt == 78) begin
        max_pooling1[3] <= com01_result;

        max_pooling2[3] <= com11_result;
    end
    else if(cnt == 62)begin
        max_pooling1[0] <= com00_result;
        max_pooling1[1] <= feature_map1[35];

        max_pooling2[0] <= com10_result;
        max_pooling2[1] <= feature_map2[35];
    end
    else if(cnt == 71) begin
        max_pooling1[2] <= com00_result;
        max_pooling1[3] <= feature_map1[35];

        max_pooling2[2] <= com10_result;
        max_pooling2[3] <= feature_map2[35];
    end 
    else if(cnt == 65 || cnt == 68) begin
        max_pooling1[0] <= com00_result;
        max_pooling1[1] <= com01_result;

        max_pooling2[0] <= com10_result;
        max_pooling2[1] <= com11_result;
    end
      
end*/
//==============================================//
//                  activation                  //
//==============================================//
// reg  [31:0] exp0_input, exp1_input;
// wire [31:0] exp0_result, exp1_result;
// // reg  [31:0] exp0_result_reg, exp1_result_reg;
// fp_exp exp00(.inst_a(exp0_input), .z_inst(exp0_result));
// fp_exp exp01(.inst_a(exp1_input), .z_inst(exp1_result));

// always@(posedge clk) begin
//     exp0_result_reg <= exp0_result;
//     exp1_result_reg <= exp1_result;
// end

reg  [31:0] add08_op1, add08_op2;
wire [31:0] add08_result;
reg  [31:0] add08_result_reg;
reg  [31:0] add09_op1, add09_op2;
wire [31:0] add09_result;
reg  [31:0] add09_result_reg;

reg  [31:0] add18_op1, add18_op2;
wire [31:0] add18_result;
reg  [31:0] add18_result_reg;
reg  [31:0] add19_op1, add19_op2;
wire [31:0] add19_result;
reg  [31:0] add19_result_reg;
fp_add add08(.inst_a(add08_op1), .inst_b(add08_op2), .inst_rnd(3'b000), .z_inst(add08_result));
fp_add add09(.inst_a(add09_op1), .inst_b(add09_op2), .inst_rnd(3'b000), .z_inst(add09_result));

fp_add add18(.inst_a(add18_op1), .inst_b(add18_op2), .inst_rnd(3'b000), .z_inst(add18_result));
fp_add add19(.inst_a(add19_op1), .inst_b(add19_op2), .inst_rnd(3'b000), .z_inst(add19_result));

always@(posedge clk) begin
    add08_result_reg <= add08_result;
    add09_result_reg <= add09_result;
    add18_result_reg <= add18_result;
    add19_result_reg <= add19_result;
end

// reg  [31:0] div0_op1, div0_op2;
// wire [31:0] div0_result;
// // reg  [31:0] div0_result_reg;
// reg  [31:0] div1_op1, div1_op2;
// wire [31:0] div1_result;
// // reg  [31:0] div1_result_reg;
// fp_div div0(.inst_a(div0_op1), .inst_b(div0_op2), .inst_rnd(3'b000), .z_inst(div0_result));
// fp_div div1(.inst_a(div1_op1), .inst_b(div1_op2), .inst_rnd(3'b000), .z_inst(div1_result));

// // always@(posedge clk) begin
// //     div0_result_reg <= div0_result;
// //     div1_result_reg <= div1_result;
// // end

always @(*) begin
    exp0_input = 0;
    exp1_input = 0;
    if(cnt == 76)begin
        exp0_input = (Opt_reg) ?  {max_pooling1[0][31], (max_pooling1[0][30:23] + 1'b1), max_pooling1[0][22:0]} : {~max_pooling1[0][31], max_pooling1[0][30:0]}; // 2*z (Tanh) or -z (Sigmoid);
        exp1_input = (Opt_reg) ?  {max_pooling2[0][31], (max_pooling2[0][30:23] + 1'b1), max_pooling2[0][22:0]} : {~max_pooling2[0][31], max_pooling2[0][30:0]};
    end
    else if(cnt == 77)begin
        exp0_input = (Opt_reg) ?  {max_pooling1[1][31], (max_pooling1[1][30:23] + 1'b1), max_pooling1[1][22:0]} : {~max_pooling1[1][31], max_pooling1[1][30:0]}; // 2*z (Tanh) or -z (Sigmoid);
        exp1_input = (Opt_reg) ?  {max_pooling2[1][31], (max_pooling2[1][30:23] + 1'b1), max_pooling2[1][22:0]} : {~max_pooling2[1][31], max_pooling2[1][30:0]};
    end
    else if(cnt == 78)begin
        exp0_input = (Opt_reg) ?  {max_pooling1[2][31], (max_pooling1[2][30:23] + 1'b1), max_pooling1[2][22:0]} : {~max_pooling1[2][31], max_pooling1[2][30:0]}; // 2*z (Tanh) or -z (Sigmoid);
        exp1_input = (Opt_reg) ?  {max_pooling2[2][31], (max_pooling2[2][30:23] + 1'b1), max_pooling2[2][22:0]} : {~max_pooling2[2][31], max_pooling2[2][30:0]};
    end
    else if(cnt == 79)begin
        exp0_input = (Opt_reg) ?  {max_pooling1[3][31], (max_pooling1[3][30:23] + 1'b1), max_pooling1[3][22:0]} : {~max_pooling1[3][31], max_pooling1[3][30:0]}; // 2*z (Tanh) or -z (Sigmoid);
        exp1_input = (Opt_reg) ?  {max_pooling2[3][31], (max_pooling2[3][30:23] + 1'b1), max_pooling2[3][22:0]} : {~max_pooling2[3][31], max_pooling2[3][30:0]};
    end
    else if(cnt == 84) begin
        exp0_input = feature_map1[33]; //full_connected_result1
        exp1_input = feature_map1[34]; //full_connected_result2
    end
    else if(cnt == 85) begin
        exp0_input = feature_map1[35]; //full_connected_result3
    end
end

always @(*) begin
    // if(cnt == 79 || cnt == 80 || cnt == 81 || cnt == 82)begin
        add08_op1 = (Opt_reg) ? exp0_result_reg : 32'b01000000000000000000000000000000; // exp0_result or 2
        add08_op2 = 32'b10111111100000000000000000000000; // -1
        add09_op1 = exp0_result_reg;
        add09_op2 = 32'b00111111100000000000000000000000; // +1

        add18_op1 = (Opt_reg) ? exp1_result_reg : 32'b01000000000000000000000000000000; // exp0_result or 2
        add18_op2 = 32'b10111111100000000000000000000000; // -1
        add19_op1 = exp1_result_reg;
        add19_op2 = 32'b00111111100000000000000000000000; // +1
    // end
end

always @(*) begin
    div0_op1 = 0;
    div0_op2 = 0;

    div1_op1 = 0;
    div1_op2 = 0;
    if(cnt == 78 || cnt == 79 || cnt == 80 || cnt == 81)begin
        div0_op1 = add08_result_reg; 
        div0_op2 = add09_result_reg;

        div1_op1 = add18_result_reg;
        div1_op2 = add19_result_reg; 
    end
    else if(cnt == 87) begin
        div0_op1 = feature_map1[32];//exp1
        div0_op2 = feature_map1[35];//sum
    end
    else if(cnt == 88) begin
        div0_op1 = feature_map1[33];//exp2 
        div0_op2 = feature_map1[35];//sum
    end
    else if(cnt == 89) begin
        div0_op1 = feature_map1[34];//exp3
        div0_op2 = feature_map1[35];//sum
    end
end

// always @(posedge clk) begin
//     if(cnt == 78)begin
//         activation_result1[0] <= div0_result; //activation_result1[0]
//         activation_result1[4] <= div1_result; //activation_result1[4]
//     end
//     else if(cnt == 79)begin
//         activation_result1[1] <= div0_result; //activation_result1[1]
//         activation_result1[5] <= div1_result; //activation_result1[5]
//     end
//     else if(cnt == 80)begin
//         activation_result1[2] <= div0_result; //activation_result1[2]
//         activation_result1[6] <= div1_result; //activation_result1[6]
//     end
//     else if(cnt == 81)begin
//         activation_result1[3] <= div0_result; //activation_result1[3]
//         activation_result1[7] <= div1_result; //activation_result1[7]
//     end
//     else if(cnt == 87 || cnt == 88 || cnt == 89)begin
//         activation_result1[0] <= div0_result; //activation_result1[0]
//     end
// end
//==============================================//
//               fully connected                //
//==============================================//

// always@(posedge clk)begin
//     if(cnt == 80 || cnt == 81 || cnt == 82 || cnt == 83) begin
//         full_connected_result1 <= add01_result; //full_connected_result1
//         full_connected_result2 <= add03_result; //full_connected_result2
//         full_connected_result3 <= add05_result; //full_connected_result3
//     end
// end

//==============================================//
//                  soft max                    //
//==============================================//

// always@(posedge clk)begin
//     if(cnt == 84) begin
//         exp1 <= exp0_result;
//         exp2 <= exp1_result;
//     end
//     else if(cnt == 85) begin
//         exp3 <= exp0_result;
//         sum <= add01_result;
//     end
//     else if(cnt == 86) begin
//         sum <= add01_result;
//     end
// end



//==============================================//
//                   output                     //
//==============================================//

always @(*) begin
    if(cnt == 88 || cnt == 89 ||cnt == 90) begin
        out_valid = 1;
    end
    else out_valid = 0;
end

always @(*) begin
    if(cnt == 88 || cnt == 89 || cnt == 90) begin
        out = feature_map1[0];//activation_result1[0]//div0_result_reg
    end
    else out = 0;
end

endmodule

//---------------------------------------------------------------------
// IPs
//---------------------------------------------------------------------

module fp_mult( inst_a, inst_b, inst_rnd, z_inst);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;

input [inst_sig_width+inst_exp_width : 0] inst_a;
input [inst_sig_width+inst_exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [inst_sig_width+inst_exp_width : 0] z_inst;
// output [7 : 0] status_inst;

    // Instance of DW_fp_mult
    DW_fp_mult #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
		U1( .a(inst_a), 
			.b(inst_b), 
			.rnd(inst_rnd), 
			.z(z_inst), 
			.status() );

endmodule

//================================================//
// 2-input adder of floating point
module fp_add(inst_a, inst_b, inst_rnd, z_inst);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;


input [inst_sig_width+inst_exp_width : 0] inst_a;
input [inst_sig_width+inst_exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [inst_sig_width+inst_exp_width : 0] z_inst;
// output [7 : 0] status_inst;

    // Instance of DW_fp_add
    DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
		U1( .a(inst_a), 
			.b(inst_b), 
			.rnd(inst_rnd), 
			.z(z_inst), 
			.status() );

endmodule

//================================================//
// comparation of floating point
module fp_cmp( inst_a, inst_b, inst_zctr, aeqb_inst, altb_inst, 
		agtb_inst, unordered_inst, z0_inst, z1_inst);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;


input [inst_sig_width+inst_exp_width : 0] inst_a;
input [inst_sig_width+inst_exp_width : 0] inst_b;
input inst_zctr;
output aeqb_inst;
output altb_inst;
output agtb_inst;
output unordered_inst;
output [inst_sig_width+inst_exp_width : 0] z0_inst;
output [inst_sig_width+inst_exp_width : 0] z1_inst;
// output [7 : 0] status0_inst;
// output [7 : 0] status1_inst;

    // Instance of DW_fp_cmp
    DW_fp_cmp #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
		U1( .a(inst_a), 
			.b(inst_b), 
			.zctr(inst_zctr), 
			.aeqb(aeqb_inst), 
			.altb(altb_inst), 
			.agtb(agtb_inst), 
			.unordered(unordered_inst), 
			.z0(z0_inst), 
			.z1(z1_inst), 
			.status0(), 
			.status1() );

endmodule

//================================================//
// division of floating point
module fp_div( inst_a, inst_b, inst_rnd, z_inst);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;


input [inst_sig_width+inst_exp_width : 0] inst_a;
input [inst_sig_width+inst_exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [inst_sig_width+inst_exp_width : 0] z_inst;
// output [7 : 0] status_inst;

	// Instance of DW_fp_div
	DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) 
		U1( .a(inst_a), 
			.b(inst_b), 
			.rnd(inst_rnd), 
			.z(z_inst), 
			.status());

endmodule

//================================================//
// exponent of floating point
module fp_exp( inst_a, z_inst);

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;


input [inst_sig_width+inst_exp_width : 0] inst_a;
output [inst_sig_width+inst_exp_width : 0] z_inst;
// output [7 : 0] status_inst;

    // Instance of DW_fp_exp
    DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type) 
		U1( .a(inst_a),
			.z(z_inst),
			.status() );

endmodule