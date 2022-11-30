`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module digital_show(
    input clk,en,
    input [4:0] floor_call,   
    input [4:0] floor,      
    input [2:0] state,
    output en_led,
    output [4:0] led,
    output reg [7:0] a2g,
    output reg [3:0] sel

    );
    reg sel_change;
    //右位显示上升下降，左位显示所在楼层
    reg [3:0]data;
    always@(posedge clk)begin
        if(!en) sel_change<=0;
        else sel_change <= ~sel_change;
    end
    
    always@(*)begin
        if(en) begin
            if (sel_change) begin
                if (floor[4]) data<=4'b0101;
                else if (floor[3]) data<=4'b0100;
                else if (floor[2]) data<=4'b0011;
                else if (floor[1]) data<=4'b0010;
                else if (floor[0]) data<=4'b0001;
            end
            else begin
                if (state=='b001) data<=4'b1010;
                else if (state=='b011) data<=4'b1111;
                else data<=4'b1110;
            end        
        end  
    end
    assign en_led=!en;
    assign led = en?floor_call:5'b00000;
    always@(posedge clk) begin
        if(!en)a2g = 8'b1111_1111;
        else begin
            case(data)
                'b0001:a2g<=8'b10011111;
                'b0010:a2g<=8'b00100101;
                'b0011:a2g<=8'b00001101;
                'b0100:a2g<=8'b10011001;
                'b0101:a2g<=8'b01001001;
                'b1010:a2g<=8'b00010001;
                'b1110:a2g<=8'b11111101;
                'b1111:a2g<=8'b10000001;
                default:a2g<=8'b11111111;
            endcase
        end
    end
    always @(posedge clk) begin
        if (en) begin
            if (sel_change) sel='b1011;
            else sel='b1101;            
        end
    end
endmodule
