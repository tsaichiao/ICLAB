module TMIP(
    // input signals
    clk,
    rst_n,
    in_valid, 
    in_valid2,
    
    image,
    template,
    image_size,
	action,
	
    // output signals
    out_valid,
    out_value
    );

input            clk, rst_n;
input            in_valid, in_valid2;

input      [7:0] image;
input      [7:0] template;
input      [1:0] image_size;
input      [2:0] action;

output reg       out_valid;
output reg       out_value;

//==================================================================
// parameter & integer
//==================================================================
parameter   IDLE           = 0,
            READ_IMG       = 1,
            WRITE_ACTION0  = 2,
            WRITE_ACTION1  = 3,
            WRITE_ACTION2  = 4,
            READ_ACTION    = 5,
            WAIT           = 6,
            MAXP           = 7,
            MINP           = 8,
            IF             = 9,
            CROSS          = 10,
            OUTPUT         = 11;


//==================================================================
// reg & wire
//==================================================================
// state reg
reg [3:0] c_state, n_state;

reg [2:0] cnt, n_cnt;
reg [3:0] cnt_temp, n_cnt_temp;
reg [7:0] act_cnt;
reg [4:0] cnt_20;
reg [8:0] out_num;
reg [19:0] out_ans;
reg [19:0] temp_ans;
reg out;

reg [7:0] temp_reg[0:8], n_temp_reg[0:8];

reg [1:0] image_size_reg, ori_imgsize_reg;
reg [7:0] red, green, blue;
reg [7:0] /*action0_8b,*/ action1_8b, action2_8b;
reg [7:0] action0_8b_, action1_8b_, action2_8b_;
reg [7:0] action0_16b, action1_16b, action2_16b;

reg [15:0] data_in, data_out_img, data_out1_img, data_out;
reg [8:0] addr_img, addr1_img;
reg web_img, web1_img;
reg [8:0] addr_img_2, addr_img_1, n_addr;
reg [7:0] addr_img_0;

reg [8:0] addr_write;
reg [8:0] addr_read;

reg [2:0] action_s [0:7];
reg [3:0] input_act_cnt, do_act_cnt;

reg neg_flag, flip_flag;
reg mem1to0_flag, finish;
reg move;

reg [7:0] reg16x3[0:2][0:15];

reg [7:0] max_op0, max_op1, max_op2, max_op3, max_out, max_out_s, min_out, min_out_s;
reg [7:0] if_op0, if_op1, if_op2, if_op3, 
        if_op4, if_op5, if_op6, if_op7, 
        if_op8, if_op9, if_op10, if_op11,
        if_out0, if_out1;

reg [7:0] mul0_op1, mul0_op2;
reg [15:0] mul0_out;
reg [19:0] add0_op1, add0_op2,add0_out;

//==============================================//
//             Current State Block              //
//==============================================//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) c_state <= IDLE;
    else c_state <= n_state;
end

//==============================================//
//              Next State Block                //
//==============================================//
always @(*) begin
    case (c_state)
        IDLE: begin
            if (in_valid) n_state = READ_IMG;
            else if (in_valid2) n_state = READ_ACTION;
            else n_state = IDLE;
        end

        // 1. read image when in_valid is high
        READ_IMG: begin
            if (in_valid2) n_state = READ_ACTION;
            else if (cnt == 5) n_state = WRITE_ACTION0;
            else n_state = READ_IMG;
        end
        WRITE_ACTION0: begin
            n_state = WRITE_ACTION1;
        end
        WRITE_ACTION1: begin
            n_state = WRITE_ACTION2;
        end
        WRITE_ACTION2: begin
            if(in_valid2) n_state = READ_ACTION;
            else n_state = READ_IMG;
        end
        READ_ACTION: begin
			if (!in_valid2) n_state = WAIT;
			else n_state = c_state;
		end
		WAIT: begin
			case(action_s[do_act_cnt])//1
				//0: n_state = WRITE_ACTION0;
				//1: n_state = WRITE_ACTION1;
				//2: n_state = WRITE_ACTION2;
				3: n_state = MAXP;
				4: n_state = MINP;
				//5: n_state = HF;
				6: n_state = IF;
				7: n_state = CROSS;
                default: n_state = WAIT;
			endcase
		end
        MAXP:begin
            case(action_s[do_act_cnt])
				3: n_state = MAXP;
				4: n_state = MINP;
				6: n_state = IF;
				7: n_state = CROSS;
                default: n_state = MAXP;
			endcase
        end
        MINP:begin
            case(action_s[do_act_cnt])
				3: n_state = MAXP;
				4: n_state = MINP;
				6: n_state = IF;
				7: n_state = CROSS;
                default: n_state = MINP;
			endcase
        end
        IF:begin
            case(action_s[do_act_cnt])
				3: n_state = MAXP;
				4: n_state = MINP;
				6: n_state = IF;
				7: n_state = CROSS;
                default: n_state = IF;
			endcase
        end
        CROSS:begin
            if(finish && act_cnt > 0) n_state = IDLE;   
            else n_state = CROSS;
        end
        default: n_state = IDLE;
    endcase
end

//==================================================================
// design
//==================================================================

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 0;
    end
    else begin
        cnt <= n_cnt;
    end
end

always @(*) begin
    if(in_valid && cnt < 5)begin
        n_cnt = cnt + 1;
    end

    else begin
        n_cnt = 0;
    end
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cnt_temp <= 0;
    end
    else begin
        cnt_temp <= n_cnt_temp;
    end
end

always @(*) begin
    if(in_valid && cnt_temp < 9)begin
        n_cnt_temp = cnt_temp + 1;
    end
    else if(n_state == CROSS)begin
        n_cnt_temp = 0;
    end
    else begin
        n_cnt_temp = cnt_temp;
    end
end

always@(posedge clk) begin
    temp_reg <= n_temp_reg;
end

always @(*) begin
    if(in_valid && cnt_temp < 9)begin
        n_temp_reg[0] = temp_reg[1];
        n_temp_reg[1] = temp_reg[2];
        n_temp_reg[2] = temp_reg[3];
        n_temp_reg[3] = temp_reg[4];
        n_temp_reg[4] = temp_reg[5];
        n_temp_reg[5] = temp_reg[6];
        n_temp_reg[6] = temp_reg[7];
        n_temp_reg[7] = temp_reg[8];
        n_temp_reg[8] = template;
    end
    else begin
        n_temp_reg = temp_reg;
    end
end
//==============================================//
//              Image SRAM Control              //
//==============================================//

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        red <= 0;
    end
    else if(in_valid && (cnt == 0 || cnt == 3)) begin
        red <= image;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        green <= 0;
    end
    else if(in_valid && (cnt == 1 || cnt == 4)) begin
        green <= image;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        blue <= 0;
    end
    else if(in_valid && (cnt == 2 || cnt == 5)) begin
        blue <= image;
    end
end

always @(*) begin
    if(red >= green && red >= blue) action0_8b_ = red;
    else if(green >= red && green >= blue) action0_8b_ = green;
    else action0_8b_ = blue;
    action1_8b_ = (red + green + blue)/3;
    action2_8b_ = (red>>2) + (green>>1) + (blue>>2);
end

always @(posedge clk) begin
    if(cnt == 0) begin
        //action0_8b <= action0_8b_;
        action1_8b <= action1_8b_;
        action2_8b <= action2_8b_;
    end
end

always @(posedge clk) begin
    if(cnt == 3) begin
        action0_16b <= action0_8b_;
        action1_16b <= action1_8b_;
        action2_16b <= action2_8b_;
    end
end

MEM_16b_512 m0(.A0(addr_img[0]), .A1(addr_img[1]), .A2(addr_img[2]), .A3(addr_img[3]), .A4(addr_img[4]), .A5(addr_img[5]), .A6(addr_img[6]), .A7(addr_img[7]), .A8(addr_img[8]), 
.DO0(data_out_img[0]), .DO1(data_out_img[1]), .DO2(data_out_img[2]), .DO3(data_out_img[3]), .DO4(data_out_img[4]), .DO5(data_out_img[5]), .DO6(data_out_img[6]), .DO7(data_out_img[7]),
.DO8(data_out_img[8]), .DO9(data_out_img[9]), .DO10(data_out_img[10]), .DO11(data_out_img[11]), .DO12(data_out_img[12]), .DO13(data_out_img[13]), .DO14(data_out_img[14]), .DO15(data_out_img[15]), 
.DI0(data_in[0]), .DI1(data_in[1]), .DI2(data_in[2]), .DI3(data_in[3]), .DI4(data_in[4]), .DI5(data_in[5]), .DI6(data_in[6]), .DI7(data_in[7]),
.DI8(data_in[8]), .DI9(data_in[9]), .DI10(data_in[10]), .DI11(data_in[11]), .DI12(data_in[12]), .DI13(data_in[13]), .DI14(data_in[14]), .DI15(data_in[15]), .CK(clk), .WEB(web_img), .OE(1'b1), .CS(1'b1));

MEM_16b_128 m1(.A0(addr1_img[0]), .A1(addr1_img[1]), .A2(addr1_img[2]), .A3(addr1_img[3]), .A4(addr1_img[4]), .A5(addr1_img[5]), .A6(addr1_img[6]),/* .A7(addr1_img[7]), .A8(addr1_img[8]), */
.DO0(data_out1_img[0]), .DO1(data_out1_img[1]), .DO2(data_out1_img[2]), .DO3(data_out1_img[3]), .DO4(data_out1_img[4]), .DO5(data_out1_img[5]), .DO6(data_out1_img[6]), .DO7(data_out1_img[7]),
.DO8(data_out1_img[8]), .DO9(data_out1_img[9]), .DO10(data_out1_img[10]), .DO11(data_out1_img[11]), .DO12(data_out1_img[12]), .DO13(data_out1_img[13]), .DO14(data_out1_img[14]), .DO15(data_out1_img[15]), 
.DI0(data_in[0]), .DI1(data_in[1]), .DI2(data_in[2]), .DI3(data_in[3]), .DI4(data_in[4]), .DI5(data_in[5]), .DI6(data_in[6]), .DI7(data_in[7]),
.DI8(data_in[8]), .DI9(data_in[9]), .DI10(data_in[10]), .DI11(data_in[11]), .DI12(data_in[12]), .DI13(data_in[13]), .DI14(data_in[14]), .DI15(data_in[15]), .CK(clk), .WEB(web1_img), .OE(1'b1), .CS(1'b1));

// write enable of image SRAM
always @(*) begin
    if (c_state == WRITE_ACTION0 || c_state == WRITE_ACTION1 || c_state == WRITE_ACTION2) begin
        web_img = 0; // enable write image
        web1_img = 1;
    end 
    else if(c_state == MAXP || c_state == MINP || c_state == IF) begin
        if(finish) begin
            web_img = 1;
            web1_img = 1;
        end
        else if(mem1to0_flag) begin
            web_img = 0; // enable write image
            web1_img = 1;
        end
        else begin
            web_img = 1; // enable write image
            web1_img = 0;
        end
    end
    else begin
        web_img = 1; // disable write image
        web1_img = 1;
    end
end

// data_in of image SRAM and kernel SRAM
always @(*) begin
    if(c_state == WRITE_ACTION0) begin
        data_in = {action0_16b,action0_8b_};
    end
    else if(c_state == WRITE_ACTION1)begin
        data_in = {action1_16b,action1_8b};
    end
    else if(c_state == WRITE_ACTION2)begin
        data_in = {action2_16b,action2_8b};
    end
    //
    else if(c_state == MAXP) begin
        data_in = {max_out_s,max_out};
    end
    else if(c_state == MINP)begin
        data_in = {min_out_s,min_out};
    end
    else if(c_state == IF)begin
        data_in = {if_out0,if_out1};//
    end
    else data_in = 0;
end


// address of image SRAM
always @(*) begin
    if(c_state == WRITE_ACTION0) begin
        addr_img = addr_img_0;
    end 
    else if(c_state == WRITE_ACTION1) begin
        addr_img = addr_img_1;
    end 
    else if(c_state == WRITE_ACTION2) begin
        addr_img = addr_img_2;
    end
    //
    else if(c_state == MAXP || c_state == MINP) begin
        addr_img = (mem1to0_flag) ? addr_write : addr_read;
    end 
    else if(c_state == IF) begin
        addr_img = (mem1to0_flag) ? addr_write : addr_read;
    end 
    else if(c_state == CROSS) begin
        addr_img = (mem1to0_flag) ? addr_write : addr_read;
    end
    else addr_img = addr_read;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) addr_img_0 <= 0;
    else if(n_state == IDLE) addr_img_0 <= 127;
    else if(n_state == WRITE_ACTION0) begin
        addr_img_0 <= addr_img_0 + 1;
    end
end

always @(*) begin
    addr_img_1 = addr_img_0 + 128;
    addr_img_2 = addr_img_0 + 256;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) n_addr <= 0;
    else if(n_state == WAIT || move == 0) begin
        if(action_s[0] == 0) n_addr <= 128;
        else if(action_s[0] == 1) n_addr <= 256;
        else n_addr <= 384;
    end
    else n_addr <= 0;
end

//sram2
always @(*) begin
    if(c_state == MAXP || c_state == MINP) begin
        addr1_img = (mem1to0_flag) ? addr_read : addr_write;
    end 
    else if(c_state == IF) begin
        addr1_img = (mem1to0_flag) ? addr_read : addr_write;
    end 
    else addr1_img = addr_read;
end




//==============================================//
//                 Input action                 //
//==============================================//

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        input_act_cnt <= 0;
        neg_flag <= 0;
        flip_flag <= 0;
    end
    else begin
        if (n_state == READ_ACTION) begin
            if(action == 4) begin //NEG
                if(neg_flag == 0) neg_flag <= 1;
                else neg_flag <= 0;
            end
            else if(action == 5) begin //HF
                if(flip_flag == 0) flip_flag <= 1;
                else flip_flag <= 0;
            end
            else if(action == 3) begin
                if(neg_flag == 1) begin
                    action_s[input_act_cnt] <= 4; //MINP
                    input_act_cnt <= input_act_cnt + 1;
                end
                else begin
                    action_s[input_act_cnt] <= 3; //MAXP
                    input_act_cnt <= input_act_cnt + 1;
                end
            end
            else begin
                action_s[input_act_cnt] <= action;
                input_act_cnt <= input_act_cnt + 1;
            end
        end
        else if (n_state == IDLE) begin
			input_act_cnt <= 0;
            neg_flag <= 0;
            flip_flag <= 0;
        end
    end
end

//==============================================//
//                  MAXPOOLING                  //
//==============================================//
maxpooling max0(.op0(max_op0),.op1(max_op1),.op2(max_op2),.op3(max_op3),.out(max_out));
minpooling min0(.op0(max_op0),.op1(max_op1),.op2(max_op2),.op3(max_op3),.out(min_out));

always @(posedge clk) begin
    if(c_state == MAXP || c_state == MINP) begin
        max_op0 <= max_op2;
        max_op1 <= max_op3;
        max_op2 <= data_out[15:8];
        max_op3 <= data_out[7:0];
    end
end

always @(posedge clk) begin
    if(c_state == MAXP) begin
        if(act_cnt%4 == 0) begin
            max_out_s <= max_out;
        end
    end
    else if(c_state == MINP) begin
        if(act_cnt%4 == 0) begin
            min_out_s <= min_out;
        end
    end
end

//==============================================//
//                 IMAGE FILTER                 //
//==============================================//
imagefilter if0(.op0(if_op0), .op1(if_op1), .op2(if_op2), .op3(if_op3), 
                .op4(if_op4), .op5(if_op5), .op6(if_op6), .op7(if_op7), 
                .op8(if_op8), .op9(if_op9), .op10(if_op10), .op11(if_op11),
                .out0(if_out0), .out1(if_out1));

assign data_out = (mem1to0_flag) ? data_out1_img : data_out_img;

always@(*)begin
    if_op0 = 0; if_op1 = 0; if_op2 = 0; 
    if_op3 = 0; if_op4 = 0; if_op5 = 0; 
    if_op6 = 0; if_op7 = 0; if_op8 = 0; 
    if_op9 = 0; if_op10 = 0; if_op11 = 0;
    case(image_size_reg)
        0:begin
            if(act_cnt == 6) begin
                if_op0 = reg16x3[0][0]; if_op1 = reg16x3[0][0]; if_op2 = reg16x3[1][0]; 
                if_op3 = reg16x3[0][0]; if_op4 = reg16x3[0][0]; if_op5 = reg16x3[1][0]; 
                if_op6 = reg16x3[0][1]; if_op7 = reg16x3[0][1]; if_op8 = reg16x3[1][1]; 
                if_op9 = reg16x3[0][2]; if_op10 = reg16x3[0][2]; if_op11 = reg16x3[1][2]; 
            end
            else if(act_cnt == 7) begin
                if_op0 = reg16x3[0][1]; if_op1 = reg16x3[0][1]; if_op2 = reg16x3[1][1]; 
                if_op3 = reg16x3[0][2]; if_op4 = reg16x3[0][2]; if_op5 = reg16x3[1][2]; 
                if_op6 = reg16x3[0][3]; if_op7 = reg16x3[0][3]; if_op8 = reg16x3[1][3]; 
                if_op9 = reg16x3[0][3]; if_op10 = reg16x3[0][3]; if_op11 = reg16x3[1][3]; 
            end
            else if(act_cnt == 8) begin
                if_op0 = reg16x3[0][0]; if_op1 = reg16x3[1][0]; if_op2 = reg16x3[2][0]; 
                if_op3 = reg16x3[0][0]; if_op4 = reg16x3[1][0]; if_op5 = reg16x3[2][0]; 
                if_op6 = reg16x3[0][1]; if_op7 = reg16x3[1][1]; if_op8 = reg16x3[2][1]; 
                if_op9 = reg16x3[0][2]; if_op10 = reg16x3[1][2]; if_op11 = reg16x3[2][2]; 
            end
            else if(act_cnt == 9) begin
                if_op0 = reg16x3[0][1]; if_op1 = reg16x3[1][1]; if_op2 = reg16x3[2][1]; 
                if_op3 = reg16x3[0][2]; if_op4 = reg16x3[1][2]; if_op5 = reg16x3[2][2]; 
                if_op6 = reg16x3[0][3]; if_op7 = reg16x3[1][3]; if_op8 = reg16x3[2][3]; 
                if_op9 = reg16x3[0][3]; if_op10 = reg16x3[1][3]; if_op11 = reg16x3[2][3]; 
            end
            else if(act_cnt == 10) begin
                if_op0 = reg16x3[1][0]; if_op1 = reg16x3[2][0]; if_op2 = reg16x3[0][4]; 
                if_op3 = reg16x3[1][0]; if_op4 = reg16x3[2][0]; if_op5 = reg16x3[0][4]; 
                if_op6 = reg16x3[1][1]; if_op7 = reg16x3[2][1]; if_op8 = reg16x3[0][5]; 
                if_op9 = reg16x3[1][2]; if_op10 = reg16x3[2][2]; if_op11 = reg16x3[0][6]; 
            end
            else if(act_cnt == 11) begin
                if_op0 = reg16x3[1][1]; if_op1 = reg16x3[2][1]; if_op2 = reg16x3[0][5]; 
                if_op3 = reg16x3[1][2]; if_op4 = reg16x3[2][2]; if_op5 = reg16x3[0][6]; 
                if_op6 = reg16x3[1][3]; if_op7 = reg16x3[2][3]; if_op8 = reg16x3[0][7]; 
                if_op9 = reg16x3[1][3]; if_op10 = reg16x3[2][3]; if_op11 = reg16x3[0][7]; 
            end
            else if(act_cnt == 12) begin
                if_op0 = reg16x3[2][0]; if_op1 = reg16x3[0][4]; if_op2 = reg16x3[0][4]; 
                if_op3 = reg16x3[2][0]; if_op4 = reg16x3[0][4]; if_op5 = reg16x3[0][4]; 
                if_op6 = reg16x3[2][1]; if_op7 = reg16x3[0][5]; if_op8 = reg16x3[0][5]; 
                if_op9 = reg16x3[2][2]; if_op10 = reg16x3[0][6]; if_op11 = reg16x3[0][6]; 
            end
            else if(act_cnt == 13) begin
                if_op0 = reg16x3[2][1]; if_op1 = reg16x3[0][5]; if_op2 = reg16x3[0][5]; 
                if_op3 = reg16x3[2][2]; if_op4 = reg16x3[0][6]; if_op5 = reg16x3[0][6]; 
                if_op6 = reg16x3[2][3]; if_op7 = reg16x3[0][7]; if_op8 = reg16x3[0][7]; 
                if_op9 = reg16x3[2][3]; if_op10 = reg16x3[0][7]; if_op11 = reg16x3[0][7]; 
            end
        end
        1: begin
            if(act_cnt == 8) begin
                if_op0 = reg16x3[1][0]; if_op1 = reg16x3[1][0]; if_op2 = reg16x3[2][0]; 
                if_op3 = reg16x3[1][0]; if_op4 = reg16x3[1][0]; if_op5 = reg16x3[2][0]; 
                if_op6 = reg16x3[1][1]; if_op7 = reg16x3[1][1]; if_op8 = reg16x3[2][1]; 
                if_op9 = reg16x3[1][2]; if_op10 = reg16x3[1][2]; if_op11 = reg16x3[2][2]; 
            end
            else if(act_cnt == 9) begin
                if_op0 = reg16x3[1][1]; if_op1 = reg16x3[1][1]; if_op2 = reg16x3[2][1]; 
                if_op3 = reg16x3[1][2]; if_op4 = reg16x3[1][2]; if_op5 = reg16x3[2][2]; 
                if_op6 = reg16x3[1][3]; if_op7 = reg16x3[1][3]; if_op8 = reg16x3[2][3]; 
                if_op9 = reg16x3[1][4]; if_op10 = reg16x3[1][4]; if_op11 = reg16x3[2][4];
            end
            else if(act_cnt == 10) begin
                if_op0 = reg16x3[1][3]; if_op1 = reg16x3[1][3]; if_op2 = reg16x3[2][3]; 
                if_op3 = reg16x3[1][4]; if_op4 = reg16x3[1][4]; if_op5 = reg16x3[2][4];
                if_op6 = reg16x3[1][5]; if_op7 = reg16x3[1][5]; if_op8 = reg16x3[2][5]; 
                if_op9 = reg16x3[1][6]; if_op10 = reg16x3[1][6]; if_op11 = reg16x3[2][6];
            end
            else if(act_cnt == 11) begin
                if_op0 = reg16x3[1][5]; if_op1 = reg16x3[1][5]; if_op2 = reg16x3[2][5]; 
                if_op3 = reg16x3[1][6]; if_op4 = reg16x3[1][6]; if_op5 = reg16x3[2][6];
                if_op6 = reg16x3[1][7]; if_op7 = reg16x3[1][7]; if_op8 = reg16x3[2][7]; 
                if_op9 = reg16x3[1][7]; if_op10 = reg16x3[1][7]; if_op11 = reg16x3[2][7];
            end
            // last row
            else if(act_cnt == 36) begin
                if_op0 = reg16x3[1][0]; if_op1 = reg16x3[2][0]; if_op2 = reg16x3[2][0]; 
                if_op3 = reg16x3[1][0]; if_op4 = reg16x3[2][0]; if_op5 = reg16x3[2][0]; 
                if_op6 = reg16x3[1][1]; if_op7 = reg16x3[2][1]; if_op8 = reg16x3[2][1]; 
                if_op9 = reg16x3[1][2]; if_op10 = reg16x3[2][2]; if_op11 = reg16x3[2][2]; 
            end
            else if(act_cnt == 37) begin
                if_op0 = reg16x3[1][1]; if_op1 = reg16x3[2][1]; if_op2 = reg16x3[2][1]; 
                if_op3 = reg16x3[1][2]; if_op4 = reg16x3[2][2]; if_op5 = reg16x3[2][2]; 
                if_op6 = reg16x3[1][3]; if_op7 = reg16x3[2][3]; if_op8 = reg16x3[2][3]; 
                if_op9 = reg16x3[1][4]; if_op10 = reg16x3[2][4]; if_op11 = reg16x3[2][4]; 
            end
            else if(act_cnt == 38) begin
                if_op0 = reg16x3[1][3]; if_op1 = reg16x3[2][3]; if_op2 = reg16x3[2][3]; 
                if_op3 = reg16x3[1][4]; if_op4 = reg16x3[2][4]; if_op5 = reg16x3[2][4];
                if_op6 = reg16x3[1][5]; if_op7 = reg16x3[2][5]; if_op8 = reg16x3[2][5]; 
                if_op9 = reg16x3[1][6]; if_op10 = reg16x3[2][6]; if_op11 = reg16x3[2][6];
            end
            else if(act_cnt == 39) begin
                if_op0 = reg16x3[1][5]; if_op1 = reg16x3[2][5]; if_op2 = reg16x3[2][5]; 
                if_op3 = reg16x3[1][6]; if_op4 = reg16x3[2][6]; if_op5 = reg16x3[2][6];
                if_op6 = reg16x3[1][7]; if_op7 = reg16x3[2][7]; if_op8 = reg16x3[2][7]; 
                if_op9 = reg16x3[1][7]; if_op10 = reg16x3[2][7]; if_op11 = reg16x3[2][7];
            end
            // middle
            else if(act_cnt[1:0] == 2'b00/*act_cnt == 12 || act_cnt == 16 || act_cnt == 20 || act_cnt == 24 || act_cnt == 28 || act_cnt == 32*/) begin
                if_op0 = reg16x3[0][0]; if_op1 = reg16x3[1][0]; if_op2 = reg16x3[2][0]; 
                if_op3 = reg16x3[0][0]; if_op4 = reg16x3[1][0]; if_op5 = reg16x3[2][0]; 
                if_op6 = reg16x3[0][1]; if_op7 = reg16x3[1][1]; if_op8 = reg16x3[2][1]; 
                if_op9 = reg16x3[0][2]; if_op10 = reg16x3[1][2]; if_op11 = reg16x3[2][2]; 
            end
            else if(act_cnt[1:0] == 2'b01/*act_cnt == 13 || act_cnt == 17 || act_cnt == 21 || act_cnt == 25 || act_cnt == 29 || act_cnt == 33*/) begin
                if_op0 = reg16x3[0][1]; if_op1 = reg16x3[1][1]; if_op2 = reg16x3[2][1]; 
                if_op3 = reg16x3[0][2]; if_op4 = reg16x3[1][2]; if_op5 = reg16x3[2][2]; 
                if_op6 = reg16x3[0][3]; if_op7 = reg16x3[1][3]; if_op8 = reg16x3[2][3]; 
                if_op9 = reg16x3[0][4]; if_op10 = reg16x3[1][4]; if_op11 = reg16x3[2][4];
            end
            else if(act_cnt[1:0] == 2'b10/*act_cnt == 14 || act_cnt == 18 || act_cnt == 22 || act_cnt == 26 || act_cnt == 30 || act_cnt == 34*/) begin
                if_op0 = reg16x3[0][3]; if_op1 = reg16x3[1][3]; if_op2 = reg16x3[2][3]; 
                if_op3 = reg16x3[0][4]; if_op4 = reg16x3[1][4]; if_op5 = reg16x3[2][4];
                if_op6 = reg16x3[0][5]; if_op7 = reg16x3[1][5]; if_op8 = reg16x3[2][5]; 
                if_op9 = reg16x3[0][6]; if_op10 = reg16x3[1][6]; if_op11 = reg16x3[2][6];
            end
            else if(act_cnt[1:0] == 2'b11/*act_cnt == 15 || act_cnt == 19 || act_cnt == 23 || act_cnt == 27 || act_cnt == 31 || act_cnt == 35*/) begin
                if_op0 = reg16x3[0][5]; if_op1 = reg16x3[1][5]; if_op2 = reg16x3[2][5]; 
                if_op3 = reg16x3[0][6]; if_op4 = reg16x3[1][6]; if_op5 = reg16x3[2][6];
                if_op6 = reg16x3[0][7]; if_op7 = reg16x3[1][7]; if_op8 = reg16x3[2][7]; 
                if_op9 = reg16x3[0][7]; if_op10 = reg16x3[1][7]; if_op11 = reg16x3[2][7];
            end
            
        end
        2: begin
            if(act_cnt == 12) begin
                if_op0 = reg16x3[1][0]; if_op1 = reg16x3[1][0]; if_op2 = reg16x3[2][0]; 
                if_op3 = reg16x3[1][0]; if_op4 = reg16x3[1][0]; if_op5 = reg16x3[2][0]; 
                if_op6 = reg16x3[1][1]; if_op7 = reg16x3[1][1]; if_op8 = reg16x3[2][1]; 
                if_op9 = reg16x3[1][2]; if_op10 = reg16x3[1][2]; if_op11 = reg16x3[2][2]; 
            end
            else if(act_cnt == 13) begin
                if_op0 = reg16x3[1][1]; if_op1 = reg16x3[1][1]; if_op2 = reg16x3[2][1]; 
                if_op3 = reg16x3[1][2]; if_op4 = reg16x3[1][2]; if_op5 = reg16x3[2][2]; 
                if_op6 = reg16x3[1][3]; if_op7 = reg16x3[1][3]; if_op8 = reg16x3[2][3]; 
                if_op9 = reg16x3[1][4]; if_op10 = reg16x3[1][4]; if_op11 = reg16x3[2][4]; 
            end
            else if(act_cnt == 14) begin
                if_op0 = reg16x3[1][3]; if_op1 = reg16x3[1][3]; if_op2 = reg16x3[2][3]; 
                if_op3 = reg16x3[1][4]; if_op4 = reg16x3[1][4]; if_op5 = reg16x3[2][4]; 
                if_op6 = reg16x3[1][5]; if_op7 = reg16x3[1][5]; if_op8 = reg16x3[2][5]; 
                if_op9 = reg16x3[1][6]; if_op10 = reg16x3[1][6]; if_op11 = reg16x3[2][6]; 
            end
            else if(act_cnt == 15) begin
                if_op0 = reg16x3[1][5]; if_op1 = reg16x3[1][5]; if_op2 = reg16x3[2][5]; 
                if_op3 = reg16x3[1][6]; if_op4 = reg16x3[1][6]; if_op5 = reg16x3[2][6]; 
                if_op6 = reg16x3[1][7]; if_op7 = reg16x3[1][7]; if_op8 = reg16x3[2][7]; 
                if_op9 = reg16x3[1][8]; if_op10 = reg16x3[1][8]; if_op11 = reg16x3[2][8]; 
            end
            else if(act_cnt == 16) begin
                if_op0 = reg16x3[1][7]; if_op1 = reg16x3[1][7]; if_op2 = reg16x3[2][7]; 
                if_op3 = reg16x3[1][8]; if_op4 = reg16x3[1][8]; if_op5 = reg16x3[2][8]; 
                if_op6 = reg16x3[1][9]; if_op7 = reg16x3[1][9]; if_op8 = reg16x3[2][9]; 
                if_op9 = reg16x3[1][10]; if_op10 = reg16x3[1][10]; if_op11 = reg16x3[2][10]; 
            end
            else if(act_cnt == 17) begin
                if_op0 = reg16x3[1][9]; if_op1 = reg16x3[1][9]; if_op2 = reg16x3[2][9]; 
                if_op3 = reg16x3[1][10]; if_op4 = reg16x3[1][10]; if_op5 = reg16x3[2][10]; 
                if_op6 = reg16x3[1][11]; if_op7 = reg16x3[1][11]; if_op8 = reg16x3[2][11]; 
                if_op9 = reg16x3[1][12]; if_op10 = reg16x3[1][12]; if_op11 = reg16x3[2][12]; 
            end
            else if(act_cnt == 18) begin
                if_op0 = reg16x3[1][11]; if_op1 = reg16x3[1][11]; if_op2 = reg16x3[2][11]; 
                if_op3 = reg16x3[1][12]; if_op4 = reg16x3[1][12]; if_op5 = reg16x3[2][12]; 
                if_op6 = reg16x3[1][13]; if_op7 = reg16x3[1][13]; if_op8 = reg16x3[2][13]; 
                if_op9 = reg16x3[1][14]; if_op10 = reg16x3[1][14]; if_op11 = reg16x3[2][14]; 
            end
            else if(act_cnt == 19) begin
                if_op0 = reg16x3[1][13]; if_op1 = reg16x3[1][13]; if_op2 = reg16x3[2][13]; 
                if_op3 = reg16x3[1][14]; if_op4 = reg16x3[1][14]; if_op5 = reg16x3[2][14]; 
                if_op6 = reg16x3[1][15]; if_op7 = reg16x3[1][15]; if_op8 = reg16x3[2][15]; 
                if_op9 = reg16x3[1][15]; if_op10 = reg16x3[1][15]; if_op11 = reg16x3[2][15]; 
            end
            // last row
            else if(act_cnt == 132) begin
                if_op0 = reg16x3[1][0]; if_op1 = reg16x3[2][0]; if_op2 = reg16x3[2][0]; 
                if_op3 = reg16x3[1][0]; if_op4 = reg16x3[2][0]; if_op5 = reg16x3[2][0]; 
                if_op6 = reg16x3[1][1]; if_op7 = reg16x3[2][1]; if_op8 = reg16x3[2][1]; 
                if_op9 = reg16x3[1][2]; if_op10 = reg16x3[2][2]; if_op11 = reg16x3[2][2]; 
            end
            else if(act_cnt == 133) begin
                if_op0 = reg16x3[1][1]; if_op1 = reg16x3[2][1]; if_op2 = reg16x3[2][1]; 
                if_op3 = reg16x3[1][2]; if_op4 = reg16x3[2][2]; if_op5 = reg16x3[2][2]; 
                if_op6 = reg16x3[1][3]; if_op7 = reg16x3[2][3]; if_op8 = reg16x3[2][3]; 
                if_op9 = reg16x3[1][4]; if_op10 = reg16x3[2][4]; if_op11 = reg16x3[2][4]; 
            end
            else if(act_cnt == 134) begin
                if_op0 = reg16x3[1][3]; if_op1 = reg16x3[2][3]; if_op2 = reg16x3[2][3]; 
                if_op3 = reg16x3[1][4]; if_op4 = reg16x3[2][4]; if_op5 = reg16x3[2][4]; 
                if_op6 = reg16x3[1][5]; if_op7 = reg16x3[2][5]; if_op8 = reg16x3[2][5]; 
                if_op9 = reg16x3[1][6]; if_op10 = reg16x3[2][6]; if_op11 = reg16x3[2][6]; 
            end
            else if(act_cnt == 135) begin
                if_op0 = reg16x3[1][5]; if_op1 = reg16x3[2][5]; if_op2 = reg16x3[2][5]; 
                if_op3 = reg16x3[1][6]; if_op4 = reg16x3[2][6]; if_op5 = reg16x3[2][6]; 
                if_op6 = reg16x3[1][7]; if_op7 = reg16x3[2][7]; if_op8 = reg16x3[2][7]; 
                if_op9 = reg16x3[1][8]; if_op10 = reg16x3[2][8]; if_op11 = reg16x3[2][8]; 
            end
            else if(act_cnt == 136) begin
                if_op0 = reg16x3[1][7]; if_op1 = reg16x3[2][7]; if_op2 = reg16x3[2][7]; 
                if_op3 = reg16x3[1][8]; if_op4 = reg16x3[2][8]; if_op5 = reg16x3[2][8]; 
                if_op6 = reg16x3[1][9]; if_op7 = reg16x3[2][9]; if_op8 = reg16x3[2][9]; 
                if_op9 = reg16x3[1][10]; if_op10 = reg16x3[2][10]; if_op11 = reg16x3[2][10]; 
            end
            else if(act_cnt == 137) begin
                if_op0 = reg16x3[1][9]; if_op1 = reg16x3[2][9]; if_op2 = reg16x3[2][9]; 
                if_op3 = reg16x3[1][10]; if_op4 = reg16x3[2][10]; if_op5 = reg16x3[2][10]; 
                if_op6 = reg16x3[1][11]; if_op7 = reg16x3[2][11]; if_op8 = reg16x3[2][11]; 
                if_op9 = reg16x3[1][12]; if_op10 = reg16x3[2][12]; if_op11 = reg16x3[2][12]; 
            end
            else if(act_cnt == 138) begin
                if_op0 = reg16x3[1][11]; if_op1 = reg16x3[2][11]; if_op2 = reg16x3[2][11]; 
                if_op3 = reg16x3[1][12]; if_op4 = reg16x3[2][12]; if_op5 = reg16x3[2][12]; 
                if_op6 = reg16x3[1][13]; if_op7 = reg16x3[2][13]; if_op8 = reg16x3[2][13]; 
                if_op9 = reg16x3[1][14]; if_op10 = reg16x3[2][14]; if_op11 = reg16x3[2][14]; 
            end
            else if(act_cnt == 139) begin
                if_op0 = reg16x3[1][13]; if_op1 = reg16x3[2][13]; if_op2 = reg16x3[2][13]; 
                if_op3 = reg16x3[1][14]; if_op4 = reg16x3[2][14]; if_op5 = reg16x3[2][14]; 
                if_op6 = reg16x3[1][15]; if_op7 = reg16x3[2][15]; if_op8 = reg16x3[2][15]; 
                if_op9 = reg16x3[1][15]; if_op10 = reg16x3[2][15]; if_op11 = reg16x3[2][15]; 
            end
            // middle
            else if(act_cnt[2:0] == 3'b100/*act_cnt == 20*/) begin
                if_op0 = reg16x3[0][0]; if_op1 = reg16x3[1][0]; if_op2 = reg16x3[2][0]; 
                if_op3 = reg16x3[0][0]; if_op4 = reg16x3[1][0]; if_op5 = reg16x3[2][0]; 
                if_op6 = reg16x3[0][1]; if_op7 = reg16x3[1][1]; if_op8 = reg16x3[2][1]; 
                if_op9 = reg16x3[0][2]; if_op10 = reg16x3[1][2]; if_op11 = reg16x3[2][2]; 
            end
            else if(act_cnt[2:0] == 3'b101/*act_cnt == 21*/) begin
                if_op0 = reg16x3[0][1]; if_op1 = reg16x3[1][1]; if_op2 = reg16x3[2][1]; 
                if_op3 = reg16x3[0][2]; if_op4 = reg16x3[1][2]; if_op5 = reg16x3[2][2]; 
                if_op6 = reg16x3[0][3]; if_op7 = reg16x3[1][3]; if_op8 = reg16x3[2][3]; 
                if_op9 = reg16x3[0][4]; if_op10 = reg16x3[1][4]; if_op11 = reg16x3[2][4]; 
            end
            else if(act_cnt[2:0] == 3'b110/*act_cnt == 22*/) begin
                if_op0 = reg16x3[0][3]; if_op1 = reg16x3[1][3]; if_op2 = reg16x3[2][3]; 
                if_op3 = reg16x3[0][4]; if_op4 = reg16x3[1][4]; if_op5 = reg16x3[2][4]; 
                if_op6 = reg16x3[0][5]; if_op7 = reg16x3[1][5]; if_op8 = reg16x3[2][5]; 
                if_op9 = reg16x3[0][6]; if_op10 = reg16x3[1][6]; if_op11 = reg16x3[2][6]; 
            end
            else if(act_cnt[2:0] == 3'b111/*act_cnt == 23*/) begin
                if_op0 = reg16x3[0][5]; if_op1 = reg16x3[1][5]; if_op2 = reg16x3[2][5]; 
                if_op3 = reg16x3[0][6]; if_op4 = reg16x3[1][6]; if_op5 = reg16x3[2][6]; 
                if_op6 = reg16x3[0][7]; if_op7 = reg16x3[1][7]; if_op8 = reg16x3[2][7]; 
                if_op9 = reg16x3[0][8]; if_op10 = reg16x3[1][8]; if_op11 = reg16x3[2][8]; 
            end
            else if(act_cnt[2:0] == 3'b000/*act_cnt == 24*/) begin
                if_op0 = reg16x3[0][7]; if_op1 = reg16x3[1][7]; if_op2 = reg16x3[2][7]; 
                if_op3 = reg16x3[0][8]; if_op4 = reg16x3[1][8]; if_op5 = reg16x3[2][8]; 
                if_op6 = reg16x3[0][9]; if_op7 = reg16x3[1][9]; if_op8 = reg16x3[2][9]; 
                if_op9 = reg16x3[0][10]; if_op10 = reg16x3[1][10]; if_op11 = reg16x3[2][10]; 
            end
            else if(act_cnt[2:0] == 3'b001/*act_cnt == 25*/) begin
                if_op0 = reg16x3[0][9]; if_op1 = reg16x3[1][9]; if_op2 = reg16x3[2][9]; 
                if_op3 = reg16x3[0][10]; if_op4 = reg16x3[1][10]; if_op5 = reg16x3[2][10]; 
                if_op6 = reg16x3[0][11]; if_op7 = reg16x3[1][11]; if_op8 = reg16x3[2][11]; 
                if_op9 = reg16x3[0][12]; if_op10 = reg16x3[1][12]; if_op11 = reg16x3[2][12]; 
            end
            else if(act_cnt[2:0] == 3'b010/*act_cnt == 26*/) begin
                if_op0 = reg16x3[0][11]; if_op1 = reg16x3[1][11]; if_op2 = reg16x3[2][11]; 
                if_op3 = reg16x3[0][12]; if_op4 = reg16x3[1][12]; if_op5 = reg16x3[2][12]; 
                if_op6 = reg16x3[0][13]; if_op7 = reg16x3[1][13]; if_op8 = reg16x3[2][13]; 
                if_op9 = reg16x3[0][14]; if_op10 = reg16x3[1][14]; if_op11 = reg16x3[2][14]; 
            end
            else if(act_cnt[2:0] == 3'b011/*act_cnt == 27*/) begin
                if_op0 = reg16x3[0][13]; if_op1 = reg16x3[1][13]; if_op2 = reg16x3[2][13]; 
                if_op3 = reg16x3[0][14]; if_op4 = reg16x3[1][14]; if_op5 = reg16x3[2][14]; 
                if_op6 = reg16x3[0][15]; if_op7 = reg16x3[1][15]; if_op8 = reg16x3[2][15]; 
                if_op9 = reg16x3[0][15]; if_op10 = reg16x3[1][15]; if_op11 = reg16x3[2][15]; 
            end
        end
        
    endcase
end

always @(posedge clk) begin
    if(c_state == IF) begin
        case(image_size_reg)
            0:begin
                if(act_cnt == 2) begin
                    reg16x3[0][0] <= data_out[15:8];
                    reg16x3[0][1] <= data_out[7:0];
                end
                else if(act_cnt == 3) begin
                    reg16x3[0][2] <= data_out[15:8];
                    reg16x3[0][3] <= data_out[7:0];
                end
                else if(act_cnt == 4) begin
                    reg16x3[1][0] <= data_out[15:8];
                    reg16x3[1][1] <= data_out[7:0];
                end
                else if(act_cnt == 5) begin
                    reg16x3[1][2] <= data_out[15:8];
                    reg16x3[1][3] <= data_out[7:0];
                end
                else if(act_cnt == 6) begin
                    reg16x3[2][0] <= data_out[15:8];
                    reg16x3[2][1] <= data_out[7:0];
                end
                else if(act_cnt == 7) begin
                    reg16x3[2][2] <= data_out[15:8];
                    reg16x3[2][3] <= data_out[7:0];
                end
                else if(act_cnt == 8) begin
                    reg16x3[0][4] <= data_out[15:8];
                    reg16x3[0][5] <= data_out[7:0];
                end
                else if(act_cnt == 9) begin
                    reg16x3[0][6] <= data_out[15:8];
                    reg16x3[0][7] <= data_out[7:0];
                end
            end
            1: begin
                if(act_cnt[1:0] == 2'b10 && act_cnt < 34/*act_cnt == 14 || act_cnt == 18 || act_cnt == 22 || act_cnt == 26 || act_cnt == 30*/) begin
                    reg16x3[0][0] <= reg16x3[1][0];
                    reg16x3[0][1] <= reg16x3[1][1];
                    reg16x3[1][0] <= reg16x3[2][0];
                    reg16x3[1][1] <= reg16x3[2][1];
                    reg16x3[2][0] <= data_out[15:8];
                    reg16x3[2][1] <= data_out[7:0];
                end
                else if(act_cnt[1:0] == 2'b11 && act_cnt < 34/*act_cnt == 15*/) begin
                    reg16x3[0][2] <= reg16x3[1][2];
                    reg16x3[0][3] <= reg16x3[1][3];
                    reg16x3[1][2] <= reg16x3[2][2];
                    reg16x3[1][3] <= reg16x3[2][3];
                    reg16x3[2][2] <= data_out[15:8];
                    reg16x3[2][3] <= data_out[7:0];
                end
                else if(act_cnt[1:0] == 2'b00 && act_cnt < 34/*act_cnt == 16*/) begin
                    reg16x3[0][4] <= reg16x3[1][4];
                    reg16x3[0][5] <= reg16x3[1][5];
                    reg16x3[1][4] <= reg16x3[2][4];
                    reg16x3[1][5] <= reg16x3[2][5];
                    reg16x3[2][4] <= data_out[15:8];
                    reg16x3[2][5] <= data_out[7:0];
                end
                else if(act_cnt[1:0] == 2'b01 && act_cnt < 34/*act_cnt == 17*/) begin
                    reg16x3[0][6] <= reg16x3[1][6];
                    reg16x3[0][7] <= reg16x3[1][7];
                    reg16x3[1][6] <= reg16x3[2][6];
                    reg16x3[1][7] <= reg16x3[2][7];
                    reg16x3[2][6] <= data_out[15:8];
                    reg16x3[2][7] <= data_out[7:0];
                end
            end
            2: begin
                if(act_cnt[2:0] == 3'b010 && act_cnt < 130/*act_cnt == 2*/) begin
                    reg16x3[0][0] <= reg16x3[1][0];
                    reg16x3[0][1] <= reg16x3[1][1];
                    reg16x3[1][0] <= reg16x3[2][0];
                    reg16x3[1][1] <= reg16x3[2][1];
                    reg16x3[2][0] <= data_out[15:8];
                    reg16x3[2][1] <= data_out[7:0];
                end
                else if(act_cnt[2:0] == 3'b011 && act_cnt < 130/*act_cnt == 3*/) begin
                    reg16x3[0][2] <= reg16x3[1][2];
                    reg16x3[0][3] <= reg16x3[1][3];
                    reg16x3[1][2] <= reg16x3[2][2];
                    reg16x3[1][3] <= reg16x3[2][3];
                    reg16x3[2][2] <= data_out[15:8];
                    reg16x3[2][3] <= data_out[7:0];
                end
                else if(act_cnt[2:0] == 3'b100 && act_cnt < 130/*act_cnt == 4*/) begin
                    reg16x3[0][4] <= reg16x3[1][4];
                    reg16x3[0][5] <= reg16x3[1][5];
                    reg16x3[1][4] <= reg16x3[2][4];
                    reg16x3[1][5] <= reg16x3[2][5];
                    reg16x3[2][4] <= data_out[15:8];
                    reg16x3[2][5] <= data_out[7:0];
                end
                else if(act_cnt[2:0] == 3'b101 && act_cnt < 130/*act_cnt == 5*/) begin
                    reg16x3[0][6] <= reg16x3[1][6];
                    reg16x3[0][7] <= reg16x3[1][7];
                    reg16x3[1][6] <= reg16x3[2][6];
                    reg16x3[1][7] <= reg16x3[2][7];
                    reg16x3[2][6] <= data_out[15:8];
                    reg16x3[2][7] <= data_out[7:0];
                end
                else if(act_cnt[2:0] == 3'b110 && act_cnt < 130/*act_cnt == 6*/) begin
                    reg16x3[0][8] <= reg16x3[1][8];
                    reg16x3[0][9] <= reg16x3[1][9];
                    reg16x3[1][8] <= reg16x3[2][8];
                    reg16x3[1][9] <= reg16x3[2][9];
                    reg16x3[2][8] <= data_out[15:8];
                    reg16x3[2][9] <= data_out[7:0];
                end
                else if(act_cnt[2:0] == 3'b111 && act_cnt < 130/*act_cnt == 7*/) begin
                    reg16x3[0][10] <= reg16x3[1][10];
                    reg16x3[0][11] <= reg16x3[1][11];
                    reg16x3[1][10] <= reg16x3[2][10];
                    reg16x3[1][11] <= reg16x3[2][11];
                    reg16x3[2][10] <= data_out[15:8];
                    reg16x3[2][11] <= data_out[7:0];
                end
                else if(act_cnt[2:0] == 3'b000 && act_cnt < 130/*act_cnt == 8*/) begin
                    reg16x3[0][12] <= reg16x3[1][12];
                    reg16x3[0][13] <= reg16x3[1][13];
                    reg16x3[1][12] <= reg16x3[2][12];
                    reg16x3[1][13] <= reg16x3[2][13];
                    reg16x3[2][12] <= data_out[15:8];
                    reg16x3[2][13] <= data_out[7:0];
                end
                else if(act_cnt[2:0] == 3'b001 && act_cnt < 130/*act_cnt == 9*/) begin
                    reg16x3[0][14] <= reg16x3[1][14];
                    reg16x3[0][15] <= reg16x3[1][15];
                    reg16x3[1][14] <= reg16x3[2][14];
                    reg16x3[1][15] <= reg16x3[2][15];
                    reg16x3[2][14] <= data_out[15:8];
                    reg16x3[2][15] <= data_out[7:0];
                end
            end
            
        endcase
    end
    else if(c_state == CROSS)begin
        if(flip_flag)begin
            case(image_size_reg)
                0:begin
                    if(act_cnt == 2)begin
                        reg16x3[0][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[0][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 3)begin
                        reg16x3[1][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 4)begin
                        reg16x3[0][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[0][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 5)begin
                        reg16x3[1][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 6)begin
                        reg16x3[2][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 7)begin
                        reg16x3[2][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 8)begin
                        reg16x3[0][4] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[0][5] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 9)begin
                        reg16x3[0][6] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[0][7] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                end
                1:begin
                    if(act_cnt == 2) begin
                        reg16x3[1][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 3) begin
                        reg16x3[2][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 4)begin
                        reg16x3[1][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 5)begin
                        reg16x3[2][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 6)begin
                        reg16x3[1][4] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][5] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 7)begin
                        reg16x3[2][4] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][5] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 8)begin
                        reg16x3[1][6] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][7] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 9)begin
                        reg16x3[2][6] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][7] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    //other rows
                    else if(out_num[2:0] == 3'b111 && cnt_20 == 2 && out_num < 55)begin
                        reg16x3[0][0] <= reg16x3[1][0];
                        reg16x3[0][1] <= reg16x3[1][1];
                        reg16x3[1][0] <= reg16x3[2][0];
                        reg16x3[1][1] <= reg16x3[2][1];
                        reg16x3[2][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[2:0] == 3'b111 && cnt_20 == 3 && out_num < 55)begin
                        reg16x3[0][2] <= reg16x3[1][2];
                        reg16x3[0][3] <= reg16x3[1][3];
                        reg16x3[1][2] <= reg16x3[2][2];
                        reg16x3[1][3] <= reg16x3[2][3];
                        reg16x3[2][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[2:0] == 3'b111 && cnt_20 == 4 && out_num < 55)begin
                        reg16x3[0][4] <= reg16x3[1][4];
                        reg16x3[0][5] <= reg16x3[1][5];
                        reg16x3[1][4] <= reg16x3[2][4];
                        reg16x3[1][5] <= reg16x3[2][5];
                        reg16x3[2][4] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][5] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[2:0] == 3'b111 && cnt_20 == 5 && out_num < 55)begin
                        reg16x3[0][6] <= reg16x3[1][6];
                        reg16x3[0][7] <= reg16x3[1][7];
                        reg16x3[1][6] <= reg16x3[2][6];
                        reg16x3[1][7] <= reg16x3[2][7];
                        reg16x3[2][6] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][7] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                end
                2:begin
                    if(act_cnt == 2) begin
                        reg16x3[1][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 3) begin
                        reg16x3[2][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 4)begin
                        reg16x3[1][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 5)begin
                        reg16x3[2][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 6)begin
                        reg16x3[1][4] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][5] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 7)begin
                        reg16x3[2][4] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][5] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 8)begin
                        reg16x3[1][6] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][7] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 9)begin
                        reg16x3[2][6] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][7] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 10) begin
                        reg16x3[1][8] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][9] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 11) begin
                        reg16x3[2][8] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][9] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 12)begin
                        reg16x3[1][10] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][11] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 13)begin
                        reg16x3[2][10] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][11] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 14)begin
                        reg16x3[1][12] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][13] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 15)begin
                        reg16x3[2][12] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][13] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 16)begin
                        reg16x3[1][14] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[1][15] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(act_cnt == 17)begin
                        reg16x3[2][14] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][15] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    //other rows
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 2 && out_num < 238)begin
                        reg16x3[0][0] <= reg16x3[1][0];
                        reg16x3[0][1] <= reg16x3[1][1];
                        reg16x3[1][0] <= reg16x3[2][0];
                        reg16x3[1][1] <= reg16x3[2][1];
                        reg16x3[2][0] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 3 && out_num < 238)begin
                        reg16x3[0][2] <= reg16x3[1][2];
                        reg16x3[0][3] <= reg16x3[1][3];
                        reg16x3[1][2] <= reg16x3[2][2];
                        reg16x3[1][3] <= reg16x3[2][3];
                        reg16x3[2][2] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 4 && out_num < 238)begin
                        reg16x3[0][4] <= reg16x3[1][4];
                        reg16x3[0][5] <= reg16x3[1][5];
                        reg16x3[1][4] <= reg16x3[2][4];
                        reg16x3[1][5] <= reg16x3[2][5];
                        reg16x3[2][4] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][5] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 5 && out_num < 238)begin
                        reg16x3[0][6] <= reg16x3[1][6];
                        reg16x3[0][7] <= reg16x3[1][7];
                        reg16x3[1][6] <= reg16x3[2][6];
                        reg16x3[1][7] <= reg16x3[2][7];
                        reg16x3[2][6] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][7] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 6 && out_num < 238)begin
                        reg16x3[0][8] <= reg16x3[1][8];
                        reg16x3[0][9] <= reg16x3[1][9];
                        reg16x3[1][8] <= reg16x3[2][8];
                        reg16x3[1][9] <= reg16x3[2][9];
                        reg16x3[2][8] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][9] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 7 && out_num < 238)begin
                        reg16x3[0][10] <= reg16x3[1][10];
                        reg16x3[0][11] <= reg16x3[1][11];
                        reg16x3[1][10] <= reg16x3[2][10];
                        reg16x3[1][11] <= reg16x3[2][11];
                        reg16x3[2][10] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][11] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 8 && out_num < 238)begin
                        reg16x3[0][12] <= reg16x3[1][12];
                        reg16x3[0][13] <= reg16x3[1][13];
                        reg16x3[1][12] <= reg16x3[2][12];
                        reg16x3[1][13] <= reg16x3[2][13];
                        reg16x3[2][12] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][13] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 9 && out_num < 238)begin
                        reg16x3[0][14] <= reg16x3[1][14];
                        reg16x3[0][15] <= reg16x3[1][15];
                        reg16x3[1][14] <= reg16x3[2][14];
                        reg16x3[1][15] <= reg16x3[2][15];
                        reg16x3[2][14] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                        reg16x3[2][15] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                    end
                end
            endcase
            
        end
        else begin
            case(image_size_reg)
                0:begin
                    if(act_cnt == 2)begin
                        reg16x3[0][0]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[0][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 3)begin
                        reg16x3[1][0]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 4)begin
                        reg16x3[0][2]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[0][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 5)begin
                        reg16x3[1][2]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 6)begin
                        reg16x3[2][0]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 7)begin
                        reg16x3[2][2]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 8)begin
                        reg16x3[0][4]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[0][5] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 9)begin
                        reg16x3[0][6]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[0][7] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                end
                1:begin
                    if(act_cnt == 2) begin
                        reg16x3[1][0]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 3) begin
                        reg16x3[2][0]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 4)begin
                        reg16x3[1][2]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 5)begin
                        reg16x3[2][2]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 6)begin
                        reg16x3[1][4]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][5] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 7)begin
                        reg16x3[2][4]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][5] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 8)begin
                        reg16x3[1][6]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][7] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 9)begin
                        reg16x3[2][6]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][7] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    //other rows
                    else if(out_num[2:0] == 3'b111 && cnt_20 == 2 && out_num < 55)begin
                        reg16x3[0][0] <= reg16x3[1][0];
                        reg16x3[0][1] <= reg16x3[1][1];
                        reg16x3[1][0] <= reg16x3[2][0];
                        reg16x3[1][1] <= reg16x3[2][1];
                        reg16x3[2][0] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[2:0] == 3'b111 && cnt_20 == 3 && out_num < 55)begin
                        reg16x3[0][2] <= reg16x3[1][2];
                        reg16x3[0][3] <= reg16x3[1][3];
                        reg16x3[1][2] <= reg16x3[2][2];
                        reg16x3[1][3] <= reg16x3[2][3];
                        reg16x3[2][2] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[2:0] == 3'b111 && cnt_20 == 4 && out_num < 55)begin
                        reg16x3[0][4] <= reg16x3[1][4];
                        reg16x3[0][5] <= reg16x3[1][5];
                        reg16x3[1][4] <= reg16x3[2][4];
                        reg16x3[1][5] <= reg16x3[2][5];
                        reg16x3[2][4] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][5] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[2:0] == 3'b111 && cnt_20 == 5 && out_num < 55)begin
                        reg16x3[0][6] <= reg16x3[1][6];
                        reg16x3[0][7] <= reg16x3[1][7];
                        reg16x3[1][6] <= reg16x3[2][6];
                        reg16x3[1][7] <= reg16x3[2][7];
                        reg16x3[2][6] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][7] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                end
                2:begin
                    if(act_cnt == 2) begin
                        reg16x3[1][0]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 3) begin
                        reg16x3[2][0]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 4)begin
                        reg16x3[1][2]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 5)begin
                        reg16x3[2][2]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 6)begin
                        reg16x3[1][4]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][5] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 7)begin
                        reg16x3[2][4]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][5] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 8)begin
                        reg16x3[1][6]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][7] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 9)begin
                        reg16x3[2][6]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][7] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 10) begin
                        reg16x3[1][8]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][9] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 11) begin
                        reg16x3[2][8]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][9] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 12)begin
                        reg16x3[1][10]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][11] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 13)begin
                        reg16x3[2][10]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][11] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 14)begin
                        reg16x3[1][12]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][13] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 15)begin
                        reg16x3[2][12]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][13] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 16)begin
                        reg16x3[1][14]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[1][15] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(act_cnt == 17)begin
                        reg16x3[2][14]<= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][15] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    //other rows
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 2 && out_num < 238)begin
                        reg16x3[0][0] <= reg16x3[1][0];
                        reg16x3[0][1] <= reg16x3[1][1];
                        reg16x3[1][0] <= reg16x3[2][0];
                        reg16x3[1][1] <= reg16x3[2][1];
                        reg16x3[2][0] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][1] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 3 && out_num < 238)begin
                        reg16x3[0][2] <= reg16x3[1][2];
                        reg16x3[0][3] <= reg16x3[1][3];
                        reg16x3[1][2] <= reg16x3[2][2];
                        reg16x3[1][3] <= reg16x3[2][3];
                        reg16x3[2][2] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][3] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 4 && out_num < 238)begin
                        reg16x3[0][4] <= reg16x3[1][4];
                        reg16x3[0][5] <= reg16x3[1][5];
                        reg16x3[1][4] <= reg16x3[2][4];
                        reg16x3[1][5] <= reg16x3[2][5];
                        reg16x3[2][4] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][5] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 5 && out_num < 238)begin
                        reg16x3[0][6] <= reg16x3[1][6];
                        reg16x3[0][7] <= reg16x3[1][7];
                        reg16x3[1][6] <= reg16x3[2][6];
                        reg16x3[1][7] <= reg16x3[2][7];
                        reg16x3[2][6] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][7] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 6 && out_num < 238)begin
                        reg16x3[0][8] <= reg16x3[1][8];
                        reg16x3[0][9] <= reg16x3[1][9];
                        reg16x3[1][8] <= reg16x3[2][8];
                        reg16x3[1][9] <= reg16x3[2][9];
                        reg16x3[2][8] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][9] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 7 && out_num < 238)begin
                        reg16x3[0][10] <= reg16x3[1][10];
                        reg16x3[0][11] <= reg16x3[1][11];
                        reg16x3[1][10] <= reg16x3[2][10];
                        reg16x3[1][11] <= reg16x3[2][11];
                        reg16x3[2][10] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][11] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 8 && out_num < 238)begin
                        reg16x3[0][12] <= reg16x3[1][12];
                        reg16x3[0][13] <= reg16x3[1][13];
                        reg16x3[1][12] <= reg16x3[2][12];
                        reg16x3[1][13] <= reg16x3[2][13];
                        reg16x3[2][12] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][13] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 == 9 && out_num < 238)begin
                        reg16x3[0][14] <= reg16x3[1][14];
                        reg16x3[0][15] <= reg16x3[1][15];
                        reg16x3[1][14] <= reg16x3[2][14];
                        reg16x3[1][15] <= reg16x3[2][15];
                        reg16x3[2][14] <= (neg_flag) ? (~data_out[15:8]) : data_out[15:8];
                        reg16x3[2][15] <= (neg_flag) ? (~data_out[7:0]) : data_out[7:0];
                    end
                end
            endcase
        end
    end
end

always@(*)begin

    mul0_op1 = 0;
    mul0_op2 = 0;
    add0_op1 = mul0_out;
    add0_op2 = temp_ans;
    if(act_cnt == 3) begin
        mul0_op1 = (image_size_reg == 0) ? reg16x3[0][0] : reg16x3[1][0];
        mul0_op2 = temp_reg[4];
    end
    else if(act_cnt == 4) begin
        mul0_op1 = (image_size_reg == 0) ? reg16x3[0][1] : reg16x3[1][1];
        mul0_op2 = temp_reg[5];
    end
    else if(act_cnt == 5) begin
        mul0_op1 = (image_size_reg == 0) ? reg16x3[1][0] : reg16x3[2][0];
        mul0_op2 = temp_reg[7];
    end
    else if(act_cnt == 6) begin
        mul0_op1 = (image_size_reg == 0) ? reg16x3[1][1] : reg16x3[2][1];
        mul0_op2 = temp_reg[8];
    end
    else begin
        case(image_size_reg)
            0: begin
                case(out_num+1)
                    1:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    2:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    3:begin
                        if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[7];
                        end
                    end
                    4:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    5:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    6:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    7:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[7];
                        end
                    end
                    8:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    9:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    10:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    11:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = 0;
                        end
                    end
                    12:begin
                        if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[5];
                        end
                    end
                    13:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[5];
                        end
                    end
                    14:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[5];
                        end
                    end
                    15:begin
                        if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[4];
                        end
                    end

                endcase
            
            end
            1: begin
                case(out_num+1)
                    1:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    2:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    3:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    4:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    5:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    6:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    7:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                    end
                    8,16,24,32,40,48:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    9,17,25,33,41,49:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    10,18,26,34,42,50:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    11,19,27,35,43,51:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    12,20,28,36,44,52:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    13,21,29,37,45,53:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    14,22,30,38,46,54:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    15,23,31,39,47,55:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                    end
                    56:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = 0;
                        end
                    end
                    57:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = 0;
                        end
                    end
                    58:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = 0;
                        end
                    end
                    59:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = 0;
                        end
                    end
                    60:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = 0;
                        end
                    end
                    61:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = 0;
                        end
                    end
                    62:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                    end
                    63:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                    end
                endcase
            end
            2:begin
                case(out_num+1)
                    1:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    2:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    3:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    4:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    5:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    6:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    7:begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    8: begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    9: begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    10: begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    11: begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    12: begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    13: begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    14: begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    15: begin
                        if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = 0;
                        end
                    end
                    16,32,48,64,80,96,112,128,144,160,176,192,208,224: begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    17,33,49,65,81,97,113,129,145,161,177,193,209,225:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][0];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    18,34,50,66,82,98,114,130,146,162,178,194,210,226:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][1];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    19,35,51,67,83,99,115,131,147,163,179,195,211,227:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][2];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    20,36,52,68,84,100,116,132,148,164,180,196,212,228:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][3];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    21,37,53,69,85,101,117,133,149,165,181,197,213,229:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][4];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    22,38,54,70,86,102,118,134,150,166,182,198,214,230:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][5];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    23,39,55,71,87,103,119,135,151,167,183,199,215,231:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][6];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][8];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    24,40,56,72,88,104,120,136,152,168,184,200,216,232:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][7];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][8];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][9];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    25,41,57,73,89,105,121,137,153,169,185,201,217,233:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][8];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][9];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][10];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    26,42,58,74,90,106,122,138,154,170,186,202,218,234:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][9];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][10];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][11];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    27,43,59,75,91,107,123,139,155,171,187,203,219,235:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][10];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][11];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][12];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    28,44,60,76,92,108,124,140,156,172,188,204,220,236:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][11];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][12];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][13];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    29,45,61,77,93,109,125,141,157,173,189,205,221,237:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][12];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][13];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][14];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    30,46,62,78,94,110,126,142,158,174,190,206,222,238:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][13];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][14];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][15];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = temp_reg[8];
                        end
                    end
                    31,47,63,79,95,111,127,143,159,175,191,207,223,239:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[0][14];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[0][15];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[0][15];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[6];
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = temp_reg[7];
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = 0;
                        end
                    end
                    240:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = 0;
                        end
                    end
                    241:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][0];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][0];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = 0;
                        end
                    end
                    242:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][1];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][1];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = 0;
                        end
                    end
                    243:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][2];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][2];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = 0;
                        end
                    end
                    244:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][3];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][3];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = 0;
                        end
                    end
                    245:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][4];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][4];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = 0;
                        end
                    end
                    246:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][5];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][5];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                    end
                    247:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][6];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][6];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = 0;
                        end
                    end
                    248:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][7];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][7];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = 0;
                        end
                    end
                    249:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][8];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][8];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = 0;
                        end
                    end
                    250:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][9];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][9];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = 0;
                        end
                    end
                    251:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][10];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][10];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = 0;
                        end
                    end
                    252:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][11];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][11];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = 0;
                        end
                    end
                    253:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][12];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][12];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = 0;
                        end
                    end
                    254:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][13];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = temp_reg[2];
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = temp_reg[5];
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][13];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = 0;
                        end
                    end
                    255:begin
                        if(cnt_20 == 11)begin
                            mul0_op1 = reg16x3[1][14];
                            mul0_op2 = temp_reg[0];
                        end
                        else if(cnt_20 == 12)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = temp_reg[1];
                        end
                        else if(cnt_20 == 13)begin
                            mul0_op1 = reg16x3[1][15];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 14)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = temp_reg[3];
                        end
                        else if(cnt_20 == 15)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = temp_reg[4];
                        end
                        else if(cnt_20 == 16)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 17)begin
                            mul0_op1 = reg16x3[2][14];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 18)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = 0;
                        end
                        else if(cnt_20 == 19)begin
                            mul0_op1 = reg16x3[2][15];
                            mul0_op2 = 0;
                        end
                    end
                endcase

            end
        endcase
    end
end

always@(posedge clk)begin
    if(c_state == IDLE)begin
        temp_ans <= 0;
    end
    else if(cnt_20 == 10 || act_cnt == 2) 
        temp_ans <= 0;
    else if(cnt_20 > 10 || act_cnt == 3 || act_cnt == 4 || act_cnt == 5)
        temp_ans <= add0_out;
end

assign mul0_out = mul0_op1 * mul0_op2;
assign add0_out = add0_op1 + add0_op2;

//addr imgsize 
always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        do_act_cnt <= 0;
        addr_write <= 0;
        addr_read <= 0;
		
		finish <= 0;
        out <= 0;

        image_size_reg <= 0;
        mem1to0_flag <= 0;
		
		act_cnt <= 0;
		out_ans <= 0;
    end 
    else if(c_state == IDLE && n_state == READ_IMG) begin
        image_size_reg <= image_size;
        ori_imgsize_reg <= image_size;
        do_act_cnt <= 1;
    end
    else if(n_state == IDLE) begin
        out_ans <= 0;
        do_act_cnt <= 1;
        out <= 0;
        finish <= 0;
        mem1to0_flag <= 0;
        act_cnt <= 0;
        image_size_reg <= ori_imgsize_reg;
        move <= 0;
    end
    /*else if(n_state == WAIT) begin
        if((action_s[do_act_cnt] == MAXP || action_s[do_act_cnt] == MINP) && image_size_reg == 0)
            do_act_cnt <= do_act_cnt + 1;
    end*/
    else if(n_state == MAXP || n_state == MINP) begin
        case(image_size_reg)
            0: do_act_cnt <= do_act_cnt + 1;
            1: begin
                //read
                case(act_cnt)
                    0: addr_read <= n_addr;
                    1,3,5,7, 9,11,13,15, 17,19,21,23, 25,27,29,31: addr_read <= addr_read + 4;
                    2,4,6, 10,12,14, 18,20,22, 26,28,30: addr_read <= addr_read - 3;
                    8,16,24: addr_read <= addr_read + 1;
                    default: addr_read <= 0;
                endcase
                //write
                case(act_cnt)
                    0: addr_write <= 0;
                    6,10,14,18,22,26,30: addr_write <= addr_write + 1;
                    default: addr_write <= addr_write;
                endcase

                //finish
                if(act_cnt == 34) begin//33
                    act_cnt <= 0;
                    image_size_reg <= 0;
                    do_act_cnt <= do_act_cnt + 1;
                    mem1to0_flag <= ~mem1to0_flag;
                    finish <= 1;
                end
                else begin
                    act_cnt <= act_cnt + 1;
                    finish <= 0;
                end
                move <= 1;
            end
            2: begin
                //read
                if(act_cnt == 0) begin
                    addr_read <= n_addr;
                end
                else if(act_cnt == 16 || act_cnt == 32 || act_cnt == 48 || act_cnt == 64 || act_cnt == 80 || act_cnt == 96 || act_cnt == 112) begin
                    addr_read <= addr_read + 1;
                end
                else if(act_cnt%2 == 1) begin
                    addr_read <= addr_read + 8;
                end
                else addr_read <= addr_read - 7;
                //write
                case(act_cnt)
                    0: addr_write <= 0;
                    6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,66,70,74,78,82,86,90,94,98,102,106,110,114,118,122,126: addr_write <= addr_write + 1;
                    default: addr_write <= addr_write;
                endcase
                
                //finish
                if(act_cnt == 130) begin//129
                    act_cnt <= 0;
                    image_size_reg <= 1;
                    do_act_cnt <= do_act_cnt + 1;
                    mem1to0_flag <= ~mem1to0_flag;
                    finish <= 1;
                end
                else begin
                    act_cnt <= act_cnt + 1;
                    finish <= 0;
                end
                move <= 1;
            end
        endcase
    end
    else if(n_state == IF) begin
        move <= 1;
        case(image_size_reg)
            0: begin
                //read
                if(act_cnt == 0) begin
                    addr_read <= n_addr;
                end
                else addr_read <= addr_read + 1;
                //write
                if(act_cnt < 6) begin
                    addr_write <= 0;
                end
                else addr_write <= addr_write + 1;
                
                //finish
                if(act_cnt == 13) begin//12
                    act_cnt <= 0;
                    do_act_cnt <= do_act_cnt + 1;
                    mem1to0_flag <= ~mem1to0_flag;
                    finish <= 1;
                end
                else begin
                    act_cnt <= act_cnt + 1;
                    finish <= 0;
                end
            end
            1: begin
                //read
                if(act_cnt == 0) begin
                    addr_read <= n_addr;
                end
                else addr_read <= addr_read + 1;
                //write
                if(act_cnt < 8) begin
                    addr_write <= 0;
                end
                else addr_write <= addr_write + 1;
                
                //finish
                if(act_cnt == 39) begin//38
                    act_cnt <= 0;
                    do_act_cnt <= do_act_cnt + 1;
                    mem1to0_flag <= ~mem1to0_flag;
                    finish <= 1;
                end
                else begin
                    act_cnt <= act_cnt + 1;
                    finish <= 0;
                end
            end
            2:begin
                //read
                if(act_cnt == 0) begin
                    addr_read <= n_addr;
                end
                else addr_read <= addr_read + 1;
                //write
                if(act_cnt < 12) begin
                    addr_write <= 0;
                end
                else addr_write <= addr_write + 1;
                
                //finish
                if(act_cnt == 139) begin//138
                    act_cnt <= 0;
                    do_act_cnt <= do_act_cnt + 1;
                    mem1to0_flag <= ~mem1to0_flag;
                    finish <= 1;
                end
                else begin
                    act_cnt <= act_cnt + 1;
                    finish <= 0;
                end
            end
        endcase
    end
    else if(n_state == CROSS) begin
        
        if(flip_flag)begin
            case(image_size_reg)
                0:begin
                    if(act_cnt == 0) addr_read <= n_addr + 1;
                    else if(act_cnt == 1) addr_read <= addr_read + 2;
                    else if(act_cnt == 2) addr_read <= addr_read - 3;
                    else if(act_cnt == 3) addr_read <= addr_read + 2;
                    else if(act_cnt == 4) addr_read <= addr_read + 3;
                    else if(act_cnt == 5) addr_read <= addr_read - 1;
                    else if(act_cnt == 6) addr_read <= addr_read + 3;
                    else if(act_cnt == 7) addr_read <= addr_read - 1;
                end
                
                1:begin
                    if(act_cnt == 0) 
                        addr_read <= n_addr + 3;
                    else if(act_cnt == 1 || act_cnt == 3 || act_cnt == 5 || act_cnt == 7) 
                        addr_read <= addr_read + 4;
                    else if(act_cnt == 2 || act_cnt == 4 || act_cnt == 6) 
                        addr_read <= addr_read - 5;
                    // other rows
                    else if(out_num[2:0] == 3'b111/* == 7*/ && cnt_20 == 0)begin
                        addr_read <= addr_read + 7;
                    end
                    else if(out_num[2:0] == 3'b111 && cnt_20 < 4)begin
                        addr_read <= addr_read - 1;
                    end
                end
                
                2:begin
                    if(act_cnt == 0) 
                        addr_read <= n_addr + 7;
                    else if(act_cnt == 1 || act_cnt == 3 || act_cnt == 5 || act_cnt == 7 || act_cnt == 9 || act_cnt == 11 || act_cnt == 13 || act_cnt == 15) 
                        addr_read <= addr_read + 8;
                    else if(act_cnt == 2 || act_cnt == 4 || act_cnt == 6 || act_cnt == 8 || act_cnt == 10 || act_cnt == 12 || act_cnt == 14) 
                        addr_read <= addr_read - 9;
                    // other rows
                    else if(out_num[3:0] == 4'b1111/* == 15*/ && cnt_20 == 0)begin
                        addr_read <= addr_read + 15;
                    end
                    else if(out_num[3:0] == 4'b1111 && cnt_20 < 8)begin
                        addr_read <= addr_read - 1;
                    end
                end
            endcase
        end
        else begin
            case(image_size_reg)
                0:begin
                    if(act_cnt == 0) addr_read <= n_addr;
                    else if(act_cnt == 1 || act_cnt == 3) addr_read <= addr_read + 2;
                    else if(act_cnt == 2) addr_read <= addr_read - 1;
                    else if(act_cnt == 4 || act_cnt == 5 || act_cnt == 6 || act_cnt == 7) addr_read <= addr_read + 1;

                end
                
                1:begin
                    if(act_cnt == 0) 
                        addr_read <= n_addr;
                    else if(act_cnt == 1 || act_cnt == 3 || act_cnt == 5 || act_cnt == 7) 
                        addr_read <= addr_read + 4;
                    else if(act_cnt == 2 || act_cnt == 4 || act_cnt == 6) 
                        addr_read <= addr_read - 3;
                    // other rows
                    else if(out_num[2:0] == 3'b111 && cnt_20 < 4)begin
                        addr_read <= addr_read + 1;
                    end
                end
                
                2:begin
                    if(act_cnt == 0) 
                        addr_read <= n_addr;
                    else if(act_cnt == 1 || act_cnt == 3 || act_cnt == 5 || act_cnt == 7 || act_cnt == 9 || act_cnt == 11 || act_cnt == 13 || act_cnt == 15) 
                        addr_read <= addr_read + 8;
                    else if(act_cnt == 2 || act_cnt == 4 || act_cnt == 6 || act_cnt == 8 || act_cnt == 10 || act_cnt == 12 || act_cnt == 14) 
                        addr_read <= addr_read - 7;
                    // other rows
                    else if(out_num[3:0] == 4'b1111 && cnt_20 < 8)begin
                        addr_read <= addr_read + 1;
                    end
                    
                end
            endcase

        end

        if(act_cnt < 20) begin
            act_cnt <= act_cnt + 1;
        end

        if((out_num == 15 && image_size_reg == 0) && cnt_20 == 19)begin
            out <= 0;
            finish <= 1;
        end
        else if((out_num == 63 && image_size_reg == 1) && cnt_20 == 19)begin
            out <= 0;
            finish <= 1;
        end
        else if((out_num == 255 && image_size_reg == 2) && cnt_20 == 19)begin
            out <= 0;
            finish <= 1;
        end
        else if(act_cnt == 6 || cnt_20 == 19) begin
            out_ans <= add0_out;
            out <= 1;
        end
        else begin
            finish <= 0;
            out_ans[0] <= out_ans[19];
            out_ans[19] <= out_ans[18];
            out_ans[18] <= out_ans[17];
            out_ans[17] <= out_ans[16];
            out_ans[16] <= out_ans[15];
            out_ans[15] <= out_ans[14];
            out_ans[14] <= out_ans[13];
            out_ans[13] <= out_ans[12];
            out_ans[12] <= out_ans[11];
            out_ans[11] <= out_ans[10];
            out_ans[10] <= out_ans[9];
            out_ans[9] <= out_ans[8];
            out_ans[8] <= out_ans[7];
            out_ans[7] <= out_ans[6];
            out_ans[6] <= out_ans[5];
            out_ans[5] <= out_ans[4];
            out_ans[4] <= out_ans[3];
            out_ans[3] <= out_ans[2];
            out_ans[2] <= out_ans[1];
            out_ans[1] <= out_ans[0];
        end
        
    end
end

always@(posedge clk) begin
    if(cnt_20 == 19)begin
        cnt_20 <= 0;
    end
    else if(out)begin
        cnt_20 <= cnt_20 + 1;
    end
    else cnt_20 <= 0;
end

always@(posedge clk) begin
    if(c_state == IDLE)
        out_num <= 0;
    else if(cnt_20 == 19)begin
        out_num <= out_num + 1;
    end
end

assign out_valid = (out) ? 1 : 0;
assign out_value = (out_valid) ? out_ans[19] : 0;

endmodule

module maxpooling(
    // input signals
    op0,
    op1,
    op2,
	op3,
	
    // output signals
    out
);

input      [7:0] op0, op1, op2, op3;
output reg [7:0] out;

reg [7:0] ans0, ans1;

always @(*) begin
    ans0 = (op0 > op1)? op0 : op1;
    ans1 = (op2 > op3)? op2 : op3;
    out = (ans0 > ans1)? ans0 : ans1;
end

endmodule

module minpooling(
    // input signals
    op0,
    op1,
    op2,
	op3,
	
    // output signals
    out
);

input      [7:0] op0, op1, op2, op3;
output reg [7:0] out;

reg [7:0] ans0, ans1;

always @(*) begin
    ans0 = (op0 > op1)? op1 : op0;
    ans1 = (op2 > op3)? op3 : op2;
    out = (ans0 > ans1)? ans1 : ans0;
end

endmodule

module imagefilter(
    // input signals
    op0,
    op1,
    op2,
	op3,
    op4,
    op5,
    op6,
    op7,
    op8,
    op9,
    op10,
    op11,

    // output signals
    out0,
    out1
);

input      [7:0] op0, op1, op2, op3, op4, op5, op6, op7, op8, op9, op10, op11;
output reg [7:0] out0, out1;

reg [7:0] ans0, ans1, ans2, ans3, ans4, ans5, ans6, ans7, ans8, ans9;
reg [7:0] ans10, ans11, ans12, ans13, ans14, ans15, ans16, ans17, ans18, ans19;
reg [7:0] ans20, ans21, ans22, ans23, ans24, ans25, ans26, ans27, ans28, ans29;
reg [7:0] ans30, ans31, ans32, ans33, ans34;

reg [7:0] ans20_, ans21_, ans22_, ans23_, ans24_, ans25_, ans26_, ans27_, ans28_, ans29_;
reg [7:0] ans30_, ans31_, ans32_, ans33_, ans34_, ans18_, ans19_;

always @(*) begin
    


    ans0 = (op3 > op4)? op3 : op4;//
    ans1 = (op3 > op4)? op4 : op3;
    ans2 = (ans1 > op5)? ans1 : op5;
    ans3 = (ans1 > op5)? op5 : ans1;
    ans4 = (ans0 > ans2)? ans0 : ans2;
    ans5 = (ans0 > ans2)? ans2 : ans0;

    ans6 = (op6 > op7)? op6 : op7;//
    ans7 = (op6 > op7)? op7 : op6;
    ans8 = (ans7 > op8)? ans7 : op8;
    ans9 = (ans7 > op8)? op8 : ans7;
    ans10 = (ans6 > ans8)? ans6 : ans8;
    ans11 = (ans6 > ans8)? ans8 : ans6;

    //ans12 = (ans4 > ans10)? ans4 : ans10;//
    ans13 = (ans4 > ans10)? ans10 : ans4;
    ans14 = (ans5 > ans11)? ans5 : ans11;
    ans15 = (ans5 > ans11)? ans11 : ans5;
    ans16 = (ans3 > ans9)? ans3 : ans9;
    //ans17 = (ans3 > ans9)? ans9 : ans3;

    //0
    ans18 = (op0 > op1)? op0 : op1;
    ans19 = (op0 > op1)? op1 : op0;
    ans20 = (ans19 > op2)? ans19 : op2;
    ans21 = (ans19 > op2)? op2 : ans19;
    ans22 = (ans18 > ans20)? ans18 : ans20;
    ans23 = (ans18 > ans20)? ans20 : ans18;

    //ans24 = (ans13 > ans22)? ans13 : ans22;
    ans25 = (ans13 > ans22)? ans22 : ans13;
    ans26 = (ans15 > ans23)? ans15 : ans23;
    ans27 = (ans15 > ans23)? ans23 : ans15;
    //ans28 = (ans14 > ans26)? ans14 : ans26;
    ans29 = (ans14 > ans26)? ans26 : ans14;

    ans30 = (ans16 > ans21)? ans16 : ans21;
    //ans31 = (ans16 > ans21)? ans21 : ans16;
    ans32 = (ans30 > ans29)? ans30 : ans29;
    ans33 = (ans30 > ans29)? ans29 : ans30;
    ans34 = (ans33 > ans25)? ans33 : ans25;
    //ans35 = (ans33 > ans25)? ans25 : ans33;

    out0 = (ans32 > ans34)? ans34 : ans32;


    //1
    ans18_ = (op9 > op10)? op9 : op10;
    ans19_ = (op9 > op10)? op10 : op9;
    ans20_ = (ans19_ > op11)? ans19_ : op11;
    ans21_ = (ans19_ > op11)? op11 : ans19_;
    ans22_ = (ans18_ > ans20_)? ans18_ : ans20_;
    ans23_ = (ans18_ > ans20_)? ans20_ : ans18_;

    //ans24_ = (ans13 > ans22_)? ans13 : ans22_;
    ans25_ = (ans13 > ans22_)? ans22_ : ans13;
    ans26_ = (ans15 > ans23_)? ans15 : ans23_;
    ans27_ = (ans15 > ans23_)? ans23_ : ans15;
    //ans28_ = (ans14 > ans26_)? ans14 : ans26_;
    ans29_ = (ans14 > ans26_)? ans26_ : ans14;

    ans30_ = (ans16 > ans21_)? ans16 : ans21_;
    //ans31_ = (ans16 > ans21_)? ans21_ : ans16;
    ans32_ = (ans30_ > ans29_)? ans30_ : ans29_;
    ans33_ = (ans30_ > ans29_)? ans29_ : ans30_;
    ans34_ = (ans33_ > ans25_)? ans33_ : ans25_;
    //ans35_ = (ans33_ > ans25_)? ans25_ : ans33_;

    out1 = (ans32_ > ans34_)? ans34_ : ans32_;
end

endmodule