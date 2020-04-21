`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2020 11:36:01 AM
// Design Name: 
// Module Name: screen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module screen(clk, wr, x_w, y_w, rgb_w, x_r, y_r, rgb_r);
    input clk, wr;
    input [11:0] x_w, y_w, x_r, y_r;
    input wire [11:0] rgb_w;
    output wire [11:0] rgb_r;
    
    integer i, j;
    parameter WIDTH = 480;
    parameter HEIGHT = 270;
    wire [2:0] color;
    
    reg [2:0] mem [HEIGHT - 1:0][WIDTH - 1:0];
    reg [2:0] rom [HEIGHT * WIDTH - 1:0];
    
    initial 
    begin
        $readmemb("intro.list", rom);
        for(i = 0; i < HEIGHT; i = i + 1)
            for(j = 0; j < WIDTH; j = j + 1)
                mem[i][j] = rom[WIDTH * i + j];
    end
    
    color_decode decode(mem[y_r / 4][x_r / 4], rgb_r);
    color_encode encode(rgb_w, color);
    
    always @(posedge clk)
    begin: MEM_WRITE
        if (wr) mem[y_w / 4][x_w / 4] = color;
    end
endmodule
