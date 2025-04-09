module Segment (
    input           [ 0 : 0]            clk        ,
    input           [ 0 : 0]            rst_n           ,

    input           [31 : 0]            display_data    ,

    output  reg     [ 7 : 0]            an              ,      // Connecting segments display
    output  reg     [ 6 : 0]            data                   // Connecting segments display      
);

    reg  [ 2 : 0]     seg_cnt     ;
    reg  [ 3 : 0]     seg_data    ;
    reg  [16 : 0]     cnt400      ;


    always @(posedge clk) begin
        if (rst_n) begin
            cnt400  <= 0;
            seg_cnt <= 0;
        end
        else begin
            if (cnt400 > 'D49999) begin
                cnt400 <= 0;
                if (seg_cnt == 'D7)
                    seg_cnt <= 0;
                else
                    seg_cnt <= seg_cnt + 'B1;
            end
            else
                cnt400 <= cnt400 + 'B1;
        end
    end
    
    always @(*) begin
        case (seg_cnt)
             'D0: begin an = 8'B11111110; seg_data = display_data[0 +: 4]; end
             'D1: begin an = 8'B11111101; seg_data = display_data[4 +: 4]; end
             'D2: begin an = 8'B11111011; seg_data = display_data[8 +: 4]; end
             'D3: begin an = 8'B11110111; seg_data = display_data[12 +: 4]; end
             'D4: begin an = 8'B11101111; seg_data = display_data[16 +: 4]; end
             'D5: begin an = 8'B11011111; seg_data = display_data[20 +: 4]; end
             'D6: begin an = 8'B10111111; seg_data = display_data[24 +: 4]; end
             'D7: begin an = 8'B01111111; seg_data = display_data[28 +: 4]; end
        endcase   
        case (seg_data)
            4'H0: data = 7'B0000001;  //0
            4'H1: data = 7'B1001111;  //1
            4'H2: data = 7'B0010010;  //2
            4'H3: data = 7'B0000110;  //3
            4'H4: data = 7'B1001100;  //4
            4'H5: data = 7'B0100100;  //5
            4'H6: data = 7'B0100000;  //6
            4'H7: data = 7'B0001111;  //7
            4'H8: data = 7'B0000000;  //8
            4'H9: data = 7'B0000100;  //9
            4'Ha: data = 7'B0001000;  //A
            4'Hb: data = 7'B1100000;  //B
            4'Hc: data = 7'B0110001;  //C
            4'Hd: data = 7'B1000010;  //D
            4'He: data = 7'B0110000;  //E
            4'Hf: data = 7'B0111000;  //F
        endcase
    end
endmodule