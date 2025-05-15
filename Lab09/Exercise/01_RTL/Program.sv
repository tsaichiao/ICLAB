module Program(input clk, INF.Program_inf inf);
import usertype::*;

typedef enum logic  [4:0] { IDLE	        = 5'h0,
                            WAIT	        = 5'h1,
							READ_A          = 5'h2,
                            READ_D          = 5'h3,
                            WAIT_ABCD       = 5'h4,
                            ACTION0         = 5'h5,
                            FORMULA         = 5'h6,
                            FORMULA_1       = 5'h7,
                            FORMULA_2       = 5'h8,
                            THRESHOLD       = 5'h9,
                            ACTION1         = 5'h10,
                            WRITE_A         = 5'h11,
                            WRITE_D         = 5'h12,
                            W_RES           = 5'h13,
                            ACTION2         = 5'h14,
                            OUTPUT          = 5'h15
}  state;

state c_state, n_state;

logic [2:0] index_cnt, n_index_cnt;
// logic [10:0] threshold;
Action act_reg, n_act_reg;
Formula_Type formula_reg, n_formula_reg;
Mode mode_reg, n_mode_reg;
Date date_reg, n_date_reg;//month[8:5]day[4:0]
Data_No data_no_reg, n_data_no_reg;
Data_Dir data_dram, n_data_dram;
// Index pattern_a, pattern_b, pattern_c, pattern_d, n_pattern_a, n_pattern_b, n_pattern_c, n_pattern_d;
ABCD  pat_abcd,  n_pat_abcd;

Warn_Msg warn_msg_reg, n_warn_msg_reg;

always_ff @( posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        c_state <= IDLE;
    end
    else begin
        c_state <= n_state;
    end
end

always_comb begin
    case(c_state)
        IDLE: begin
            n_state = (inf.sel_action_valid) ? WAIT : IDLE;
        end
        WAIT: begin
            n_state = (inf.data_no_valid) ? READ_A : WAIT;
        end
        READ_A: begin
            n_state = (inf.AR_READY) ? READ_D : READ_A;
        end
        READ_D: begin
            if(inf.R_VALID) begin
                if(act_reg == Index_Check && n_index_cnt == 4) begin
                    n_state = ACTION0;
                end
                else if(act_reg == Update && n_index_cnt == 4) begin
                    n_state = ACTION1;
                end
                else if(act_reg == Check_Valid_Date) begin
                    n_state = ACTION2;
                end
                else begin
                    n_state = WAIT_ABCD;
                end
            end
            else begin
                n_state = READ_D;
            end
        end
        WAIT_ABCD: begin
            n_state = (n_index_cnt == 4) ? ((act_reg == Index_Check)? ACTION0 : ACTION1) : WAIT_ABCD;
        end
        ACTION0: begin
            if(n_warn_msg_reg == Date_Warn) 
                n_state = OUTPUT;
            else if(formula_reg == Formula_A || formula_reg == Formula_C || formula_reg == Formula_D || formula_reg == Formula_E) 
                n_state = THRESHOLD;
            else 
                n_state = FORMULA;
        end
        FORMULA:begin
            n_state = (formula_reg == Formula_B || formula_reg == Formula_H) ? THRESHOLD : FORMULA_1;
        end
        FORMULA_1:begin
            n_state = (formula_reg == Formula_G) ? THRESHOLD : FORMULA_2;
        end
        FORMULA_2:begin
            n_state = THRESHOLD;
        end
        THRESHOLD: begin
            n_state = OUTPUT;
        end
        //************************************************************************************//
        ACTION1: begin
            n_state = WRITE_A;
        end
        WRITE_A: begin
            n_state = (inf.AW_READY) ? WRITE_D : WRITE_A;
        end
        WRITE_D: begin
            n_state = (inf.W_READY) ? W_RES : WRITE_D;
        end
        W_RES: begin
            n_state = (inf.B_VALID) ? OUTPUT : W_RES;
        end
        //************************************************************************************//
        ACTION2: begin
            n_state = OUTPUT;
        end
        OUTPUT: begin
            n_state = IDLE;
        end
        default: begin
            n_state = IDLE;
        end
    endcase
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        index_cnt <= 0;
    end
    else begin
        index_cnt <= n_index_cnt;
    end
end

always_comb begin
    if(c_state == IDLE)begin
        n_index_cnt = 0;
    end
    else if(inf.index_valid)begin
        n_index_cnt = index_cnt + 1;
    end
    else begin
        n_index_cnt = index_cnt;
    end
end

//*************************************************************************************//
//***********************************    ACTION    ************************************//
//*************************************************************************************//
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        act_reg <= 0;
    end
    else begin
        act_reg <= n_act_reg;
    end
end

always_comb begin
    if(inf.sel_action_valid)begin
        n_act_reg = inf.D.d_act[0];
    end
    else begin
        n_act_reg = act_reg;
    end
end

//*************************************************************************************//
//***********************************     DATE     ************************************//
//*************************************************************************************//
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        date_reg <= 0;
    end
    else begin
        date_reg <= n_date_reg;
    end
end

always_comb begin
    if(inf.date_valid)begin
        n_date_reg = inf.D.d_date[0];
    end
    else begin
        n_date_reg = date_reg;
    end
end

//*************************************************************************************//
//*********************************     FORMULA     ***********************************//
//*************************************************************************************//
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        formula_reg <= 0;
    end
    else begin
        formula_reg <= n_formula_reg;
    end
end

always_comb begin
    if(inf.formula_valid)begin
        n_formula_reg = inf.D.d_formula[0];
    end
    else begin
        n_formula_reg = formula_reg;
    end
end

//*************************************************************************************//
//**********************************     MODE     *************************************//
//*************************************************************************************//
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        mode_reg <= 0;
    end
    else begin
        mode_reg <= n_mode_reg;
    end
end

always_comb begin
    if(inf.mode_valid)begin
        n_mode_reg = inf.D.d_mode[0];
    end
    else begin
        n_mode_reg = mode_reg;
    end
end

//*************************************************************************************//
//********************************     DATA NO     ************************************//
//*************************************************************************************//
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        data_no_reg <= 0;
    end
    else begin
        data_no_reg <= n_data_no_reg;
    end
end

always_comb begin
    if(inf.data_no_valid)begin
        n_data_no_reg = inf.D.d_data_no[0];
    end
    else begin
        n_data_no_reg = data_no_reg;
    end
end

//*************************************************************************************//
//*********************************      ABCD     *************************************//
//*************************************************************************************//
logic signed [13:0] add0_op0, add0_op1;
logic signed [13:0] add1_op0, add1_op1;
logic signed [13:0] add2_op0, add2_op1;
logic signed [13:0] add3_op0, add3_op1;

logic signed [13:0] add0;
logic signed [13:0] add1;
logic signed [13:0] add2;
logic signed [13:0] add3;

logic signed [13:0] com0_op0, com0_op1;
logic signed [13:0] com1_op0, com1_op1;
logic signed [13:0] com2_op0, com2_op1;
logic signed [13:0] com3_op0, com3_op1;

logic com_c00, com_c10, com_c20, com_c30;
logic signed [13:0] com0, com1, com2, com3, com4, com5, com6, com7;


always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
         pat_abcd <= 0;
    end
    else begin
         pat_abcd <=  n_pat_abcd;
    end
end

always_comb begin
     n_pat_abcd =  pat_abcd;
    if(inf.index_valid)begin
        if(act_reg == Index_Check)begin
             n_pat_abcd.A =  n_pat_abcd.B;
             n_pat_abcd.B =  n_pat_abcd.C;
             n_pat_abcd.C =  n_pat_abcd.D;
             n_pat_abcd.D = inf.D.d_index[0];
        end
        else begin
             n_pat_abcd.A =  n_pat_abcd.B;
             n_pat_abcd.B =  n_pat_abcd.C;
             n_pat_abcd.C =  n_pat_abcd.D;
             n_pat_abcd.D = $signed(inf.D.d_index[0]);
        end
    end
    else if(c_state == ACTION1)begin
         n_pat_abcd.A = (add0>4095)? 4095 : ((add0[13]/*<0*/)? 0 : add0);
         n_pat_abcd.B = (add1>4095)? 4095 : ((add1[13]/*<0*/)? 0 : add1);
         n_pat_abcd.C = (add2>4095)? 4095 : ((add2[13]/*<0*/)? 0 : add2);
         n_pat_abcd.D = (add3>4095)? 4095 : ((add3[13]/*<0*/)? 0 : add3);
    end
    else if(c_state == ACTION0)begin
        case(formula_reg)
            Formula_B:begin
                n_pat_abcd.A = com4;
                n_pat_abcd.B = com5;
                n_pat_abcd.C = com6;
                n_pat_abcd.D = com7;
            end
            Formula_F, Formula_G, Formula_H:begin
                n_pat_abcd.A = (add0[13]/*>=0*/)? ~add0+1 : add0;
                n_pat_abcd.B = (add1[13]/*>=0*/)? ~add1+1 : add1;
                n_pat_abcd.C = (add2[13]/*>=0*/)? ~add2+1 : add2;
                n_pat_abcd.D = (add3[13]/*>=0*/)? ~add3+1 : add3;
            end
        endcase
    end
    else if(c_state == FORMULA)begin
        // case(formula_reg)
        //     Formula_F:begin
                n_pat_abcd.A = com4;
                n_pat_abcd.B = com5;
                n_pat_abcd.C = com6;
                n_pat_abcd.D = com7;
        //     end
        //     Formula_G:begin
        //         n_pat_abcd.A = com4;
        //         n_pat_abcd.B = com5;
        //         n_pat_abcd.C = com6;
        //         n_pat_abcd.D = com7;
        //     end
        // endcase
    end

end

//*************************************************************************************//
//*********************************     READ_A     ************************************//
//*************************************************************************************//
always_comb begin
    if(c_state == READ_A)begin
        inf.AR_VALID = 1;
        inf.AR_ADDR = data_no_reg*8 + 'h10000;
    end
    else begin
        inf.AR_VALID = 0;
        inf.AR_ADDR = 0;
    end
end
always_comb begin
    if(c_state == READ_D)begin
        inf.R_READY = 1;
    end
    else begin
        inf.R_READY = 0;
    end
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        data_dram.D       = 0;
        data_dram.Index_D = 0;
        data_dram.Index_C = 0;
        data_dram.M       = 0;
        data_dram.Index_B = 0;
        data_dram.Index_A = 0;
    end
    else begin
        data_dram.D       = n_data_dram.D;
        data_dram.Index_D = n_data_dram.Index_D;
        data_dram.Index_C = n_data_dram.Index_C;
        data_dram.M       = n_data_dram.M;
        data_dram.Index_B = n_data_dram.Index_B;
        data_dram.Index_A = n_data_dram.Index_A;
    end
end

always_comb begin
    if(c_state == READ_D && inf.R_VALID)begin
        n_data_dram.D       = inf.R_DATA[7:0];//Day
        n_data_dram.Index_D = inf.R_DATA[19:8];//Index_D
        n_data_dram.Index_C = inf.R_DATA[31:20];//Index_C
        n_data_dram.M       = inf.R_DATA[39:32];//Month
        n_data_dram.Index_B = inf.R_DATA[51:40];//Index_B
        n_data_dram.Index_A = inf.R_DATA[63:52];//Index_A
    end
    else begin
        n_data_dram.D       = data_dram.D;//Day
        n_data_dram.Index_D = data_dram.Index_D;//Index_D
        n_data_dram.Index_C = data_dram.Index_C;//Index_C
        n_data_dram.M       = data_dram.M;//Month
        n_data_dram.Index_B = data_dram.Index_B;//Index_B
        n_data_dram.Index_A = data_dram.Index_A;//Index_A
    end
end
//*************************************************************************************//
//*********************************     WRITE_A     ***********************************//
//*************************************************************************************//
always_comb begin
    if(c_state == WRITE_A)begin
        inf.AW_VALID = 1;
        inf.AW_ADDR = data_no_reg*8 + 'h10000;
    end
    else begin
        inf.AW_VALID = 0;
        inf.AW_ADDR = 0;
    end
end
//*************************************************************************************//
//*********************************     WRITE_D     ***********************************//
//*************************************************************************************//
always_comb begin
    if(c_state == WRITE_D)begin
        inf.W_VALID = 1;
        inf.W_DATA = {pat_abcd.A[11:0], pat_abcd.B[11:0], 4'b0000, date_reg.M[3:0], pat_abcd.C[11:0], pat_abcd.D[11:0], 3'b000, date_reg.D[4:0]};
    end
    else begin
        inf.W_VALID = 0;
        inf.W_DATA = 0;
    end
end
//*************************************************************************************//
//**********************************     W_RES     ************************************//
//*************************************************************************************//
always_comb begin
    if(c_state == W_RES)begin
        inf.B_READY = 1;
    end
    else begin
        inf.B_READY = 0;
    end
end

//*************************************************************************************//
//**********************************    ACTION1     ***********************************//
//*************************************************************************************//
always_comb begin
    add0 = add0_op0 + add0_op1;
    add1 = add1_op0 + add1_op1;
    add2 = add2_op0 + add2_op1;
    add3 = add3_op0 + add3_op1;
end

always_comb begin
    com_c00 = (com0_op0 >= com0_op1);
    com_c10 = (com1_op0 >= com1_op1);
    com_c20 = (com2_op0 >= com2_op1);
    com_c30 = (com3_op0 >= com3_op1);
end

always_comb begin
    com0 = (com_c00)? com0_op0: com0_op1;
    com1 = (com_c00)? com0_op1: com0_op0;
    com2 = (com_c10)? com1_op0: com1_op1;
    com3 = (com_c10)? com1_op1: com1_op0;
    com4 = (com_c20)? com2_op0: com2_op1;
    com5 = (com_c20)? com2_op1: com2_op0;
    com6 = (com_c30)? com3_op0: com3_op1;
    com7 = (com_c30)? com3_op1: com3_op0;
end

logic [2:0] com_t;
assign com_t = com_c00 + com_c10 + com_c20 + com_c30;

always_comb begin
    add0_op0 = data_dram.Index_A;
    add0_op1 = (c_state == ACTION0) ? ~pat_abcd.A+1 : pat_abcd.A;
    add1_op0 = data_dram.Index_B;
    add1_op1 = (c_state == ACTION0) ? ~pat_abcd.B+1 : pat_abcd.B;
    add2_op0 = data_dram.Index_C;
    add2_op1 = (c_state == ACTION0) ? ~pat_abcd.C+1 : pat_abcd.C;
    add3_op0 = data_dram.Index_D;
    add3_op1 = (c_state == ACTION0) ? ~pat_abcd.D+1 : pat_abcd.D;
end

always_comb begin
    com0_op0 = 0;
    com0_op1 = 0;
    com1_op0 = 0;
    com1_op1 = 0;
    com2_op0 = 0;
    com2_op1 = 0;
    com3_op0 = 0;
    com3_op1 = 0;
    // if(c_state == ACTION0)begin
        case(formula_reg)
            Formula_B:begin
                com0_op0 = data_dram.Index_A;
                com0_op1 = data_dram.Index_B;
                com1_op0 = data_dram.Index_C;
                com1_op1 = data_dram.Index_D;
                com2_op0 = com0;
                com2_op1 = com2;
                com3_op0 = com1;
                com3_op1 = com3;
            end
            Formula_C:begin
                com0_op0 = data_dram.Index_A;
                com0_op1 = data_dram.Index_B;
                com1_op0 = data_dram.Index_C;
                com1_op1 = data_dram.Index_D;
                com2_op0 = com0;
                com2_op1 = com2;
                com3_op0 = com1;
                com3_op1 = com3;
            end
            Formula_D:begin
                com0_op0 = data_dram.Index_A;
                com0_op1 = 2047;
                com1_op0 = data_dram.Index_B;
                com1_op1 = 2047;//com0_op1
                com2_op0 = data_dram.Index_C;
                com2_op1 = 2047;//com0_op1
                com3_op0 = data_dram.Index_D;
                com3_op1 = 2047;//com0_op1
            end
            Formula_E:begin
                com0_op0 = data_dram.Index_A;
                com0_op1 = pat_abcd.A;
                com1_op0 = data_dram.Index_B;
                com1_op1 = pat_abcd.B;
                com2_op0 = data_dram.Index_C;
                com2_op1 = pat_abcd.C;
                com3_op0 = data_dram.Index_D;
                com3_op1 = pat_abcd.D;
            end
            Formula_F, Formula_G:begin
                com0_op0 = pat_abcd.A;
                com0_op1 = pat_abcd.B;
                com1_op0 = pat_abcd.C;
                com1_op1 = pat_abcd.D;
                com2_op0 = com0;
                com2_op1 = com2;
                com3_op0 = com1;
                com3_op1 = com3;
            end
            // Formula_E, Formula_F, Formula_G, Formula_H:begin
            //     com0_op0 = data_dram.Index_A;
            //     com0_op1 = pat_abcd.A;
            //     com1_op0 = data_dram.Index_B;
            //     com1_op1 = pat_abcd.B;
            //     com2_op0 = data_dram.Index_C;
            //     com2_op1 = pat_abcd.C;
            //     com3_op0 = data_dram.Index_D;
            //     com3_op1 = pat_abcd.D;
            // end
        endcase
    // end
    // else if(c_state == FORMULA)begin
        // case(formula_reg)
        //     Formula_F:begin
                // com0_op0 = pat_abcd.A;
                // com0_op1 = pat_abcd.B;
                // com1_op0 = pat_abcd.C;
                // com1_op1 = pat_abcd.D;
                // com2_op0 = com0;
                // com2_op1 = com2;
                // com3_op0 = com1;
                // com3_op1 = com3;
            // end
            // Formula_G:begin
                // com0_op0 = pat_abcd.A;
                // com0_op1 = pat_abcd.B;
                // com1_op0 = pat_abcd.C;
                // com1_op1 = pat_abcd.D;
                // com2_op0 = com0;
                // com2_op1 = com2;
                // com3_op0 = com1;
                // com3_op1 = com3;
        //     end
        // endcase
    // end
end
//*************************************************************************************//
//***********************************    ADDER     ************************************//
//*************************************************************************************//
R add, n_add;
always_ff@(posedge clk) begin
    add <= n_add;
end
always_comb begin
    n_add = pat_abcd.B + pat_abcd.C + pat_abcd.D;
end
//*************************************************************************************//
//***********************************    RESULT    ************************************//
//*************************************************************************************//
R res, n_res;
always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        res <= 0;
    end
    else begin
        res <= n_res;
    end
end
always_comb begin
    n_res = res;
    case(formula_reg)
        Formula_A:begin
            n_res = (data_dram.Index_A + data_dram.Index_B + data_dram.Index_C + data_dram.Index_D) >> 2;//add2;
        end
        Formula_B:begin
            n_res = pat_abcd.A + (~pat_abcd.D+1);//add0
        end
        Formula_C:begin
            n_res = com7;
        end
        Formula_D:begin
            n_res = com_t;
        end
        Formula_E:begin
            n_res = com_t;
        end
        Formula_F:begin
            n_res = (add)/3;//add1/3
        end
        Formula_G:begin
            n_res = (pat_abcd.B>>2) + (pat_abcd.C>>2) + (pat_abcd.D>>1);//add1
        end
        Formula_H:begin
            n_res = (pat_abcd.A + pat_abcd.B + pat_abcd.C + pat_abcd.D) >> 2;//add2>>2
        end
    endcase
end


//*************************************************************************************//
//**********************************    WARN_MSG    ***********************************//
//*************************************************************************************//
logic Warn_data;
always_comb begin
    Warn_data = add0>4095 || add1>4095 || add2>4095 || add3>4095 || add0<0 || add1<0 || add2<0 || add3<0;
end

logic month_violation, day_violation;
always_comb begin
    month_violation = (data_dram.M > date_reg.M);
    day_violation = (data_dram.M == date_reg.M && data_dram.D > date_reg.D);
end

logic [10:0]th;
always_comb begin
    th = 0;
    case(formula_reg)
        Formula_A, Formula_C:begin
            case(mode_reg)
                Insensitive: th = 2047;
                Normal: th = 1023;
                Sensitive: th = 511;
                default: th = 0;
            endcase
        end
        Formula_D, Formula_E:begin
            case(mode_reg)
                Insensitive: th = 3;
                Normal: th = 2;
                Sensitive: th = 1;
                default: th = 0;
            endcase
        end
        Formula_B, Formula_F, Formula_G, Formula_H:begin
            case(mode_reg)
                Insensitive: th = 800;
                Normal: th = 400;
                Sensitive: th = 200;
                default: th = 0;
            endcase
        end
    endcase
end

always_ff @(posedge clk or negedge inf.rst_n) begin
    if(!inf.rst_n) begin
        warn_msg_reg <= 0;
    end
    else begin
        warn_msg_reg <= n_warn_msg_reg;
    end
end

always_comb begin
    n_warn_msg_reg = warn_msg_reg;
    case(c_state)
        IDLE: begin
            n_warn_msg_reg = No_Warn;
        end
        ACTION1: begin
            if(Warn_data)begin
                n_warn_msg_reg = Data_Warn;
            end
            else begin
                n_warn_msg_reg = No_Warn;
            end
        end
        ACTION0, ACTION2: begin
            if(month_violation)begin
                n_warn_msg_reg = Date_Warn;
            end
            else if(day_violation)begin
                n_warn_msg_reg = Date_Warn;
            end
            else begin
                n_warn_msg_reg = No_Warn;
                // case(date_reg.M)
                //     'd1:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 32)? No_Warn : Date_Warn;//1~31
                //     'd2:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 29)? No_Warn : Date_Warn;//1~28
                //     'd3:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 32)? No_Warn : Date_Warn;//1~31
                //     'd4:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 31)? No_Warn : Date_Warn;//1~30
                //     'd5:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 32)? No_Warn : Date_Warn;//1~31
                //     'd6:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 31)? No_Warn : Date_Warn;//1~30
                //     'd7:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 32)? No_Warn : Date_Warn;//1~31
                //     'd8:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 32)? No_Warn : Date_Warn;//1~31
                //     'd9:  n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 31)? No_Warn : Date_Warn;//1~30
                //     'd10: n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 32)? No_Warn : Date_Warn;//1~31
                //     'd11: n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 31)? No_Warn : Date_Warn;//1~30
                //     'd12: n_warn_msg_reg = (date_reg.D > 0 && date_reg.D < 32)? No_Warn : Date_Warn;//1~31
                //     default: n_warn_msg_reg = Date_Warn;
                // endcase
            end
        end
        THRESHOLD: begin
            n_warn_msg_reg = (res >= th) ? Risk_Warn : No_Warn;
        end
    endcase
end




always_comb begin
    inf.out_valid = (c_state == OUTPUT) ? 1 : 0;
    inf.warn_msg = (c_state == OUTPUT) ? warn_msg_reg : No_Warn;
    inf.complete = (c_state == OUTPUT) ? (warn_msg_reg == No_Warn) : 0;
end

endmodule
