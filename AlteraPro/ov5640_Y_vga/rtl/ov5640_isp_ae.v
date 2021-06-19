
module ov5640_isp_ae
(
    //module clock
    input               clk             ,   // 模块驱动时钟
    input               rst_n           ,   // 复位信号
	 input pre_frame_vsync,
	 input pre_frame_hsync,
	 input  [10:0]  pixel_xpos,   //像素点横坐标
    input  [10:0]  pixel_ypos,    //像素点纵坐标 
	 input          pre_frame_de,
	 // 
	 input [7:0] 	  img_y,	 
	 output [7:0]    img_y2,
	 output          post_frame_de    // data enable信号
);

reg [7:0] img_yb;
//wire [7:0] img_y2;
reg  [ 2:0]   pre_frame_de_d   ;

//行列计数器
reg [10:0] h_cnt;
reg [10:0] v_cnt;

assign post_frame_de    = pre_frame_de_d[2];
//assign img_y2 = (pixel_ypos==11'd300||pixel_ypos==11'd500||pixel_ypos==11'd600)?8'd255:img_y ;
//assign img_y2 = (pixel_xpos==11'd300||pixel_xpos==11'd500||pixel_xpos==11'd600)?8'd0:img_y ;
assign img_y2 = img_yb;


always @(posedge clk)begin
	if(pre_frame_hsync)
		h_cnt <= h_cnt + 1'b1;
	else
		h_cnt <= 0;
end 


always @(posedge clk )begin 
	if(~pre_frame_vsync)
		v_cnt <= 0;
	else if(h_cnt==(768-1))
			v_cnt <= v_cnt + 1'b1;	
	else
		v_cnt <= v_cnt;
end
		
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
		img_yb <= 8'h0;
	 end 
	 else begin
		if (h_cnt>=11'd300&&h_cnt<11'd500) begin 
			img_yb <= 8'hff-img_y;
		end 
		else begin 
			img_yb <= img_y;
		end		
	 end 
end 

//延时3拍以同步数据信号
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pre_frame_de_d    <= 3'd0;
    end
    else begin
        pre_frame_de_d    <= {pre_frame_de_d[1:0]   , pre_frame_de   };
    end
end

endmodule  