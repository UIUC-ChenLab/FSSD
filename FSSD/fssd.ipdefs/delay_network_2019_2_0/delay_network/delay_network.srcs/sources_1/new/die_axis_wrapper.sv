`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2022 06:33:23 AM
// Design Name: 
// Module Name: die_axis_wrapper
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


module die_axis_wrapper#
(
    parameter integer C_NUM_SLOTS                   = 16,
    parameter integer C_NUM_PLANES                  = 8,
    parameter integer C_AXIS_TID_WIDTH              = 12,
    //parameter integer C_AXIS_TDATA_WIDTH            = 128,
    parameter integer C_AXIS_M_TUSER_WIDTH          = 2,
    parameter integer C_AXIS_TUSER_WIDTH            = 34,
    parameter integer C_AXIS_TDEST_WIDTH            = 8,
    parameter integer DOWNCNT_WIDTH                 = 16,
    parameter integer PB_HIT                        = 20,
    parameter integer PB_MISS                       = 1000,
    parameter integer PB_WRITE                      = 1000,
    parameter integer PB_ERASE                      = 1000,
    parameter integer MODE_HIGH_ADDR                = 33,   // Where we slice into tuser
    parameter integer MODE_LOW_ADDR                 = 32,
//    parameter integer SIZE_HIGH_ADDR                = 40,
//    parameter integer SIZE_LOW_ADDR                 = 32,
    parameter integer ADDR_HIGH_ADDR                = 31,
    parameter integer ADDR_LOW_ADDR                 = 0,

    localparam PB_ADDR_WIDTH                        = ADDR_HIGH_ADDR - ADDR_LOW_ADDR + 1,
    localparam MODE_WIDTH                           = MODE_HIGH_ADDR - MODE_LOW_ADDR + 1,
    localparam TDEST_WIDTH                          = 3
    
)
(
    // Slave ports
    output  wire [C_NUM_SLOTS-1:0]                      s_axis_tready,
    input   wire [C_NUM_SLOTS*C_AXIS_TID_WIDTH-1:0]     s_axis_tid,
    //input   wire [C_NUM_SLOTS*C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata,
    input   wire [C_NUM_SLOTS*C_AXIS_TUSER_WIDTH-1:0]   s_axis_tuser,
    input   wire [C_NUM_SLOTS-1:0]                      s_axis_tvalid,    
    input   wire [C_NUM_SLOTS*C_AXIS_TDEST_WIDTH-1:0]   s_axis_tdest,
    
    // Master ports
    input   wire                                        aclk,
    input   wire                                        aresetn,
    output  wire [C_NUM_SLOTS-1:0]                      m_axis_tvalid,
    output  wire [C_NUM_SLOTS*C_AXIS_TID_WIDTH-1:0]     m_axis_tid,
    output  wire [C_NUM_SLOTS*C_AXIS_M_TUSER_WIDTH-1:0]   m_axis_tuser,
    output  wire [C_NUM_SLOTS-1:0]                      m_axis_tlast,
    input   wire [C_NUM_SLOTS-1:0]                      m_axis_tready
    
);

    

generate
    genvar i;
    
    for (i=0; i<C_NUM_SLOTS; i = i + 1) begin
        multiplane_die #(
            .C_NUM_PLANES(C_NUM_PLANES),
            .MODE_HIGH_ADDR(MODE_HIGH_ADDR),
            .MODE_LOW_ADDR(MODE_LOW_ADDR),
            .ADDR_HIGH_ADDR(ADDR_HIGH_ADDR),
            .ADDR_LOW_ADDR(ADDR_LOW_ADDR),
//            .SIZE_HIGH_ADDR(SIZE_HIGH_ADDR),
//            .SIZE_LOW_ADDR(SIZE_LOW_ADDR),     
            .C_AXIS_TID_WIDTH(C_AXIS_TID_WIDTH),  
            .C_AXIS_M_TUSER_WIDTH(C_AXIS_M_TUSER_WIDTH),
            //.C_AXIS_TDATA_WIDTH(C_AXIS_TDATA_WIDTH),
            .C_AXIS_TUSER_WIDTH(C_AXIS_TUSER_WIDTH),
            .DOWNCNT_WIDTH(DOWNCNT_WIDTH),
            .PB_HIT(PB_HIT),
            .PB_MISS(PB_MISS),
            .PB_WRITE(PB_WRITE),
            .PB_ERASE(PB_ERASE)
        ) die (
            .aclk           (aclk),
            .aresetn        (aresetn),
            .s_axis_tready  (s_axis_tready  [i +: 1]),
            .s_axis_tid     (s_axis_tid     [i*C_AXIS_TID_WIDTH +: C_AXIS_TID_WIDTH]),
            //.s_axis_tdata   (s_axis_tdata   [i*C_AXIS_TDATA_WIDTH +: C_AXIS_TDATA_WIDTH]),
            .s_axis_tuser   (s_axis_tuser   [i*C_AXIS_TUSER_WIDTH +: C_AXIS_TUSER_WIDTH]),
            .s_axis_tvalid  (s_axis_tvalid  [i +: 1]),
            .s_axis_tdest   (s_axis_tdest   [i*C_AXIS_TDEST_WIDTH +: TDEST_WIDTH]),
            .m_axis_tready  (m_axis_tready  [i +: 1]),
            .m_axis_tid     (m_axis_tid     [i*C_AXIS_TID_WIDTH +: C_AXIS_TID_WIDTH]),
            .m_axis_tuser   (m_axis_tuser   [i*C_AXIS_M_TUSER_WIDTH +: C_AXIS_M_TUSER_WIDTH]),
            .m_axis_tlast   (m_axis_tlast   [i +: 1]),
            .m_axis_tvalid  (m_axis_tvalid  [i +: 1])
        );
        
    end
endgenerate

endmodule