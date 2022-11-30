module elevator_design(
input clk,rst,en,
input [4:0] in,//��λ��¥�ź�
input [4:0] cancel,//��λȡ����¥�ź�
output reg en_led,
output reg [4:0] led,//��λ��¥ָʾ��
output reg [7:0] a2g,//������ʾʹ��
output reg [3:0] sel//������ʾѡ��
    );
    parameter   stop     = 3'b100,
                 upRun    = 3'b001,
                 upStop   = 3'b000,
                 downRun  = 3'b011,
                 downStop = 3'b010;
    //��0λ-->1:run 0:stop
    //��1λ-->1:down 0:up
    //��2λ-->1:top  0:yundong
    
    reg [4:0] floor;
    wire [4:0] next_floor;
    reg [2:0] state;
    wire [2:0] next_state;
    
    reg [4:0] floor_call;//���¥��Ľ���״̬
    reg [4:0] temp_floor_call;
    //ʱ�� start///////////////////////////////////////////////////
    wire clk_100ms;
    parameter clk_100ms_counter=49_9999;
    counter#(clk_100ms_counter) CLK_100ms(clk,rst,en,clk_100ms);
    wire clk_1s;
    parameter clk_1s_counter=4999_9999;
    counter#(clk_1s_counter) CLK_s(clk,rst,en,clk_1s);
    //ʱ�� end///////////////////////////////////////////////////
    
    
    //���½���״̬ start///////////////////////////////////////
    genvar i;
    for(i = 0;i<5;i=i+1)begin
        always@(posedge clk_100ms)begin
            if(!rst||!en||((state==upStop||state==downStop)&&floor[i]==1))begin
                //��û��������ǰ�Ѿ��ƶ�����¥��ȡ����¥�Ľ�¥״̬
                temp_floor_call[i]<=0;
            end
            else if(cancel[i]==1)begin
                temp_floor_call[i]<=0;
            end
            else if(in[i]==1)begin
                temp_floor_call[i]<=1;
            end
            else begin
                temp_floor_call[i]<=temp_floor_call[i];
            end
        end
        //��������߼���ʹrst��en�ܹ��첽����
        always@(*)begin
            if(!rst||!en||((state==upStop||state==downStop)&&floor[i]==1))begin
                floor_call[i]=0;
            end
            else floor_call[i]=temp_floor_call[i];
        end
    end
    //���½���״̬ end///////////////////////////////////////
    
    //״̬��¥��ת�� start///////////////////////////////////////
    always@(negedge clk_1s or negedge en) begin
        if (!rst || !en) state = stop;
        else state = next_state;
    end

    always@(negedge clk_1s or negedge en) begin
        if (!rst) floor = 'b00001;
        else if (!en) floor = floor;
        else floor = next_floor;
    end
    
    mealy_state_change mealy_state_change_inst01(
    .clk(clk_1s),
    .floor_call(floor_call),
    .floor(floor),
    .state(state),//��ǰ״̬
    .next_state(next_state),
    .next_floor(next_floor)
    );
    //״̬��¥��ת�� end///////////////////////////////////////
    //digital_showģ�� start///////////////////////////////////////
    wire en_led2;
    wire [4:0] led2;
    wire [7:0] a2g2;
    wire [3:0] sel2;
    digital_show(
    .clk(clk_100ms),
    .en(en),
    .floor_call(floor_call),   
    .floor(floor),      
    .state(state),
    .en_led(en_led2),
    .led(led2),
    .a2g(a2g2),
    .sel(sel2)

    );
    always@(*) begin
        en_led = en_led2;
        led = led2;
        a2g = a2g2;
        sel = sel2;
    end
    
    //digital_showģ�� end///////////////////////////////////////
    
                  
endmodule
