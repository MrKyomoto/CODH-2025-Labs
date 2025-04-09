`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/07 20:56:59
// Design Name: 
// Module Name: Filter
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


module LoadFilter(
    input [31:0] in,
    input [5:0] opType,
    input [1:0] offset,
    output reg [31:0] out
);
localparam LB = 21; localparam LH = 22; localparam LW = 23;
localparam LBU = 24; localparam LHU = 25;

always @(*) begin
    case (opType)
        LB:begin
            case(offset)
                2'b00:begin
                    out = {{24{in[7]}},in[7:0]};
                end
                2'b01:begin
                    out = {{24{in[15]}},in[15:8]};
                end
                2'b10:begin
                    out = {{24{in[23]}},in[23:16]};
                end
                2'b11:begin
                    out = {{24{in[31]}},in[31:24]};
                end
                default:begin
                    out = 32'b0;
                end
            endcase
        end 
        LH:begin
            case (offset)
                2'b00:begin
                    out = {{16{in[15]}},in[15:0]};
                end 
                2'b10:begin
                    out = {{16{in[31]}},in[31:16]}; 
                end
                default:begin
                    out = 32'b0;
                end 
            endcase
        end
        LW:begin
            out = in;
        end
        LBU:begin
            case(offset)
                2'b00:begin
                    out = {{24{1'b0}},in[7:0]};
                end
                2'b01:begin
                    out = {{24{1'b0}},in[15:8]};
                end
                2'b10:begin
                    out = {{24{1'b0}},in[23:16]};
                end
                2'b11:begin
                    out = {{24{1'b0}},in[31:24]};
                end
                default:begin
                    out = 32'b0;
                end
            endcase
        end
        LHU:begin
            case (offset)
                2'b00:begin
                    out = {{16{1'b0}},in[15:0]};
                end 
                2'b10:begin
                    out = {{16{1'b0}},in[31:16]}; 
                end
                default:begin
                    out = 32'b0;
                end 
            endcase
        end
        default:begin
            out = 32'b0;
        end
    endcase 
end
endmodule
