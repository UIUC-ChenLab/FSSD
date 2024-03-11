`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2022 10:46:53 PM
// Design Name: 
// Module Name: multiplane_die
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

module multiplane_die #
(
    parameter integer C_NUM_PLANES                  = 8,
    parameter integer C_AXIS_TID_WIDTH              = 4,
    //parameter integer C_AXIS_TDATA_WIDTH            = 128,
    parameter integer C_AXIS_M_TUSER_WIDTH          = 2,
    parameter integer C_AXIS_TUSER_WIDTH            = 34,
    parameter integer DOWNCNT_WIDTH                 = 16,
    parameter integer MODE_HIGH_ADDR                = 33,   // Where we slice into tuser
    parameter integer MODE_LOW_ADDR                 = 32,
//    parameter integer SIZE_HIGH_ADDR                = 40,
//    parameter integer SIZE_LOW_ADDR                 = 32,
    parameter integer ADDR_HIGH_ADDR                = 31,
    parameter integer ADDR_LOW_ADDR                 = 0,
    parameter integer PB_HIT                        = 20,
    parameter integer PB_MISS                       = 1000,
    parameter integer PB_WRITE                      = 1000,
    parameter integer PB_ERASE                      = 1000,

    localparam PB_ADDR_WIDTH                        = ADDR_HIGH_ADDR - ADDR_LOW_ADDR + 1,
    localparam MODE_WIDTH                           = MODE_HIGH_ADDR - MODE_LOW_ADDR + 1,
    localparam TDEST_WIDTH                          = 3
    
)
(
    // Slave ports
    output  wire                            s_axis_tready,
    input   wire [C_AXIS_TID_WIDTH-1:0]     s_axis_tid,
    //input   wire [C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata,
    input   wire [C_AXIS_TUSER_WIDTH-1:0]   s_axis_tuser,
    input   wire [TDEST_WIDTH-1:0]          s_axis_tdest,
    input   wire                            s_axis_tvalid,    
    
    // Master ports
    input   wire                            aclk,
    input   wire                            aresetn,
    output  wire                            m_axis_tvalid,
    output  wire [C_AXIS_TID_WIDTH-1:0]     m_axis_tid,
    //output  wire [C_AXIS_TDATA_WIDTH-1:0]   m_axis_tdata,
    output  wire [C_AXIS_M_TUSER_WIDTH-1:0] m_axis_tuser,
    output  wire                            m_axis_tlast,
    input   wire                            m_axis_tready
    
);

    wire    [C_NUM_PLANES-1:0]                           pagebuffer_i_tready;
    wire    [C_NUM_PLANES*C_AXIS_TID_WIDTH-1:0]          pagebuffer_i_tid;
    wire    [C_NUM_PLANES*C_AXIS_TUSER_WIDTH-1:0]        pagebuffer_i_tuser;
    //wire    [C_NUM_PLANES*C_AXIS_TDATA_WIDTH-1:0]        pagebuffer_i_tdata;
    wire    [C_NUM_PLANES-1:0]                           pagebuffer_i_tvalid;
    wire    [TDEST_WIDTH-1:0]                            pagebuffer_i_tdest;
                                                  
    wire    [C_NUM_PLANES-1:0]                           pagebuffer_o_tvalid;
    wire    [C_NUM_PLANES*C_AXIS_TID_WIDTH-1:0]          pagebuffer_o_tid;
    wire    [C_NUM_PLANES-1:0]                           pagebuffer_o_tready;
    wire    [C_NUM_PLANES-1:0]                           pagebuffer_o_tlast;
    wire    [C_NUM_PLANES*C_AXIS_M_TUSER_WIDTH-1:0]      pagebuffer_o_tuser;
    //wire    [C_NUM_PLANES*C_AXIS_TDATA_WIDTH-1:0]        pagebuffer_o_tdata;

//TODO add switch in and switch out
axis_switch_0 axis_switch_in (
  .aclk(aclk),                    // input wire aclk
  .aresetn(aresetn),              // input wire aresetn
  .s_axis_tvalid(s_axis_tvalid),  // input wire [0 : 0] s_axis_tvalid
  .s_axis_tready(s_axis_tready),  // output wire [0 : 0] s_axis_tready
  //.s_axis_tdata(s_axis_tdata),    // input wire [127 : 0] s_axis_tdata
  .s_axis_tid(s_axis_tid),        // input wire [11 : 0] s_axis_tid
  .s_axis_tdest(s_axis_tdest),    // input wire [2 : 0] s_axis_tdest
  .s_axis_tuser(s_axis_tuser),    // input wire [46 : 0] s_axis_tuser
  .m_axis_tvalid(pagebuffer_i_tvalid),  // output wire [7 : 0] m_axis_tvalid
  .m_axis_tready(pagebuffer_i_tready),  // input wire [7 : 0] m_axis_tready
  //.m_axis_tdata(pagebuffer_i_tdata),    // output wire [1023 : 0] m_axis_tdata
  .m_axis_tid(pagebuffer_i_tid),        // output wire [95 : 0] m_axis_tid
  .m_axis_tdest(pagebuffer_i_tdest),    // output wire [23 : 0] m_axis_tdest
  .m_axis_tuser(pagebuffer_i_tuser),    // output wire [375 : 0] m_axis_tuser
  .s_decode_err()    // output wire [0 : 0] s_decode_err
);

axis_switch_1 axis_switch_out (
  .aclk(aclk),                      // input wire aclk
  .aresetn(aresetn),                // input wire aresetn
  .s_axis_tvalid({'0,pagebuffer_o_tvalid}),    // input wire [7 : 0] s_axis_tvalid
  .s_axis_tready(pagebuffer_o_tready),    // output wire [7 : 0] s_axis_tready
  //.s_axis_tdata(pagebuffer_o_tdata),      // input wire [1023 : 0] s_axis_tdata
  .s_axis_tlast(pagebuffer_o_tlast),      // input wire [7 : 0] s_axis_tlast
  .s_axis_tuser(pagebuffer_o_tuser),
  .s_axis_tid(pagebuffer_o_tid),          // input wire [95 : 0] s_axis_tid
  .m_axis_tvalid(m_axis_tvalid),    // output wire [0 : 0] m_axis_tvalid
  .m_axis_tready(m_axis_tready),    // input wire [0 : 0] m_axis_tready
  //.m_axis_tdata(m_axis_tdata),      // output wire [127 : 0] m_axis_tdata
  .m_axis_tlast(m_axis_tlast),      // output wire [0 : 0] m_axis_tlast
  .m_axis_tuser(m_axis_tuser),
  .m_axis_tid(m_axis_tid),          // output wire [11 : 0] m_axis_tid
  .s_req_suppress(8'b00000000),  // input wire [7 : 0] s_req_suppress
  .s_decode_err()      // output wire [7 : 0] s_decode_err
);

generate
    genvar i;
    
    for (i=0; i<C_NUM_PLANES; i = i + 1) begin
        pagebuffer#(
            .PB_ADDR_WIDTH(PB_ADDR_WIDTH),
            .TXID_WIDTH(C_AXIS_TID_WIDTH),
            //.TDATA_WIDTH(C_AXIS_TDATA_WIDTH),
            .TUSER_WIDTH(C_AXIS_M_TUSER_WIDTH),
            .DOWNCNT_WIDTH(DOWNCNT_WIDTH),
            .PB_HIT(PB_HIT),
            .PB_MISS(PB_MISS),
            .PB_WRITE(PB_WRITE),
            .PB_ERASE(PB_ERASE)
        ) pagebuffer (
            .clock_t        (aclk),
            .sync_rst       (aresetn),
            .addr_valid     (pagebuffer_i_tvalid    [i +: 1]),
            .new_addr_in    (pagebuffer_i_tuser     [i*C_AXIS_TUSER_WIDTH+ADDR_LOW_ADDR +: PB_ADDR_WIDTH]),
            .mode           (pagebuffer_i_tuser     [i*C_AXIS_TUSER_WIDTH+MODE_LOW_ADDR +: MODE_WIDTH]),
            .txid_in        (pagebuffer_i_tid       [i*C_AXIS_TID_WIDTH +: C_AXIS_TID_WIDTH]),
            //.tdata_in       (pagebuffer_i_tdata     [i*C_AXIS_TDATA_WIDTH +: C_AXIS_TDATA_WIDTH]),
            .pb_ready       (pagebuffer_i_tready    [i +: 1]),            
            .master_ready   (pagebuffer_o_tready    [i +: 1]),
            .txid_out       (pagebuffer_o_tid       [i*C_AXIS_TID_WIDTH +: C_AXIS_TID_WIDTH]),
            //.tdata_out      (pagebuffer_o_tdata     [i*C_AXIS_TDATA_WIDTH +: C_AXIS_TDATA_WIDTH]),
            .tuser_out      (pagebuffer_o_tuser     [i*C_AXIS_M_TUSER_WIDTH +: C_AXIS_M_TUSER_WIDTH]),
            .tvalid         (pagebuffer_o_tvalid    [i +: 1]),
            .tlast          (pagebuffer_o_tlast     [i +: 1])

        );
    end
endgenerate

endmodule

