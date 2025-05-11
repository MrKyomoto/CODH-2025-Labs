`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/06 20:50:24
// Design Name: 
// Module Name: FUMux4
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


module FUMux4(
    input [31:0] in1,in2,in3,in4,
    input sel1, 
    input [1:0] sel2, //主sel,连接FU的mux信号
    output reg [31:0] out
);
always @(*) begin
    case (sel2)
        2'd0:begin
            if(sel1)begin
                out = in2;
            end 
            else begin
                out = in1;
            end
        end 
        2'd1:begin
            out = in3;
        end
        2'd2:begin
            out = in4;
        end
        default: begin
            out = 32'b0;
        end
    endcase 
end

endmodule
