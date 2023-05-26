`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/15 15:05:14
// Design Name: 
// Module Name: CPU32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU32(
    input fpga_rst, //Active High
    input fpga_clk,
    input[23:0] switch2N4,
    output[23:0] led2N4,
    // UART Programmer Pinouts
    // start Uart communicate at
    input start_pg,
    input rx,
    output tx
    );
    wire ALUOp;
    wire RegDst;
    wire RegWrite;
    wire ALUSrc;
    wire MemWrite;
    wire MemtoReg;
    wire Jr;
    wire Jmp;
    wire Jal;
    wire Branch;
    wire nBranch;
    wire[31:0] Instruction;
    // UART Programmer Pinouts
    wire upg_clk, upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart rx data have done
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o;
    wire spg_bufg;
    uart_bmpg_0 U1(.I(start_pg), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge fpga_clk) begin
        if (spg_bufg) upg_rst = 0;
        if (fpga_rst) upg_rst = 1;
    end
    //used for other modules which don't relate to UART
    wire rst;
    assign rst = fpga_rst | !upg_rst;
    
    reg clkin;
    wire clkout;
    cpuclk clk1(.clk_in1(clkin),.clk_out1(clkout),.clk_out2(fpga_clk));
    initial clkin = 1'b0;
    always #5 clkin=~clkin;
    
    Controller32 Controller(
        .Op(Instruction[5:0]), 
        .Func(Instruction[31:26]), 
        .Jr(Jr), 
        .Jmp(Jmp), 
        .Jal(Jal), 
        .Branch(Branch), 
        .nBranch(nBranch), 
        .RegDST(RegD), 
        .MemtoReg(MemtoReg), 
        .RegWrite(RegWrite), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc), 
        .Sftmd(Sftmd), 
        .I_format(I_format),
        .ALUOp(ALUOp)
    );
    IFetch32 IFetch(
        .clock(clk),
        .reset(re),
        .Addr_result(),
        .Zero(),
        .Read_data_1(),
        .Branch(Branch),
        .nBranch(nBranch)
        ,.Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Instruction(Instruction),
        .branch_base_addr(),
        .link_addr()
    );
    
    
    
endmodule
