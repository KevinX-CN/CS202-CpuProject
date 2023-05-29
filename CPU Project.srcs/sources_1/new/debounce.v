module Debounce(input clk,input rst,input IN,input OUT);
	reg delay1 = 0;
    reg delay2 = 0;
    reg delay3 = 0;

	reg [18:0] divcnt;
	reg divclk;
	parameter maxcnt = 500000;// 200hz
    always@(posedge clk)
    begin
        if(divcnt==maxcnt)
        begin
            divclk=~divclk;
            divcnt=0;
        end
        else
        begin
            divcnt=divcnt+1'b1;
        end
    end

    always @ (posedge divclk or posedge rst)
    begin
        if(rst == 1)
            begin
                delay1<=IN;
                delay2<=IN;
                delay3<=IN;
            end
        else begin
            delay1 <= IN;
            delay2 <= delay1;
            delay3 <= delay2;
        end
    end

    assign OUT = ((delay1 == delay2) && (delay2 == delay3) && (delay1 == 1))?1'b1:1'b0;

endmodule
