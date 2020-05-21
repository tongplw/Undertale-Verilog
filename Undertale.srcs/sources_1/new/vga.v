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
    
    parameter WIDTH = 1920;
    parameter HEIGHT = 1080;
    parameter H_BACK_PORCH = 148;
    parameter V_BACK_PORCH = 36;
    parameter H_TOTAL = 2200;
    parameter V_TOTAL = 1125;
    
    reg line_clk = 0;
    reg [15:0] h_val = 0, v_val = 0;
    
    color_decode color_decode(encoded_rgb, rgb);
    
    assign x = (h_val >= H_BACK_PORCH & h_val < WIDTH + H_BACK_PORCH) ? (h_val - H_BACK_PORCH) / 4 : 0;
    assign y = (v_val >= V_BACK_PORCH & v_val < HEIGHT + V_BACK_PORCH) ? (v_val - V_BACK_PORCH) / 4 : 0;
    assign Hsync = (h_val < WIDTH + H_BACK_PORCH) ? 1 : 0;
    assign Vsync = (v_val < HEIGHT + V_BACK_PORCH) ? 1 : 0;

    // HSYNC
    always @(posedge clk)
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
