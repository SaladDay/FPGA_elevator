module mealy_state_change(
    input clk,
    input [4:0] floor_call,
    input [4:0] floor,
    input [2:0] state,//��ǰ״̬
    output reg [2:0] next_state,
    output reg [4:0] next_floor
    );
    
    
    //ͨ����¥�����ͺ������Խ�¥�ź� start///////////////////////////////////////
    wire up;
    wire down;
    abs2rela abs2rela_inst(floor,floor_call,up,down);
    //ͨ����¥�����ͺ������Խ�¥�ź� end///////////////////////////////////////
    
    //����״̬����� start///////////////////////////////////////
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
                        //�������д�����ζ�ŵ�������Ҫ������¥��
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
                        //����Ĵ�����ζ�ţ������µĹ����У��������ɻ����ź�
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
    //����״̬����� end///////////////////////////////////////

endmodule
