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
    
    localparam hitDamage = 5;
    
    wire [1:0] page_num;
    wire ena, de;
    wire up, left, down, right, space;
    wire [7:0] command;
    wire [11:0] x, y;
    wire [2:0] intro_rgb, game_rgb, faim_rgb, selected_rgb;
    wire [11:0] rgb;
    wire game_on, faim_on;
    wire [1:0] selection;
    wire game_over, defeat_enemy, damage, collision1, collision2, end_fight;
    
    reg [5:0] player_hp = 20;
    reg [5:0] monster_hp = 20;
    wire move_enable;
    wire monster_damage;
    wire monster_damage_enable;
    
    // Read Image File
    intro_page intro_page(x, y, intro_rgb);
    menu_page menu_page(clk, page_num==1, x, y, faim_rgb, left, right, selection, player_hp, monster_hp);
    game_page game_page(clk, page_num==2, x, y, game_rgb, up, left, down, right, space,
                        game_over, defeat_enemy, player_hp, monster_hp, collision1,
                        collision2, page_num, end_fight, move_enable, monster_damage, monster_damage_enable);
    color_decode color_decode(selected_rgb, rgb);
    
    assign selected_rgb = (page_num == 0) ? intro_rgb : (page_num == 1) ? faim_rgb : game_rgb;
    assign {vgaRed, vgaGreen, vgaBlue} = (de) ? rgb : 12'h000;

    // ---------------------------------------------------------------------------
    controller controller(clk, command, ena, de, selection, move_enable, page_num, up, left, down, right, space, 
                          game_over, defeat_enemy, damage, end_fight);
    vga vga(clk, Hsync, Vsync, x, y, de);
    uart uart(clk, RsRx, RsTx, command, ena);
    
    
    always @(posedge clk) begin
        if (monster_damage_enable) begin
            monster_hp = (monster_hp - monster_damage <= 0) ? 0 : monster_hp - monster_damage;
        end
        if (collision1) begin
            player_hp = (player_hp - hitDamage <=0) ? 0 : player_hp - hitDamage;
        end
        if (collision2) begin
            player_hp = (player_hp - hitDamage <=0) ? 0 : player_hp - hitDamage;
        end
    end
    
endmodule
