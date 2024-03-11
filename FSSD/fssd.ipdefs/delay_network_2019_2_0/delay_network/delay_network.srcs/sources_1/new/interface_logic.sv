`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2022 10:36:17 PM
// Design Name: 
// Module Name: interface_logic
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


module interface_logic#(
    // Defining the interface to/from PCIe logic 
    parameter integer TDATA_WIDTH       = 64,
    parameter integer TDEST_WIDTH       = 12,
    parameter integer TAG_HIGH_ADDR     = 37,
    parameter integer TAG_LOW_ADDR      = 34,
    parameter integer MODE_HIGH_ADDR    = 33,
    parameter integer MODE_LOW_ADDR     = 32,
    parameter integer ADDR_HIGH_ADDR    = 31,
    parameter integer ADDR_LOW_ADDR     = 0,
    parameter integer S_TUSER_WIDTH     = 2,
    
    // architecture parameters
    parameter integer NUM_CHANNEL       = 8,
    parameter integer DIE_PER_CHANNEL   = 8,
    parameter integer PLANE_PER_DIE     = 1,
    parameter integer PAGE_BUFFER_SIZE  = 1024,
    
    localparam CHANNEL_WIDTH            = $clog2(NUM_CHANNEL),
    localparam DIE_WIDTH                = $clog2(DIE_PER_CHANNEL),
    localparam PLANE_WIDTH              = $clog2(PLANE_PER_DIE),
    localparam PAGE_BUFFER_OFFSET_WIDTH = $clog2(PAGE_BUFFER_SIZE),
    
    parameter integer TID_WIDTH         = TAG_HIGH_ADDR - TAG_LOW_ADDR + 1,
    parameter integer MODE_WIDTH        = MODE_HIGH_ADDR - MODE_LOW_ADDR + 1,
    parameter integer ADDR_WIDTH        = ADDR_HIGH_ADDR - ADDR_LOW_ADDR + 1,
    parameter integer TUSER_WIDTH       = MODE_WIDTH + ADDR_WIDTH

)(
    // Clk and rst
    input                           clk,
    input                           aresetn,

    // Master port to delay network
    output                          m00_axis_tvalid,
    input                           m00_axis_tready,
    output [TID_WIDTH-1:0]          m00_axis_tid,
    output [TDEST_WIDTH-1:0]        m00_axis_tdest,
    //output [TDATA_WIDTH-1:0]        m00_axis_tdata,
    output [TUSER_WIDTH-1:0]        m00_axis_tuser,     // tuser = {mode, address} 
    
    // Slave port from delay network
    input                           s00_axis_tvalid,
    input                           s00_axis_tlast,
    input [S_TUSER_WIDTH-1:0]       s00_axis_tuser,
    output logic                          s00_axis_tready,
    input [TID_WIDTH-1:0]           s00_axis_tid,
    
    // Master port to pcie logic
    output logic                         m01_axis_tvalid,
    input                           m01_axis_tready,
    output [TID_WIDTH-1:0]          m01_axis_tid,
    output [S_TUSER_WIDTH-1:0]      m01_axis_tuser,
    //output [TDATA_WIDTH-1:0]        m01_axis_tdata,
    
    // Slave port from pcie logic
    input                           s01_axis_tvalid,
    input                           s01_axis_tlast,
    output                          s01_axis_tready,
    input  [TDATA_WIDTH-1:0]        s01_axis_tdata      // {complete axi read request, id, mode, address}
    
);

// data flow: s01 - m00, s00 - m01

    // Output FIFO signals
    logic [TID_WIDTH-1:0]   out_fifo_txid;
    logic [S_TUSER_WIDTH-1:0] out_fifo_tuser;
    //logic [TDATA_WIDTH-1:0] out_fifo_tdata;
    logic                   out_fifo_full;
    logic                   out_fifo_empty;
    
    // Input FIFO signals
    logic                   in_fifo_full;
    logic                   in_fifo_empty;
    logic                   in_fifo_rd_en;
    logic                   in_fifo_tlast_out; // input fifo holds {tlast, tdata}
    logic [TDATA_WIDTH-1:0] in_fifo_tdata_out;
    
    // Registered signals connected to delay network
    logic [ADDR_WIDTH-1:0]  pb_addr_reg;
    logic [TDEST_WIDTH-1:0] tdest_reg;
    logic [MODE_WIDTH-1:0]  mode_reg;
    logic [TID_WIDTH-1:0]   tid_reg;
    logic [MODE_WIDTH-1:0]  out_mode_reg;
    logic [TID_WIDTH-1:0]   out_tid_reg;
    
    //logic [TDATA_WIDTH-1:0] tdata_reg;
//    logic [SIZE_WIDTH-1:0]  size_reg;
    logic                   pb_addr_reg_ld_en;
    logic                   tdest_reg_ld_en;
    logic                   size_reg_ld_en;
    logic                   mode_reg_ld_en;
    logic                   tid_reg_ld_en;
    logic                   tdata_reg_ld_en;
    logic                   output_reg_ld_en;

    assign s01_axis_tready                                = ~in_fifo_full;
    assign m00_axis_tdest                                 = tdest_reg;
    assign m00_axis_tid                                   = tid_reg;
    //assign m00_axis_tdata                                 = tdata_reg;
    assign m00_axis_tuser[MODE_HIGH_ADDR:MODE_LOW_ADDR]   = mode_reg;
//    assign m00_axis_tuser[SIZE_HIGH_ADDR:SIZE_LOW_ADDR]   = size_reg;
    assign m00_axis_tuser[ADDR_HIGH_ADDR:ADDR_LOW_ADDR]   = pb_addr_reg;
        
//    assign m01_axis_tvalid  = ~out_fifo_empty;
    assign m01_axis_tid     = out_tid_reg;
    assign m01_axis_tuser   = out_mode_reg;
//    //assign m01_axis_tdata   = out_fifo_tdata;
//    assign s00_axis_tready  = !out_fifo_full;

// output FSM
enum logic [3:0] {halt, load, send} state, next_state;

    always_ff @(posedge clk) begin
        if (~aresetn) begin
            state <= halt;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            halt: begin
                if (s00_axis_tvalid) next_state = load;
            end
            
            load: begin
                if (s00_axis_tlast) next_state = send;
            end
            
            send: begin
                if (m01_axis_tready) next_state = halt;
            end
            
            default: ;
        endcase
        
        s00_axis_tready = 0;
        m01_axis_tvalid = 0;
        output_reg_ld_en = 0;
        case (state)
            load: begin
                s00_axis_tready = 1;
                output_reg_ld_en = 1;
            end
            send: begin
                m01_axis_tvalid = 1;
            end
            default:;
        endcase
    end

    always_ff @(posedge clk) begin
        if (~aresetn) begin
            out_tid_reg <= '0;
            out_mode_reg <= '0;
        end
        else if (output_reg_ld_en) begin
            out_tid_reg <= s00_axis_tid;
            out_mode_reg <= s00_axis_tuser;
        end
    end


    // Need to flip the address when PCIe sends it in
    logic [ADDR_WIDTH-1:0] flipped_addr;
    // Flipping the pcie_write_addr before sending in to AXI
    genvar i;
    generate
    for (i = 0; i < ADDR_WIDTH; i++)
      assign flipped_addr[i] = in_fifo_tdata_out[ADDR_HIGH_ADDR-i];
    endgenerate

//delay_network_to_pcie_fifo dn2itf_fifo (
//  .clk(clk),                  // input wire clk
//  .srst(~aresetn),                // input wire srst
//  .din({s00_axis_tid,s00_axis_tuser}),                  // input wire din
//  .wr_en(s00_axis_tlast),              // input wire wr_en
//  .rd_en(m01_axis_tready),              // input wire rd_en
//  .dout({out_fifo_txid,out_fifo_tuser}),                // output wire dout
//  .full(out_fifo_full),                // output wire full
//  .empty(out_fifo_empty),              // output wire empty
//  .wr_rst_busy(),  // output wire wr_rst_busy
//  .rd_rst_busy()  // output wire rd_rst_busy
//);

pcie_to_delay_network_fifo itf2dn_fifo (
  .clk(clk),                  // input wire clk
  .srst(~aresetn),                // input wire srst
  .din({s01_axis_tlast, s01_axis_tdata}),                  // input wire  din
  .wr_en(s01_axis_tvalid),              // input wire wr_en
  .rd_en(in_fifo_rd_en),
  .dout({in_fifo_tlast_out, in_fifo_tdata_out}),
  .full(in_fifo_full),
  .empty(in_fifo_empty),
  .wr_rst_busy(),  // output wire wr_rst_busy
  .rd_rst_busy()  // output wire rd_rst_busy
);

    interface_logic_controller interface_logic_controller (
        .clk(clk),
        .sync_rst(aresetn),
        .fifo_empty(in_fifo_empty),
        .tready(m00_axis_tready),
        .fifo_tlast(in_fifo_tlast_out),
        .tvalid(m00_axis_tvalid),
        .fifo_pop(in_fifo_rd_en),
        .tdest_reg_ld_en(tdest_reg_ld_en),
        .pb_addr_reg_ld_en(pb_addr_reg_ld_en),
        .size_reg_ld_en(size_reg_ld_en),
        .mode_reg_ld_en(mode_reg_ld_en),
        .tid_reg_ld_en(tid_reg_ld_en),
        .tdata_reg_ld_en(tdata_reg_ld_en)
    );

    // size register
//    always_ff @(posedge clk) begin
//        if(~aresetn) begin
//            size_reg <= 0;
//        end
//        else begin
//            if(size_reg_ld_en) begin
//                size_reg <= in_fifo_tdata_out[SIZE_HIGH_ADDR:SIZE_LOW_ADDR];
//            end
//            else begin
//                size_reg <= size_reg;
//            end
//        end
//    end
    
    // pb_addr register
    always_ff @(posedge clk) begin
        if(~aresetn) begin
            pb_addr_reg <= 0;
        end
        else begin
            if(pb_addr_reg_ld_en) begin
                pb_addr_reg <= in_fifo_tdata_out[ADDR_HIGH_ADDR:ADDR_LOW_ADDR];
            end
            else begin
                pb_addr_reg <= pb_addr_reg;
            end
        end
    end
    
    // tdest register
    always_ff @(posedge clk) begin
        if(~aresetn) begin
            tdest_reg <= 0;
        end
        else begin
            if(tdest_reg_ld_en) begin
                /* Scrambing the address based off of the routing table. tdest is used 
                to go through the network of switches. Rest of the address is to index
                into a plane which is stored in tuser. */
                tdest_reg[11:8] <= CHANNEL_WIDTH ? {{(4-CHANNEL_WIDTH){1'b0}},flipped_addr[ADDR_WIDTH-PAGE_BUFFER_OFFSET_WIDTH-1 : ADDR_WIDTH-PAGE_BUFFER_OFFSET_WIDTH-CHANNEL_WIDTH]} : 4'b0;
                tdest_reg[7:4] <= DIE_WIDTH ? {{(4-DIE_WIDTH){1'b0}},flipped_addr[ADDR_WIDTH-PAGE_BUFFER_OFFSET_WIDTH-CHANNEL_WIDTH-1 : ADDR_WIDTH-PAGE_BUFFER_OFFSET_WIDTH-CHANNEL_WIDTH-DIE_WIDTH]} : 4'b0;
                tdest_reg[3:0] <= PLANE_WIDTH ? {{(4-PLANE_WIDTH){1'b0}},flipped_addr[ADDR_WIDTH-PAGE_BUFFER_OFFSET_WIDTH-CHANNEL_WIDTH-DIE_WIDTH-1 : ADDR_WIDTH-PAGE_BUFFER_OFFSET_WIDTH-CHANNEL_WIDTH-DIE_WIDTH-PLANE_WIDTH]} : 4'b0;
            end
            else begin
                tdest_reg <= tdest_reg;
            end
        end
    end
    
    // mode register
    always_ff @(posedge clk) begin
        if(~aresetn) begin
            mode_reg <= 0;
        end
        else begin
            if(mode_reg_ld_en) begin
                mode_reg <= in_fifo_tdata_out[MODE_HIGH_ADDR:MODE_LOW_ADDR];
            end
            else begin
                mode_reg <= mode_reg;
            end
        end
    end
    
    // tid register
    always_ff @(posedge clk) begin
        if(~aresetn) begin
            tid_reg <= 0;
        end
        else begin
            if(tid_reg_ld_en) begin
                tid_reg <= in_fifo_tdata_out[TAG_HIGH_ADDR:TAG_LOW_ADDR];
            end
            else begin
                tid_reg <= tid_reg;
            end
        end
    end

    // tdata register
//    always_ff @(posedge clk) begin
//        if(~aresetn) begin
//            tdata_reg <= 0;
//        end
//        else begin
//            if(tdata_reg_ld_en) begin
//                tdata_reg <= in_fifo_tdata_out;
//            end
//            else begin
//                tdata_reg <= tdata_reg;
//            end
//        end
//    end

endmodule
