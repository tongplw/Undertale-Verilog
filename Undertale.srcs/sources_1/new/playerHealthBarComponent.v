`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 11:18:21 AM
// Design Name: 
// Module Name: playerHealthBarComponent
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


module playerHealthBarComponent(
    input pageNum,clk,
    input [11:0] x,
    input [11:0] y,
    output reg [2:0] rgbCode,
    output hpOn
    // TODO: implement on collision event
    );
    
    localparam HP_LENGHT = 100;
    localparam BAR_THICKNESS = 4;
    localparam H_HP_START = 100;
    localparam H_HP_END = H_HP_START + HP_LENGHT;
    localparam V_HP_START = 400;
    localparam V_HP_END = V_HP_START + BAR_THICKNESS;
    
        
    always @(x or y) begin
        // imply game page is on
        if (pageNum) begin 
            
            if (x>=H_HP_START && 
                x<=H_HP_END   &&
                y>=V_HP_START &&
                y<V_HP_END)
            begin
                rgbCode <= 3'b111;
            end
            
            else
                rgbCode <= 3'b000;
        end
    end 
    
    // On signal
    assign hpOn = (rgbCode == 3'b111) ? 1:0;
endmodule
