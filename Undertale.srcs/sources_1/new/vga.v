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
    output [11:0] rgb,
    output [11:0] x, y,
    input [2:0] encoded_rgb
    );
    
    // Custom Clock Divider
//    reg new_clk = 0;
//    integer n = 0;
//    always @(posedge clk) begin
//        n = n + 1;
//        if (n == 2) begin
//            n = 0;
//            new_clk = ~new_clk;
//        end
//    end

    reg [15:0] cnt;
    reg pix_stb; 
    always @(posedge clk)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000


    parameter WIDTH = 640;
    parameter HEIGHT = 480;
    parameter H_FP = 16 , H_SYNC =96 , H_BP = 48;
    parameter V_FP = 10 , V_SYNC =2 , V_BP = 33;
    parameter H_TOTAL = 800;
    parameter V_TOTAL = 525;
    
    reg line_clk = 0;
    reg [9:0] h_val = 0, v_val = 0;
    
//    color_decode color_decode(encoded_rgb, rgb);
    assign rgb = 12'h0f0;
    
    assign x = (h_val >= H_BP + H_SYNC + H_BP) ? (h_val - H_BP - H_SYNC - H_BP) / 4 : 0;
    assign y = (v_val >= V_BP + V_SYNC + V_BP) ? (v_val - V_BP - V_SYNC - V_BP) / 4 : 0;
    assign Hsync = ~((h_val >= H_FP) & (h_val < H_FP + H_SYNC));
    assign Vsync = ~((v_val >= V_FP) & (v_val < V_FP + V_SYNC));

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
    
endmodule
