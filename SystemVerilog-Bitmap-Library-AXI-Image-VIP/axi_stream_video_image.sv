// System verilog package file
// AXI-Stream video stream image library
// Designer:    Deng LiWei
// Date:        2022/04
// Description: This library is includes a class which is the base class of the virtual callbacks
//     for the AXI-Stream Video Image In/Out VIPs

package axi_stream_video_image;
    class AxisVideoImageCallback;
        virtual task SentCallback(); endtask
        virtual task ReceivedCallback(); endtask
    endclass // AxisVideoImageCallback
endpackage

