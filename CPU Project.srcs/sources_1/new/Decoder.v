`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/2	6 10:31:11
// Design Name: 
// Module Name: Decoder32
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

//t
module Decoder32(
	input clk,
	input rst,

	input [31:0] Instruction,
	input [31:0] ALU_Result,
	input [31:0] Memory_data,
	input [31:0] PC_plus_4,

	input MemtoReg,
	input RegWrite,
	input RegDst,
	input Jal,
	// input ALUSrc;


	output [31:0] Read_data_1,
	output [31:0] Read_data_2,
	output [31:0] Extend
);

	wire [6:0] Opc = Instruction[31:26];
	wire [4:0] rs = Instruction[25:21];
	wire [4:0] rt = Instruction[20:16];
	wire [4:0] rd = Instruction[15:11];

	reg [31:0] Reg[31:0];

	assign Read_data_1 = Reg[rs];
	assign Read_data_2 = Reg[rt];

	wire Unsigned;
	assign Unsigned = (Opc == 6'b001001  || Opc == 6'b001100 || Opc == 6'b001011 || Opc == 6'b001101 || Opc == 6'b001110)? 1'b1 : 1'b0;
	assign Extend = (Unsigned == 1'b1) ? {16'b0,Instruction[15:0]} : { (Instruction[15] == 1'b1 ? 16'h1111:16'h0000),Instruction[15:0]};

	reg [5:0] DstReg;
	always @(*) begin
		if(RegDst == 1'b1)
			DstReg = rd;
		else
			if(Jal == 1'b1)
				DstReg = 5'b11111;
			else
				DstReg = rt;
	end

	reg [31:0] Write_data;
	always @(*) begin
        if(Jal == 1)
            Write_data = PC_plus_4;
        else
			if(MemtoReg == 1'b1)
            	Write_data = Memory_data;
        	else
            	Write_data = ALU_Result;
    end

	integer i;
	always @(posedge clk or posedge rst)
    if (rst)
        for(i = 0; i <= 31; i = i + 1)
            Reg[i] <= 32'b0;
    else
		if (RegWrite == 1'b1 && DstReg != 5'b0) 
            Reg[DstReg] <= Write_data;
		else;
 
endmodule