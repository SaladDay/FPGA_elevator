module mealy_state_change(
    input clk,
    input [4:0] floor_call,
    input [4:0] floor,
    input [2:0] state,//当前状态
    output reg [2:0] next_state,
    output reg [4:0] next_floor
    );
    
    
    //通过各楼叫梯型号输出相对叫楼信号 start///////////////////////////////////////
    wire up;
    wire down;
    abs2rela abs2rela_inst(floor,floor_call,up,down);
    //通过各楼叫梯型号输出相对叫楼信号 end///////////////////////////////////////
    
    //有限状态机设计 start///////////////////////////////////////
    parameter   stop     = 3'b100,
                 upRun    = 3'b001,
                 upStop   = 3'b000,
                 downRun  = 3'b011,
                 downStop = 3'b010;
                 
    
    always@(posedge clk)begin
        case(state)
             stop:      begin
                        if(up) next_state <= upRun;
                        else if (down) next_state <= downRun;
                        else next_state <= stop;
                        next_floor <= floor;
                        end
             upRun:     begin
                        //下面这行代码意味着到达了需要上升的楼层
                        if ((floor_call & floor) != 'b00000) begin next_state <= upStop;next_floor <= floor; end
                        else if (up)  begin next_state <= upRun; next_floor <= (floor<<1); end
                        else begin next_state <= stop;next_floor <= floor; end
                        end
             upStop:    begin
                        if (up) next_state <= upRun;
                        else if (down) next_state <= downRun;
                        else next_state <= stop;
                        next_floor <= floor;
                        end
             downRun:   begin
                        if ((floor_call & floor) != 'b00000) begin next_state <= downStop; next_floor <= floor; end
                        //下面的代码意味着，在向下的过程中，下面依旧还有信号
                        else if (down) begin next_state <= downRun; next_floor <= (floor>>1); end
                        else begin next_state <= stop; next_floor <= floor; end
                        end
             downStop:  begin
                        if (down) next_state <= downRun;
                        else if (up) next_state <= upRun;
                        else next_state <= stop;
                        next_floor <= floor;            
                        end
//             default:   begin
//                        next_state<=stop;
//                        next_floor<=floor;
//                        end

                        
        endcase
    
    end
    //有限状态机设计 end///////////////////////////////////////

endmodule
