`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2022 05:19:41 PM
// Design Name: 
// Module Name: delay_network_wrapper
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


module delay_network_wrapper #(
    // architecture config
    parameter integer NUM_CHANNEL                   = 16,
    parameter integer CHANNEL                       = 16,
    parameter integer DIE_PER_CHANNEL               = 1,
    parameter integer PLANE_PER_DIE                 = 1,
    parameter integer PAGE_BUFFER_SIZE              = 4096,
    // interface parameter
    parameter integer C_AXIS_TDATA_WIDTH            = 64,
    parameter integer C_AXIS_TID_WIDTH              = 4,
    parameter integer C_AXIS_M_TUSER_WIDTH          = 2,
    parameter integer C_AXIS_TDEST_WIDTH            = 12,
    parameter integer C_AXIS_SND_TDEST_WIDTH        = 8,
    parameter integer C_AXIS_TUSER_WIDTH            = 34,
    parameter integer DOWNCNT_WIDTH                 = 16,
    parameter integer TAG_HIGH_ADDR                 = 37,
    parameter integer TAG_LOW_ADDR                  = 34,
    parameter integer MODE_HIGH_ADDR                = 33,
    parameter integer MODE_LOW_ADDR                 = 32,
    parameter integer ADDR_HIGH_ADDR                = 31,
    parameter integer ADDR_LOW_ADDR                 = 0,
    // NAND flash latency
    parameter integer PB_HIT                        = 2,
    parameter integer PB_MISS                       = 1748,
    parameter integer PB_WRITE                      = 15385,
    parameter integer PB_ERASE                      = 34965,
    parameter integer CHANNEL_CONTENTION_LAT        = 4
)
(
    input   logic                           clk,
    input   logic                           arstn,
    // s01_axis
    input   logic [C_AXIS_TDATA_WIDTH-1:0]  s01_axis_tdata,
    input   logic                           s01_axis_tlast,
    input   logic                           s01_axis_tvalid,
    output  logic                           s01_axis_tready,
    // m01_axis
    output  logic [C_AXIS_TID_WIDTH-1:0]    m01_axis_tid,
    output  logic [C_AXIS_M_TUSER_WIDTH-1:0]  m01_axis_tuser,
    output  logic                           m01_axis_tvalid,
    input   logic                           m01_axis_tready
);
    
logic [C_AXIS_TID_WIDTH-1:0]        itf2dn_tid;
logic [C_AXIS_TDEST_WIDTH-1:0]      itf2dn_tdest;
logic [C_AXIS_TUSER_WIDTH-1:0]      itf2dn_tuser;
logic                               itf2dn_tvalid;    
logic                               itf2dn_tready;

logic [C_AXIS_M_TUSER_WIDTH-1:0]    dn2itf_tuser;
logic [C_AXIS_TID_WIDTH-1:0]        dn2itf_tid;
logic                               dn2itf_tlast;
logic                               dn2itf_tready;
logic                               dn2itf_tvalid;

logic [NUM_CHANNEL-1:0]                     dn_in_tvalid;
logic [NUM_CHANNEL-1:0]                     dn_in_tready;
logic [NUM_CHANNEL*C_AXIS_TID_WIDTH-1:0]    dn_in_tid;
logic [NUM_CHANNEL*C_AXIS_TDEST_WIDTH-1:0]  dn_in_tdest;
logic [NUM_CHANNEL*C_AXIS_TUSER_WIDTH-1:0]  dn_in_tuser;

logic [NUM_CHANNEL-1:0]                     dn_out_tvalid;
logic [NUM_CHANNEL-1:0]                     dn_out_tready;
logic [NUM_CHANNEL-1:0]                     dn_out_tlast;
logic [NUM_CHANNEL*C_AXIS_TID_WIDTH-1:0]    dn_out_tid;
logic [NUM_CHANNEL*C_AXIS_M_TUSER_WIDTH-1:0]  dn_out_tuser;

interface_logic #(
    .TDATA_WIDTH(C_AXIS_TDATA_WIDTH),
    .TDEST_WIDTH(C_AXIS_TDEST_WIDTH),
    .TAG_HIGH_ADDR(TAG_HIGH_ADDR),
    .TAG_LOW_ADDR(TAG_LOW_ADDR),
    .MODE_HIGH_ADDR(MODE_HIGH_ADDR),
    .MODE_LOW_ADDR(MODE_LOW_ADDR),
    .ADDR_HIGH_ADDR(ADDR_HIGH_ADDR),
    .ADDR_LOW_ADDR(ADDR_LOW_ADDR),
    .S_TUSER_WIDTH(C_AXIS_M_TUSER_WIDTH),
    .NUM_CHANNEL(CHANNEL),
    .DIE_PER_CHANNEL(DIE_PER_CHANNEL),
    .PLANE_PER_DIE(PLANE_PER_DIE),
    .PAGE_BUFFER_SIZE(PAGE_BUFFER_SIZE)
) interface_logic_0 (
    .clk(clk),
    .aresetn(arstn),
    .m00_axis_tvalid(itf2dn_tvalid),
    .m00_axis_tready(itf2dn_tready),
    .m00_axis_tid(itf2dn_tid),
    .m00_axis_tdest(itf2dn_tdest),
    .m00_axis_tuser(itf2dn_tuser),
    .s00_axis_tvalid(dn2itf_tvalid),
    .s00_axis_tlast(dn2itf_tlast),
    .s00_axis_tuser(dn2itf_tuser),
    .s00_axis_tready(dn2itf_tready),
    .s00_axis_tid(dn2itf_tid),
    .m01_axis_tvalid(m01_axis_tvalid),
    .m01_axis_tready(m01_axis_tready),
    .m01_axis_tid(m01_axis_tid),
    .m01_axis_tuser(m01_axis_tuser),
    .s01_axis_tvalid(s01_axis_tvalid),
    .s01_axis_tlast(s01_axis_tlast),
    .s01_axis_tready(s01_axis_tready),
    .s01_axis_tdata(s01_axis_tdata)
);    

dn_in_switch in_switch (
  .aclk(clk),                    // input wire aclk
  .aresetn(arstn),              // input wire aresetn
  .s_axis_tvalid(itf2dn_tvalid),  // input wire [0 : 0] s_axis_tvalid
  .s_axis_tready(itf2dn_tready),  // output wire [0 : 0] s_axis_tready
  .s_axis_tid(itf2dn_tid),        // input wire [3 : 0] s_axis_tid
  .s_axis_tdest(itf2dn_tdest),    // input wire [11 : 0] s_axis_tdest
  .s_axis_tuser(itf2dn_tuser),    // input wire [33 : 0] s_axis_tuser
  .m_axis_tvalid(dn_in_tvalid),  // output wire [15 : 0] m_axis_tvalid
  .m_axis_tready(dn_in_tready),  // input wire [15 : 0] m_axis_tready
  .m_axis_tid(dn_in_tid),        // output wire [63 : 0] m_axis_tid
  .m_axis_tdest(dn_in_tdest),    // output wire [191 : 0] m_axis_tdest
  .m_axis_tuser(dn_in_tuser),    // output wire [543 : 0] m_axis_tuser
  .s_decode_err()    // output wire [0 : 0] s_decode_err
);

dn_out_switch out_switch (
  .aclk(clk),                      // input wire aclk
  .aresetn(arstn),                // input wire aresetn
  .s_axis_tvalid(dn_out_tvalid),    // input wire [15 : 0] s_axis_tvalid
  .s_axis_tready(dn_out_tready),    // output wire [15 : 0] s_axis_tready
  .s_axis_tlast(dn_out_tlast),      // input wire [15 : 0] s_axis_tlast
  .s_axis_tid(dn_out_tid),          // input wire [63 : 0] s_axis_tid
  .s_axis_tuser(dn_out_tuser),      // input wire [31 : 0] s_axis_tuser
  .m_axis_tvalid(dn2itf_tvalid),    // output wire [0 : 0] m_axis_tvalid
  .m_axis_tready(dn2itf_tready),    // input wire [0 : 0] m_axis_tready
  .m_axis_tlast(dn2itf_tlast),      // output wire [0 : 0] m_axis_tlast
  .m_axis_tid(dn2itf_tid),          // output wire [3 : 0] m_axis_tid
  .m_axis_tuser(dn2itf_tuser),      // output wire [1 : 0] m_axis_tuser
  .s_req_suppress(16'b0000000000000000),  // input wire [15 : 0] s_req_suppress
  .s_decode_err()      // output wire [15 : 0] s_decode_err
);

generate
    genvar i;
    
    for (i=0; i < 16; i=i+1) begin
        channel_axis_wrapper #(
            .C_NUM_SLOTS(16),
            .C_NUM_PLANES(8),
            .C_AXIS_TID_WIDTH(C_AXIS_TID_WIDTH),
            .C_AXIS_TDEST_WIDTH(C_AXIS_SND_TDEST_WIDTH),
            .C_AXIS_M_TUSER_WIDTH(C_AXIS_M_TUSER_WIDTH),
            .C_AXIS_TUSER_WIDTH(C_AXIS_TUSER_WIDTH),
            .DOWNCNT_WIDTH(DOWNCNT_WIDTH),
            .MODE_HIGH_ADDR(MODE_HIGH_ADDR),
            .MODE_LOW_ADDR(MODE_LOW_ADDR),
            .ADDR_HIGH_ADDR(ADDR_HIGH_ADDR),
            .ADDR_LOW_ADDR(ADDR_LOW_ADDR),
            .PB_HIT(PB_HIT),
            .PB_MISS(PB_MISS),
            .PB_WRITE(PB_WRITE),
            .PB_ERASE(PB_ERASE),
            .CHANNEL_CONTENTION_LAT(CHANNEL_CONTENTION_LAT)    
        ) channel (
            .aclk           (clk),
            .aresetn        (arstn),
            .s_axis_tready  (dn_in_tready   [i +: 1]),
            .s_axis_tid     (dn_in_tid      [i*C_AXIS_TID_WIDTH +: C_AXIS_TID_WIDTH]),
            .s_axis_tdest   (dn_in_tdest    [i*C_AXIS_TDEST_WIDTH +: C_AXIS_SND_TDEST_WIDTH]),
            .s_axis_tuser   (dn_in_tuser    [i*C_AXIS_TUSER_WIDTH +: C_AXIS_TUSER_WIDTH]),
            .s_axis_tvalid  (dn_in_tvalid   [i +: 1]),
            .m_axis_tvalid  (dn_out_tvalid  [i +: 1]),
            .m_axis_tid     (dn_out_tid     [i*C_AXIS_TID_WIDTH +: C_AXIS_TID_WIDTH]),
            .m_axis_tuser   (dn_out_tuser   [i*C_AXIS_M_TUSER_WIDTH +: C_AXIS_M_TUSER_WIDTH]),
            .m_axis_tready  (dn_out_tready  [i +: 1]),
            .m_axis_tlast   (dn_out_tlast   [i +: 1])
        );
    end
endgenerate
    
endmodule
