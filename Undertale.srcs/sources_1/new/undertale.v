`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2020 11:37:48 AM
// Design Name: 
// Module Name: Undertale
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


module undertale(
    input clk,
    input RsRx,
    output RsTx,
    output [3:0] vgaRed, vgaGreen, vgaBlue,
    output Hsync, Vsync
    );
    
//    reg clk = 0;
//    always #1 clk = ~clk;
    
    wire page_num, ena, de;
    wire up, left, down, right, space;
    wire [7:0] command;
    wire [11:0] x, y;
    wire [2:0] intro_rgb, game_rgb; 
    reg [2:0]selected_rgb, rgb_buffer;
    wire [11:0] rgb;
    
    // game component wire
    wire [2:0] hp_rgb, ehp_rgb, box_rgb;
    
    // components On signal
    wire intro_on, game_on, hp_on,ehp_on, box_on;
    
    // Read Image File
    intro_page intro_page(page_num, x, y, intro_rgb, intro_on);
    game_page game_page(clk, page_num, x, y, game_rgb, up, left, down, right, space, game_on);
    
    // decode color
    color_decode color_decode(rgb_buffer, rgb);
    
    
    // game components 
    playerHealthBarComponent hp(.clk(clk),
                                .pageNum(page_num),
                                .x(x),
                                .y(y),
                                .rgbCode(hp_rgb),
                                .hpOn(hp_on)
                                );
    enemyHealthBarComponent ehp(.clk(clk),
                                .pageNum(page_num),
                                .x(x),
                                .y(y),
                                .rgbCode(ehp_rgb),
                                .ehpOn(ehp_on)
                                );
    boxComponent box (.x(x),
                      .y(y),
                      .rgbCode(box_rgb),
                      .boxOn(box_on)
                      );
    
//    assign selected_rgb = (page_num == 0) ? intro_rgb : game_rgb;
    assign {vgaRed, vgaGreen, vgaBlue} = (de) ? rgb : 12'h000;

    // ---------------------------------------------------------------------------
    controller controller(clk, command, ena, de, page_num, up, left, down, right, space);
    vga vga(clk, Hsync, Vsync, x, y, de);
    uart uart(clk, RsRx, RsTx, command, ena);

    always @* begin
        if (page_num==0 && intro_on) begin
            selected_rgb <= intro_rgb;
        end
        else if (page_num==1) begin
            if (game_on) begin
                selected_rgb <= game_rgb;
            end
            else if (hp_on) begin
                selected_rgb <= hp_rgb;
            end
            else if (ehp_on) begin
                selected_rgb <= ehp_rgb;
            end
            else if (box_on) begin
                selected_rgb <= box_rgb;
            end
            else 
                selected_rgb <= 3'b000;
        end
        
        
    end
    
    always @(posedge clk) begin
        rgb_buffer <= selected_rgb;
    end
    
endmodule
