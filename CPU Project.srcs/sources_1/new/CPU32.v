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
    /*Module Clock Start*/
    cpuclk clk1(
        .clk_in1(clkin),
        .clk_out1(clkout),
        .clk_out2(fpga_clk)
    );
    reg clkin;
    wire clkout;
    initial clkin = 1'b0;
    always #5 clkin=~clkin;
    /*Module Clock End*/

    /*Controller Module Start*/
    Controller32 Controller(
        .Op(Instruction[31:26]), 
        .Func(Instruction[5:0]), 
        .Jr(Jr), 
        .Jmp(Jmp), 
        .Jal(Jal), 
        .Branch(Branch), 
        .nBranch(nBranch), 

        .RegDST(RegDST), 
        .MemtoReg(MemtoReg), 
        .RegWrite(RegWrite), 
        .MemWrite(MemWrite), 
        .ALUSrc(ALUSrc), 
        .Sftmd(Sftmd), 
        .I_format(I_format),
        .ALUOp(ALUOp)
    );


    wire[31:0] Instruction;
    wire Jr;
    wire Jmp;
    wire Jal;
    wire Branch;
    wire nBranch;
    wire ALUOp;
    wire RegDst;
    wire RegWrite;
    wire ALUSrc;
    wire MemWrite;
    wire MemtoReg;
    IFetch32 IFetch(
        .clock(clk),
        .reset(restn),
        .Addr_result(Addr_result),
        .Zero(Zero),
        .Read_data_1(Read_data_1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Instruction(Instruction),
        .branch_base_addr(branch_base_addr),
        .link_addr(link_addr),

        .upg_rst_i(fpga_rst), // UPG reset (Active High)
        .upg_clk_i(upg_clk_i), // UPG clock (10MHz)
        .upg_wen_i(upg_wen_i), // UPG write enable
        .upg_adr_i(upg_adr_i), // UPG write address
        .upg_dat_i(upg_dat_i), // UPG write data
        .upg_done_i(upg_done_i)
    );
    wire Zero;
    wire Addr_result;
    wire Read_data_1;
    wire Read_data_2;
    wire Sign_extend;
    wire branch_base_addr;
    wire link_addr;
    wire ALU_Result;
    ALU32 ALU(
        // from Decoder
        .Read_data_1(Read_data_1), //the source of Ainput
        .Read_data_2(Read_data_2), //one of the sources of Binput
        .Sign_extend(Sign_extend), //one of the sources of Binput
        // from IFetch
        .Opcode(Instruction[31:26]), //instruction[31:26]
        .Function_opcode(Instruction[5:0]), //instructions[5:0]
        .Shamt(Instruction[5:0]), //instruction[10:6], the amount of shift bits
        .PC_plus_4(branch_base_addr), //pc+4
        // from Controller
        .ALUOp(ALUOp), //{ (R_format || I_format) , (Branch || nBranch) }
        .ALUSrc(ALUSrc), // 1 means the 2nd operand is an immediate (except beq,bne¬£¬©
        .I_format(I_format), // 1 means I-Type instruction except beq, bne, LW, SW
        .Sftmd(Sftmd),
        // output
        .ALU_Result(ALU_Result), // the ALU calculation result
        .Zero(Zero), // 1 means the ALU_reslut is zero, 0 otherwise
        .Addr_Result(Addr_result) // the calculated instruction address
    );

     Decoder32 Decoder(
        .clk(clkout),
        .rst(re),

        .Instruction(Instruction),
        .ALU_Result(ALU_Result),
        .Memory_data(Memory_data),
        .PC_plus_4(link_addr),

        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .RegDst(RegDST),
        .Jal(Jal),


        .Read_data_1(Read_data_1),
        .Read_data_2(Read_data_2),
        .Extend(Sign_extend)
    );
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
    MemOrIO MemOrIOU1(
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .IORead(IORead),
        .IOWrite(IOWrite),
        .addr_in(addr_in),
        .addr_out(addr_out),
        .M_ReadData(M_ReadData),
        .IO_ReadData(IO_ReadData),
        .test_index(test_index),
        .InputCtrl(InputCtrl),
        .Reg_WriteData(Reg_WriteData),
        .Reg_ReadData(Reg_ReadData),
        .write_data(write_data),
        .LEDCtrl(LEDCtrl),
        .LEDELCtrl(LEDELCtrl),
        .SwitchCtrl(SwitchCtrl)
    ); 
    Debounce Debounce(
        .clk(clkout),
        .rst(re),
        .IN(IN),
        .OUT(OUT)
    );
    Screen Screen(
        .clk(clkout),
        .rst(re),
        .number(number),
        .seg(seg),//ÊÆµÈ?âÔºåÈ´òÊúâÊï?
        .seg1(seg1),
        .an(an) //‰ΩçÈ?âÔºå‰ΩéÊúâÊï?
    );

endmodule