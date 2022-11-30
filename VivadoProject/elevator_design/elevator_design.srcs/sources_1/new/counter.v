module counter
#(parameter clk_counter=499)
(
    input clk,rst,en,
    output reg CLK
    );
    integer i;
    always@(posedge clk)begin
        if(!en||!rst) begin
            i<=0;
            CLK<=0;
        end 
        else begin
            i<=i+1;
            if(i==clk_counter)begin
                CLK=!CLK;
                i<=0;
            end
        end
    end
endmodule
