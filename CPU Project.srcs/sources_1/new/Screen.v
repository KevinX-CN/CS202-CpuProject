module Screen(
    input clk,
    input rst,
    input[31:0] number,
    output[7:0] seg,//段选，高有效
    output[7:0] seg1,
    output[7:0] an //位选，低有效
);
    reg[18:0] divclk_cnt = 0;//分频计数器
    reg divclk = 0;//分频后的时钟
    reg[7:0] seg=0;//段码
    reg[7:0] seg1=0;
    reg[7:0] an=8'b00000001;//位码
    reg[3:0] disp_dat=0;//要显示的数据
    reg[2:0] disp_bit=0;//要显示的位
    parameter maxcnt = 50000;// 周期：50000*2/100M
    always@(posedge clk)
    begin
        if(divclk_cnt==maxcnt)
        begin
            divclk=~divclk;
            divclk_cnt=0;
        end
        else
        begin
            divclk_cnt=divclk_cnt+1'b1;
        end
    end
    always@(posedge divclk) begin
        if(disp_bit >= 7)
            disp_bit=0;
         else
            disp_bit=disp_bit+1'b1;
         case (disp_bit)
            3'b000 :
            begin
                disp_dat=number[3:0];
                an=8'b00000001;//显示第一个数码管，高电平有效
            end
            3'b001 :
            begin
                disp_dat=number[7:4];
                an=8'b00000010;//显示第二个数码管，低电平有效
            end
            3'b010 :
            begin
                disp_dat=number[11:8];
                an=8'b00000100;//显示第三个数码管，低电平有效
            end
            3'b011 :
            begin
                disp_dat=number[15:12];
                an=8'b00001000;//显示第四个数码管，低电平有效
            end
            3'b100 :
            begin
                disp_dat=number[19:16];
                an=8'b00010000;//显示第五个数码管，低电平有效
            end
            3'b101 :
            begin
                disp_dat=number[23:20];
                an=8'b00100000;//显示第六个数码管，低电平有效
            end
            3'b110 :
            begin
                disp_dat=number[27:24];
                an=8'b01000000;//显示第七个数码管，低电平有效
            end
            3'b111 :
            begin
                disp_dat=number[31:28];
                an=8'b10000000;//显示第八个数码管，低电平有效
            end
            default:
            begin
                disp_dat=0;
                an=8'b00000000;
            end
        endcase
    end
    always@(disp_dat)
    begin
        if(an > 8'b00001000) begin
            case (disp_dat)
            //显示0—F
            4'h0 : seg = 8'hfc;
            4'h1 : seg = 8'h60;
            4'h2 : seg = 8'hda;
            4'h3 : seg = 8'hf2;
            4'h4 : seg = 8'h66;
            4'h5 : seg = 8'hb6;
            4'h6 : seg = 8'hbe;
            4'h7 : seg = 8'he0;
            4'h8 : seg = 8'hfe;
            4'h9 : seg = 8'hf6;
            4'ha : seg = 8'hee;
            4'hb : seg = 8'h3e;
            4'hc : seg = 8'h9c;
            4'hd : seg = 8'h7a;
            4'he : seg = 8'h9e;
            4'hf : seg = 8'h8e;
            endcase
        end
        else begin
            case (disp_dat)
            //显示0-F
            4'h0 : seg1 = 8'hfc;
            4'h1 : seg1 = 8'h60;
            4'h2 : seg1 = 8'hda;
            4'h3 : seg1 = 8'hf2;
            4'h4 : seg1 = 8'h66;
            4'h5 : seg1 = 8'hb6;
            4'h6 : seg1 = 8'hbe;
            4'h7 : seg1 = 8'he0;
            4'h8 : seg1 = 8'hfe;
            4'h9 : seg1 = 8'hf6;
            4'ha : seg1 = 8'hee;
            4'hb : seg1 = 8'h3e;
            4'hc : seg1 = 8'h9c;
            4'hd : seg1 = 8'h7a;
            4'he : seg1 = 8'h9e;
            4'hf : seg1 = 8'h8e;
            endcase
        end
    end
endmodule
