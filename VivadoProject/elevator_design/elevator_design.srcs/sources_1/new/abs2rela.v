`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/25 23:04:17
// Design Name: 
// Module Name: abs2rela
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


module abs2rela(
input[4:0] floor,
input[4:0] floor_in,
output reg up,
output reg down
    );


always@(*) begin
    case(floor) 
        'b10000: begin
                 up = 0;
                 if (floor_in[3:0] == 'b0000) down=0;
                 else down = 1;
                 end
        'b01000: begin
                 if (floor_in[4]=='b0) up = 0;
                 else up = 1;
                 if (floor_in[2:0]=='b000) down = 0;
                 else down = 1;
                 end
        'b00100: begin
                 if (floor_in[4:3]=='b00) up = 0;
                 else up = 1;
                 if (floor_in[1:0]=='b00) down = 0;
                 else down = 1;
                 end
        'b00010: begin
                 if (floor_in[4:2]=='b000) up = 0;
                 else up = 1;
                 if (floor_in=='b0) down = 0;
                 else down = 1;
                 end
        'b00001: begin
                 if (floor_in[4:1]=='b0000) up = 0;
                 else up = 1;
                 down = 0;
                 end
        default: begin
                 up = 0;
                 down = 0;
                 end
    endcase
end
endmodule

