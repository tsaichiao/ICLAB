/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NYCU Institute of Electronic
2023 Autumn IC Design Laboratory 
Lab10: SystemVerilog Coverage & Assertion
File Name   : CHECKER.sv
Module Name : CHECKER
Release version : v1.0 (Release Date: Nov-2023)
Author : Jui-Huang Tsai (erictsai.10@nycu.edu.tw)
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

`include "Usertype.sv"
module Checker(input clk, INF.CHECKER inf);
import usertype::*;

// integer fp_w;

// initial begin
// fp_w = $fopen("out_valid.txt", "w");
// end

/**
 * This section contains the definition of the class and the instantiation of the object.
 *  * 
 * The always_ff blocks update the object based on the values of valid signals.
 * When valid signal is true, the corresponding property is updated with the value of inf.D
 */

class Formula_and_mode;
    Formula_Type f_type;
    Mode f_mode;
endclass

Formula_and_mode fm_info = new();
Action act_reg;
always_ff @(posedge clk iff inf.formula_valid) fm_info.f_type = inf.D.d_formula[0];
always_ff @(posedge clk iff inf.mode_valid) fm_info.f_mode = inf.D.d_mode[0];
always_ff @(posedge clk iff inf.sel_action_valid) act_reg = inf.D.d_act[0];

covergroup covergroup_1_formula @(posedge clk iff inf.formula_valid);
    option.per_instance = 1; // Keeps track of coverage for each instance when it is set true
    option.at_least = 150;
    c_formula: coverpoint inf.D.d_formula[0] {bins b_formula[] = {[Formula_A:Formula_H]};}
endgroup

covergroup_1_formula cg_formula = new();

covergroup covergroup_2_mode @(posedge clk iff inf.mode_valid);
    option.per_instance = 1;
    option.at_least = 150;
    c_mode: coverpoint inf.D.d_mode[0] {bins b_mode[] = {2'b00,2'b01,2'b11};}
endgroup

covergroup_2_mode cg_mode = new();

covergroup covergroup_3_formula_x_mode @(posedge clk iff inf.date_valid && act_reg == Index_Check);
    option.per_instance = 1;
    option.at_least = 150;
    // c_fo: coverpoint fm_info.f_type {bins b_formula[] = {[Formula_A:Formula_H]};}
    // c_mo: coverpoint inf.D.d_mode[0] {bins b_mode[] = {2'b00,2'b01,2'b11};}
    c_formula_x_mode: cross fm_info.f_type, fm_info.f_mode;//fm_info.f_type, fm_info.f_mode
endgroup

covergroup_3_formula_x_mode cg_formula_x_mode = new();

covergroup covergroup_4_warnmsg @(posedge clk iff inf.out_valid);
    option.per_instance = 1;
    option.at_least = 50;
    c_msg: coverpoint inf.warn_msg {bins b_msg[] = {No_Warn, Date_Warn, Risk_Warn, Data_Warn};}
endgroup

covergroup_4_warnmsg cg_warnmsg = new();

covergroup covergroup_5_action @(posedge clk iff inf.sel_action_valid);
    option.per_instance = 1;
    option.at_least = 300;
    c_action: coverpoint inf.D.d_act[0] {bins b_act[] = ([Index_Check:Check_Valid_Date]=>[Index_Check:Check_Valid_Date]);}
endgroup

covergroup_5_action cg_action = new();

covergroup covergroup_6_update @(posedge clk iff inf.index_valid && act_reg == Update);
    option.per_instance = 1;
    option.at_least = 1;
    option.auto_bin_max = 32;
    c_update: coverpoint inf.D.d_index[0];
endgroup

covergroup_6_update cg_update = new();

// //* assert 
// assert property(SPEC_1_rst)                 else print_Assertion_msg("1");
// assert property(SPEC_2_IC)                  else print_Assertion_msg("2");
// assert property(SPEC_2_U)                   else print_Assertion_msg("2");
// assert property(SPEC_2_CVD)                 else print_Assertion_msg("2");
// assert property(SPEC_3_warnmsg)             else print_Assertion_msg("3");
// assert property(SPEC_4_IC)                  else print_Assertion_msg("4");
// assert property(SPEC_4_U)                   else print_Assertion_msg("4");
// assert property(SPEC_4_CVD)                 else print_Assertion_msg("4");
// assert property(SPEC_5_sel_action)          else print_Assertion_msg("5");
// assert property(SPEC_5_formula)             else print_Assertion_msg("5");
// assert property(SPEC_5_mode)                else print_Assertion_msg("5");
// assert property(SPEC_5_date)                else print_Assertion_msg("5");
// assert property(SPEC_5_data_no)             else print_Assertion_msg("5");
// assert property(SPEC_5_index)               else print_Assertion_msg("5");
// assert property(SPEC_6_outvalid_one_cycle)  else print_Assertion_msg("6");
// assert property(SPEC_7_next_input)          else print_Assertion_msg("7");
// assert property(SPEC_8_MONTH)               else print_Assertion_msg("8");
// assert property(SPEC_8_DAY_28)              else print_Assertion_msg("8");
// assert property(SPEC_8_DAY_30)              else print_Assertion_msg("8");
// assert property(SPEC_8_DAY_31)              else print_Assertion_msg("8");
// assert property(SPEC_9_overlap)             else print_Assertion_msg("9");

// //* display task
// task print_Assertion_msg(string num);
//     $display("==============================================================");
//     $display("                 Assertion %s is violated                     ", num);
//     $display("==============================================================");
//     $fatal;
// endtask

//* assert 
assert property(SPEC_1_rst) else begin
    $display("==============================================================");
    $display("                 Assertion 1 is violated                     ");
    $display("==============================================================");
    $fatal;
end

assert property(SPEC_2_IC) else begin
    $display("==============================================================");
    $display("                 Assertion 2 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_2_U) else begin
    $display("==============================================================");
    $display("                 Assertion 2 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_2_CVD) else begin
    $display("==============================================================");
    $display("                 Assertion 2 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_3_warnmsg) else begin
    $display("==============================================================");
    $display("                 Assertion 3 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_4_IC) else begin
    $display("==============================================================");
    $display("                 Assertion 4 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_4_U) else begin
    $display("==============================================================");
    $display("                 Assertion 4 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_4_CVD) else begin
    $display("==============================================================");
    $display("                 Assertion 4 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_5_sel_action) else begin
    $display("==============================================================");
    $display("                 Assertion 5 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_5_formula) else begin
    $display("==============================================================");
    $display("                 Assertion 5 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_5_mode) else begin
    $display("==============================================================");
    $display("                 Assertion 5 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_5_date) else begin
    $display("==============================================================");
    $display("                 Assertion 5 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_5_data_no) else begin
    $display("==============================================================");
    $display("                 Assertion 5 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_5_index) else begin
    $display("==============================================================");
    $display("                 Assertion 5 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_6_outvalid_one_cycle) else begin
    $display("==============================================================");
    $display("                 Assertion 6 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_7_next_input) else begin
    $display("==============================================================");
    $display("                 Assertion 7 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_8_MONTH) else begin
    $display("==============================================================");
    $display("                 Assertion 8 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_8_DAY_28) else begin
    $display("==============================================================");
    $display("                 Assertion 8 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_8_DAY_30) else begin
    $display("==============================================================");
    $display("                 Assertion 8 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_8_DAY_31) else begin
    $display("==============================================================");
    $display("                 Assertion 8 is violated                     ");
    $display("==============================================================");
    $fatal;
end
assert property(SPEC_9_overlap) else begin
    $display("==============================================================");
    $display("                 Assertion 9 is violated                     ");
    $display("==============================================================");
    $fatal;
end


//*    1. All outputs signals (Program.sv) should be zero after reset.

property SPEC_1_rst;
    @(posedge inf.rst_n) 1 |-> @(posedge clk) (inf.out_valid   === 0 &&    inf.complete    === 0 &&    inf.warn_msg     === 0 &&    
                                               inf.AR_VALID    === 0 &&    inf.AR_ADDR     === 0 &&    inf.R_READY     === 0 &&    
                                               inf.AW_VALID    === 0 &&    inf.AW_ADDR     === 0 &&    inf.W_VALID     === 0 &&    
                                               inf.W_DATA      === 0 &&    inf.B_READY     === 0);
endproperty

//*    2.	Latency should be less than 1000 cycles for each operation.

property SPEC_2_IC;
    @(posedge clk) (inf.sel_action_valid && inf.D.d_act[0]===Index_Check) 
    ##[1:4] inf.formula_valid ##[1:4] inf.mode_valid ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] (inf.index_valid[->4]) |-> ##[1:999] inf.out_valid;
endproperty


property SPEC_2_U;
    @(posedge clk) (inf.sel_action_valid && inf.D.d_act[0]===Update) 
    ##[1:4] inf.date_valid##[1:4] inf.data_no_valid ##[1:4] (inf.index_valid[->4]) |-> ##[1:999] inf.out_valid;
endproperty


property SPEC_2_CVD;
    @(posedge clk) (inf.sel_action_valid && inf.D.d_act[0]===Check_Valid_Date) 
    ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid |-> ##[1:999] inf.out_valid;
endproperty

//*    3. If action is completed (complete=1), warn_msg should be 2’b0 (no_err).

property SPEC_3_warnmsg;
    @(negedge clk) ((inf.out_valid!==0) && (inf.complete===1)) |-> inf.warn_msg===No_Warn; 
endproperty

//*    4. Next input valid will be valid 1-4 cycles after previous input valid fall.

property SPEC_4_IC;
    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Index_Check) |-> ##[1:4] inf.formula_valid  ##[1:4] inf.mode_valid  ##[1:4] inf.date_valid  ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid; 
endproperty

property SPEC_4_U;
    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Update) |-> ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid ##[1:4] inf.index_valid; 
endproperty

property SPEC_4_CVD;
    @(posedge clk) (inf.sel_action_valid===1 && inf.D.d_act[0]===Check_Valid_Date) |-> ##[1:4] inf.date_valid ##[1:4] inf.data_no_valid; 
endproperty

//*    5. All input valid signals won't overlap with each other. 

property SPEC_5_formula;
    @(posedge clk) (inf.formula_valid===1) |-> !(inf.sel_action_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property SPEC_5_sel_action;
    @(posedge clk) (inf.sel_action_valid===1) |-> !(inf.formula_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property SPEC_5_date;
    @(posedge clk) (inf.date_valid===1) |-> !(inf.formula_valid || inf.mode_valid || inf.sel_action_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property SPEC_5_mode;
    @(posedge clk) (inf.mode_valid===1) |-> !(inf.formula_valid || inf.sel_action_valid || inf.date_valid || inf.data_no_valid || inf.index_valid); 
endproperty

property SPEC_5_index;
    @(posedge clk) (inf.index_valid===1) |-> !(inf.formula_valid || inf.mode_valid || inf.date_valid || inf.data_no_valid || inf.sel_action_valid); 
endproperty

property SPEC_5_data_no;
    @(posedge clk) (inf.data_no_valid===1) |-> !(inf.formula_valid || inf.mode_valid || inf.date_valid || inf.sel_action_valid || inf.index_valid); 
endproperty

//*    6. Out_valid can only be high for exactly one cycle.

property SPEC_6_outvalid_one_cycle;
    @(posedge clk) (inf.out_valid===1) |=> (inf.out_valid===0); 
endproperty

//*    7. Next operation will be valid 1-4 cycles after out_valid fall.

property SPEC_7_next_input;
    @(posedge clk) (inf.out_valid===1) |-> ##[1:4] (inf.sel_action_valid === 1) ;
    // @(posedge clk) (inf.out_valid===1) ##(1) !inf.out_valid |-> ##[0:3] inf.sel_action_valid; 
endproperty

//*    8. The input date from pattern should adhere to the real calendar. (ex: 2/29, 3/0, 4/31, 13/1 are illegal cases)

property SPEC_8_MONTH;
    @(posedge clk) (inf.date_valid===1) |-> inf.D.d_date[0].M inside {[1:12]}; 
endproperty

property SPEC_8_DAY_31;
    @(posedge clk) 
    ((inf.date_valid===1) && (  inf.D.d_date[0].M===1  ||
                                inf.D.d_date[0].M===3  ||
                                inf.D.d_date[0].M===5  ||
                                inf.D.d_date[0].M===7  ||
                                inf.D.d_date[0].M===8  ||
                                inf.D.d_date[0].M===10 ||
                                inf.D.d_date[0].M===12
                        )) |-> inf.D.d_date[0].D inside {[1:31]}; 
endproperty

property SPEC_8_DAY_28;
    @(posedge clk) ((inf.date_valid===1) && inf.D.d_date[0].M===2) |-> inf.D.d_date[0].D inside {[1:28]}; 
endproperty

property SPEC_8_DAY_30;
    @(posedge clk) 
    ((inf.date_valid===1) && (  inf.D.d_date[0].M===4 ||
                                inf.D.d_date[0].M===6 ||
                                inf.D.d_date[0].M===9 ||
                                inf.D.d_date[0].M===11)) |-> inf.D.d_date[0].D inside {[1:30]}; 
endproperty

//*    9. The AR_VALID signals should not overlap with the AW_VALID signal.

property SPEC_9_overlap;
    @(posedge clk) (inf.AR_VALID===1) |-> (!inf.AW_VALID); 
endproperty


endmodule