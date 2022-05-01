// System verilog package file
// AXI-Stream video stream image input verification IP (VIP) package
// Designer:    Deng LiWei
// Date:        2022/04
// Description: This VIP can read a single image and make standard AXI-Stream video stream
//    to verify the video or image processing IPs.
//    Note: This VIP using 32BPP RGB stream, if you only need one of the channel,
//          or YUV format, pleast connect slicer or converter after this
//    Note: We do not change the byte order from Bitmap file, and directly send it to stream.
//          So if the channel order (like RGBA, ARGB, ARBG, etc.) is different from Xilinx standard,
//          you can simply use the slicer to change its order.
//    Note: For more information of the design of AXI-Stream Video Processing System,
//          or the video transmission protocol on AXI-Stream, please see UG934
//          "AXI4-Stream Video IP and System Design Guide" from Xilinx.

import bitmap_processing::*;
import axi_stream_video_image::*;

module axis_video_img_in_vip
#(
    // Image size
    parameter IMAGE_WIDTH = 960,
    parameter IMAGE_HEIGHT = 540,

    // Pixel per clock, can be 1, 2, 4 or 8
    parameter PIXEL_PER_CLK = 1,

    // Bits per pixel, fixed 32bpp
    parameter BITS_PER_PIXEL = 32
)
(
    // Target bitmap
    ref Bitmap frameBitmap,

    // Callback class
    ref AxisVideoImageCallback callbacks,

    // Clock
    input logic clk,

    // AXI-Stream video output
    // Note: Functions of each wire
    //  TDATA: Pixel data
    //  TVALID & TREADY: Handshake signal, transfer will enable when they both 1
    //  TLAST: End of line
    //  TUSER: Start of frame

    // Waveform
    //           +-+ +-+ +-+ +-+    +-+ +-+ +-+ +-+ +-+     +-+ +-+ +-+ +-+
    // CLK     --+ +-+ +-+ +-+ +-//-+ +-+ +-+ +-+ +-+ +-//--+ +-+ +-+ +-+ +--
    // 
    //               +---+---+---//-+---+---+             --+---+---+---+
    // TDATA   ------+0,0|1,0|2,0   |y,0|z,0+-----------//  |x,1|y,1|z,1+-----
    //               +---+---+---//-+---+---+             --+---+---+---+
    //                                   End of line 0               End of line 1
    //           +-------+          +-----------+           +-----------+
    // TVALID  --+       +-------//-+           +-------//--+           +-----
    // 
    //               +-------+      +-------+               +-----------+
    // TREADY  ------+       +---//-+       +-----------//--+           +-----
    // 
    //               +---+
    // TUSER   ------+   +-------//---------------------//--------------------
    // 
    //                                   +--+                        +--+
    // TLAST   ------------------//------+  +-----------//-----------+  +-----

    output logic [BITS_PER_PIXEL * PIXEL_PER_CLK - 1:0] m_axis_video_out_tdata,
    output logic                                        m_axis_video_out_tvalid,
    output logic                                        m_axis_video_out_tlast,
    output logic                                        m_axis_video_out_tuser,
    input  logic                                        m_axis_video_out_tready
);

logic [BITS_PER_PIXEL * PIXEL_PER_CLK - 1:0] pixel_buffer;
//Bitmap frameBitmap;

initial begin
    m_axis_video_out_tdata = 'h0;
    m_axis_video_out_tuser = 'b0;
    m_axis_video_out_tlast = 'b0;
    m_axis_video_out_tvalid = 'b0;
end

// Read a bitmap file and send it to AXI-Stream interface immediately
task ReadAndSendBitmap(input string fileName);
    frameBitmap = new();
    frameBitmap.read(fileName);

    SendBitmap();
endtask

// Send current bitmap file to AXI-Stream interface 
task SendBitmap();
    fork begin
        automatic bit[31:0] color;
        
        if ((frameBitmap.width != IMAGE_WIDTH) || (frameBitmap.height != IMAGE_HEIGHT)) begin
            $display("Error: Bitmap size is not meet VIP setting");
        end
        else begin
            for (int y = 0; y < IMAGE_HEIGHT; y++) begin
                for (int x = 0; x < IMAGE_WIDTH; ) begin
                    pixel_buffer = 0;

                    if (PIXEL_PER_CLK > 1) begin
                        for (int i = 0; i < PIXEL_PER_CLK; i++) begin
                            color = frameBitmap.getPixel(x + i, y);
                            pixel_buffer = {color, pixel_buffer[BITS_PER_PIXEL * PIXEL_PER_CLK - 1 : BITS_PER_PIXEL]};
                        end
                    end
                    else begin
                        color = frameBitmap.getPixel(x, y);
                        pixel_buffer = color;
                    end

                    m_axis_video_out_tdata = pixel_buffer;
                    m_axis_video_out_tuser = (x == 0) && (y == 0);
                    m_axis_video_out_tlast = (x == IMAGE_WIDTH - PIXEL_PER_CLK);
                    m_axis_video_out_tvalid = 'b1;

                    @(posedge clk);
                    if (m_axis_video_out_tready) begin
                        x = x + PIXEL_PER_CLK;
                    end
                end // X
            end // Y

            m_axis_video_out_tvalid = 'b0;

            $display("A frame of bitmap sent.");
            callbacks.SentCallback();
        end // Size determine
    end
    join_none 
endtask

endmodule

