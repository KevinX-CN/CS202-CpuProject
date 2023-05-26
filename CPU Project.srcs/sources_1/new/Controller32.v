`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/17 16:30:07
// Design Name: 
// Module Name: Controller
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


module Controller32(
    input[5:0] Op,
    input[5:0] Func,
    output Jr,
    output Jmp,
    output Jal,
    output Branch,
    output nBranch,
    output RegDST,
    output MemtoReg,
    output RegWrite,
    output MemWrite,
    output[1:0] ALUSrc,
    output Sftmd
    );
    assign Jr = ((Op==6'b000000)&&(Func==6'b001000)) ? 1'b1 : 1'b0;
    assign Jmp = (Op==6'b000010) ? 1'b1 : 1'b0;
    assign Jal = (Op==6'b000011) ? 1'b1 : 1'b0;
    assign Branch = (Op==6'b000100) ? 1'b1 : 1'b0;
    assign nBranch = (Op==6'b000101) ? 1'b1 : 1'b0;
    wire R_format = (Op==6'b000000)? 1'b1:1'b0;
    wire I_format = (Op[5:3]==3'b001) ? 1'b1 : 1'b0;
    wire ALUOp = { (R_format || I_format) , (Branch || nBranch) };
    assign RegDST = R_format;
    assign MemtoReg= (Op==6'b100011) ? 1'b1 : 1'b0;
    assign RegWrite = (R_format || (Op==6'b010111) || Jal || I_format) && !(Jr);
    assign MemWrite= (Op==6'b101011) ? 1'b1 : 1'b0;
    assign ALUSrc=ALUOp;
    assign Sftmd = (((Func==6'b000000)||(Func==6'b000010)||(Func==6'b000011)||(Func==6'b000100)||(Func==6'b000110)||(Func==6'b000111))&& R_format) ? 1'b1 : 1'b0;
    
endmodule
