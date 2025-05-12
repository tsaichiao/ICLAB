module BB(
    //Input Ports
    input clk,
    input rst_n,
    input in_valid,
    input [1:0] inning,   // Current inning number
    input half,           // 0: top of the inning, 1: bottom of the inning
    input [2:0] action,   // Action code

    //Output Ports
    output reg out_valid,  // Result output valid
    output reg [7:0] score_A,  // Score of team A (guest team)
    output reg [7:0] score_B,  // Score of team B (home team)
    output reg [1:0] result    // 0: Team A wins, 1: Team B wins, 2: Darw
);

//==============================================//
//             Action Memo for Students         //
// Action code interpretation:
// 3’d0: Walk (BB)
// 3’d1: 1H (single hit)
// 3’d2: 2H (double hit)
// 3’d3: 3H (triple hit)
// 3’d4: HR (home run)
// 3’d5: Bunt (short hit)
// 3’d6: Ground ball
// 3’d7: Fly ball
//==============================================//

//==============================================//
//             Parameter and Integer            //
//==============================================//
// State declaration for FSM
// Example: parameter IDLE = 3'b000;
parameter IDLE      = 3'd0;
parameter INPUT_A 	= 3'd2;
parameter INPUT_B   = 3'd3;
parameter OUTPUT	= 3'd1;
//==============================================//
//            FSM State Declaration             //
//==============================================//
reg [2:0] c_state;
reg [2:0] n_state;

//==============================================//
//                 reg declaration              //
//==============================================//
reg [1:0] out_count; // count of outs
reg [2:0] base;      // base

reg [2:0] n_score;
reg [2:0] n_base;
reg [2:0] n_out;

reg [4:0] score_A_;
reg [2:0] score_B_;
reg [3:0] score_sel;
reg [3:0] score_;

reg n_early_stop;
reg early_stop;
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
		IDLE :  n_state = (in_valid) ? INPUT_A : IDLE;
		INPUT_A : n_state = (half) ? INPUT_B : INPUT_A;
        INPUT_B : n_state = (in_valid) ? ((half) ? INPUT_B : INPUT_A) : OUTPUT;
        OUTPUT : n_state =  IDLE;
		default : n_state = IDLE;
    endcase
end

//==============================================//
//             Base and Score Logic             //
//==============================================//
// Handle base runner movements and score calculation.
// Update bases and score depending on the action:
// Example: Walk, Hits (1H, 2H, 3H), Home Runs, etc.

CALCULATION cal01(.action(action), .base(base), .out(out_count), .new_score(n_score), .new_base(n_base), .new_out(n_out));

assign score_sel = half ? score_B_ : score_A_;
assign score_ = score_sel + n_score;

always@(posedge clk /*or negedge rst_n*/) begin
    /*if(!rst_n) begin
        score_A_ <= 0;
    end
    else begin*/
        if(n_state == INPUT_A) begin
            score_A_ <= score_;
        end
        else if(n_state == IDLE/*n_state == INPUT_B || n_state == OUTPUT*/)begin
	    	score_A_ <= 0;
        end
        else score_A_ <= score_A_;
    //end
end

always@(posedge clk/* or negedge rst_n*/) begin
    /*if(!rst_n) begin
        score_B_ <= 0;
    end
    else begin*/
        if(n_state == INPUT_B && !n_early_stop) begin
            score_B_ <= score_;
        end
        else if(n_state == IDLE/*n_state == INPUT_A || n_state == INPUT_B || n_state == OUTPUT*/)begin
	    	score_B_ <= 0;
        end
        else score_B_ <= score_B_;
    //end
end

always@(posedge clk) begin
    if(n_state == IDLE) begin
        base <= 0;
        out_count <= 0;
    end
    else begin
        base <= (n_out /*== 3*/> 2) ? 3'b000 : n_base;
        out_count <= (n_out /*== 3*/> 2) ? 0 : n_out;
    end
end

always@(posedge clk /*or negedge rst_n*/) begin
    if(n_state == IDLE/*!rst_n*/) 
        early_stop <= 0;
    else 
    early_stop <= n_early_stop;
end

always@(*) begin
    if(c_state == IDLE) 
        n_early_stop = 0;
    else if(c_state == INPUT_A && inning == 3 && half/*n_out == 3*/ && score_B_ > score_A_)
        n_early_stop = 1;
    else  n_early_stop = early_stop;
end

//==============================================//
//                Output Block                  //
//==============================================//
// Decide when to set out_valid high, and output score_A, score_B, and result.

/*always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        out_valid <= 0;
    else if(n_state == OUTPUT)
        out_valid <= 1;
    else out_valid <= 0;
end*/

always@(*) begin
    if(c_state == OUTPUT)
        out_valid = 1;
    else out_valid = 0;
end

/*always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        score_A <= 0;
        score_B <= 0;
    end
    else begin
        if(n_state == OUTPUT) begin
            score_A <= score_A_;
            score_B <= score_B_;
        end
        else begin
            score_A <= 0;
            score_B <= 0;
        end
    end
end*/

always@(*) begin
    if(c_state == OUTPUT/*out_valid*/) begin
        score_A = score_A_;
        score_B = score_B_;
    end
    else begin
        score_A = 0;
        score_B = 0;
    end
end



/*always@(posedge clk or negedge rst_n) begin
    if(!rst_n) result <= 0;
    else begin
        if(score_A > score_B) result <= 0;
        else if(score_A < score_B) result <= 1;
        else result <= 2;
    end
end*/

always@(*) begin
    if(c_state == OUTPUT/*out_valid*/) begin
        if(score_A > score_B) result = 0;
        else if(score_A < score_B) result = 1;
        else result = 2;
    end
    else result = 0;
    
end

endmodule

module CALCULATION(
    //Input Ports
    input [2:0] action,
    input [2:0] base,
    input [1:0] out,   

    //Output Ports
    output reg [2:0] new_score, 
    output reg [2:0] new_base,
    output reg [2:0] new_out
);

parameter Walk        = 3'd0;
parameter Single      = 3'd1;
parameter Double      = 3'd2;
parameter Triple      = 3'd3;
parameter Home_run    = 3'd4;
parameter Bunt        = 3'd5;
parameter Ground_ball = 3'd6;
parameter Fly_ball    = 3'd7;


always@(*) begin //score
    case(action)
        Walk        : new_score = (base == 3'b111) ?  1 : 0;
                    //if(&(base)) new_score = 1;
                    //else new_score = 0;
        Single      : begin
                        if(out == 2) new_score = base[2] + base[1];
                        else //begin
                            if(base[2]) new_score = 1; //new_score = base[2];
                            else new_score = 0;
                        //end
                    end
        Double      : begin
                        if(out == 2) new_score = base[2] + base[1] + base[0];
                        else new_score = base[2] + base[1];
                    end
        Triple      : new_score = base[2] + base[1] + base[0];
        Home_run    : new_score = base[2] + base[1] + base[0] + 1; 
        Bunt        : new_score = (out == 2) ? 0 : base[2];
        Ground_ball : new_score = (out[1]/* == 2*/ || (out[0]/* == 1*/ && base[0])) ? 0 : base[2];
        Fly_ball    : new_score = (out == 2) ? 0 : base[2];
    endcase
end

always@(*) begin //base
    case(action)
        Walk        : 
                    /*if(base == 3'b000) new_base = 3'b001;
                    else if(base == 3'b001 || base == 3'b010) new_base = 3'b011;
                    else if(base == 3'b100) new_base = 3'b101;
                    else new_base = 3'b111;*/
                    case(base)
                        3'b000: new_base = 3'b001;
                        3'b001: new_base = 3'b011;
                        3'b010: new_base = 3'b011;
                        3'b100: new_base = 3'b101;
                        3'b011: new_base = 3'b111;
                        3'b101: new_base = 3'b111;
                        3'b110: new_base = 3'b111;
                        3'b111: new_base = 3'b111;
                    endcase
        Single      : begin
                        if(out[1]) new_base = {base[0],2'b01}; //<<2 + 1
                        else new_base = {base[1],base[0],1'b1}; //<<1 + 1
                    end
        Double      : begin
                        if(out == 2) new_base = 3'b010; //<<2 + 2
                        else new_base = {base[0],2'b10};
                    end
        Triple      : new_base = 3'b100;
        Home_run    : new_base = 3'b000; 
        Bunt        : new_base = {base[1],base[0],1'b0}; //<<1
        Ground_ball : new_base = {base[1],2'b00};
        Fly_ball    : new_base = {1'b0,base[1],base[0]};
    endcase
end

always@(*) begin //out
    case(action) 
        Bunt : new_out = out + 1;
        Ground_ball : new_out = out + base[0] + 1;/*if(base[0] && !out[1]) new_out = out + 2;
                      else new_out = out + 1;*/
        Fly_ball : new_out = out + 1;
        default : new_out = out;
    endcase
end

/*always@(*) begin //base[0]
    case(action)
        Walk        : new_base[0] = 1'b1;
        Single      : new_base[0] = 1'b1;
        Double      : new_base[0] = 1'b0;
        Triple      : new_base[0] = 1'b0;
        Home_run    : new_base[0] = 1'b0;
        Bunt        : new_base[0] = 1'b0;
        Ground_ball : new_base[0] = 1'b0;
        Fly_ball    : new_base[0] = base[0];
        default     : new_base[0] = base[0];
    endcase
end

always@(*) begin //base[1]
    case(action)
        Walk        : begin
                        if(base[1:0] == 2'b00) new_base[1] = 1'b0;
                        else new_base[1] = 1'b1;
                    end
        Single      : begin
                        if(out == 2) new_base[1] = 1'b0;
                        else new_base[1] = base[0];
                    end
        Double      : new_base[1] = 1'b1;
        Triple      : new_base[1] = 1'b0;
        Home_run    : new_base[1] = 1'b0;
        Bunt        : new_base[1] = base[0];
        Ground_ball : new_base[1] = 1'b0;
        Fly_ball    : new_base[1] = base[1];
        default     : new_base[1] = base[1];
    endcase
end

always@(*) begin //base[2]
    case(action)
        Walk        : begin
                        case(base)
                            3'b000,3'b001,3'b010 : new_base[2] = 1'b0;
                            default : new_base[2] = 1'b1;
                        endcase
                    end
        Single      : begin
                        if(out == 2) new_base[2] = base[0];
                        else new_base[2] = base[1];
                    end
        Double      : begin
                        if(out == 2) new_base[2] = 1'b0;
                        else new_base[2] = base[0];
                    end
        Triple      : new_base[2] = 1'b1;
        Home_run    : new_base[2] = 1'b0;
        Bunt        : new_base[2] = base[1];
        Ground_ball : new_base[2] = base[1];
        Fly_ball    : new_base[2] = 1'b0;
        default     : new_base[2] = base[2];
    endcase
end*/
endmodule
