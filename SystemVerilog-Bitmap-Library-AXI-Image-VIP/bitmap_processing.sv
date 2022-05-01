// System verilog package file
// Bitmap processing library
// Designer:    Deng LiWei
// Date:        2022/04
// Description: This library is a Bitmap library which can open or save a bitmap(BMP)
//     image in Verilog. The pixel data will storage in a array.

package bitmap_processing;
    `define DEFAULT_BMP_HEADER 'h424D

    typedef enum bit[3:0]
    {
        BMPR_ERR_OK,
        BMPR_ERR_FILE,
        BMPR_ERR_FILE_FORMAT,
        BMPR_ERR_BPP_FORMAT,
        BMPR_ERR_BMP_COMPRESSED
    } BitmapReadError;

    typedef enum bit[3:0]
    {
        BMPW_ERR_OK,
        BMPW_ERR_NULL_POINTER,
        BMPW_ERR_FILE
    }BitmapWriteError;

    typedef struct{
        bit[31:0] biSize;
        bit[31:0] biWidth;
        bit[31:0] biHeight;
        bit[15:0] biPlanes;
        bit[15:0] biBitCount;
        bit[31:0] biCompression;
        bit[31:0] biSizeImage;
        bit[31:0] biXPelsPerMeter;
        bit[31:0] biYPelsPerMeter;
        bit[31:0] biClrUsed;
        bit[31:0] biClrImportant;
    }BitmapHead;

    class Bitmap;
        int width, height;
        bit [15:0] bitCount;
        bit [31:0] image[][];

        BitmapHead head;

        function new();

        endfunction // new

        function void setPixel(int x, int y, bit [31:0] color);
            if ((x < 0) || (x > width) || (y < 0) || (y > height)) begin
                $display("Out of write operation range, (%d, %d)", x, y);
            end

            image[y][x] = color;
        endfunction // setPixel(x, y, color)

        function bit[31:0] getPixel(int x, int y);
            if ((x < 0) || (x > width) || (y < 0) || (y > height)) begin
                $display("Out of read operation range, (%d, %d)", x, y);
            end

            return image[y][x];
        endfunction // getPixel(x, y)

	    function void create(int width, int height);
            this.width = width; 
            this.height = height;

            image = new[height];
            foreach(image[i]) begin
                image[i] = new[width];
            end

            head.biClrImportant = 0;
            head.biClrUsed = 0;
            head.biCompression = 'h00;
            head.biHeight = BE2LE32(height);
            head.biPlanes = BE2LE16(1);
            head.biSize = BE2LE32(40);
            head.biSizeImage = BE2LE32(width * height * 4);
            head.biWidth = BE2LE32(width);
            head.biXPelsPerMeter = 0;
            head.biYPelsPerMeter = 0;
            head.biBitCount = BE2LE16(32);

            $display("Created a bitmap (%d x %d).", width, height);
        endfunction // create(width, height)

        function BitmapReadError read(string fileName);
            int fp;
            bit[15:0] bitmapIdentify;
            bit[31:0] bitmapFileSize;
            bit[31:0] bitmapDataOffset;
            bit[7:0] color24[0:2];

            fp = $fopen(fileName, "rb");


            if (!fp) begin 
                $error("Could not open the file %s.", fileName); 
                return BMPR_ERR_FILE; 
            end 
           
            $fread(bitmapIdentify, fp);
            
            if (bitmapIdentify != `DEFAULT_BMP_HEADER) begin
                $error("The target file %s is not a bitmap file.", fileName);
                return BMPR_ERR_FILE_FORMAT;
            end

            $fread(bitmapFileSize, fp);
            $fseek(fp, 4, 1);
            $fread(bitmapDataOffset, fp);

            readBitmapInfoHead(fp);

            // We do not want to decode 8bpp or 16bpp images,
            // compatible format is 24bpp or 32bpp, no compression
            if ((bitCount != 24) && (bitCount != 32)) begin
                return BMPR_ERR_BPP_FORMAT;
            end

            if (head.biCompression != 'h00) begin // 0x00: BI_RGB, no compression
                return BMPR_ERR_BMP_COMPRESSED;
            end

            $display("Start read a bitmap (%d x %d).", width, height);

            // Create the array space to storage the image data
            image = new[height];
            foreach (image[i]) begin
                image[i] = new[width];
            end

            // Read the image pixels
            $fseek(fp, BE2LE32(bitmapDataOffset), 0);

            for (int y = height - 1; y >= 0; y--) begin
                if (bitCount == 32) begin // 32 bpp (BGRA)
                    $fread(image[y], fp, 0, width);
                end
                else begin
                    for (int x = 0; x < width; x++) begin
                        $fread(color24, fp, 0, 3);
                        image[y][x] = {color24[0], color24[1], color24[2], 8'hFF};
                    end
                end
            end

            $fclose(fp);

            return BMPR_ERR_OK;
        endfunction // read(filename)

        function BitmapWriteError write(string fileName);
            int fp;
            bit[15:0] bitmapIdentify;
            bit[31:0] bitmapFileSize;
            bit[31:0] bitmapDataOffset;
            bit[7:0]  bitmapHeader[];
            bit[7:0]  bitmapHead[0:39];

            bitmapHeader = new[14];

            fp = $fopen(fileName, "wb+");

            if (!fp) begin 
                $error("Could not open and write the file %s.", fileName); 
                return BMPR_ERR_FILE; 
            end 

            $display("Writing a bitmap (%d x %d) to file %s.", width, height, fileName);

            WR16BUF(`DEFAULT_BMP_HEADER, 0, 0, bitmapHeader);
            WR32BUF(BE2LE32(head.biSizeImage) + 54, 2, 1, bitmapHeader);
            WR32BUF(32'd54, 10, 1, bitmapHeader);
            
            foreach (bitmapHeader[i]) begin 
                $fwrite(fp, "%c", bitmapHeader[i]);
            end
            
            {>>{bitmapHead}} = head;
            foreach (bitmapHead[i]) begin
                $fwrite(fp, "%c", bitmapHead[i]);
            end

            for (int y = height - 1; y >= 0; y--) begin
                for (int x = 0; x < width; x++) begin
                    $fwrite(fp, "%u", BE2LE32(image[y][x]));
                end
            end

            $fclose(fp);

            $display("Bitmap wrote.");

            return BMPW_ERR_OK;
        endfunction
        
        function void readBitmapInfoHead(int fp);
            BitmapHead head;

            $fseek(fp, 14, 0);
            $fread(head, fp, 0, 40);

            this.head = head;

            bitCount = BE2LE16(head.biBitCount);
            width = BE2LE32(head.biWidth);
            height = BE2LE32(head.biHeight);
        endfunction

        function bit[15:0] BE2LE16(bit[15:0] x);
            return {x[7:0], x[15:8]};
        endfunction

        function bit[31:0] BE2LE32(bit[31:0] x);
            return {x[7:0], x[15:8], x[23:16], x[31:24]};
        endfunction

        function void WR16BUF(bit[15:0] x, int offset, bit rev, ref bit[7:0] buff[]);
            bit[15:0] data;
            if (rev) begin
                data = BE2LE16(x);
            end
            else begin
                data = x;
            end 

            buff[offset] = data[15:8];
            buff[offset + 1] = data[7:0];
        endfunction

        function void WR32BUF(bit[31:0] x, int offset, bit rev, ref bit[7:0] buff[]);
            bit[31:0] data;
            if (rev) begin
                data = BE2LE32(x);
            end
            else begin
                data = x;
            end 

            buff[offset]     = data[31:24];
            buff[offset + 1] = data[23:16];
            buff[offset + 2] = data[15:8];
            buff[offset + 3] = data[7:0];
        endfunction
    endclass //Bitmap
endpackage


