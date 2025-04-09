`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/06 22:26:04
// Design Name: 
// Module Name: ALU
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


module ALU(
    input   [31 : 0]    in1    ,      // 操作数0
    input   [31 : 0]    in2    ,      // 操作数1
    input   [3  : 0]    op      ,      // 运算功能
    output  [31 : 0]    out            // 运算结果
);

reg [31:0] out_R; 
wire signed [31:0] s1_S = in1;
wire signed [31:0] s2_S = in2;
always @(*) begin
    case (op)
        0: out_R = in1 + in2; //add 
        1: out_R = in1 - in2; //subtract
        2: out_R =  {{31{1'b0}},{(s1_S < s2_S)}}; //signed less
        3: out_R =  {{31{1'b0}},{(in1 < in2)}}; //unsigned less 
        4: out_R =  in1 & in2; //and
        5: out_R =  in1 | in2; //or
        6: out_R =  ~(in1 | in2); //not or
        7: out_R =  in1 ^ in2; //xor 
        8: out_R =  in1 << in2[4:0];//shl 
        9: out_R =  in1 >> in2[4:0]; //shr 
        10: out_R =  s1_S >>> in2[4:0]; //shrs 
        11: out_R =  in2; 
        default:out_R = 32'b0 ;
    endcase 
end
assign out = out_R;

endmodule
