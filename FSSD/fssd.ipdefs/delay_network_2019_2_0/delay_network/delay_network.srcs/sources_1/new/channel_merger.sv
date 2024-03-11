`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2022 07:42:52 AM
// Design Name: 
// Module Name: channel_merger
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


module channel_merger #
(
    parameter integer C_M00_AXIS_TID_WIDTH                  = 4,
    //parameter integer C_M00_AXIS_TDATA_WIDTH                = 128,
    parameter integer C_AXIS_M_TUSER_WIDTH                  = 2,
    parameter integer CHANNEL_CONTENTION_LAT                = 4,
    localparam integer DOWNCNT_WIDTH                        = $clog2(CHANNEL_CONTENTION_LAT)+1
)
(
    // Slave ports
    output  wire                                s00_axis_tready,
    input   wire                                s00_axis_tlast,
    input   wire                                s00_axis_tvalid,
    input   wire [C_M00_AXIS_TID_WIDTH-1:0]     s00_axis_tid,
    input   wire [C_AXIS_M_TUSER_WIDTH-1:0]     s00_axis_tuser,

    // Master ports
    input   wire                                aclk,
    input   wire                                aresetn,
    output  wire                                m00_axis_tvalid,
    output  wire [C_M00_AXIS_TID_WIDTH-1:0]     m00_axis_tid,
    output  wire [C_AXIS_M_TUSER_WIDTH-1:0]     m00_axis_tuser,
    input   wire                                m00_axis_tready,
    output  wire                                m00_axis_tlast
);

    logic                                       fifo_full;
    logic                                       fifo_empty;
    logic                                       fifo_rd_en;
    logic [5:0]                                 fifo_data_count;
    logic                                       fifo_prog_full; // If the FIFO has hit our programmable limit
    logic [5:0]                                 prog_fifo_depth = 63; // Doesn't need to be 64 because full will still go high
    
    logic [C_M00_AXIS_TID_WIDTH-1:0]            out_fifo_txid;
    logic [C_AXIS_M_TUSER_WIDTH-1:0]            out_fifo_tuser;
    
    
    logic                               tvalid;
    logic                               tlast;
    
    logic                               dwcnt_done;
    logic                               dwcnt_ld_en;
    logic                               dwcnt_count_en;
    logic [DOWNCNT_WIDTH - 1 : 0]       curr_cnt;
    logic [DOWNCNT_WIDTH - 1 : 0]       dwcnt_ld_val = CHANNEL_CONTENTION_LAT;

    assign m00_axis_tvalid  = tvalid;
    assign m00_axis_tlast   = tlast;
    assign m00_axis_tid     = out_fifo_txid;
    assign m00_axis_tuser   = out_fifo_tuser;
    assign s00_axis_tready  = ~(fifo_full | fifo_prog_full);
    
    channel_merger_controller channel_merger_controller(
        .clk(aclk),
        .rst(aresetn),
        .fifo_empty(fifo_empty),
        .dwcnt_done(dwcnt_done),
        .fifo_rd_en(fifo_rd_en),
        .dwcnt_ld_en(dwcnt_ld_en),
        .tvalid(tvalid),
        .tlast(tlast)
    );
    
    /* Controlling the programmable full logic. This 
    is to allow the user to program how large the 
    FIFO is from the software. Sure would be nice
    if we could just pass these parameter to Xilinx
    IP :-| */
    always_ff @(posedge aclk) begin
        if(~aresetn) begin
            fifo_prog_full <= 0;
        end
        else begin
            fifo_prog_full <= (fifo_data_count >= prog_fifo_depth);
        end
    end
    
    // Controlling the count enable logic
    always_ff @(posedge aclk) begin
        if(~aresetn) begin
            dwcnt_count_en <= 0;
        end
        else begin
            dwcnt_count_en <= m00_axis_tready & (curr_cnt > 1);
        end
    end
    
    channel_merger_downcounter
    #(
        .DOWNCNT_WIDTH(DOWNCNT_WIDTH)
    ) channel_merger_downcounter (
        .clock_t(aclk), 
        .sync_rst(aresetn),
        .load_en_n(dwcnt_ld_en),
        .load_val(dwcnt_ld_val),
        .count_en(dwcnt_count_en),
        .done(dwcnt_done),
        .count(curr_cnt)
    );

    channel_merger_fifo channel_merger_fifo(
        .clk(aclk),
        .srst(~aresetn),
        .din({s00_axis_tuser, s00_axis_tid}),
        .wr_en(s00_axis_tlast),
        .rd_en(fifo_rd_en),
        .dout({out_fifo_tuser, out_fifo_txid}),
        .data_count(fifo_data_count),
        .full(fifo_full),
        .empty(fifo_empty),
        .wr_rst_busy(),
        .rd_rst_busy()
     );



endmodule
