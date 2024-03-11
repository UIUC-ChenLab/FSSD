`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2022 04:40:43 PM
// Design Name: 
// Module Name: burst_ctrl
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


module burst_ctrl #(
    parameter id_width          = 2,
    parameter addr_width        = 32,
    parameter data_width        = 512,
    parameter strb_width        = data_width/8, 
    parameter user_width        = 4
)
(   
    // interface with TC
    input   logic [id_width-1:0]    axi_s_awid,
    input   logic [addr_width-1:0]  axi_s_awaddr,
    input   logic [2:0]             axi_s_awsize,
    input   logic [7:0]             axi_s_awlen,
    input   logic [1:0]             axi_s_awburst,
    input   logic [3:0]             axi_s_awcache,
    input   logic [2:0]             axi_s_awprot,
    input   logic                   axi_s_awvalid,
    output  logic                   axi_s_awready,
    input   logic                   axi_s_awlock,
    
    input   logic [id_width-1:0]    axi_s_wid, 
    input   logic [data_width-1:0]  axi_s_wdata,
    input   logic [strb_width-1:0]  axi_s_wstrb,
    input   logic                   axi_s_wlast,
    input   logic                   axi_s_wvalid,
    output  logic                   axi_s_wready,
    
    output  logic [id_width-1:0]    axi_s_bid,
    output  logic [1:0]             axi_s_bresp,
    output  logic                   axi_s_bvalid,
    input   logic                   axi_s_bready,
    
    input   logic [id_width-1:0]    axi_s_arid,
    input   logic [addr_width-1:0]  axi_s_araddr,
    input   logic [2:0]             axi_s_arsize,
    input   logic [7:0]             axi_s_arlen,
    input   logic [1:0]             axi_s_arburst,
    input   logic [3:0]             axi_s_arcache,
    input   logic [3:0]             axi_s_arqos,
    input   logic [2:0]             axi_s_arprot,
    input   logic                   axi_s_arvalid,
    output  logic                   axi_s_arready,
    input   logic                   axi_s_arlock,

    output  logic [id_width-1:0]    axi_s_rid,
    output  logic [data_width-1:0]  axi_s_rdata,
    output  logic [1:0]             axi_s_rresp,
    output  logic                   axi_s_rlast,
    output  logic                   axi_s_rvalid,
    input   logic                   axi_s_rready,

    // interface with FTL
    output  logic [addr_width-1:0]  mem_address,
    output  logic                   addr_valid,
    output  logic                   mem_rw,     // 0 for read, 1 for write
    input   logic [addr_width-1:0]  mem_new_address,
    input   logic                   addr_resp,
    input   logic                   cache_hit,

    // interface with cache
    output  logic [id_width-1:0]    axi_m_cache_awid,
    output  logic [user_width-1:0]  axi_m_cache_awuser,
    output  logic [addr_width-1:0]  axi_m_cache_awaddr,
    output  logic [2:0]             axi_m_cache_awsize,
    output  logic [7:0]             axi_m_cache_awlen,
    output  logic [1:0]             axi_m_cache_awburst,
    output  logic [3:0]             axi_m_cache_awcache,
    output  logic [2:0]             axi_m_cache_awprot,
    output  logic                   axi_m_cache_awvalid,
    input   logic                   axi_m_cache_awready,
    output  logic                   axi_m_cache_awlock,
    
    output  logic [id_width-1:0]    axi_m_cache_wid,
    output  logic [data_width-1:0]  axi_m_cache_wdata,
    output  logic [strb_width-1:0]  axi_m_cache_wstrb,
    output  logic                   axi_m_cache_wlast,
    output  logic                   axi_m_cache_wvalid,
    input   logic                   axi_m_cache_wready,
    
    input   logic [id_width-1:0]    axi_m_cache_bid,
    input   logic [1:0]             axi_m_cache_bresp,
    input   logic                   axi_m_cache_bvalid,
    output  logic                   axi_m_cache_bready,
    
    output  logic [id_width-1:0]    axi_m_cache_arid,
    output  logic [user_width-1:0]  axi_m_cache_aruser,
    output  logic [addr_width-1:0]  axi_m_cache_araddr,
    output  logic [2:0]             axi_m_cache_arsize,
    output  logic [7:0]             axi_m_cache_arlen,
    output  logic [1:0]             axi_m_cache_arburst,
    output  logic [3:0]             axi_m_cache_arcache,
    output  logic [3:0]             axi_m_cache_arqos,
    output  logic [2:0]             axi_m_cache_arprot,
    output  logic                   axi_m_cache_arvalid,
    input   logic                   axi_m_cache_arready,
    output  logic                   axi_m_cache_arlock,

    input   logic [id_width-1:0]    axi_m_cache_rid,
    input   logic [data_width-1:0]  axi_m_cache_rdata,
    input   logic [1:0]             axi_m_cache_rresp,
    input   logic                   axi_m_cache_rlast,
    input   logic                   axi_m_cache_rvalid,
    output  logic                   axi_m_cache_rready,

    input   logic                   arstn, // active low reset
    input   logic                   clk
);

localparam READ = 0, WRITE = 1;

// address buffer
logic [addr_width-1:0] new_addr_buf;
logic ld_addr;
logic user_buf;

always_ff @(posedge clk) begin
    if (!arstn) begin
        new_addr_buf <= '0;
        user_buf <= '0;
    end
    else if (ld_addr) begin
        new_addr_buf <= mem_new_address;
        user_buf <= cache_hit;
    end
end

logic mode;
assign mem_rw = mode;
// W
assign axi_m_cache_wid = axi_s_wid;
assign axi_m_cache_wdata = axi_s_wdata;
assign axi_m_cache_wstrb = axi_s_wstrb;
assign axi_m_cache_wlast = axi_s_wlast;
assign axi_m_cache_wvalid = axi_s_wvalid;
assign axi_s_wready = axi_m_cache_wready;

// R
assign axi_s_rid = axi_m_cache_rid;
assign axi_s_rdata = axi_m_cache_rdata;
assign axi_s_rresp = axi_m_cache_rresp;
assign axi_s_rlast = axi_m_cache_rlast;
assign axi_s_rvalid = axi_m_cache_rvalid;
assign axi_m_cache_rready = axi_s_rready;

// B
assign axi_s_bid = axi_m_cache_bid;
assign axi_s_bresp = axi_m_cache_bresp;
assign axi_s_bvalid = axi_m_cache_bvalid;
assign axi_m_cache_bready = axi_s_bready;

// AW
assign axi_m_cache_awid = axi_s_awid;
assign axi_m_cache_awsize = axi_s_awsize;
assign axi_m_cache_awlen = axi_s_awlen;
assign axi_m_cache_awburst = axi_s_awburst;
assign axi_m_cache_awcache = '1;
assign axi_m_cache_awprot = axi_s_awprot;
assign axi_m_cache_awlock = axi_s_awlock;

//AR
assign axi_m_cache_arid = axi_s_arid;
assign axi_m_cache_arsize = axi_s_arsize;
assign axi_m_cache_arlen = axi_s_arlen;
assign axi_m_cache_arburst = axi_s_arburst;
assign axi_m_cache_arcache = axi_s_arcache;
assign axi_m_cache_arqos = axi_s_arqos;
assign axi_m_cache_arprot = axi_s_arprot;
assign axi_m_cache_arlock = axi_s_arlock;

enum logic [3:0] {halt, rrequest, wrequest, rwait, wwait, rsend, wsend, rresp, wresp} state, next_state;

always_ff @(posedge clk) begin
    if (!arstn) begin
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
            if (axi_s_arvalid) begin
                next_state = rrequest;
            end
            else if (axi_s_awvalid) begin
                next_state = wrequest;
            end
        end
        
        rrequest: begin
            if (addr_resp) begin
                next_state = rwait;
            end
        end
        
        wrequest: begin
            if (addr_resp) begin
                next_state = wwait;
            end
        end
        
        rwait: begin
            if (~addr_resp) begin
                next_state = rsend;
            end
        end
        
        wwait: begin
            if (~addr_resp) begin
                next_state = wsend;
            end
        end
        
        rsend: begin
            if (axi_m_cache_arready) begin
                next_state = rresp;
            end
        end
        
        wsend: begin
            if (axi_m_cache_awready) begin
                next_state = wresp;
            end
        end
        
        rresp, wresp: begin
            next_state = halt;
        end
        
        default:;
    endcase
    
    axi_m_cache_arvalid = 0;
    axi_m_cache_araddr = '0;
    axi_m_cache_awvalid = 0;
    axi_m_cache_awaddr = '0;
    axi_s_arready = 0;
    axi_s_awready = 0;
    mode = 0;
    addr_valid = 0;
    mem_address = '0;
    ld_addr = 0;
    axi_m_cache_aruser = '0;
    axi_m_cache_awuser = '0;
    case (state)
        rrequest: begin
            mode = READ;
            addr_valid = 1;
            mem_address = axi_s_araddr;
            if (addr_resp) begin
                ld_addr = 1;
            end
        end
        
        wrequest: begin
            mode = WRITE;
            addr_valid = 1;
            mem_address = axi_s_awaddr;
            if (addr_resp) begin
                ld_addr = 1;
            end
        end
        
        rsend: begin
            axi_m_cache_arvalid = 1;
            axi_m_cache_araddr = new_addr_buf;
            axi_m_cache_aruser = {{(user_width-1){1'b0}}, user_buf};
        end
        
        wsend: begin
            axi_m_cache_awvalid = 1;
            axi_m_cache_awaddr = new_addr_buf;
            axi_m_cache_awuser = {{(user_width-1){1'b0}}, user_buf};
        end
        
        rresp: begin
            axi_s_arready = 1;
        end
        
        wresp: begin
            axi_s_awready = 1;
        end
        
        default:;
    endcase
end

endmodule