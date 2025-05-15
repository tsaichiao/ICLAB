
// `include "../00_TESTBED/pseudo_DRAM.sv"
`include "Usertype.sv"

program automatic PATTERN(input clk, INF.PATTERN inf);
import usertype::*;
//================================================================
// parameters & integer
//================================================================
parameter DRAM_p_r = "../00_TESTBED/DRAM/dram.dat";
parameter MAX_CYCLE=1000;
integer SEED = 5;
parameter PATNUM = 5400;
`define CYCLE_TIME 15.0

integer j;
integer i_pat;
integer total_latency, latency;
integer formula_cnt;
//================================================================
// wire & registers 
//================================================================
logic [7:0] golden_DRAM [((65536+8*256)-1):(65536+0)];  // 32 box


Action       act_g;
Formula_Type formula_g;
Mode         mode_g;
Date         date_g;
Data_No      data_no_g;
Data_Dir     dram_data_g, S_dram_data_g;
Index        index_g;

logic [63:0] dd_64;
logic [2:0] z;
R result[0:7];
// logic [12:0]th;
ABCD P, G, C, N;
R M00, M01, M10, M11, M20, M21, M30, M31;
R S00, S01, S10, S11, S20, S21, S30, S31;

// golden outputs
logic complete_g;
Warn_Msg warn_msg_g;
// logic [31:0] out_info_g;
//================================================================
// class random
//================================================================
class action_random; // action for input valid signals
	rand Action action_id;
	function new (int seed);
		this.srandom(seed);
	endfunction
	constraint limit { action_id inside {Index_Check, Update, Check_Valid_Date}; }
endclass
action_random r_action = new(SEED) ;
//================================================================
class formula_random; // formula for input valid signals
	rand Formula_Type formula;
	function new (int seed);
		this.srandom(seed);
	endfunction
	constraint limit { formula inside {Formula_A, Formula_B, Formula_C, Formula_D, Formula_E, Formula_F, Formula_G, Formula_H}; }
endclass
formula_random r_formula = new(SEED) ;
//================================================================
class mode_random; // mode for input valid signals
	rand Mode mode;
	function new (int seed);
		this.srandom(seed);
	endfunction
	constraint limit { mode inside {Insensitive, Normal, Sensitive}; }
endclass
mode_random r_mode = new(SEED) ;
//================================================================
class date_random; // date for input valid signals
	rand Date date;
	function new (int seed);
		this.srandom(seed);
	endfunction
	constraint limit { date.M inside {[1:12]};
        if (date.M == 1 || date.M == 3 || date.M == 5 || date.M == 7 || date.M == 8 || date.M == 10 || date.M == 12)
            date.D inside {[1:31]};
        else if (date.M == 4 || date.M == 6 || date.M == 9 || date.M == 11)
            date.D inside {[1:30]};
        else if (date.M == 2)
            date.D inside {[1:28]};
     }
endclass
date_random r_date = new(SEED) ;
//================================================================
class data_no_random; // data_no for input valid signals
	rand Data_No data_no;
	function new (int seed);
		this.srandom(seed);
	endfunction
	constraint limit { data_no inside {[0:255]}; }
endclass
data_no_random r_data_no = new(SEED) ;
//================================================================
class index_random; // index for input valid signals
    rand Index index;
    function new (int seed);
        this.srandom(seed);
    endfunction
    constraint limit { index inside {[0:4095]}; }
endclass
index_random r_index = new(SEED) ;    
//================================================================
class delay_random; // Delays for input valid signals
	rand int delay;
	function new (int seed);
		this.srandom(seed);
	endfunction
	constraint limit { delay inside {[0:3]}; }
endclass
delay_random r_delay = new(SEED) ;
/**
 * Class representing a random action.
 */
// class random_act;
//     randc Action act_id;
//     constraint range{
//         act_id inside{Index_Check, Update, Check_Valid_Date};
//     }
// endclass


initial begin
    $readmemh(DRAM_p_r, golden_DRAM);
    reset_task;

    i_pat = 0;
    total_latency = 0;
    formula_cnt = 0;
    for (i_pat = 0; i_pat < PATNUM; i_pat = i_pat + 1) begin
        // @(negedge clk);
        task_delaying;
        action_generate;
        case(act_g)
			Index_Check: begin
				index_check_task;
			end
			Update: begin
				update_task;
			end
			Check_Valid_Date: begin
				check_valid_date_task;
			end
		endcase
        wait_out_valid_task;
        check_ans_task;
        $display("PASS PATTERN NO.%4d", i_pat);
        
    end

    YOU_PASS_task;
end

task reset_task; begin
    inf.rst_n            = 1'b1;
    inf.sel_action_valid = 1'b0;
    inf.formula_valid    = 1'b0;
    inf.mode_valid       = 1'b0;
    inf.date_valid       = 1'b0;
    inf.data_no_valid    = 1'b0;
    inf.index_valid      = 1'b0;
    inf.D                = 'bx;


    // Reseting
    #(1.0);	inf.rst_n = 0 ;
	#(`CYCLE_TIME*5);
	/*if (inf.out_valid !== 0 || inf.warn_msg !== 0 || inf.complete !== 0)begin
        $display ("                                                                SPEC 3 INCORRECT!                                                                ");
        #(100);
        $finish;
	end*/
	#(1.0);	inf.rst_n = 1 ;
end endtask



task action_generate; begin
    if(i_pat < 2700) begin
        case(i_pat%9)
        0: begin
            act_g = Index_Check;
        end
        1: begin
            act_g = Update;
        end
        2: begin
            act_g = Update;
        end
        3: begin
            act_g = Check_Valid_Date;
        end
        4: begin
            act_g = Check_Valid_Date;
        end
        5: begin
            act_g = Update;
        end
        6: begin
            act_g = Index_Check;
        end
        7: begin
            act_g = Check_Valid_Date;
        end
        8:begin
            act_g = Index_Check;
        end
        endcase
    end
    else begin
        act_g = Index_Check;
    end

end endtask

task index_check_task;begin
    inf.sel_action_valid = 1'b1;
    inf.D = act_g;
    @(negedge clk);
    inf.sel_action_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;


    inf.formula_valid = 1'b1;
    r_formula.randomize();
    // formula_g = r_formula.formula;
    case(formula_cnt%8)
        0: formula_g = Formula_A;
        1: formula_g = Formula_B;
        2: formula_g = Formula_C;
        3: formula_g = Formula_D;
        4: formula_g = Formula_E;
        5: formula_g = Formula_F;
        6: formula_g = Formula_G;
        7: formula_g = Formula_H;
    endcase
    inf.D  = formula_g;
    @(negedge clk);
    inf.formula_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;


    inf.mode_valid = 1'b1;
    r_mode.randomize();
    // mode_g = r_mode.mode;
    case(formula_cnt%3)
        0: mode_g = Insensitive;
        1: mode_g = Normal;
        2: mode_g = Sensitive;
    endcase
    formula_cnt++;
    // Golden mode selection, 3 sizes
    inf.D = mode_g;
    @(negedge clk);
    inf.mode_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;


    // Give Today's Date
    inf.date_valid = 1'b1;
    r_date.randomize();
    date_g.D = r_date.date.D;
    date_g.M = r_date.date.M;
    inf.D  = {date_g.M,date_g.D};
    @(negedge clk);
    inf.date_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;


    inf.data_no_valid= 1'b1;
    r_data_no.randomize();
    data_no_g = r_data_no.data_no;
    // no_box_g = 7;
    inf.D  = data_no_g;
    @(negedge clk);
    inf.data_no_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    get_dram_data_task;

    inf.index_valid= 1'b1;
    r_index.randomize();
    index_g = r_index.index;
    P.A = index_g;
    inf.D  = index_g;
    @(negedge clk);
    inf.index_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    inf.index_valid= 1'b1;
    r_index.randomize();
    index_g = r_index.index;
    P.B = index_g;
    inf.D  = index_g;
    @(negedge clk);
    inf.index_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    inf.index_valid= 1'b1;
    r_index.randomize();
    index_g = r_index.index;
    P.C = index_g;
    inf.D  = index_g;
    @(negedge clk);
    inf.index_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    inf.index_valid= 1'b1;
    r_index.randomize();
    index_g = r_index.index;
    P.D = index_g;
    inf.D  = index_g;
    @(negedge clk);
    inf.index_valid = 1'b0;
    inf.D = 'bx;

    // ABCD G;
    G.A = ($signed(dram_data_g.Index_A - P.A) >= 0) ? (dram_data_g.Index_A - P.A) : ~(dram_data_g.Index_A - P.A)+1/*(P.A - dram_data_g.Index_A)*/;
    G.B = ($signed(dram_data_g.Index_B - P.B) >= 0) ? (dram_data_g.Index_B - P.B) : ~(dram_data_g.Index_B - P.B)+1/*(P.B - dram_data_g.Index_B)*/;
    G.C = ($signed(dram_data_g.Index_C - P.C) >= 0) ? (dram_data_g.Index_C - P.C) : ~(dram_data_g.Index_C - P.C)+1/*(P.C - dram_data_g.Index_C)*/;
    G.D = ($signed(dram_data_g.Index_D - P.D) >= 0) ? (dram_data_g.Index_D - P.D) : ~(dram_data_g.Index_D - P.D)+1/*(P.D - dram_data_g.Index_D)*/;

    M00 = (dram_data_g.Index_A > dram_data_g.Index_B) ? dram_data_g.Index_A : dram_data_g.Index_B;
    M01 = (dram_data_g.Index_A > dram_data_g.Index_B) ? dram_data_g.Index_B : dram_data_g.Index_A;
    M10 = (dram_data_g.Index_C > dram_data_g.Index_D) ? dram_data_g.Index_C : dram_data_g.Index_D;
    M11 = (dram_data_g.Index_C > dram_data_g.Index_D) ? dram_data_g.Index_D : dram_data_g.Index_C;
    M20 = (M00 > M10) ? M00 : M10;//B
    M21 = (M00 > M10) ? M10 : M00;
    M30 = (M01 > M11) ? M01 : M11;
    M31 = (M01 > M11) ? M11 : M01;//S

    S00 = (G.A > G.B) ? G.A : G.B;
    S01 = (G.A > G.B) ? G.B : G.A;
    S10 = (G.C > G.D) ? G.C : G.D;
    S11 = (G.C > G.D) ? G.D : G.C;
    S20 = (S00 > S10) ? S00 : S10;//B
    S21 = (S00 > S10) ? S10 : S00;
    S30 = (S01 > S11) ? S01 : S11;
    S31 = (S01 > S11) ? S11 : S01;//S

    if((dram_data_g.M > date_g.M) || ((dram_data_g.M == date_g.M) && (dram_data_g.D > date_g.D)))begin
        warn_msg_g = Date_Warn;
        complete_g = 0;
    end
    else begin

        case(formula_g)
            Formula_A: begin
                result[0] = (dram_data_g.Index_A + dram_data_g.Index_B + dram_data_g.Index_C + dram_data_g.Index_D) >> 2;
                case(mode_g)
                    Insensitive: begin
                        if(result[0] >= 2047)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Normal: begin
                        if(result[0] >= 1023)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Sensitive: begin
                        if(result[0] >= 511)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                endcase
            end
            Formula_B: begin
                result[1] = M20 - M31;
                case(mode_g)
                    Insensitive: begin
                        if(result[1] >= 800)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Normal: begin
                        if(result[1] >= 400)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Sensitive: begin
                        if(result[1] >= 200)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                endcase
            end
            Formula_C: begin
                result[2] = M31;
                case(mode_g)
                    Insensitive: begin
                        if(result[2] >= 2047)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Normal: begin
                        if(result[2] >= 1023)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Sensitive: begin
                        if(result[2] >= 511)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                endcase
            end
            Formula_D: begin
                result[3] = (dram_data_g.Index_A>=2047) + (dram_data_g.Index_B>=2047) + (dram_data_g.Index_C>=2047) + (dram_data_g.Index_D>=2047);
                case(mode_g)
                    Insensitive: begin
                        if(result[3] >= 3)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Normal: begin
                        if(result[3] >= 2)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Sensitive: begin
                        if(result[3] >= 1)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                endcase
            end
            Formula_E: begin
                result[4] = (dram_data_g.Index_A>=P.A) + (dram_data_g.Index_B>=P.B) + (dram_data_g.Index_C>=P.C) + (dram_data_g.Index_D>=P.D);
                case(mode_g)
                    Insensitive: begin
                        if(result[4] >= 3)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Normal: begin
                        if(result[4] >= 2)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Sensitive: begin
                        if(result[4] >= 1)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                endcase
            end
            Formula_F: begin
                result[5] = (S21+S30+S31)/3;
                case(mode_g)
                    Insensitive: begin
                        if(result[5] >= 800)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Normal: begin
                        if(result[5] >= 400)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Sensitive: begin
                        if(result[5] >= 200)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                endcase
            end
            Formula_G: begin
                result[6] = (S21>>2) + (S30>>2) + (S31>>1);
                case(mode_g)
                    Insensitive: begin
                        if(result[6] >= 800)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Normal: begin
                        if(result[6] >= 400)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Sensitive: begin
                        if(result[6] >= 200)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                endcase
            end
            Formula_H: begin
                result[7] = (G.A + G.B + G.C + G.D)>>2;
                case(mode_g)
                    Insensitive: begin
                        if(result[7] >= 800)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Normal: begin
                        if(result[7] >= 400)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                    Sensitive: begin
                        if(result[7] >= 200)begin
                            warn_msg_g = Risk_Warn;
                            complete_g = 0;
                        end
                        else begin
                            warn_msg_g = No_Warn;
                            complete_g = 1;
                        end
                    end
                endcase
            end
        endcase
    end
    // case(formula_g)
    //     Formula_A, Formula_C:begin
    //         case(mode_g)
    //             Insensitive: th = 2047;
    //             Normal: th = 1023;
    //             Sensitive: th = 511;
    //             default: th = 0;
    //         endcase
    //     end
    //     Formula_D, Formula_E:begin
    //         case(mode_g)
    //             Insensitive: th = 3;
    //             Normal: th = 2;
    //             Sensitive: th = 1;
    //             default: th = 0;
    //         endcase
    //     end
    //     Formula_B, Formula_F, Formula_G, Formula_H:begin
    //         case(mode_g)
    //             Insensitive: th = 800;
    //             Normal: th = 400;
    //             Sensitive: th = 200;
    //             default: th = 0;
    //         endcase
    //     end
    // endcase

    
end endtask

task update_task;begin
    inf.sel_action_valid = 1'b1;
    inf.D = act_g;
    @(negedge clk);
    inf.sel_action_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;


    // Give Today's Date
    inf.date_valid = 1'b1;
    r_date.randomize();
    date_g.D = r_date.date.D;
    date_g.M = r_date.date.M;
    inf.D  = {date_g.M,date_g.D};
    @(negedge clk);
    inf.date_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;


    inf.data_no_valid= 1'b1;
    r_data_no.randomize();
    data_no_g = r_data_no.data_no;
    inf.D  = data_no_g;
    @(negedge clk);
    inf.data_no_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    get_dram_data_task;

    inf.index_valid= 1'b1;
    r_index.randomize();
    index_g = r_index.index;
    P.A = $signed(index_g);
    inf.D  = index_g;
    @(negedge clk);
    inf.index_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    inf.index_valid= 1'b1;
    r_index.randomize();
    index_g = r_index.index;
    P.B = $signed(index_g);
    inf.D  = index_g;
    @(negedge clk);
    inf.index_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    inf.index_valid= 1'b1;
    r_index.randomize();
    index_g = r_index.index;
    P.C = $signed(index_g);
    inf.D  = index_g;
    @(negedge clk);
    inf.index_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    inf.index_valid= 1'b1;
    r_index.randomize();
    index_g = r_index.index;
    P.D = $signed(index_g);
    inf.D  = index_g;
    @(negedge clk);
    inf.index_valid = 1'b0;
    inf.D = 'bx;

    // ABCD C;
    C.A = dram_data_g.Index_A + P.A;
    C.B = dram_data_g.Index_B + P.B;
    C.C = dram_data_g.Index_C + P.C;
    C.D = dram_data_g.Index_D + P.D;

    
    if(C.A > 4095 || C.B > 4095 || C.C > 4095 || C.D > 4095 || C.A < 0 || C.B < 0 || C.C < 0 || C.D < 0)begin
        warn_msg_g = Data_Warn;
        complete_g = 0;
    end
    else begin
        warn_msg_g = No_Warn;
        complete_g = 1;
    end

    // ABCD N;
    S_dram_data_g.Index_A = ($signed(dram_data_g.Index_A + P.A) > 4095) ? 4095 : ($signed(dram_data_g.Index_A + P.A) < 0) ? 0 : $signed(dram_data_g.Index_A + P.A);
    S_dram_data_g.Index_B = ($signed(dram_data_g.Index_B + P.B) > 4095) ? 4095 : ($signed(dram_data_g.Index_B + P.B) < 0) ? 0 : $signed(dram_data_g.Index_B + P.B);
    S_dram_data_g.Index_C = ($signed(dram_data_g.Index_C + P.C) > 4095) ? 4095 : ($signed(dram_data_g.Index_C + P.C) < 0) ? 0 : $signed(dram_data_g.Index_C + P.C);
    S_dram_data_g.Index_D = ($signed(dram_data_g.Index_D + P.D) > 4095) ? 4095 : ($signed(dram_data_g.Index_D + P.D) < 0) ? 0 : $signed(dram_data_g.Index_D + P.D);
    S_dram_data_g.M = date_g.M;
    S_dram_data_g.D = date_g.D;

    update_dram_data_task;

end endtask

task check_valid_date_task;begin
    inf.sel_action_valid = 1'b1;
    inf.D = act_g;
    @(negedge clk);
    inf.sel_action_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;


    // Give Today's Date
    inf.date_valid = 1'b1;
    r_date.randomize();
    date_g.D = r_date.date.D;
    date_g.M = r_date.date.M;
    inf.D  = {date_g.M,date_g.D};
    @(negedge clk);
    inf.date_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;


    inf.data_no_valid= 1'b1;
    r_data_no.randomize();
    data_no_g = r_data_no.data_no;
    inf.D  = data_no_g;
    @(negedge clk);
    inf.data_no_valid = 1'b0;
    inf.D = 'bx;
    task_delaying;

    get_dram_data_task;

    if((dram_data_g.M > date_g.M) || ((dram_data_g.M == date_g.M) && (dram_data_g.D > date_g.D)))begin
        warn_msg_g = Date_Warn;
        complete_g = 0;
    end
    else begin
        warn_msg_g = No_Warn;
        complete_g = 1;
    end

end endtask



task get_dram_data_task;begin
    // dram_data_g.Index_A = {golden_DRAM[65536+data_no_g*8 + 7],     golden_DRAM[65536+data_no_g*8 + 6][7:4]};
	// dram_data_g.Index_B = {golden_DRAM[65536+data_no_g*8 + 6][3:0],golden_DRAM[65536+data_no_g*8 + 5]};
	// dram_data_g.M       =  golden_DRAM[65536+data_no_g*8 + 4];
	// dram_data_g.Index_C = {golden_DRAM[65536+data_no_g*8 + 3],     golden_DRAM[65536+data_no_g*8 + 2][7:4]};
	// dram_data_g.Index_D = {golden_DRAM[65536+data_no_g*8 + 2][3:0],golden_DRAM[65536+data_no_g*8 + 1]};
	// dram_data_g.D       =  golden_DRAM[65536+data_no_g*8 + 0];
    dd_64[7:0]  = golden_DRAM[65536+data_no_g*8];
    dd_64[15:8] = golden_DRAM[65536+data_no_g*8 + 1];
    dd_64[23:16]= golden_DRAM[65536+data_no_g*8 + 2];
    dd_64[31:24]= golden_DRAM[65536+data_no_g*8 + 3];
    dd_64[39:32]= golden_DRAM[65536+data_no_g*8 + 4];
    dd_64[47:40]= golden_DRAM[65536+data_no_g*8 + 5];
    dd_64[55:48]= golden_DRAM[65536+data_no_g*8 + 6];
    dd_64[63:56]= golden_DRAM[65536+data_no_g*8 + 7];

    dram_data_g.Index_A = dd_64[63:52];
    dram_data_g.Index_B = dd_64[51:40];
    dram_data_g.M = dd_64[39:32];
    dram_data_g.Index_C = dd_64[31:20];
    dram_data_g.Index_D = dd_64[19:8];
    dram_data_g.D = dd_64[7:0];
end
endtask

task update_dram_data_task;begin
    golden_DRAM[65536+data_no_g*8 + 7]      = S_dram_data_g.Index_A[11:4];
    golden_DRAM[65536+data_no_g*8 + 6][7:4] = S_dram_data_g.Index_A[3:0];
	golden_DRAM[65536+data_no_g*8 + 6][3:0] = S_dram_data_g.Index_B[11:8];
    golden_DRAM[65536+data_no_g*8 + 5]      = S_dram_data_g.Index_B[7:0];
    golden_DRAM[65536+data_no_g*8 + 4]      = S_dram_data_g.M;
    golden_DRAM[65536+data_no_g*8 + 3]      = S_dram_data_g.Index_C[11:4];
    golden_DRAM[65536+data_no_g*8 + 2][7:4] = S_dram_data_g.Index_C[3:0];
    golden_DRAM[65536+data_no_g*8 + 2][3:0] = S_dram_data_g.Index_D[11:8];
    golden_DRAM[65536+data_no_g*8 + 1]      = S_dram_data_g.Index_D[7:0];
    golden_DRAM[65536+data_no_g*8 + 0]      = S_dram_data_g.D;
end
endtask

task task_delaying ;
begin
	r_delay.randomize();
	for( j=0 ; j<r_delay.delay ; j++ )
    begin
        @(negedge clk);
    end
end
endtask

task wait_out_valid_task;
begin
	latency = 0 ;
	while (inf.out_valid!==1)
    begin
		latency = latency + 1 ;
		/*if (latency==1000)
        begin
            $display ("============================================================================================================================");
            $display ("                                         total_latency is over 1000 cycles!                                         ");
            $display ("============================================================================================================================");
        	#(100);
            $finish;
		end*/
		@(negedge clk);
	end
	total_latency = total_latency + latency ;
end
endtask

task check_ans_task; begin
	// $display("output_task");
	z = 0;
	while (inf.out_valid===1)
    begin
		/*if (z >= 1)
        begin
			$display ("--------------------------------------------------");
			$display ("                    INCORRECT                     ");
			$display ("          Outvalid is more than 1 cycles          ");
			$display ("--------------------------------------------------");
	        #(100);
			$finish;
		end
		else*/ if (act_g==Index_Check)
        begin
    		if ( (inf.complete!==complete_g) || (inf.warn_msg!==warn_msg_g))
            begin
				$display("-----------------------------------------------------------");
    	    	$display("                      INCORRECT Index_Check                     ");
    	    	$display("    Golden complete : %6d    your complete : %6d ", complete_g, inf.complete);
    			$display("    Golden err_msg  : %6d    your err_msg  : %6d ", warn_msg_g, inf.warn_msg);
    			$display("-----------------------------------------------------------");
                incorrect_task;
		        // #(100);
    			$finish;
    		end
    	end
		else if (act_g == Update)
        begin
    		if ( (inf.complete!==complete_g) || (inf.warn_msg!==warn_msg_g))
            begin
				$display("-----------------------------------------------------------");
    	    	$display("                           INCORRECT Update                    ");
    	    	$display("    Golden complete : %6d    your complete : %6d ", complete_g, inf.complete);
    			$display("    Golden err_msg  : %6d    your err_msg  : %6d ", warn_msg_g, inf.warn_msg);
    			$display("-----------------------------------------------------------");
                incorrect_task;
		        // #(100);
    			$finish;
    		end
        end
        else if(act_g == Check_Valid_Date)
        begin
            if ( (inf.complete!==complete_g) || (inf.warn_msg!==warn_msg_g))
            begin
				$display("-----------------------------------------------------------");
    	    	$display("                     INCORRECT Check Valid date            ");
    	    	$display("    Golden complete : %6d    your complete : %6d ", complete_g, inf.complete);
    			$display("    Golden err_msg  : %6d    your err_msg  : %6d ", warn_msg_g, inf.warn_msg);
    			$display("-----------------------------------------------------------");
                incorrect_task;
		        // #(100);
    			$finish;
    		end
        end
	    @(negedge clk);
	    z = z + 1;
    end
end
endtask

task YOU_PASS_task;begin
$display ("----------------------------------------------------------------------------------------------------------------------");
$display ("                                                  Congratulations                                                     ");
// $display ("                                           You have passed all patterns!                                              ");
// $display ("                                                                                                                      ");
// $display ("                                        Your execution cycles   = %5d cycles                                          ", total_latency);
// $display ("                                        Your clock period       = %.1f ns                                             ", `CYCLE_TIME);
// $display ("                                        Total latency           = %.1f ns                                             ", total_latency*`CYCLE_TIME );
$display ("----------------------------------------------------------------------------------------------------------------------");
$finish;
end endtask

task incorrect_task; begin
$display("====================================================================================");
$display("                                      Wrong Answer                                  ");
$display("====================================================================================");
end endtask

endprogram