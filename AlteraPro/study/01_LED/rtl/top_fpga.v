//file name:       top_fpga.v
//author:           ETree
//date:             2017.9.9
//function:        top file of project
//log:              led light

module top_fpga(
    //global signal
    input clk,  //50MHz
    input rst_n,//low active
	 
    //led
    output [3:0] led //high active
);

//寄存器定义
reg [31:0] timer=0;
reg [3:0]  led_r=0;

assign led = led_r;

always @(posedge clk or negedge rst_n)
    if (~rst_n)
        timer <= 0; //计数器清零
    else if (timer == 32'd49_999_999) //0.5 秒计数(50M-1=49_999_999)
        timer <= 0; //计数器清零
    else
        timer <= timer + 1'b1; //计数器加 1

//LED控制
always @(posedge clk or negedge rst_n)
    if (~rst_n)
        led_r <= 4'b0000; //LED 灯灭
    else if (timer == 32'd12_499_999) //计数器计到 0.25 秒，
        led_r <= 4'b0001; //LED0 点亮
	 else if (timer == 32'd24_999_999) //计数器计到 0.5 秒，
        led_r <= 4'b0010; //LED1 点亮
	 else if (timer == 32'd37_499_999) //计数器计到 0.75 秒，
        led_r <= 4'b0100; //LED2 点亮
    else if (timer == 32'd49_999_999) //计数器计到 1 秒，
        led_r <= 4'b1000; //LED3 点亮
    else
        led_r <= led_r;
    
endmodule

