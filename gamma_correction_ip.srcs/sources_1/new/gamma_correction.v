`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 12:01:56 AM
// Design Name: 
// Module Name: gamma_correction
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


module gamma_correction#(parameter DATA_WIDTH=32)
   (
    input    axi_clk,
    input    axi_reset_n,
    //AXI4-S slave i/f
    input    s_axis_valid,
    input [DATA_WIDTH-1:0] s_axis_data,
    output   s_axis_ready,
    //AXI4-S master i/f
    output reg  m_axis_valid,
    output reg [DATA_WIDTH-1:0] m_axis_data,
    input    m_axis_ready
    );
    
    integer i;
    wire [DATA_WIDTH-1:0] lut_value;
    reg [DATA_WIDTH-1:0] pixel_value;
    gamma_lut lut_instance0(
        .index(pixel_value[7:0]),
        .value(lut_value[7:0])
    );
    gamma_lut lut_instance1(
        .index(pixel_value[15:8]),
        .value(lut_value[15:8])
    );  
    gamma_lut lut_instance2(
        .index(pixel_value[23:16]),
        .value(lut_value[23:16])
    );  
    gamma_lut lut_instance3(
        .index(pixel_value[31:24]),
        .value(lut_value[31:24])
    );    
    
    assign s_axis_ready = m_axis_ready;
    
    always @(posedge axi_clk)
    begin
       if(s_axis_valid & s_axis_ready)
       begin
           for(i=0;i<DATA_WIDTH/8;i=i+1)
           begin
              pixel_value[i*8+:8] <= s_axis_data[i*8+:8];
              m_axis_data[i*8+:8] <= lut_value[i*8+:8]; 
           end 
       end
    end
    
    always @(posedge axi_clk)
    begin
        m_axis_valid <= s_axis_valid;
    end

endmodule
