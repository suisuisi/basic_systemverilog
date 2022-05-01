
import bitmap_processing::*;
import axi_stream_video_image::*;

module axi_stream_video_image_example();
    // Bitmaps
    Bitmap inputBitmap;
    Bitmap outputBitmap;

    // Interfaces
    logic        clk;
    logic [31:0] m_axis_video_out_tdata;
    logic        m_axis_video_out_tvalid;
    logic        m_axis_video_out_tlast;
    logic        m_axis_video_out_tuser;
    logic        m_axis_video_out_tready;

    logic [31:0] s_axis_video_in_tdata;
    logic        s_axis_video_in_tvalid;
    logic        s_axis_video_in_tlast;
    logic        s_axis_video_in_tuser;
    logic        s_axis_video_in_tready;

    assign s_axis_video_in_tdata  = m_axis_video_out_tdata; // | 'hFF;
    assign s_axis_video_in_tvalid = m_axis_video_out_tvalid;
    assign s_axis_video_in_tlast  = m_axis_video_out_tlast;
    assign s_axis_video_in_tuser  = m_axis_video_out_tuser;
    assign s_axis_video_in_tready = m_axis_video_out_tready;

    // Callback class
    class VideoVIPCallback extends AxisVideoImageCallback;
        virtual task SentCallback(); 
            $display("Sent");
        endtask

        virtual task ReceivedCallback(); 
            $display("Received");
            $stop();
        endtask
    endclass

    VideoVIPCallback vcallback = new();
    AxisVideoImageCallback callbacks = vcallback;

    axis_video_img_in_vip #(
        .IMAGE_WIDTH(960),
        .IMAGE_HEIGHT(540),
        .PIXEL_PER_CLK(1)
    )
    in_vip
    (
        .*,
        .frameBitmap(inputBitmap),
        .callbacks(callbacks)
    );

    axis_video_img_out_vip #(
        .IMAGE_WIDTH(960),
        .IMAGE_HEIGHT(540),
        .PIXEL_PER_CLK(1)
    )
    out_vip
    (
        .*,
        .frameBitmap (outputBitmap),
        .callbacks(callbacks),
    );


    always begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        for(int i = 0; i < 10; i++) begin
            @(posedge clk);
        end
    
        out_vip.ReceiveAndSaveBitmap("out.bmp");
        in_vip.ReadAndSendBitmap("in.bmp");
    end
endmodule

