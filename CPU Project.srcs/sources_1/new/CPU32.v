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
    input[31:0] Instruction
    );
    wire ALUOp;
    wire RegDst;
    wire RegWrite;
    wire ALUSrc;
    wire MemWrite;
    wire MemtoReg;
    
    Controller32 Controller();
    ALU32 ALU();
    
    
endmodule
