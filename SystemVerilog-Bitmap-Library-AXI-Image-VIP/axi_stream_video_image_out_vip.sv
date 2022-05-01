// System verilog package file
// AXI-Stream video stream image output verification IP (VIP) package
// Designer:    Deng LiWei
// Date:        2022/04
// Description: This VIP can read a single image and make standard AXI-Stream video stream
//    to verify the video or image processing IPs.
//    Note: This VIP using 32BPP RGB stream, the format is BGRA (BBBBBBBB GGGGGGGG RRRRRRRR AAAAAAAA)
//    Note: If the channel order (like RGBA, ARGB, ARBG, etc.) is different from Xilinx standard,
//          you can simply use the slicer to change its order.
//    Note: For more information of the design of AXI-Stream Video Processing System,
//          or the video transmission protocol on AXI-Stream, please see UG934
//          "AXI4-Stream Video IP and System Design Guide" from Xilinx.

import bitmap_processing::*;
import axi_stream_video_image::*;

module axis_video_img_out_vip
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

    // AXI-Stream video input
    // Note: Functions of each wire
    //  TDATA: Pixel data
    //  TVALID & TREADY: Handshake signal, transfer will enable when they both 1
    //  TLAST: End of line
    //  TUSER: Start of frame
    // Note: This is a AXI-Stream Slave Monitor interface, 
    //   which both TVALID & TREADY are input direction.
    //   When they both 1, the monitor received a valid transmission.

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

    input  logic [BITS_PER_PIXEL * PIXEL_PER_CLK - 1:0] s_axis_video_in_tdata,
    input  logic                                        s_axis_video_in_tvalid,
    input  logic                                        s_axis_video_in_tready,
    input  logic                                        s_axis_video_in_tlast,
    input  logic                                        s_axis_video_in_tuser
);

bit inFrame;
logic [BITS_PER_PIXEL * PIXEL_PER_CLK - 1:0] pixel_buffer;
// Bitmap frameBitmap;

// Receive and save the bitmap to a bitmap file
// If the filename is empty, do not save the file, but in the frameBitmap object
task ReceiveAndSaveBitmap(input string fileName);
    fork begin
        automatic bit[31:0] color;
        inFrame = 0;

        frameBitmap = new();
        frameBitmap.create(IMAGE_WIDTH, IMAGE_HEIGHT);

        for (int y = 0; y < IMAGE_HEIGHT; y++) begin
            for (int x = 0; x < IMAGE_WIDTH; ) begin
                @(posedge clk);
                if (s_axis_video_in_tvalid & s_axis_video_in_tready) begin
                    if (s_axis_video_in_tuser) begin
                        inFrame = 1; // This is the first pixel of frame
                        $display("Get a valid frame @%t", $time);
                    end

                    if (inFrame) begin 
                        pixel_buffer = s_axis_video_in_tdata;

                        // Get the pixel
                        if (PIXEL_PER_CLK > 1) begin
                            for (int i = 0; i < PIXEL_PER_CLK; i++) begin
                                color = pixel_buffer[(i + 1) * BITS_PER_PIXEL - 1 -: BITS_PER_PIXEL];
                                frameBitmap.setPixel(x + i, y, color);
                            end
                        end
                        else begin
                            color = pixel_buffer;
                            frameBitmap.setPixel(x, y, color);
                        end

                        if(s_axis_video_in_tlast) begin
                            if (x != IMAGE_WIDTH - PIXEL_PER_CLK) begin
                                // When a unexpected end of line occurs,
                                // give a warning
                                $display("Warning: Unexpected end of line @%t", $time);
                            end
                        end // TLAST

                        if (x == IMAGE_WIDTH - PIXEL_PER_CLK) begin
                            if (!s_axis_video_in_tlast) begin
                                // When a unexpected end of line occurs,
                                // give a warning
                                $display("Warning: No end of line (%d) @%t", y, $time);
                            end
                        end // TLAST 

                        // Increase X
                        x = x + PIXEL_PER_CLK;
                    end // In frame
                end // TVALID
            end // X
        end // Y

        if (fileName != "") begin
            if (frameBitmap.write(fileName) != BMPW_ERR_OK) begin
                $display("Error when writing the bitmap file.");
            end
        end
        
        callbacks.ReceivedCallback();

        $display("A frame of bitmap received, and saved to a bitmap file %s.", fileName);
    end
    join_none
endtask

endmodule


