/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Mon Sep 23 11:36:37 2024
/////////////////////////////////////////////////////////////


module BB ( clk, rst_n, in_valid, inning, half, action, out_valid, score_A, 
        score_B, result );
  input [1:0] inning;
  input [2:0] action;
  output [7:0] score_A;
  output [7:0] score_B;
  output [1:0] result;
  input clk, rst_n, in_valid, half;
  output out_valid;
  wire   N42, N43, N44, N45, N50, N51, N52, N62, N63, N64, N65, N66,
         early_stop, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136,
         n137, n138, n139, n140, n141, n142, n143, n144, n145, n146, n147,
         n148, n149, n150, n151, n152, n153, n154, n155, n156, n157, n158,
         n159, n160, n161, n162, n163, n164, n165, n166, n167, n168, n169,
         n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180,
         n181, n182, n183, n184;
  wire   [1:0] c_state;
  wire   [2:0] base;
  wire   [1:0] out_count;
  wire   [2:0] score_B_;
  wire   [3:0] score_A_;

  DFFHQX1 score_A__reg_3_ ( .D(N45), .CK(clk), .Q(score_A_[3]) );
  DFFHQX1 score_A__reg_2_ ( .D(N44), .CK(clk), .Q(score_A_[2]) );
  DFFHQX1 score_A__reg_1_ ( .D(N43), .CK(clk), .Q(score_A_[1]) );
  DFFHQX1 score_A__reg_0_ ( .D(N42), .CK(clk), .Q(score_A_[0]) );
  DFFHQX1 base_reg_0_ ( .D(N62), .CK(clk), .Q(base[0]) );
  DFFHQX1 out_count_reg_0_ ( .D(N65), .CK(clk), .Q(out_count[0]) );
  DFFHQX1 out_count_reg_1_ ( .D(N66), .CK(clk), .Q(out_count[1]) );
  DFFHQX1 base_reg_1_ ( .D(N63), .CK(clk), .Q(base[1]) );
  DFFHQX1 base_reg_2_ ( .D(N64), .CK(clk), .Q(base[2]) );
  DFFHQX1 early_stop_reg ( .D(n180), .CK(clk), .Q(early_stop) );
  DFFHQX1 score_B__reg_0_ ( .D(N50), .CK(clk), .Q(score_B_[0]) );
  DFFHQX1 score_B__reg_1_ ( .D(N51), .CK(clk), .Q(score_B_[1]) );
  DFFHQX1 score_B__reg_2_ ( .D(N52), .CK(clk), .Q(score_B_[2]) );
  DFFRX1 c_state_reg_1_ ( .D(n182), .CK(clk), .RN(rst_n), .Q(c_state[1]), .QN(
        n184) );
  DFFRX1 c_state_reg_0_ ( .D(n181), .CK(clk), .RN(rst_n), .Q(c_state[0]), .QN(
        n183) );
  NOR2XL U111 ( .A(action[0]), .B(n124), .Y(n120) );
  NOR2XL U112 ( .A(n120), .B(n119), .Y(n139) );
  NOR2XL U113 ( .A(action[2]), .B(n118), .Y(n111) );
  NOR2XL U114 ( .A(action[1]), .B(action[2]), .Y(n163) );
  NOR2XL U115 ( .A(score_A[1]), .B(n168), .Y(n169) );
  NOR2XL U116 ( .A(out_valid), .B(n98), .Y(n182) );
  NOR2XL U117 ( .A(n174), .B(n179), .Y(score_B[0]) );
  NOR2XL U118 ( .A(n179), .B(n160), .Y(score_B[2]) );
  NOR2X1 U119 ( .A(n162), .B(n165), .Y(N66) );
  NOR2X1 U120 ( .A(n166), .B(n165), .Y(N62) );
  NOR2X1 U121 ( .A(n161), .B(n165), .Y(N65) );
  NOR2X1 U122 ( .A(n103), .B(n102), .Y(n101) );
  NOR2X1 U123 ( .A(half), .B(n178), .Y(n156) );
  NOR2X1 U124 ( .A(n179), .B(n167), .Y(score_A[1]) );
  NOR2X1 U125 ( .A(n179), .B(n177), .Y(score_A[2]) );
  NOR2X1 U126 ( .A(n179), .B(n178), .Y(score_A[3]) );
  NOR2X1 U127 ( .A(n172), .B(n179), .Y(score_A[0]) );
  NOR2X1 U128 ( .A(action[2]), .B(n99), .Y(n116) );
  INVXL U129 ( .A(1'b1), .Y(score_B[3]) );
  INVXL U131 ( .A(1'b1), .Y(score_B[4]) );
  INVXL U133 ( .A(1'b1), .Y(score_B[5]) );
  INVXL U135 ( .A(1'b1), .Y(score_B[6]) );
  INVXL U137 ( .A(1'b1), .Y(score_B[7]) );
  INVXL U139 ( .A(1'b1), .Y(score_A[4]) );
  INVXL U141 ( .A(1'b1), .Y(score_A[5]) );
  INVXL U143 ( .A(1'b1), .Y(score_A[6]) );
  INVXL U145 ( .A(1'b1), .Y(score_A[7]) );
  NAND2XL U147 ( .A(n129), .B(n130), .Y(n145) );
  NAND2XL U148 ( .A(score_A[1]), .B(n168), .Y(n173) );
  NAND2XL U149 ( .A(out_valid), .B(score_B_[1]), .Y(n168) );
  NAND2XL U150 ( .A(n184), .B(c_state[0]), .Y(n179) );
  OR3XL U151 ( .A(n114), .B(n180), .C(n159), .Y(n150) );
  OAI21XL U152 ( .A0(n181), .A1(n182), .B0(n150), .Y(n151) );
  OAI2BB1XL U153 ( .A0N(n160), .A1N(score_A_[2]), .B0(n178), .Y(n176) );
  OAI211XL U154 ( .A0(n162), .A1(n161), .B0(n106), .C0(n105), .Y(n165) );
  OAI21XL U155 ( .A0(n104), .A1(out_count[0]), .B0(out_count[1]), .Y(n105) );
  OR2XL U156 ( .A(n181), .B(n182), .Y(n106) );
  ADDFXL U157 ( .A(n145), .B(n144), .CI(n143), .CO(n146), .S(n141) );
  AOI22XL U158 ( .A0(half), .A1(score_B_[1]), .B0(score_A_[1]), .B1(n142), .Y(
        n143) );
  AOI21XL U159 ( .A0(n139), .A1(n138), .B0(n137), .Y(n144) );
  OAI22XL U160 ( .A0(n136), .A1(n148), .B0(n147), .B1(n135), .Y(n137) );
  NAND2XL U161 ( .A(n182), .B(n159), .Y(n158) );
  INVXL U162 ( .A(n179), .Y(out_valid) );
  OAI22XL U163 ( .A0(n124), .A1(n123), .B0(n149), .B1(n122), .Y(n125) );
  OAI21XL U164 ( .A0(base[2]), .A1(base[1]), .B0(n148), .Y(n132) );
  INVXL U165 ( .A(n115), .Y(n124) );
  MXI2XL U166 ( .A(base[0]), .B(n149), .S0(n132), .Y(n134) );
  NOR2BXL U167 ( .AN(action[2]), .B(n118), .Y(n133) );
  NAND2XL U168 ( .A(n103), .B(out_count[1]), .Y(n115) );
  NAND2XL U169 ( .A(n164), .B(n117), .Y(n121) );
  INVXL U170 ( .A(action[1]), .Y(n99) );
  NAND2XL U171 ( .A(n99), .B(n117), .Y(n118) );
  OAI211XL U172 ( .A0(action[0]), .A1(n149), .B0(action[2]), .C0(n118), .Y(
        n102) );
  OAI211XL U173 ( .A0(n136), .A1(n132), .B0(n128), .C0(n127), .Y(n130) );
  MXI2XL U174 ( .A(n133), .B(n139), .S0(n134), .Y(n128) );
  OAI21XL U175 ( .A0(n126), .A1(n125), .B0(base[2]), .Y(n127) );
  AOI211XL U176 ( .A0(base[0]), .A1(out_count[0]), .B0(out_count[1]), .C0(n121), .Y(n126) );
  AOI22XL U177 ( .A0(half), .A1(n174), .B0(n172), .B1(n142), .Y(n129) );
  OAI21XL U178 ( .A0(n149), .A1(n132), .B0(n148), .Y(n138) );
  AOI33XL U179 ( .A0(n124), .A1(n163), .A2(action[0]), .B0(n117), .B1(n116), 
        .B2(n115), .Y(n136) );
  OAI22XL U180 ( .A0(n134), .A1(n138), .B0(n149), .B1(n148), .Y(n135) );
  INVXL U181 ( .A(n133), .Y(n147) );
  NAND2XL U182 ( .A(base[2]), .B(base[1]), .Y(n148) );
  INVXL U183 ( .A(half), .Y(n142) );
  NOR2X1 U184 ( .A(in_valid), .B(n183), .Y(n114) );
  NAND4XL U185 ( .A(half), .B(inning[1]), .C(inning[0]), .D(n183), .Y(n94) );
  NAND2XL U186 ( .A(action[0]), .B(n119), .Y(n123) );
  AOI22XL U187 ( .A0(action[0]), .A1(out_count[1]), .B0(n116), .B1(n115), .Y(
        n100) );
  INVXL U188 ( .A(n121), .Y(n104) );
  INVXL U189 ( .A(action[0]), .Y(n117) );
  NAND2XL U190 ( .A(base[1]), .B(n111), .Y(n122) );
  NOR3XL U191 ( .A(action[1]), .B(out_count[1]), .C(n117), .Y(n110) );
  AOI211XL U192 ( .A0(n104), .A1(base[0]), .B0(out_count[1]), .C0(n101), .Y(
        n162) );
  MXI2XL U193 ( .A(n103), .B(out_count[0]), .S0(n102), .Y(n161) );
  AND2XL U194 ( .A(action[1]), .B(action[2]), .Y(n164) );
  OAI21XL U195 ( .A0(n130), .A1(n129), .B0(n145), .Y(n131) );
  XNOR2XL U196 ( .A(n154), .B(n153), .Y(n152) );
  OAI31XL U197 ( .A0(n149), .A1(n148), .A2(n147), .B0(n146), .Y(n153) );
  OAI22XL U198 ( .A0(n142), .A1(n160), .B0(n177), .B1(half), .Y(n154) );
  OAI21XL U199 ( .A0(half), .A1(n114), .B0(c_state[1]), .Y(n159) );
  OAI22XL U200 ( .A0(score_A_[2]), .A1(n171), .B0(n170), .B1(n176), .Y(
        result[0]) );
  NAND2XL U201 ( .A(score_B[2]), .B(n178), .Y(n171) );
  AOI31XL U202 ( .A0(score_B[0]), .A1(n172), .A2(n173), .B0(n169), .Y(n170) );
  NOR4XL U203 ( .A(n179), .B(n176), .C(result[0]), .D(n175), .Y(result[1]) );
  OAI2BB1XL U204 ( .A0N(score_A[0]), .A1N(n174), .B0(n173), .Y(n175) );
  AOI2BB1XL U205 ( .A0N(n184), .A1N(c_state[0]), .B0(in_valid), .Y(n98) );
  OAI22XL U206 ( .A0(n160), .A1(n151), .B0(n150), .B1(n152), .Y(N52) );
  OAI22XL U207 ( .A0(n141), .A1(n150), .B0(n140), .B1(n151), .Y(N51) );
  OAI22XL U208 ( .A0(n174), .A1(n151), .B0(n131), .B1(n150), .Y(N50) );
  AOI2BB1XL U209 ( .A0N(early_stop), .A1N(n97), .B0(n184), .Y(n180) );
  AOI211XL U210 ( .A0(n96), .A1(n95), .B0(n176), .C0(n94), .Y(n97) );
  OAI211XL U211 ( .A0(score_B_[1]), .A1(n167), .B0(score_B_[0]), .C0(n172), 
        .Y(n95) );
  AOI22XL U212 ( .A0(score_B_[1]), .A1(n167), .B0(score_B_[2]), .B1(n177), .Y(
        n96) );
  AOI31XL U213 ( .A0(n109), .A1(n108), .A2(n107), .B0(n165), .Y(N64) );
  OAI21XL U214 ( .A0(n104), .A1(n110), .B0(base[1]), .Y(n109) );
  OAI2BB1XL U215 ( .A0N(n100), .A1N(n122), .B0(base[0]), .Y(n108) );
  AOI32XL U216 ( .A0(base[2]), .A1(n123), .A2(n163), .B0(action[0]), .B1(n123), 
        .Y(n107) );
  AOI31XL U217 ( .A0(n113), .A1(n122), .A2(n112), .B0(n165), .Y(N63) );
  OAI21XL U218 ( .A0(n111), .A1(n110), .B0(base[0]), .Y(n112) );
  AOI32XL U219 ( .A0(base[1]), .A1(action[0]), .A2(n164), .B0(n116), .B1(n117), 
        .Y(n113) );
  AOI31XL U220 ( .A0(action[0]), .A1(base[0]), .A2(n164), .B0(n163), .Y(n166)
         );
  OAI22XL U221 ( .A0(n172), .A1(n159), .B0(n131), .B1(n158), .Y(N42) );
  OAI22XL U222 ( .A0(n141), .A1(n158), .B0(n159), .B1(n167), .Y(N43) );
  OAI22XL U223 ( .A0(n159), .A1(n177), .B0(n158), .B1(n152), .Y(N44) );
  OAI22XL U224 ( .A0(n159), .A1(n178), .B0(n158), .B1(n157), .Y(N45) );
  XOR2XL U225 ( .A(n156), .B(n155), .Y(n157) );
  NAND2XL U226 ( .A(n154), .B(n153), .Y(n155) );
  INVXL U227 ( .A(n116), .Y(n119) );
  INVXL U228 ( .A(score_A_[1]), .Y(n167) );
  INVXL U229 ( .A(score_A_[2]), .Y(n177) );
  INVXL U230 ( .A(score_A_[0]), .Y(n172) );
  INVXL U231 ( .A(score_B_[2]), .Y(n160) );
  INVXL U232 ( .A(score_A_[3]), .Y(n178) );
  INVXL U233 ( .A(n159), .Y(n181) );
  INVXL U234 ( .A(n168), .Y(score_B[1]) );
  INVXL U235 ( .A(out_count[0]), .Y(n103) );
  INVXL U236 ( .A(base[0]), .Y(n149) );
  INVXL U237 ( .A(score_B_[0]), .Y(n174) );
  INVXL U238 ( .A(score_B_[1]), .Y(n140) );
endmodule

