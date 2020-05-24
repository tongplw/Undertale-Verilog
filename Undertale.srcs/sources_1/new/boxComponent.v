`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 02:30:03 PM
// Design Name: 
// Module Name: boxComponent
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


module boxComponent(
    input [11:0] x,y,
    output reg [2:0] rgbCode,
    output boxOn
    );
    
    // local params
    integer thickness = 3;        
    integer left_boundary = 200;  
    integer right_boundary = 440; 
    integer top_boundary = 120;   
    integer bottom_boundary = 360;
    
    // On signal 
    assign boxOn = (rgbCode == 3'b111) ? 1:0;
    
    always @(x or y) begin
        // box                                                                                                                            
        if ((x>=left_boundary-thickness && x<left_boundary && y>=top_boundary-thickness && y<bottom_boundary+thickness) ||                
                 (x>=right_boundary && x<right_boundary+thickness && y>=top_boundary-thickness && y<bottom_boundary+thickness) ||         
                 (y>=top_boundary-thickness && y<top_boundary && x>=left_boundary-thickness && x<right_boundary+thickness) ||             
                 (y>=bottom_boundary && y<bottom_boundary+thickness && x>=left_boundary-thickness && x<right_boundary+thickness))         
        begin                                                                                                                             
            rgbCode <= 3'b111;                                                                                                                
        end    
        else 
            rgbCode <= 3'b000;                                                                                                                           
    end
endmodule
