/**************************************************************************/
// Copyright (c) 2024, OASIS Lab
// MODULE: TETRIS
// FILE NAME: TETRIS.v
// VERSRION: 1.0
// DATE: August 15, 2024
// AUTHOR: Yu-Hsuan Hsu, NYCU IEE
// DESCRIPTION: ICLAB2024FALL / LAB3 / TETRIS
// MODIFICATION HISTORY:
// Date                 Description
// 
/**************************************************************************/
module TETRIS (
	//INPUT
	rst_n,
	clk,
	in_valid,
	tetrominoes,
	position,
	//OUTPUT
	tetris_valid,
	score_valid,
	fail,
	score,
	tetris
);

//---------------------------------------------------------------------
//   PORT DECLARATION          
//---------------------------------------------------------------------
input				rst_n, clk, in_valid;
input		[2:0]	tetrominoes;
input		[2:0]	position;
output reg			tetris_valid, score_valid, fail;
output reg	[3:0]	score;
output reg 	[71:0]	tetris;


//---------------------------------------------------------------------
//   PARAMETER & INTEGER DECLARATION
//---------------------------------------------------------------------
parameter IDLE      = 'd0;
parameter CAL       = 'd1;
parameter OUT       = 'd3;
//parameter RESET	    = 3'd1;

integer i;
//==============================================//
//            FSM State Declaration             //
//==============================================//
reg [1:0] c_state;
reg [1:0] n_state;
//---------------------------------------------------------------------
//   REG & WIRE DECLARATION
//---------------------------------------------------------------------

reg [2:0] score_temp, n_score_temp;
reg [5:0] tetris_temp[0:13], n_tetris_temp[0:13];

reg [3:0] col_top[0:5];

reg [3:0] com_in0, com_in1, com_in2, com_in3, com_in00, com_in01, com_out;
//wire [11:0] row_full;
reg [3:0] cut_row;/*wire*/

reg [3:0] cnt, n_cnt;

//reg  pass;//fail_temp,

//==============================================//
//             Current State Block              //
//==============================================//

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        c_state <= IDLE; /* initial state */
    else 
        c_state <= n_state;
end

//==============================================//
//              Next State Block                //
//==============================================//

always@(*) begin
    case(c_state)
		IDLE :  n_state = (in_valid) ? CAL : IDLE;
        CAL : n_state = (cut_row == 12/*pass == 0//cut_row[3]&&cut_row[2]*/) ? OUT : CAL;
		OUT : n_state = (in_valid) ? CAL : IDLE;
		default : n_state = IDLE;
    endcase
end

//---------------------------------------------------------------------
//   DESIGN
//---------------------------------------------------------------------
//assign pass = (&tetris_temp[0]) | (&tetris_temp[1]) | (&tetris_temp[2]) | (&tetris_temp[3]) | (&tetris_temp[4]) | (&tetris_temp[5]) | (&tetris_temp[6]) | (&tetris_temp[7]) | (&tetris_temp[8]) | (&tetris_temp[9]) | (&tetris_temp[10]) | (&tetris_temp[11]);
//assign pass = row_full[0] | row_full[1] | row_full[2] | row_full[3] | row_full[4] | row_full[5] | row_full[6] | row_full[7] | row_full[8] | row_full[9] | row_full[10] | row_full[11];


// assign row_full[0] = &tetris_temp[0];
// assign row_full[1] = &tetris_temp[1];
// assign row_full[2] = &tetris_temp[2];
// assign row_full[3] = &tetris_temp[3];
// assign row_full[4] = &tetris_temp[4];
// assign row_full[5] = &tetris_temp[5];
// assign row_full[6] = &tetris_temp[6];
// assign row_full[7] = &tetris_temp[7];
// assign row_full[8] = &tetris_temp[8];
// assign row_full[9] = &tetris_temp[9];
// assign row_full[10] = &tetris_temp[10];
// assign row_full[11] = &tetris_temp[11];


//assign cut_row = row_full[0] ? 0 : (row_full[1] ? 1 : (row_full[2] ? 2 : (row_full[3] ? 3 : (row_full[4] ? 4 : (row_full[5] ? 5 : (row_full[6] ? 6 : (row_full[7] ? 7 : (row_full[8] ? 8 : (row_full[9] ? 9 : (row_full[10] ? 10 : (row_full[11] ? 11 : 12)))))))))));
// always@(*) begin
// 	if(&tetris_temp[0]/*row_full[0]*/) pass = 1;
// 	else if(&tetris_temp[1]/*row_full[1]*/) pass = 1;
// 	else if(&tetris_temp[2]/*row_full[2]*/) pass = 1;
// 	else if(&tetris_temp[3]/*row_full[3]*/) pass = 1;
// 	else if(&tetris_temp[4]/*row_full[4]*/) pass = 1;
// 	else if(&tetris_temp[5]/*row_full[5]*/) pass = 1;
// 	else if(&tetris_temp[6]/*row_full[6]*/) pass = 1;
// 	else if(&tetris_temp[7]/*row_full[7]*/) pass = 1;
// 	else if(&tetris_temp[8]/*row_full[8]*/) pass = 1;
// 	else if(&tetris_temp[9]/*row_full[9]*/) pass = 1;
// 	else if(&tetris_temp[10]/*row_full[10]*/) pass = 1;
// 	else if(&tetris_temp[11]/*row_full[11]*/) pass = 1;
// 	else pass = 0;
// end

always@(*) begin
	if(&tetris_temp[0]/*row_full[0]*/) cut_row = 0;
	else if(&tetris_temp[1]/*row_full[1]*/) cut_row = 1;
	else if(&tetris_temp[2]/*row_full[2]*/) cut_row = 2;
	else if(&tetris_temp[3]/*row_full[3]*/) cut_row = 3;
	else if(&tetris_temp[4]/*row_full[4]*/) cut_row = 4;
	else if(&tetris_temp[5]/*row_full[5]*/) cut_row = 5;
	else if(&tetris_temp[6]/*row_full[6]*/) cut_row = 6;
	else if(&tetris_temp[7]/*row_full[7]*/) cut_row = 7;
	else if(&tetris_temp[8]/*row_full[8]*/) cut_row = 8;
	else if(&tetris_temp[9]/*row_full[9]*/) cut_row = 9;
	else if(&tetris_temp[10]/*row_full[10]*/) cut_row = 10;
	else if(&tetris_temp[11]/*row_full[11]*/) cut_row = 11;
	else cut_row = 12;
end

//***********************************  cnt  ***********************************//

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt <= 0;
    else begin
		cnt <= n_cnt;
	end
end
always@(*) begin

	if(tetris_valid) n_cnt = 0;/*fail*/
    else if(score_valid) n_cnt = cnt + 1;
	else n_cnt = cnt;

end

//assign col_top[0] = tetris_temp[11][0] ? 12 : (tetris_temp[10][0] ? 11 :(tetris_temp[9][0] ? 10 :(tetris_temp[8][0] ? 9 :(tetris_temp[7][0] ? 8 :(tetris_temp[6][0] ? 7 :(tetris_temp[5][0] ? 6 :(tetris_temp[4][0] ? 5 :(tetris_temp[3][0] ? 4 :(tetris_temp[2][0] ? 3 :(tetris_temp[1][0] ? 2 :(tetris_temp[0][0] ? 1 : 0)))))))))));
//assign col_top[1] = tetris_temp[11][1] ? 12 : (tetris_temp[10][1] ? 11 :(tetris_temp[9][1] ? 10 :(tetris_temp[8][1] ? 9 :(tetris_temp[7][1] ? 8 :(tetris_temp[6][1] ? 7 :(tetris_temp[5][1] ? 6 :(tetris_temp[4][1] ? 5 :(tetris_temp[3][1] ? 4 :(tetris_temp[2][1] ? 3 :(tetris_temp[1][1] ? 2 :(tetris_temp[0][1] ? 1 : 0)))))))))));
//assign col_top[2] = tetris_temp[11][2] ? 12 : (tetris_temp[10][2] ? 11 :(tetris_temp[9][2] ? 10 :(tetris_temp[8][2] ? 9 :(tetris_temp[7][2] ? 8 :(tetris_temp[6][2] ? 7 :(tetris_temp[5][2] ? 6 :(tetris_temp[4][2] ? 5 :(tetris_temp[3][2] ? 4 :(tetris_temp[2][2] ? 3 :(tetris_temp[1][2] ? 2 :(tetris_temp[0][2] ? 1 : 0)))))))))));
//assign col_top[3] = tetris_temp[11][3] ? 12 : (tetris_temp[10][3] ? 11 :(tetris_temp[9][3] ? 10 :(tetris_temp[8][3] ? 9 :(tetris_temp[7][3] ? 8 :(tetris_temp[6][3] ? 7 :(tetris_temp[5][3] ? 6 :(tetris_temp[4][3] ? 5 :(tetris_temp[3][3] ? 4 :(tetris_temp[2][3] ? 3 :(tetris_temp[1][3] ? 2 :(tetris_temp[0][3] ? 1 : 0)))))))))));
//assign col_top[4] = tetris_temp[11][4] ? 12 : (tetris_temp[10][4] ? 11 :(tetris_temp[9][4] ? 10 :(tetris_temp[8][4] ? 9 :(tetris_temp[7][4] ? 8 :(tetris_temp[6][4] ? 7 :(tetris_temp[5][4] ? 6 :(tetris_temp[4][4] ? 5 :(tetris_temp[3][4] ? 4 :(tetris_temp[2][4] ? 3 :(tetris_temp[1][4] ? 2 :(tetris_temp[0][4] ? 1 : 0)))))))))));
//assign col_top[5] = tetris_temp[11][5] ? 12 : (tetris_temp[10][5] ? 11 :(tetris_temp[9][5] ? 10 :(tetris_temp[8][5] ? 9 :(tetris_temp[7][5] ? 8 :(tetris_temp[6][5] ? 7 :(tetris_temp[5][5] ? 6 :(tetris_temp[4][5] ? 5 :(tetris_temp[3][5] ? 4 :(tetris_temp[2][5] ? 3 :(tetris_temp[1][5] ? 2 :(tetris_temp[0][5] ? 1 : 0)))))))))));

always@(*) begin
    if(tetris_temp[11][0]) col_top[0] = 12;
	else if(tetris_temp[10][0]) col_top[0] = 11;
	else if(tetris_temp[9][0]) col_top[0] = 10;
	else if(tetris_temp[8][0]) col_top[0] = 9;
	else if(tetris_temp[7][0]) col_top[0] = 8;
	else if(tetris_temp[6][0]) col_top[0] = 7;
	else if(tetris_temp[5][0]) col_top[0] = 6;
	else if(tetris_temp[4][0]) col_top[0] = 5;
	else if(tetris_temp[3][0]) col_top[0] = 4;
	else if(tetris_temp[2][0]) col_top[0] = 3;
	else if(tetris_temp[1][0]) col_top[0] = 2;
	else if(tetris_temp[0][0]) col_top[0] = 1;
	else col_top[0] = 0;

	if(tetris_temp[11][1]) col_top[1] = 12;
	else if(tetris_temp[10][1]) col_top[1] = 11;
	else if(tetris_temp[9][1]) col_top[1] = 10;
	else if(tetris_temp[8][1]) col_top[1] = 9;
	else if(tetris_temp[7][1]) col_top[1] = 8;
	else if(tetris_temp[6][1]) col_top[1] = 7;
	else if(tetris_temp[5][1]) col_top[1] = 6;
	else if(tetris_temp[4][1]) col_top[1] = 5;
	else if(tetris_temp[3][1]) col_top[1] = 4;
	else if(tetris_temp[2][1]) col_top[1] = 3;
	else if(tetris_temp[1][1]) col_top[1] = 2;
	else if(tetris_temp[0][1]) col_top[1] = 1;
	else col_top[1] = 0;

	if(tetris_temp[11][2]) col_top[2] = 12;
	else if(tetris_temp[10][2]) col_top[2] = 11;
	else if(tetris_temp[9][2]) col_top[2] = 10;
	else if(tetris_temp[8][2]) col_top[2] = 9;
	else if(tetris_temp[7][2]) col_top[2] = 8;
	else if(tetris_temp[6][2]) col_top[2] = 7;
	else if(tetris_temp[5][2]) col_top[2] = 6;
	else if(tetris_temp[4][2]) col_top[2] = 5;
	else if(tetris_temp[3][2]) col_top[2] = 4;
	else if(tetris_temp[2][2]) col_top[2] = 3;
	else if(tetris_temp[1][2]) col_top[2] = 2;
	else if(tetris_temp[0][2]) col_top[2] = 1;
	else col_top[2] = 0;

	if(tetris_temp[11][3]) col_top[3] = 12;
	else if(tetris_temp[10][3]) col_top[3] = 11;
	else if(tetris_temp[9][3]) col_top[3] = 10;
	else if(tetris_temp[8][3]) col_top[3] = 9;
	else if(tetris_temp[7][3]) col_top[3] = 8;
	else if(tetris_temp[6][3]) col_top[3] = 7;
	else if(tetris_temp[5][3]) col_top[3] = 6;
	else if(tetris_temp[4][3]) col_top[3] = 5;
	else if(tetris_temp[3][3]) col_top[3] = 4;
	else if(tetris_temp[2][3]) col_top[3] = 3;
	else if(tetris_temp[1][3]) col_top[3] = 2;
	else if(tetris_temp[0][3]) col_top[3] = 1;
	else col_top[3] = 0;

	if(tetris_temp[11][4]) col_top[4] = 12;
	else if(tetris_temp[10][4]) col_top[4] = 11;
	else if(tetris_temp[9][4]) col_top[4] = 10;
	else if(tetris_temp[8][4]) col_top[4] = 9;
	else if(tetris_temp[7][4]) col_top[4] = 8;
	else if(tetris_temp[6][4]) col_top[4] = 7;
	else if(tetris_temp[5][4]) col_top[4] = 6;
	else if(tetris_temp[4][4]) col_top[4] = 5;
	else if(tetris_temp[3][4]) col_top[4] = 4;
	else if(tetris_temp[2][4]) col_top[4] = 3;
	else if(tetris_temp[1][4]) col_top[4] = 2;
	else if(tetris_temp[0][4]) col_top[4] = 1;
	else col_top[4] = 0;

	if(tetris_temp[11][5]) col_top[5] = 12;
	else if(tetris_temp[10][5]) col_top[5] = 11;
	else if(tetris_temp[9][5]) col_top[5] = 10;
	else if(tetris_temp[8][5]) col_top[5] = 9;
	else if(tetris_temp[7][5]) col_top[5] = 8;
	else if(tetris_temp[6][5]) col_top[5] = 7;
	else if(tetris_temp[5][5]) col_top[5] = 6;
	else if(tetris_temp[4][5]) col_top[5] = 5;
	else if(tetris_temp[3][5]) col_top[5] = 4;
	else if(tetris_temp[2][5]) col_top[5] = 3;
	else if(tetris_temp[1][5]) col_top[5] = 2;
	else if(tetris_temp[0][5]) col_top[5] = 1;
	else col_top[5] = 0;

end

//COMPARATOR comp01(.in0(com_in0), .in1(com_in1), .in2(com_in2), .in3(com_in3), .out(com_out));

always@(*) begin
	if(tetrominoes == 'd0) begin
		com_in0 = col_top[position];
		com_in1 = col_top[position + 1];
		com_in2 = 0;
		com_in3 = 0;
	end
	else if(tetrominoes == 'd1) begin
		com_in0 = col_top[position];
		com_in1 = 0;
		com_in2 = 0;
		com_in3 = 0;
	end
    else if(tetrominoes == 'd2) begin
		com_in0 = col_top[position];
		com_in1 = col_top[position + 1];
		com_in2 = col_top[position + 2];
		com_in3 = col_top[position + 3];
	end
	else if(tetrominoes == 'd3) begin
		com_in0 = col_top[position];
		com_in1 = col_top[position + 1] + 2;
		com_in2 = 0;
		com_in3 = 0;
	end
	else if(tetrominoes == 'd4) begin
		com_in0 = col_top[position] + 1;
		com_in1 = col_top[position + 1];
		com_in2 = col_top[position + 2];
		com_in3 = 0;
	end
    else if(tetrominoes == 'd5) begin
		com_in0 = col_top[position];
		com_in1 = col_top[position + 1];
		com_in2 = 0;
		com_in3 = 0;
	end
	else if(tetrominoes == 'd6) begin
		com_in0 = col_top[position];
		com_in1 = col_top[position + 1] + 1;
		com_in2 = 0;
		com_in3 = 0;
	end
	else if(tetrominoes == 'd7) begin
		com_in0 = col_top[position] + 1;
		com_in1 = col_top[position + 1] + 1;
		com_in2 = col_top[position + 2];
		com_in3 = 0;
	end
	
	// case(tetrominoes)
    //     'd0:begin
	// 		com_in0 = col_top[position];
	// 		com_in1 = col_top[position + 1];
	// 		com_in2 = 0;
	// 		com_in3 = 0;
	// 	end
	// 	'd1: begin
	// 		com_in0 = col_top[position];
	// 		com_in1 = 0;
	// 		com_in2 = 0;
	// 		com_in3 = 0;
	// 	end
    //     'd2:begin
	// 		com_in0 = col_top[position];
	// 		com_in1 = col_top[position + 1];
	// 		com_in2 = col_top[position + 2];
	// 		com_in3 = col_top[position + 3];
	// 	end
	// 	'd3:begin
	// 		com_in0 = col_top[position];
	// 		com_in1 = col_top[position + 1] + 2;
	// 		com_in2 = 0;
	// 		com_in3 = 0;
	// 	end
	// 	'd4: begin
	// 		com_in0 = col_top[position] + 1;
	// 		com_in1 = col_top[position + 1];
	// 		com_in2 = col_top[position + 2];
	// 		com_in3 = 0;
	// 	end
    //     'd5:begin
	// 		com_in0 = col_top[position];
	// 		com_in1 = col_top[position + 1];
	// 		com_in2 = 0;
	// 		com_in3 = 0;
	// 	end
	// 	'd6:begin
	// 		com_in0 = col_top[position];
	// 		com_in1 = col_top[position + 1] + 1;
	// 		com_in2 = 0;
	// 		com_in3 = 0;
	// 	end
	// 	'd7: begin
	// 		com_in0 = col_top[position] + 1;
	// 		com_in1 = col_top[position + 1] + 1;
	// 		com_in2 = col_top[position + 2];
	// 		com_in3 = 0;
	// 	end
	// endcase
	com_in00 = (com_in0 > com_in1) ? com_in0 : com_in1;
	com_in01 = (com_in2 > com_in3) ? com_in2 : com_in3;
	com_out = (com_in00 > com_in01) ? com_in00 : com_in01;

end

//***********************************  tetris_temp  ***********************************//
always@(*) begin
	//n_score_temp = score_temp;
	n_tetris_temp = tetris_temp;
	if(in_valid) begin
		if(tetrominoes == 'd0) begin
			n_tetris_temp[com_out]    [position]     = 1'b1;
    		n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		n_tetris_temp[com_out + 1][position]     = 1'b1;
    		n_tetris_temp[com_out + 1][position + 1] = 1'b1;
		end
		else if(tetrominoes == 'd1) begin
    		n_tetris_temp[com_out]    [position] = 1'b1;
    		n_tetris_temp[com_out + 1][position] = 1'b1;
    		n_tetris_temp[com_out + 2][position] = 1'b1;
    		n_tetris_temp[com_out + 3][position] = 1'b1;
    	end
    	else if(tetrominoes == 'd2) begin
    		n_tetris_temp[com_out][position]     = 1'b1;
    		n_tetris_temp[com_out][position + 1] = 1'b1;
    		n_tetris_temp[com_out][position + 2] = 1'b1;
    		n_tetris_temp[com_out][position + 3] = 1'b1;
    	end
    	else if(tetrominoes == 'd3) begin
    		n_tetris_temp[com_out]    [position]     = 1'b1;
    		n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		n_tetris_temp[com_out - 1][position + 1] = 1'b1;//-1
    		n_tetris_temp[com_out - 2][position + 1] = 1'b1;//-2
    	end
    	else if(tetrominoes == 'd4) begin
    		n_tetris_temp[com_out - 1][position]     = 1'b1;//-1
    		n_tetris_temp[com_out]    [position]     = 1'b1;
    		n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		n_tetris_temp[com_out]    [position + 2] = 1'b1;
    	end
    	else if(tetrominoes == 'd5) begin
    		n_tetris_temp[com_out]    [position]     = 1'b1;
    		n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		n_tetris_temp[com_out + 1][position]     = 1'b1;
    		n_tetris_temp[com_out + 2][position]     = 1'b1;
    	end
    	else if(tetrominoes == 'd6) begin
    		n_tetris_temp[com_out]    [position]     = 1'b1;
    		n_tetris_temp[com_out + 1][position]     = 1'b1;
    		n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		n_tetris_temp[com_out - 1][position + 1] = 1'b1;//-1
    	end
    	else if(tetrominoes == 'd7) begin
    		n_tetris_temp[com_out - 1][position]     = 1'b1;//-1
    		n_tetris_temp[com_out - 1][position + 1] = 1'b1;//-1
    		n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		n_tetris_temp[com_out]    [position + 2] = 1'b1;
    	end
		/*case(tetrominoes)
    		'd0:begin
    		    n_tetris_temp[com_out]    [position]     = 1'b1;
    		    n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		    n_tetris_temp[com_out + 1][position]     = 1'b1;
    		    n_tetris_temp[com_out + 1][position + 1] = 1'b1;
    		end
    		'd1:begin
    		    n_tetris_temp[com_out]    [position] = 1'b1;
    		    n_tetris_temp[com_out + 1][position] = 1'b1;
    		    n_tetris_temp[com_out + 2][position] = 1'b1;
    		    n_tetris_temp[com_out + 3][position] = 1'b1;
    		end
    		'd2:begin
    		    n_tetris_temp[com_out][position]     = 1'b1;
    		    n_tetris_temp[com_out][position + 1] = 1'b1;
    		    n_tetris_temp[com_out][position + 2] = 1'b1;
    		    n_tetris_temp[com_out][position + 3] = 1'b1;
    		end
    		'd3:begin
    		    n_tetris_temp[com_out]    [position]     = 1'b1;
    		    n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		    n_tetris_temp[com_out - 1][position + 1] = 1'b1;
    		    n_tetris_temp[com_out - 2][position + 1] = 1'b1;
    		end
    		'd4:begin
    			n_tetris_temp[com_out - 1][position]     = 1'b1;
    			n_tetris_temp[com_out]    [position]     = 1'b1;
    			n_tetris_temp[com_out]    [position + 1] = 1'b1;
    			n_tetris_temp[com_out]    [position + 2] = 1'b1;
    		end
    		'd5:begin
    		    n_tetris_temp[com_out]    [position]     = 1'b1;
    		    n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		    n_tetris_temp[com_out + 1][position]     = 1'b1;//+1
    		    n_tetris_temp[com_out + 2][position]     = 1'b1;//+2
    		end
    		'd6:begin
    		    n_tetris_temp[com_out]    [position]     = 1'b1;
    		    n_tetris_temp[com_out + 1][position]     = 1'b1;
    		    n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		    n_tetris_temp[com_out - 1][position + 1] = 1'b1;
    		end
    		'd7:begin
    		    n_tetris_temp[com_out - 1][position]     = 1'b1;
    		    n_tetris_temp[com_out - 1][position + 1] = 1'b1;
    		    n_tetris_temp[com_out]    [position + 1] = 1'b1;
    		    n_tetris_temp[com_out]    [position + 2] = 1'b1;
    		end
    	endcase*/
	end
	else if(tetris_valid) begin
		//n_score_temp = 0;
		for(i = 0; i < 14; i=i+1)
			n_tetris_temp[i] = 0;
	end
	/*else begin
		case(cut_row)
			'd0:begin
    		    for(i = 0; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd1:begin
    		    for(i = 1; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd2:begin
    		    for(i = 2; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd3:begin
    		    for(i = 3; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd4:begin
    			for(i = 4; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd5:begin
    		    for(i = 5; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd6:begin
    		    for(i = 6; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd7:begin
				for(i = 7; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
			'd8:begin
    			for(i = 8; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd9:begin
    		    for(i = 9; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd10:begin
    		    for(i = 10; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
    		'd11:begin
				for(i = 11; i < 13; i=i+1)
					n_tetris_temp[i] = tetris_temp[i+1];
    		end
			default:n_tetris_temp = tetris_temp;
		endcase
	end*/
	else if(cut_row == 0)begin//row_full[0]&tetris_temp[0]
		//n_score_temp = score_temp + 1;
		for(i = 0; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 1)begin//row_full[1]&tetris_temp[1]
		//n_score_temp = score_temp + 1;
		for(i = 1; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 2)begin//row_full[2]&tetris_temp[2]
		//n_score_temp = score_temp + 1;
		for(i = 2; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 3)begin//row_full[3]&tetris_temp[3]
		//n_score_temp = score_temp + 1;
		for(i = 3; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 4)begin//row_full[4]&tetris_temp[4]
		//n_score_temp = score_temp + 1;
		for(i = 4; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 5)begin//row_full[5]&tetris_temp[5]
		//n_score_temp = score_temp + 1;
		for(i = 5; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 6)begin//row_full[6]&tetris_temp[6]
		//n_score_temp = score_temp + 1;
		for(i = 6; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 7)begin//row_full[7]&tetris_temp[7]
		//n_score_temp = score_temp + 1;
		for(i = 7; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 8)begin//row_full[8]&tetris_temp[8]
		//n_score_temp = score_temp + 1;
		for(i = 8; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 9)begin//row_full[9]&tetris_temp[9]
		//n_score_temp = score_temp + 1;
		for(i = 9; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 10)begin//row_full[10]&tetris_temp[10]
		//n_score_temp = score_temp + 1;
		for(i = 10; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	else if(cut_row == 11)begin//row_full[11]&tetris_temp[11]
		//n_score_temp = score_temp + 1;
		for(i = 11; i < 13; i=i+1)
			n_tetris_temp[i] = tetris_temp[i+1];
    end
	
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        for(i = 0; i < 14; i=i+1)
			tetris_temp[i] <= 0;
    else begin
		tetris_temp <= n_tetris_temp;
	end
end

//***********************************  score  ***********************************//

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        score_temp <= 0;
    else begin
		score_temp <= n_score_temp;
	end
end
always@(*) begin

	if(tetris_valid) n_score_temp = 0;
    else if(cut_row != 12)//pass//!(cut_row[3]&&cut_row[2])
		n_score_temp = score_temp + 1;
	else n_score_temp = score_temp;

end

//**********************************************************************************//
//***********************************   OUTPUT   ***********************************//
//**********************************************************************************//
/*always@(*) begin
	if(n_state == OUT) begin
		score = score_temp;
	end
	else begin
		score = 0;
	end
end

always@(*) begin
	if(n_state == OUT) begin
		score_valid = 1;
	end
	else begin
		score_valid = 0;
	end
end

always@(*) begin
	if(n_state == OUT && |tetris_temp[12]) begin
		fail = 1;
	end
	else begin
		fail = 0;
	end
end

always@(*) begin
	if(n_state == OUT && (|tetris_temp[12] || cnt == 15)) begin
		tetris_valid = 1;
	end
	else begin
		tetris_valid = 0;
	end
end*/

always@(*) begin
	score_valid = (n_state == OUT) ? 1 : 0;
	score = (n_state == OUT) ? score_temp : 0;
	fail = (n_state == OUT && |tetris_temp[12]) ? 1 : 0;
	tetris_valid = (n_state == OUT && (|tetris_temp[12] || cnt == 15)) ? 1 : 0;
	tetris = (n_state == OUT && (|tetris_temp[12] || cnt == 15)) ? {tetris_temp[11],tetris_temp[10],tetris_temp[9],tetris_temp[8],tetris_temp[7],tetris_temp[6],tetris_temp[5],tetris_temp[4],tetris_temp[3],tetris_temp[2],tetris_temp[1],tetris_temp[0]} : 0;
end

// always@(*) begin
// 	if(n_state == OUT && (|tetris_temp[12] || cnt == 15)) begin
// 		tetris[5:0] = tetris_temp[0];
//     	tetris[11:6] = tetris_temp[1];
//     	tetris[17:12] = tetris_temp[2];
//     	tetris[23:18] = tetris_temp[3];
//     	tetris[29:24] = tetris_temp[4];
//     	tetris[35:30] = tetris_temp[5];
//     	tetris[41:36] = tetris_temp[6];
//     	tetris[47:42] = tetris_temp[7];
//     	tetris[53:48] = tetris_temp[8];
//     	tetris[59:54] = tetris_temp[9];
//     	tetris[65:60] = tetris_temp[10];
//     	tetris[71:66] = tetris_temp[11];
// 	end
// 	else begin
// 		tetris = 0;
// 	end
// end

endmodule

/*module COMPARATOR (
	//INPUT
	in0, in1, in2, in3,
	//OUTPUT
	out
);

input     [3:0] in0, in1, in2, in3;

output reg [3:0] out;

reg [3:0] a1, a2;

assign a1 = (in0>in1) ? in0 : in1;
assign a2 = (in2>in3) ? in2 : in3;
assign out = (a1>a2) ? a1 : a2;

endmodule*/
