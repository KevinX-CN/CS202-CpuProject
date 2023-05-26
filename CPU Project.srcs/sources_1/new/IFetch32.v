`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/26 10:41:06
// Design Name: 
// Module Name: IFetch32
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


module IFetch32(
    //from CPU TOP
    input clock, reset, // Clock and reset
    // from ALU
    input[31:0] Addr_result, // the calculated address from ALU
    input Zero, // while Zero is 1, it means the ALUresult is zero
    // from Decoder
    input[31:0] Read_data_1, // the address of instruction used by jr instruction
    // from Controller
    input Branch, // while Branch is 1,it means current instruction is beq
    input nBranch, // while nBranch is 1,it means current instruction is bnq
    input Jmp, // while Jmp 1, it means current instruction is jump
    input Jal, // while Jal is 1, it means current instruction is jal
    input Jr,

    output[31:0] Instruction, // the instruction fetched from this module to Decoder and Controller
    output[31:0] branch_base_addr, // (pc+4) to ALU which is used by branch type instruction
    output[31:0] link_addr, // (pc+4) to Decoder which is used by jal instruction
    // UART Programmer Pinouts
    input upg_rst_i, // UPG reset (Active High)
    input upg_clk_i, // UPG clock (10MHz)
    input upg_wen_i, // UPG write enable
    input[13:0] upg_adr_i, // UPG write address
    input[31:0] upg_dat_i, // UPG write data
    input upg_done_i
);
    reg[31:0] PC, Next_PC;
    always @* begin
        if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = PC+Addr_result; // the calculated new value for PC
        else if(Jr == 1)
            Next_PC = Read_data_1; // the value of $31 register
        else 
            Next_PC = PC+4; // PC+4
    end
    
    always @(negedge clock) begin
        if(reset == 1)
            PC <= 32'h0000_0000;
        else if((Jmp == 1) || (Jal == 1))
                PC <= {PC[31:28],Instruction[25:0],2'b00};
        else 
            PC <=Next_PC;
    end
    ProgramROM32 instmem(
        .rom_clk_i(clock), // ROM clock
        .rom_adr_i(PC[15:2]), // From IFetch
        .Instruction_o(Instruction), // To IFetch
        // UART Programmer Pinouts
        .upg_rst_i(upg_rst_i), // UPG reset (Active High)
        .upg_clk_i(upg_clk_i), // UPG clock (10MHz)
        .upg_wen_i(upg_wen_i), // UPG write enable
        .upg_adr_i(upg_adr_i), // UPG write address
        .upg_dat_i(upg_dat_i), // UPG write data
        .upg_done_i(upg_done_i) // 1 if program finished
    );
    
    assign branch_base_addr=PC+4;
    assign link_addr=PC+4;
endmodule
