`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 20:45:38
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    input [31:0] IR,

    output reg [4:0] rs1, 
    output reg [4:0] rs2, 
    output reg [4:0] rd, 
    output reg [11:0] imm12,
    output reg [19:0] imm20,
    output reg [2:0] sel_branch,//B型比较,服务于CMP
    output reg [0:0] se_type,//立即数扩展类型,服务于SE
    output reg [0:0] isHalt,
    output reg [5:0] opType //TODO(不确定这个地方的位数到底是多少,目前感觉6位起码是够用的)
);
wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
assign opcode = IR[6:0]; 
assign funct3 = IR[14:12];
assign funct7 = IR[31:25];

localparam R  = 7'b0110011;
localparam I1 = 7'b0010011; //I型运算指令
localparam U1 = 7'b0110111; //lui 
localparam U2 = 7'b0010111; //auipc
localparam I2 = 7'b0000011; //I型取数指令
localparam S  = 7'b0100011; //S型存数指令
localparam J1 = 7'b1101111; //Jal
localparam J2 = 7'b1100111; //Jalr
localparam B  = 7'b1100011; //Branch
localparam H  = 7'b1110011; //Halt(ebreak = 00000000000100000000000001110011)

// R Type
localparam ADD = 0; localparam SUB = 1; localparam SLL = 2;
localparam SLT = 3; localparam XORR = 4;localparam SRL = 5;
localparam SRA = 6; localparam ORR = 7; localparam AND = 8;

//I Type
localparam ADDI = 9; localparam SLTI = 10; localparam SLTIU = 11;
localparam XORI = 13; localparam ORI = 14; localparam ANDI = 15;
localparam SLLI = 16; localparam SRLI = 17;localparam SRAI = 18;

//U Type
localparam LUI = 19; localparam AUIPC = 20;

//I 访存 Type
localparam LB = 21; localparam LH = 22; localparam LW = 23;
localparam LBU = 24; localparam LHU = 25;

//S Type
localparam SB = 26; localparam SH = 27; localparam SW = 28;

//J Type
localparam JAL = 29; localparam JALR = 30;


//B Type
localparam BEQ = 31; localparam BNE = 32; localparam BLT = 33;
localparam BGE = 34; localparam BLTU = 35;localparam BGEU = 36;

//HALT
localparam HALT = 37;

//R Type Addition
localparam SLTU = 38;

//extend imm type
localparam SE32 = 0;//extend as signed
localparam UE32 = 1;//extend as unsigned

//serve for CMP
localparam SEL_BEQ = 0; localparam SEL_BNE = 1;
localparam SEL_BLT = 2; localparam SEL_BGE = 3;
localparam SEL_BLTU = 4;localparam SEL_BGEU = 5;

always @(*) begin
    case (opcode)
        R:begin
            rs1 = IR[19:15];
            rs2 = IR[24:20];
            rd  = IR[11:7];
            imm12 = 12'b0;
            imm20 = 20'b0;
            sel_branch = 3'b0;
            se_type = 1'b0;
            isHalt = 0;
            case (funct7)
                7'b0000000:begin
                    case (funct3)
                        3'b000:begin
                            opType = ADD;
                        end 
                        3'b001:begin
                            opType = SLL;
                        end
                        3'b010:begin
                            opType = SLT;
                        end
                        3'b011:begin
                            opType = SLTU;
                        end
                        3'b100:begin
                            opType = XORR;
                        end
                        3'b101:begin
                            opType = SRL;
                        end
                        3'b110:begin
                            opType = ORR;
                        end
                        3'b111:begin
                            opType = AND;
                        end
                        default: //FIXME(事实上所有的default都应该处理,否则会出现不可预测的结果,把主要逻辑写完了再来考虑这个事情)
                        begin
                            opType = ADD; //默认值赋值为当前类型指令的第一个指令
                        end
                    endcase 
                end 
                7'b0100000:begin
                    case (funct3)
                        3'b000:begin
                            opType = SUB;
                        end 
                        3'b101:begin
                            opType = SRA;
                        end
                        default:begin
                            opType = SUB; 
                        end
                    endcase 
                end
                default:begin
                    opType = ADD;
                end
            endcase
        end 
        I1:begin
            rs1 = IR[19:15];
            rd  = IR[11:7];
            imm12 = IR[31:20];
            imm20 = 20'b0;
            sel_branch = 3'b0;
            isHalt = 0;
            case (funct3)
                3'b000:begin
                    se_type = SE32; 
                    opType = ADDI;
                end 
                3'b010:begin
                    se_type = SE32; 
                    opType = SLTI;
                end
                3'b011:begin
                    se_type = SE32; 
                    opType = SLTIU;  
                end
                3'b100:begin
                    se_type = SE32; 
                    opType = XORI;
                end 
                3'b110:begin
                    se_type = SE32; 
                    opType = ORI; 
                end 
                3'b111:begin
                    se_type = SE32; 
                    opType = ANDI;
                end 
                3'b001:begin
                    se_type = UE32; 
                    opType = SLLI;
                end 
                3'b101:begin
                    se_type = UE32; 
                    if(IR[30] == 0)begin
                        opType = SRLI;
                    end
                    else begin
                        opType = SRAI;
                    end
                end 
                default:begin
                    se_type = SE32;
                    opType = ADDI;
                end
            endcase
        end
        U1:begin
            rs1 = 5'b0;
            rs2 = 5'b0;
            rd = IR[11:7]; 
            imm12 = 12'b0;
            imm20 = IR[31:12];
            sel_branch = 3'b0;
            se_type = UE32;
            opType = LUI;
            isHalt = 0;
        end
        U2:begin
            rs1 = 5'b0;
            rs2 = 5'b0;
            rd = IR[11:7]; 
            imm12 = 12'b0;
            imm20 = IR[31:12];
            sel_branch = 3'b0;
            se_type = UE32;
            opType = AUIPC;
            isHalt = 0;
        end
        I2:begin
           rs1 = IR[19:15];
           rs2 = 5'b0;
           rd  = IR[11:7];
           imm12 = IR[31:20]; 
           imm20 = 20'b0;
           sel_branch = 3'b0;
           se_type = SE32;
           isHalt = 0;
           case (funct3)
            3'b000:begin
                opType = LB;    
            end 
            3'b001:begin
                opType = LH; 
            end 
            3'b010:begin
                opType = LW; 
            end 
            3'b100:begin
                opType = LBU; 
            end 
            3'b101:begin
                opType = LHU; 
            end 
            default:begin
                opType = LB;
            end
           endcase
        end
        S:begin
           rs1 = IR[19:15]; 
           rs2 = IR[24:20];
           rd = 5'b0;
           imm12 = {IR[31:25],IR[11:7]};
           imm20 = 20'b0;
           sel_branch = 3'b0;
           se_type = SE32;
           isHalt = 0;
           case (funct3)
            3'b000:begin
                opType = SB;    
            end 
            3'b001:begin
                opType = SH; 
            end 
            3'b010:begin
                opType = SW; 
            end 
            default:begin
                opType = SB;
            end
           endcase
        end
        J1:begin
           rs1 = 5'b0;
           rs2 = 5'b0;
           rd = IR[11:7]; 
           imm12 = 12'b0;
           //MEMO(我逐渐理解一切,这么设计真的是有原因的)
           imm20 = {IR[31],IR[19:12],IR[20],IR[30:21]};
           //MEMO(sel_branch = 6是对应了J型)
           sel_branch = 3'd6;
           se_type = SE32;
           opType = JAL;
           isHalt = 0;
        end
        J2:begin
            rs1 = IR[19:15];
            rs2 = 5'b0;
            rd = IR[11:7];
            imm12 = IR[31:20];
            imm20 = 20'b0;
            sel_branch = 3'd6;
            se_type = SE32;
            opType = JALR;
            isHalt = 0;
        end
        B:begin
            rs1 = IR[19:15];
            rs2 = IR[24:20];
            rd = 5'b0;
            imm12 = {IR[31],IR[7],IR[30:25],IR[11:8]};
            imm20 = 20'b0;
            se_type = SE32;
            isHalt = 0;
            case (funct3)
                3'b000:begin
                    sel_branch = 0;
                    opType = BEQ;    
                end 
                3'b001:begin
                    sel_branch = 1;
                    opType = BNE; 
                end 
                3'b100:begin
                    sel_branch = 2;
                    opType = BLT; 
                end 
                3'b101:begin
                    sel_branch = 3;
                    opType = BGE; 
                end 
                3'b110:begin
                    sel_branch = 4;
                    opType = BLTU; 
                end 
                3'b111:begin
                    sel_branch = 5;
                    opType = BGEU; 
                end 
                default: begin
                    sel_branch = 0;
                    opType = BEQ;
                end
            endcase
        end
        H:begin
            rs1 = 5'b0;
            rs2 = 5'b0;
            rd = 5'b0;
            imm12 = 12'b0;
            imm20 = 20'b0;
            sel_branch = 3'b0;
            se_type = 0;
            opType = HALT; 
            isHalt = 1;
        end
        default:begin
            rs1 = 5'b0;
            rs2 = 5'b0;
            rd = 5'b0;
            imm12 = 12'b0;
            imm20 = 20'b0;
            sel_branch = 3'b0;
            se_type = 0;
            opType = ADD;
            isHalt = 0;
        end
    endcase 
end

endmodule
