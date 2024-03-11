`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2022 08:24:37 AM
// Design Name: 
// Module Name: channel_axis_wrapper
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


module channel_axis_wrapper
    #(
        parameter integer C_NUM_SLOTS                   = 16,
        parameter integer C_NUM_PLANES                  = 8,
        parameter integer C_AXIS_TID_WIDTH              = 4,
        parameter integer C_AXIS_TDEST_WIDTH            = 8,
        parameter integer C_AXIS_M_TUSER_WIDTH          = 2,
        parameter integer C_AXIS_TUSER_WIDTH            = 34,
        parameter integer DOWNCNT_WIDTH                 = 16,
        parameter integer MODE_HIGH_ADDR                = 33,   // Where we slice into tuser
        parameter integer MODE_LOW_ADDR                 = 32,
//        parameter integer SIZE_HIGH_ADDR                = 40,
//        parameter integer SIZE_LOW_ADDR                 = 32,
        parameter integer ADDR_HIGH_ADDR                = 31,
        parameter integer ADDR_LOW_ADDR                 = 0,
        parameter integer PB_HIT                        = 2,
        parameter integer PB_MISS                       = 1748,
        parameter integer PB_WRITE                      = 15385,
        parameter integer PB_ERASE                      = 34965,
        parameter integer CHANNEL_CONTENTION_LAT        = 4,
        //parameter integer HIT_LATENCY_HIGH_ADDR         = 27,   // When we are configuring hit latency, use these bits to index into tuser
//        parameter integer HIT_LATENCY_LOW_ADDR          = 16,
//        parameter integer MISS_LATENCY_HIGH_ADDR        = 15,   // When we are configuring miss latency, use these bits to index into tuser
//        parameter integer MISS_LATENCY_LOW_ADDR         = 0,
//        parameter integer CHANNEL_CONTENTION_HIGH_ADDR  = 15,   // When we are configuring channel contention, use these bits to index into tuser
//        parameter integer CHANNEL_CONTENTION_LOW_ADDR   = 0,
        
        //localparam CHANNEL_CONTENTION_WIDTH             = CHANNEL_CONTENTION_HIGH_ADDR - CHANNEL_CONTENTION_LOW_ADDR + 1,
        localparam MODE_WIDTH                           = MODE_HIGH_ADDR - MODE_LOW_ADDR + 1
        //localparam CHANNEL_MERGER_TUSER_WIDTH           = CHANNEL_CONTENTION_WIDTH + MODE_WIDTH
    )
    (
        // Slave ports
        output  wire                            s_axis_tready,
        input   wire [C_AXIS_TID_WIDTH-1:0]     s_axis_tid,
        input   wire [C_AXIS_TDEST_WIDTH-1:0]   s_axis_tdest,
        input   wire [C_AXIS_TUSER_WIDTH-1:0]   s_axis_tuser,
        //input   wire [C_AXIS_TDATA_WIDTH-1:0]   s_axis_tdata,
        input   wire                            s_axis_tvalid,    
        
        // Master ports
        input   wire                            aclk,
        input   wire                            aresetn,
        output  wire                            m_axis_tvalid,
        output  wire [C_AXIS_TID_WIDTH-1:0]     m_axis_tid,
        output  wire [C_AXIS_M_TUSER_WIDTH-1:0]   m_axis_tuser,  
        input   wire                            m_axis_tready,
        output  wire                            m_axis_tlast
    );
    // TODO: name should be changed from pagebuffer_xxx to die_xxx
    // TODO: add tdata to all components
    wire    [C_NUM_SLOTS-1:0]                           pagebuffer_in_tready;
    wire    [C_NUM_SLOTS*C_AXIS_TID_WIDTH-1:0]          pagebuffer_in_tid;
    wire    [C_NUM_SLOTS*C_AXIS_TUSER_WIDTH-1:0]        pagebuffer_in_tuser;
    wire    [C_NUM_SLOTS*C_AXIS_TDEST_WIDTH-1:0]        pagebuffer_in_tdest;
    //wire    [C_NUM_SLOTS*C_AXIS_TDATA_WIDTH-1:0]        pagebuffer_in_tdata;
    wire    [C_NUM_SLOTS-1:0]                           pagebuffer_in_tvalid;
                                                  
    wire    [C_NUM_SLOTS-1:0]                           pagebuffer_out_tvalid;
    wire    [C_NUM_SLOTS*C_AXIS_TID_WIDTH-1:0]          pagebuffer_out_tid;
    wire    [C_NUM_SLOTS-1:0]                           pagebuffer_out_tready;
    wire    [C_NUM_SLOTS-1:0]                           pagebuffer_out_tlast;
    wire    [C_NUM_SLOTS*C_AXIS_M_TUSER_WIDTH-1:0]        pagebuffer_out_tuser;
                                                  
    wire                                                fifo_in_tvalid;
    wire    [C_AXIS_TID_WIDTH-1:0]                      fifo_in_tid;
    wire    [C_AXIS_M_TUSER_WIDTH-1:0]                    fifo_in_tuser;
    wire                                                fifo_in_tready;
    wire                                                fifo_in_tlast;
    //wire    [CHANNEL_MERGER_TUSER_WIDTH:0]              fifo_in_tuser;
                                                  
    wire                                                controller_fifo_full;    
    wire                                                controller_fifo_empty;
    wire    [C_AXIS_TDEST_WIDTH-1:0]                    controller_fifo_out_tdest;
    wire    [C_AXIS_TUSER_WIDTH-1:0]                    controller_fifo_out_tuser;
    //wire    [C_AXIS_TDATA_WIDTH-1:0]                    controller_fifo_out_tdata;
    wire    [C_AXIS_TID_WIDTH-1:0]                      controller_fifo_out_tid;
                                                  
    wire                                                switch_in_s_tready;
                                                  
    reg                                                 channel_in_enable;
    reg                                                 channel_out_enable;
    reg     [C_AXIS_TDEST_WIDTH-1:0]                    count_limit [C_AXIS_TID_WIDTH-1:0];
    
    wire                                                add_one;
    wire                                                sub_one;
    
    assign s_axis_tready = ~controller_fifo_full;
    
    // Toggle bus usage. Channel_in and channel_out are mutually exclusive.
    always @(posedge aclk) begin
        if (aresetn == 1'b0) begin
            channel_in_enable <= 1'b1;
            channel_out_enable <= 1'b0;
        end else begin
            if (channel_out_enable == 1'b1) begin
                if (fifo_in_tvalid == 1'b1 & fifo_in_tlast == 1'b1 & fifo_in_tready == 1'b1) begin
                    channel_in_enable <= 1'b1;
                    channel_out_enable <= 1'b0;
                end
            end else begin
                if (fifo_in_tvalid == 1'b1 & (controller_fifo_empty | (pagebuffer_out_tready[s_axis_tdest] == 1'b0))) begin
                    channel_in_enable <= 1'b0;
                    channel_out_enable <= 1'b1;
                end
            end
        end
    end
    
    channel_controller_fifo channel_controller_fifo (
        .clk(aclk),
        .srst(~aresetn),
        .din({s_axis_tid, s_axis_tdest, s_axis_tuser}),
        .wr_en(s_axis_tvalid),
        .rd_en(channel_in_enable & switch_in_s_tready),
        .dout({controller_fifo_out_tid, controller_fifo_out_tdest, controller_fifo_out_tuser}),
        .full(controller_fifo_full),
        .empty(controller_fifo_empty),
        .wr_rst_busy(),
        .rd_rst_busy()
    );

    axis_switch_in axis_switch_in (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tvalid(channel_in_enable & ~controller_fifo_empty),
        .s_axis_tready(switch_in_s_tready),
        .s_axis_tid(controller_fifo_out_tid),
        //.s_axis_tdata(controller_fifo_out_tdata),
        .s_axis_tdest(controller_fifo_out_tdest),
        .s_axis_tuser(controller_fifo_out_tuser),
        .m_axis_tvalid(pagebuffer_in_tvalid),
        .m_axis_tready(pagebuffer_in_tready),
        .m_axis_tid(pagebuffer_in_tid),
        .m_axis_tdest(pagebuffer_in_tdest),
        //.m_axis_tuser(pagebuffer_in_tuser),
        .m_axis_tuser(pagebuffer_in_tuser),
        .s_decode_err()
    );
    
    die_axis_wrapper #(
        .C_NUM_SLOTS(C_NUM_SLOTS),
        .C_NUM_PLANES(C_NUM_PLANES),
        .MODE_HIGH_ADDR(MODE_HIGH_ADDR),
        .MODE_LOW_ADDR(MODE_LOW_ADDR),
        .ADDR_HIGH_ADDR(ADDR_HIGH_ADDR),
        .ADDR_LOW_ADDR(ADDR_LOW_ADDR),
//        .SIZE_HIGH_ADDR(SIZE_HIGH_ADDR),
//        .SIZE_LOW_ADDR(SIZE_LOW_ADDR),     
        .C_AXIS_TID_WIDTH(C_AXIS_TID_WIDTH),  
        .C_AXIS_M_TUSER_WIDTH(C_AXIS_M_TUSER_WIDTH),
        .C_AXIS_TUSER_WIDTH(C_AXIS_TUSER_WIDTH),
        .DOWNCNT_WIDTH(DOWNCNT_WIDTH),
        .PB_HIT(PB_HIT),
        .PB_MISS(PB_MISS),
        .PB_WRITE(PB_WRITE),
        .PB_ERASE(PB_ERASE)        
    ) die_wrapper (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tready(pagebuffer_in_tready),
        .s_axis_tid(pagebuffer_in_tid),
        .s_axis_tuser(pagebuffer_in_tuser),
        .s_axis_tdest(pagebuffer_in_tdest),
        //.s_axis_tdata(pagebuffer_in_tdata),
        .s_axis_tvalid(pagebuffer_in_tvalid),   
        .m_axis_tvalid(pagebuffer_out_tvalid),
        .m_axis_tid(pagebuffer_out_tid),
        .m_axis_tlast(pagebuffer_out_tlast),
        .m_axis_tready(pagebuffer_out_tready),
        .m_axis_tuser(pagebuffer_out_tuser)
    );
    
    axis_switch_out axis_switch_out (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tvalid(pagebuffer_out_tvalid),
        .s_axis_tready(pagebuffer_out_tready),
        .s_axis_tlast(pagebuffer_out_tlast),
        .s_axis_tuser(pagebuffer_out_tuser),
        .s_axis_tid(pagebuffer_out_tid),
        .m_axis_tvalid(fifo_in_tvalid),
        .m_axis_tready(fifo_in_tready & channel_out_enable),
        .m_axis_tlast(fifo_in_tlast),
        .m_axis_tuser(fifo_in_tuser),
        .m_axis_tid(fifo_in_tid),
        .s_req_suppress(16'b0000000000000000),
        .s_decode_err()
    );
    
    channel_merger #(
        .C_M00_AXIS_TID_WIDTH(C_AXIS_TID_WIDTH),
        .C_AXIS_M_TUSER_WIDTH(C_AXIS_M_TUSER_WIDTH),
        .CHANNEL_CONTENTION_LAT(CHANNEL_CONTENTION_LAT)
    ) channel_merger (
        .aclk(aclk),
        .aresetn(aresetn),    
        .s00_axis_tready(fifo_in_tready),
        .s00_axis_tlast(fifo_in_tlast & channel_out_enable),
        .s00_axis_tvalid(fifo_in_tvalid & channel_out_enable),
        .s00_axis_tid(fifo_in_tid),
        .s00_axis_tuser(fifo_in_tuser),
        .m00_axis_tvalid(m_axis_tvalid),
        .m00_axis_tid(m_axis_tid),
        .m00_axis_tuser(m_axis_tuser),
        .m00_axis_tready(m_axis_tready),
        .m00_axis_tlast(m_axis_tlast)
    );
    
endmodule
