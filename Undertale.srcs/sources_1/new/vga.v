`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2020 11:04:45 AM
// Design Name: 
// Module Name: vga
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


module vga(
    input clk,
    output Hsync, Vsync,
    output [11:0] x, y,
    output de
    );
    
    // clock divider from 100 MHz to 25 MHz    
    reg [15:0] cnt;
    reg pix_stb; 
    always @(posedge clk)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    parameter WIDTH = 640;
    parameter HEIGHT = 480;
    parameter H_FP = 16, H_SYNC = 96, H_BP = 48;
    parameter V_FP = 10, V_SYNC = 2, V_BP = 33;
    parameter H_TOTAL = 800;
    parameter V_TOTAL = 525;

    parameter HS_START = WIDTH + H_FP;
    parameter HS_END = WIDTH + H_FP + H_SYNC;
    parameter VS_START = HEIGHT + V_FP;
    parameter VS_END = HEIGHT + V_FP + V_SYNC;
    
//    parameter HA_START = H_FP + H_SYNC + H_BP;
//    parameter VA_END = HEIGHT;
    
    reg line_clk = 0;
    reg [9:0] h_val = 0, v_val = 0;
    
    assign x = (h_val < WIDTH) ? h_val / 4 : 0;
    assign y = (v_val < HEIGHT) ? v_val / 4 : 0;
    assign Hsync = (h_val <= HS_START) || (h_val >= HS_END);
    assign Vsync = (v_val <= VS_START) || (v_val >= VS_END);

    // HSYNC
    always @(posedge pix_stb)
    begin
        if (h_val >= H_TOTAL) begin h_val = 0; line_clk = 1; end
        else begin h_val = h_val + 1; line_clk = 0; end
    end
    
    // VSYNC
    always @(posedge line_clk)
    begin
        if (v_val >= V_TOTAL) v_val = 0;
        else v_val = v_val + 1;
    end
    
    // DISPLAY ENABLE
    assign de = (h_val < H_TOTAL) && (v_val < V_TOTAL);
    
endmodule
