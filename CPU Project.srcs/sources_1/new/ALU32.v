`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/15 14:59:57
// Design Name: 
// Module Name: ALU32
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


module ALU32(
    // from Decoder
    input[31:0] Read_data_1, //the source of Ainput
    input[31:0] Read_data_2, //one of the sources of Binput
    input[31:0] Sign_extend, //one of the sources of Binput
    // from IFetch
    input[5:0] Opcode, //instruction[31:26]
    input[5:0] Function_opcode, //instructions[5:0]
    input[4:0] Shamt, //instruction[10:6], the amount of shift bits
    input[31:0] PC_plus_4, //pc+4
    // from Controller
    input[1:0] ALUOp, //{ (R_format || I_format) , (Branch || nBranch) }
    input ALUSrc, // 1 means the 2nd operand is an immediate (except beq,bne£©
    input I_format, // 1 means I-Type instruction except beq, bne, LW, SW
    input Sftmd,
    output reg [31:0] ALU_Result, // the ALU calculation result
    output Zero, // 1 means the ALU_reslut is zero, 0 otherwise
    output[31:0] Addr_Result // the calculated instruction address
);

    wire [31:0] A = Read_data_1;
    wire [31:0] B = (ALUSrc == 1'b1) ? Sign_extend : Read_data_2;

    wire [5:0] Exe_code = (I_format == 1'b0) ? Function_opcode : {3'b0 , Opcode[2:0] };
    wire [2:0] ALU_ctrl;
    assign ALU_ctrl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctrl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctrl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];

    reg signed [31:0] Calc_Result;

    always @(*)
    begin
        case(ALU_ctrl)
            3'b000: Calc_Result = A & B; // and/andi
            3'b001: Calc_Result = A | B; // or/ori
            3'b010: Calc_Result = $signed(A) + $signed(B); // add/addi/lw/sw
            3'b011: Calc_Result = A + B; // addu/addiu
            3'b100: Calc_Result = A ^ B; // xor/xori
            3'b101: Calc_Result = ~(A | B); // nor/lui
            3'b110: Calc_Result = $signed(A) - $signed(B); // sub/slti/beq/bne
            3'b111: Calc_Result = A - B; // subu/subu/sltiu/slt/sltu
            default: Calc_Result = 32'b0;
        endcase
    end

    wire[2:0] Sft_code = Function_opcode[2:0];
    reg[31:0] Sft_Result;
    always @(*)
    begin
        if(Sftmd) begin
            case(Sft_code[2:0]) 
                3'b000: Sft_Result = B << Shamt; //sll
                3'b010: Sft_Result = B >> Shamt; //srl
                3'b100: Sft_Result = B << A; //sllv
                3'b110: Sft_Result = B >> A; //srlv
                3'b011: Sft_Result = $signed(B) >>> Shamt; //Sra
                3'b111: Sft_Result = $signed(B) >>> A; //Srav
                default: Sft_Result = 32'b0;
            endcase 
        end
        else
            Sft_Result = B;
    end

    always @(*) begin 
        if(Sftmd == 1'b1)
            ALU_Result = Sft_Result;
        else
            if (((ALU_ctrl == 3'b111) && (Exe_code[3] == 1)) ||((ALU_ctrl == 3'b110) && (Exe_code == 6'b001010))|| ((ALU_ctrl == 3'b111) && (Exe_code == 6'b001011)))
                ALU_Result = (Calc_Result[31] == 1'b1)? 1'b1 : 1'b0; // slt/slti/sltu/sltiu
            else
                if((ALU_ctrl == 3'b101) && (I_format == 1))
                    ALU_Result = {B[15:0],16'b0};  //lui
                else
                    ALU_Result = Calc_Result;
    end

    assign Zero = (ALU_Result == 31'b0) ? 1'b1:1'b0;
    assign Addr_Result = PC_plus_4 + (Sign_extend << 2);
    
endmodule