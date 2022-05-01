# Bitmap Processing Library & AXI-Stream Video Image VIP

## Description
To verficate a video or a image processing IP, you may need to read a real image into your design, send its data by an interface. Then, get the output from the interface, and convert it to a new image, save or compare it.   

To solve this complex problem, we design this library, which can help you simplify your design flow. Using a few simple APIs, you can easily read and write standard Bitmap file (.BMP) in your testbench. And, with the AXI-Stream Video Image VIP, you can easily send the image to a standard AXI-Stream video interface which compatible with Xilinx User Guide UG934, receive images from an output interface and save it.  

A bitmap processing library can read and write windows bitmap files (.BMP) into a bit array (virtural memory) by System Verilog for IP Verfication. This library support 24-bit and 32-bit bitmap read in, and 32-bit bitmap write out.  

The AXI-Stream Video Image VIP using the bitmap processing library. The "axi_stream_video_image_in_vip" IP can read a bitmap file into the memory, and send it by a AXI-Stream Video Interface (Defined in Xilinx User Guide UG934). And the "axi_stream_video_image_out_vip" IP can monitor a AXI-Stream interface, obtain a frame which transmitting on the interface and save it to a bitmap file. 

Also, the AXI-Stream Video Image VIP supported bitmap directly operations. You can set bitmap instance to the "in" IP, and get bitmap instance from "out" IP, which is very convenient to automatic verification.

## General Information
Language: System Verilog  
Designer: Deng LiWei  
Date: 2022/04  
License: GPLv3

Supported Bitmaps:    
* Input: 24-bpp/32-bpp RGB/RGBA bitmap  
* Output: 32-bpp RGBA bitmap   

Bitmap Instance:
* Standard class in System Verilog.
* Support "Set Pixel" and "Get Pixel".
* Support any size of bitmap.
* Can create a new bitmap in program and save it.

AXI-Stream Video Interface  
* Supported 1/2/4/8 ppc (pixel per clock) AXI-Stream Video Interface.  
* Full AXIS_TVALID/AXIS_TREADY handshake supported.  
* AXIS_TUSER for start of frame signal, AXIS_TLAST for end of line signal. Compatible with Xilinx User Guide UG934.
* To know more information about the AXI-Stream Video Interface, please refer to the Xilinx User Guide UG934. We recommanded you using this interface for video and image processing IP design.

    NOTE: The "axi_stream_video_image_out_vip" IP has a AXI-Stream Monitor interface, which the AXIS_TVALID and AXIS_TREADY are all input port. When both port are '1', the data on interface be record.

    NOTE: The data order on AXI-Stream interface is "Left pixels on the Least", and the same byte order of bitmap file. If you need another order like "RBGA" or "BGR", you can simply slice the AXIS_TDATA to any order.

## Advantage of this library
* Easy APIs
* Open Source
* Compatible with popular EDA tools (tested on Modelsim and Qustasim)

## Files in package

|File|Description|
|--|--|
|bitmap_processing.sv|Bitmap processing library.
|axi_stream_video_image.sv|AXI stream video image library (for Callback class).
|axi_stream_video_image_in_vip.sv|VIP for reading bitmap and sending it to interface.
|axi_stream_video_image_out_vip.sv|VIP for monitor the interface and save the image to a bitmap.
|axi_stream_video_image_example.sv|Simple example for how to use VIPs and the library.

## Package usage
To use this package, you need import 2 of the package like  

>     import bitmap_processing::*;  
>     import axi_stream_video_image::*;

## APIs for Bitmap Processing library
### **[Class]** Bitmap
This is the base class of bitmap.  
You need to create an instance of this class to use the API functions. An instance of the Bitmap class generally stores and corresponds to one image.

### **[Enum]** Bitmap::BitmapReadError
This is the enumerate of bitmap file reading error.  

|Name|Description|
|--|--|
|BMPR_ERR_OK|No error
|BMPR_ERR_FILE|Error when open the file, file not exist or occupied.
|BMPR_ERR_FILE_FORMAT|The file format is not a bitmap (.BMP) file because the header is not "BM"
|BMPR_ERR_BPP_FORMAT|The file is not a 24-bpp or 32-bpp bitmap file
|BMPR_ERR_BMP_COMPRESSED|The file has been compressed, we can not read it


### **[Enum]** Bitmap::BitmapWriteError
This is the enumerate of bitmap file writing error.  

|Name|Description|
|--|--|
|BMPW_ERR_OK|No error|
|BMPW_ERR_NULL_POINTER|Reserved
|BMPW_ERR_FILE|Error when open and write the file, no permission or occupied

### **[Function]** Bitmap::new()
Create a new bitmap instance

### **[Function]** Bitmap::setPixel(x, y, color)

Write a color to corresponding pixel.

|Parameter|Type|Description|
|--|--|--|
|x|int(32-bit)|Target X coordinate|
|y|int(32-bit)|Target Y coordinate|
|color|bit[31:0]|Color to write to the pixel|

### **[Function]** Bitmap::getPixel(x, y)

Read a color to corresponding pixel.

|Return|Type|Decription|
|--|--|--|
||bit[31:0]|The color on the target pixel

|Parameter|Type|Description|
|--|--|--|
|x|int(32-bit)|Target X coordinate|
|y|int(32-bit)|Target Y coordinate|

### **[Function]** Bitmap::create(width, height)

Create a new 32-bpp bitmap, which the size is $width \cdot height$.


|Parameter|Type|Description|
|--|--|--|
|width|int(32-bit)|Width of the new bitmap(px)|
|height|int(32-bit)|Height of the new bitmap(px)|

### **[Function]** Bitmap::read(fileName)

Read a bitmap file into the instance.

|Return|Type|Decription|
|--|--|--|
||BitmapReadError|Error when reading

|Parameter|Type|Description|
|--|--|--|
|fileName|string|The path of the bitmap file|

### **[Function]** Bitmap::write(fileName)

Write the bitmap instance to a bitmap file.
The instance can be a new image created with the *Bitmap::create*, or a previously read in image.

|Return|Type|Decription|
|--|--|--|
||BitmapWriteError|Error when writing

|Parameter|Type|Description|
|--|--|--|
|fileName|string|The path of the bitmap file|

## Parameters, Interface and Task of axis_video_image_in_vip

### Parameters
|Parameter|Type|Description|
|--|--|--|
|IMAGE_WIDTH|int|The width of the bitmap read in and write to the interface|
|IMAGE_HEIGHT|int|The height of the bitmap read in and write to the interface|
|PIXEL_PER_CLK|int|Pixel per clock on the interface, can be 1, 2, 4 or 8|
|BITS_PER_PIXEL|int|Bits per pixel, fixed 32 bpp|

### Interface
|Port|Type|Direction|Description|
|--|--|--|--|
frameBitmap|Bitmap|ref var|Reference of an bitmap instance, you can create a new instance in your testbench and give it to this.
callbacks|AxisVideoImageCallback|ref var|Callback virtural class of the VIP. The VIP will call the callback function when it completed send a image on the interface. To know how to use this, see the section **Callback Class**.
|clk|logic|input|Clock of AXI-Stream interface|
|m_axis_video_out_tdata|logic|output|Data line of AXI-Stream master interface. This port's width is determined by the parameter PIXEL_PER_CLK.
|m_axis_video_out_tvalid|logic|output|Valid handshake signal of AXI-Stream master interface.
|m_axis_video_out_tlast|logic|output|Last of line signal, when the image at the last pixel of one line, this signal will be '1'.
|m_axis_video_out_tuser|logic|output|Start of frame signal, when the image at the first pixel of a frame, this signal will be '1'.
|m_axis_video_out_tready|logic|input|Ready handshake signal of AXI-Stream master interface. This signal is from your video processing IP. When it is '0', the VIP do not transmit any data on the interface.

### Task
**ReadAndSendBitmap(fileName)**

*fileName (input string):* The file path of the bitmap file.

This task will automatically open and read a bitmap on your disk into the *frameBitmap* instance. And send it to the AXI-Stream interface immediately.

**SendBitmap()**  
This task will send the image in *frameBitmap* to the AXI-Stream interface. You must ensure that there is already an image in the frameBitmap instance, either one you created yourself or one you read from a file.

## Parameters, Interface and Task of axis_video_image_out_vip

|Parameter|Type|Description|
|--|--|--|
|IMAGE_WIDTH|int|The width of the bitmap read in and write to the interface|
|IMAGE_HEIGHT|int|The height of the bitmap read in and write to the interface|
|PIXEL_PER_CLK|int|Pixel per clock on the interface, can be 1, 2, 4 or 8|
|BITS_PER_PIXEL|int|Bits per pixel, fixed 32 bpp|

### Interface
|Port|Type|Direction|Description|
|--|--|--|--|
frameBitmap|Bitmap|ref var|Reference of an bitmap instance, you can create a new instance in your testbench and give it to this.
callbacks|AxisVideoImageCallback|ref var|Callback virtural class of the VIP. The VIP will call the callback function when it completed send a image on the interface. To know how to use this, see the section "Callback Class".
|clk|logic|input|Clock of AXI-Stream interface|
|s_axis_video_in_tdata|logic|input|Data line of AXI-Stream slave interface. This port's width is determined by the parameter PIXEL_PER_CLK.
|s_axis_video_in_tvalid|logic|input|Valid handshake signal monitor of AXI-Stream slave interface.
|s_axis_video_in_tlast|logic|input|Last of line signal, when the image at the last pixel of one line, this signal will be '1'.
|s_axis_video_in_tuser|logic|input|Start of frame signal, when the image at the first pixel of a frame, this signal will be '1'.
|s_axis_video_in_tready|logic|input|Ready handshake signal monitor of AXI-Stream slave interface. 

### Task
**ReceiveAndSaveBitmap(fileName)**

*fileName (input string):* The file path of the bitmap file. Give "" (empty string) to disable write to file.

This task will start listening a new frame on the AXI-Stream monitor interface. When a new frame starting transmission on the interface, the VIP automatically record the image and save it to *frameBitmap* instance. And if you give a *fileName*, also save the bitmap to a BMP file.

## Callback Class
To know when the VIP is done sending and receiving images on interface for the next step, you need to use the Callback virtual class to set the callback function. 

When VIP finishes the current task, it will automatically call the task set inside the callback class, so that you can easily set the flag, do the next operation or end the simulation.

To create a new callback class, use this code

>     class VideoVIPCallback extends AxisVideoImageCallback;  
>         virtual task SentCallback();   
>             // Enter your code here
>         endtask  
>
>         virtual task ReceivedCallback();   
>             // Enter your code here
>         endtask  
>     endclass  

As you can see, you create a new class named *VideoVIPCallback* extends the *AxisVideoImageCallback* class.

The class has 2 virtual task you can implement.  
**SentCallback** will be called automatically after you have sent a complete image to the interface using *axis_stream_video_image_in_vip*.  
**ReceivedCallback** will be called automatically after you have received a complete frame from the interface using *axis_stream_video_image_out_vip*.

When you complete implement the callback tasks, you can instance your class by

>     VideoVIPCallback vcallback = new();

and, create a *AxisVideoImageCallback* instance, give your class to it to convert the type.

>     AxisVideoImageCallback callbacks = vcallback;

Finally, give the *AxisVideoImageCallback* class to the port of VIP, like 


>     axis_video_image_out_vip #(
>        ...
>     )
>     out_vip(
>        ...
>        .callbacks(callbacks),
>        ...
>     );

(Same class can be give both "in_vip" and "out_vip")

## Open Source Licence
This project is fully open source, and follow GNU General Public Licence (GPL).
