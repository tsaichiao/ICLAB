/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: PATTERN
// FILE NAME: PATTERN.v
// VERSRION: 1.0
// DATE: August 15, 2024
// AUTHOR: Yu-Hsuan Hsu, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / PATTERN
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/

`ifdef RTL
    `define CYCLE_TIME 6.5
`endif
`ifdef GATE
    `define CYCLE_TIME 6.5
`endif

module PATTERN(
	//OUTPUT
	rst_n,
	clk,
	in_valid,
	tetrominoes,
	position,
	//INPUT
	tetris_valid,
	score_valid,
	fail,
	score,
	tetris
);

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
output reg			rst_n, clk, in_valid;
output reg	[2:0]	tetrominoes;
output reg  [2:0]	position;
input 				tetris_valid, score_valid, fail;
input 		[3:0]	score;
input		[71:0]	tetris;

//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
integer total_latency;
real CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;

integer f_in;
integer PAT_NUM, pat_num_temp;
integer i_pat;
integer a, b, c, i, j, k, t;
integer latency;
integer out_num;

			
//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------
reg	[2:0] tetrominoes_temp;
reg [2:0] position_temp;

reg [3:0] score_temp;
reg [5:0] tetris_temp[0:13];

reg [3:0] col_top[0:5];

reg golden_fail;
reg [3:0] golden_score;
reg [71:0] golden_tetris;

//---------------------------------------------------------------------
//  CLOCK
//---------------------------------------------------------------------
initial begin
    f_in = $fopen("../00_TESTBED/input.txt", "r");
    reset_signal_task;

    i_pat = 0;
    //total_latency = 0;
    a = $fscanf(f_in, "%d", PAT_NUM);
    for (i_pat = 0; i_pat < PAT_NUM; i_pat = i_pat + 1) begin

        a = $fscanf(f_in, "%d", pat_num_temp);

        score_temp = 0;
        tetris_temp[0] = 0;tetris_temp[1] = 0;
        tetris_temp[2] = 0;tetris_temp[3] = 0;
        tetris_temp[4] = 0;tetris_temp[5] = 0;
        tetris_temp[6] = 0;tetris_temp[7] = 0;
        tetris_temp[8] = 0;tetris_temp[9] = 0;
        tetris_temp[10] = 0;tetris_temp[11] = 0;
        tetris_temp[12] = 0;tetris_temp[13] = 0;
        col_top[0] = 0;col_top[1] = 0;
        col_top[2] = 0;col_top[3] = 0;
        col_top[4] = 0;col_top[5] = 0;

        golden_fail = 0;
        //repeat(3) #CYCLE;
        t = $urandom_range(1,4);
        repeat(t) @(negedge clk);
        for(i = 0; i < 16; i = i + 1) begin
            if(golden_fail === 0) begin
                input_task;
                //generate_ans_task;
                wait_out_valid_task;
                check_ans_task;
                
            end
            else begin
                a = $fscanf(f_in, "%d", b);
                a = $fscanf(f_in, "%d", c);
            end

        end
        //total_latency = total_latency + latency;
        $display("PASS PATTERN NO.%4d", i_pat);
    end
    $fclose(f_in);

    YOU_PASS_task;
end

//---------------------------------------------------------------------
//  SIMULATION
//---------------------------------------------------------------------

//****************************            SPEC-4 FAIL            ****************************//
task reset_signal_task; begin
    // initialize all signals
    rst_n = 'b1;
    in_valid = 'b0;
    tetrominoes = 'bx;
    position = 'bx;
    total_latency = 0;

    force clk = 0;

    #CYCLE; rst_n = 0; 
    #CYCLE; rst_n = 1;
    
    if(tetris_valid !== 0 || score_valid !== 0 || fail  !== 0 || score !== 0 || tetris !== 0) begin
		$display("                    SPEC-4 FAIL                   ");
        repeat(2) #CYCLE;
        $finish;
    end
	#CYCLE; release clk;
end
endtask

//****************************            SPEC-5 FAIL            ****************************//
always @(negedge clk) begin
    if(((score_valid === 0) && (tetris_valid !== 0)) || ((score_valid === 0) && (fail  !== 0)) || ((score_valid === 0) && (score !== 0)) || (tetris !== 0 && tetris_valid === 0)) begin
        $display("                    SPEC-5 FAIL                   ");
        //repeat(2) #CYCLE;
        $finish;
    end
end

task input_task; begin
    repeat (1) @(negedge clk);
    //while (!$feof(f_in)) begin

    a = $fscanf(f_in, "%d", tetrominoes_temp);
    a = $fscanf(f_in, "%d", position_temp);
    // $display("action_value = %s", action_value);
    
    in_valid = 1'b1;
    tetrominoes = tetrominoes_temp;
    position = position_temp;
    generate_ans_task;
    @(negedge clk);


    in_valid = 1'b0;
    tetrominoes = 'bx;
    position = 'bx;

end 
endtask

task generate_ans_task; begin

    case(tetrominoes_temp)
        1'd0:begin
            if(col_top[position_temp] >= col_top[position_temp + 1]) begin
                tetris_temp[col_top[position_temp]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp + 1] = 1'b1;

                col_top[position_temp + 1] = col_top[position_temp] + 2;
                col_top[position_temp] = col_top[position_temp] + 2;
            end
            else begin
                tetris_temp[col_top[position_temp + 1]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 1][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 1][position_temp] = 1'b1;

                col_top[position_temp] = col_top[position_temp + 1] + 2;
                col_top[position_temp + 1] = col_top[position_temp + 1] + 2;
            end

        end
        1'd1:begin
            if(col_top[position_temp] < 11) begin
                tetris_temp[col_top[position_temp]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp] + 2][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp] + 3][position_temp] = 1'b1;

                col_top[position_temp] = col_top[position_temp] + 4;
            end
            else begin
                golden_fail = 1;
                tetris_temp[11][position_temp] = 1'b1;
            end
        end
        'd2:begin
            /*if(col_top[position_temp] > 11 || col_top[position_temp + 1] > 11 ||
             col_top[position_temp + 2] > 11 || col_top[position_temp + 3])begin
                golden_fail = 1;
            end
            else */if(col_top[position_temp] >= col_top[position_temp + 1] &&
                col_top[position_temp] >= col_top[position_temp + 2] &&
                col_top[position_temp] >= col_top[position_temp + 3]) begin

                tetris_temp[col_top[position_temp]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp]][position_temp + 2] = 1'b1;
                tetris_temp[col_top[position_temp]][position_temp + 3] = 1'b1;
                
                col_top[position_temp + 1] = col_top[position_temp] + 1;
                col_top[position_temp + 2] = col_top[position_temp] + 1;
                col_top[position_temp + 3] = col_top[position_temp] + 1;
                col_top[position_temp] = col_top[position_temp] + 1;
            end
            else if(col_top[position_temp + 1] >= col_top[position_temp] &&
                col_top[position_temp + 1] >= col_top[position_temp + 2] &&
                col_top[position_temp + 1] >= col_top[position_temp + 3])begin

                tetris_temp[col_top[position_temp + 1]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 1]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1]][position_temp + 2] = 1'b1;
                tetris_temp[col_top[position_temp + 1]][position_temp + 3] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 1] + 1;
                col_top[position_temp + 2] = col_top[position_temp + 1] + 1;
                col_top[position_temp + 3] = col_top[position_temp + 1] + 1;
                col_top[position_temp + 1] = col_top[position_temp + 1] + 1;
            end
            else if(col_top[position_temp + 2] >= col_top[position_temp] &&
                col_top[position_temp + 2] >= col_top[position_temp + 1] &&
                col_top[position_temp + 2] >= col_top[position_temp + 3])begin

                tetris_temp[col_top[position_temp + 2]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 2]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 2]][position_temp + 2] = 1'b1;
                tetris_temp[col_top[position_temp + 2]][position_temp + 3] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 2] + 1;
                col_top[position_temp + 1] = col_top[position_temp + 2] + 1;
                col_top[position_temp + 3] = col_top[position_temp + 2] + 1;
                col_top[position_temp + 2] = col_top[position_temp + 2] + 1;
            end
            else /*if(col_top[position_temp + 3] >= col_top[position_temp] &&
                col_top[position_temp + 3] >= col_top[position_temp + 1] &&
                col_top[position_temp + 3] >= col_top[position_temp + 2])*/begin

                tetris_temp[col_top[position_temp + 3]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 3]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 3]][position_temp + 2] = 1'b1;
                tetris_temp[col_top[position_temp + 3]][position_temp + 3] = 1'b1;

                col_top[position_temp] = col_top[position_temp + 3] + 1;
                col_top[position_temp + 1] = col_top[position_temp + 3] + 1;
                col_top[position_temp + 2] = col_top[position_temp + 3] + 1;
                col_top[position_temp + 3] = col_top[position_temp + 3] + 1;
            end
        end
        'd3:begin
            if(col_top[position_temp + 1]  > 10) begin
                golden_fail = 1;
                tetris_temp[11][position_temp + 1] = 1'b1;
            end
            else if(col_top[position_temp] >= col_top[position_temp + 1] + 2) begin
                
                tetris_temp[col_top[position_temp]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp] - 1][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp] - 2][position_temp + 1] = 1'b1;
                
                col_top[position_temp + 1] = col_top[position_temp] + 1;
                col_top[position_temp] = col_top[position_temp] + 1;
            end
            else /*if(col_top[position_temp] < col_top[position_temp + 1] + 2)*/ begin
                
                tetris_temp[col_top[position_temp + 1]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 1][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 2][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 2][position_temp] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 1] + 3;
                col_top[position_temp + 1] = col_top[position_temp + 1] + 3;
            end
        end
        'd4:begin
            if(col_top[position_temp] > 11) begin
                golden_fail = 1;
            end
            else if(col_top[position_temp] + 1 >= col_top[position_temp + 1] &&
            col_top[position_temp] + 1 >= col_top[position_temp + 2]) begin

                tetris_temp[col_top[position_temp]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp + 2] = 1'b1;
                
                col_top[position_temp + 1] = col_top[position_temp] + 2;
                col_top[position_temp + 2] = col_top[position_temp] + 2;
                col_top[position_temp] = col_top[position_temp] + 2;
            end
            else if(col_top[position_temp] + 1 < col_top[position_temp + 1] &&
            /*col_top[position_temp] + 1 < col_top[position_temp + 2] &&*/
            col_top[position_temp + 1] > col_top[position_temp + 2]) begin

                tetris_temp[col_top[position_temp + 1]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1]][position_temp + 2] = 1'b1;
                tetris_temp[col_top[position_temp + 1]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 1] - 1][position_temp] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 1] + 1;
                col_top[position_temp + 2] = col_top[position_temp + 1] + 1;
                col_top[position_temp + 1] = col_top[position_temp + 1] + 1;
            end
            else //if(/*col_top[position_temp] + 1 < col_top[position_temp + 1] &&*/
            /*col_top[position_temp] + 1 <= col_top[position_temp + 2] &&
            col_top[position_temp + 1] <= col_top[position_temp + 2])*/ begin

                tetris_temp[col_top[position_temp + 2]][position_temp + 2] = 1'b1;
                tetris_temp[col_top[position_temp + 2]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 2]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 2] - 1][position_temp] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 2] + 1;
                col_top[position_temp + 1] = col_top[position_temp + 2] + 1;
                col_top[position_temp + 2] = col_top[position_temp + 2] + 1;
            end
        end
        'd5:begin
            if(col_top[position_temp] > 11 || col_top[position_temp + 1] > 11) begin
                golden_fail = 1;
            end
            else if(col_top[position_temp] >= col_top[position_temp + 1]) begin

                tetris_temp[col_top[position_temp]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp] + 2][position_temp] = 1'b1;

                col_top[position_temp + 1] = col_top[position_temp] + 1;
                col_top[position_temp] = col_top[position_temp] + 3;
            end
            else begin
                
                tetris_temp[col_top[position_temp + 1]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 1][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 2][position_temp] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 1] + 3;
                col_top[position_temp + 1] = col_top[position_temp + 1] + 1;
            end
        end
        'd6:begin
            if(col_top[position_temp + 1] > 11) begin
                golden_fail = 1;
                tetris_temp[11][position_temp + 1] = 1'b1;
            end
            else if(col_top[position_temp] >= col_top[position_temp + 1] + 1) begin
                
                tetris_temp[col_top[position_temp]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp] - 1][position_temp + 1] = 1'b1;
                
                col_top[position_temp + 1] = col_top[position_temp] + 1;
                col_top[position_temp] = col_top[position_temp] + 2;
            end
            else /*if(col_top[position_temp] < col_top[position_temp + 1] + 1)*/ begin
                
                tetris_temp[col_top[position_temp + 1]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 1][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 1][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 2][position_temp] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 1] + 3;
                col_top[position_temp + 1] = col_top[position_temp + 1] + 2;
            end
        end
        'd7:begin
            if(col_top[position_temp] >= col_top[position_temp + 1] &&
            col_top[position_temp] + 1 >= col_top[position_temp + 2]) begin

                tetris_temp[col_top[position_temp]][position_temp] = 1'b1;
                tetris_temp[col_top[position_temp]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp] + 1][position_temp + 2] = 1'b1;
                
                col_top[position_temp + 1] = col_top[position_temp] + 2;
                col_top[position_temp + 2] = col_top[position_temp] + 2;
                col_top[position_temp] = col_top[position_temp] + 1;
            end
            else if(col_top[position_temp] <= col_top[position_temp + 1] &&
            col_top[position_temp + 1] + 1 >= col_top[position_temp + 2]) begin

                tetris_temp[col_top[position_temp + 1]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 1][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 1] + 1][position_temp + 2] = 1'b1;
                tetris_temp[col_top[position_temp + 1]][position_temp] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 1] + 1;
                col_top[position_temp + 2] = col_top[position_temp + 1] + 2;
                col_top[position_temp + 1] = col_top[position_temp + 1] + 2;
            end
            else /*if(col_top[position_temp] + 1 <= col_top[position_temp + 2] &&
            col_top[position_temp + 1] + 1 <= col_top[position_temp + 2])*/ begin

                tetris_temp[col_top[position_temp + 2]][position_temp + 2] = 1'b1;
                tetris_temp[col_top[position_temp + 2]][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 2] - 1][position_temp + 1] = 1'b1;
                tetris_temp[col_top[position_temp + 2] - 1][position_temp] = 1'b1;
                
                col_top[position_temp] = col_top[position_temp + 2];
                col_top[position_temp + 1] = col_top[position_temp + 2] + 1;
                col_top[position_temp + 2] = col_top[position_temp + 2] + 1;
            end
        end

    endcase
    #1;
    if(&tetris_temp[11]) begin
        /*tetris_temp[0] = tetris_temp[1];
        tetris_temp[1] = tetris_temp[2];
        tetris_temp[2] = tetris_temp[3];
        tetris_temp[3] = tetris_temp[4];
        tetris_temp[4] = tetris_temp[5];
        tetris_temp[5] = tetris_temp[6];
        tetris_temp[6] = tetris_temp[7];
        tetris_temp[7] = tetris_temp[8];
        tetris_temp[8] = tetris_temp[9];
        tetris_temp[9] = tetris_temp[10];
        tetris_temp[10] = tetris_temp[11];
        tetris_temp[11] = tetris_temp[12];
        tetris_temp[12] = tetris_temp[13];*/

        for (int j = 11; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[10]) begin
        for (int j = 10; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[9]) begin
        for (int j = 9; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[8]) begin
        for (int j = 8; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[7]) begin
        for (int j = 7; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[6]) begin
        for (int j = 6; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[5]) begin
        for (int j = 5; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[4]) begin
        for (int j = 4; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[3]) begin
        for (int j = 3; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[2]) begin
        for (int j = 2; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[1]) begin
        for (int j = 1; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    if(&tetris_temp[0]) begin
        for (int j = 0; j < 13; j = j + 1) begin
            tetris_temp[j] = tetris_temp[j + 1];
        end

        score_temp = score_temp + 1;
    end
    #1;
    for(int k = 0; k < 6; k = k + 1) 
        for(int j = 12; j >= 0; j = j - 1)
            if(tetris_temp[j][k] === 1'b1) begin
                col_top[k] = j + 1;
                break;
            end
            else col_top[k] = 0;
    #1;
    if((|tetris_temp[12]) || (|tetris_temp[13])) begin
        golden_fail = 1'b1;
    end

    golden_tetris[5:0] = tetris_temp[0];
    golden_tetris[11:6] = tetris_temp[1];
    golden_tetris[17:12] = tetris_temp[2];
    golden_tetris[23:18] = tetris_temp[3];
    golden_tetris[29:24] = tetris_temp[4];
    golden_tetris[35:30] = tetris_temp[5];
    golden_tetris[41:36] = tetris_temp[6];
    golden_tetris[47:42] = tetris_temp[7];
    golden_tetris[53:48] = tetris_temp[8];
    golden_tetris[59:54] = tetris_temp[9];
    golden_tetris[65:60] = tetris_temp[10];
    golden_tetris[71:66] = tetris_temp[11];
    
    golden_score = score_temp;

end
endtask

//****************************            SPEC-6 FAIL            ****************************//
task wait_out_valid_task; begin
    latency = 1;
    while (score_valid !== 1'b1) begin
        latency = latency + 1;
        if (latency == 1000) begin
            $display("                    SPEC-6 FAIL                   ");
            repeat (2) @(negedge clk);
            $finish;
        end
        @(negedge clk);
    end
    total_latency = total_latency + latency;
end 
endtask

//****************************            SPEC-7 FAIL            ****************************//
//****************************            SPEC-8 FAIL            ****************************//
task check_ans_task; begin
    
    out_num = 0;
    //$display("**********************************************************");
    while (score_valid === 1) begin

        if ((score !== golden_score || fail !== golden_fail || (tetris_valid === 1 && tetris !== golden_tetris)) && out_num === 0) begin
            $display("                    SPEC-7 FAIL                   ");
            //$display("                    SPEC-7 FAIL                   ");
            repeat (9) @(negedge clk);
            $finish;
        end
        else begin
            @(negedge clk);
            out_num = out_num + 1;
        end
    end

    if(out_num !== 1) begin
        $display("                    SPEC-8 FAIL                   ");
        repeat(9) @(negedge clk);
        $finish;
    end
end 
endtask

/*always @(negedge clk) begin
    if(score_valid === 1 || tetris_valid === 1) begin
        @(negedge clk);
        if(score_valid !== 0 || tetris_valid !== 0) begin
            $display("                    SPEC-8 FAIL                   ");
            //repeat(2) #CYCLE;
            $finish;
        end
    end
end*/

task YOU_PASS_task; begin
    $display("                  Congratulations!               ");
    $display("              execution cycles = %7d", total_latency);
    $display("              clock period = %4fns", CYCLE);
    repeat (2) @(negedge clk);
    $finish;
end
endtask

endmodule
// for spec check
// $display("                    SPEC-4 FAIL                   ");
// $display("                    SPEC-5 FAIL                   ");
// $display("                    SPEC-6 FAIL                   ");
// $display("                    SPEC-7 FAIL                   ");
// $display("                    SPEC-8 FAIL                   ");
// for successful design
// $display("                  Congratulations!               ");
// $display("              execution cycles = %7d", total_latency);
// $display("              clock period = %4fns", CYCLE);