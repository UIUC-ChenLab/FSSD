`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2022 02:53:58 PM
// Design Name: 
// Module Name: top_level_tb
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


module top_level_tb();

timeunit 10ns;

timeprecision 1ns;

		parameter KEY_WIDTH                 = 12;
		parameter VAL_WIDTH                 = 128;
		parameter CAM_DEPTH                 = 256;
		
		//parameter ERASE_ADDR_WIDTH          = 32;
		
        parameter USER_HIGH_ADDR            = 105;
        parameter USER_LOW_ADDR             = 59;
        parameter LEN_HIGH_ADDR             = 105;
        parameter LEN_LOW_ADDR              = 98;
        parameter BURST_HIGH_ADDR           = 96;
        parameter BURST_LOW_ADDR            = 95;
        parameter LOCK_ADDR                 = 90;
        parameter CACHE_HIGH_ADDR           = 85;
        parameter CACHE_LOW_ADDR            = 82;
        parameter PROT_HIGH_ADDR            = 80;
        parameter PROT_LOW_ADDR             = 78;
        
        parameter TAG_HIGH_ADDR             = 58;
        parameter TAG_LOW_ADDR              = 47;
        parameter MODE_HIGH_ADDR            = 46;
        parameter MODE_LOW_ADDR             = 41;
        parameter SIZE_HIGH_ADDR            = 40;
        parameter SIZE_LOW_ADDR             = 32;
        parameter ADDR_HIGH_ADDR            = 31;
        parameter ADDR_LOW_ADDR             = 0;
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 64;
		parameter integer C_M00_AXIS_TID_WIDTH	= 4;
		parameter integer C_M00_AXIS_START_COUNT	= 32;

		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 64;
		parameter integer C_S00_AXIS_TID_WIDTH	= 4;
		parameter integer C_S00_AXIS_TUSER_WIDTH = 2;

		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 4;
		parameter integer C_S00_AXI_DATA_WIDTH	= 512;
		parameter integer C_S00_AXI_ADDR_WIDTH	= 32;
		parameter integer C_S00_AXI_AWUSER_WIDTH	= 4;
		parameter integer C_S00_AXI_ARUSER_WIDTH	= 4;
		parameter integer C_S00_AXI_WUSER_WIDTH	= 0;
		parameter integer C_S00_AXI_RUSER_WIDTH	= 0;
		parameter integer C_S00_AXI_BUSER_WIDTH	= 0;

		// Parameters of Axi Master Bus Interface M00_AXI
		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000;
		parameter integer C_M00_AXI_BURST_LEN	= 16;
		parameter integer C_M00_AXI_ID_WIDTH	= 4;
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32;
		parameter integer C_M00_AXI_DATA_WIDTH	= 512;
		parameter integer C_M00_AXI_AWUSER_WIDTH	= 0;
		parameter integer C_M00_AXI_ARUSER_WIDTH	= 0;
		parameter integer C_M00_AXI_WUSER_WIDTH	= 0;
		parameter integer C_M00_AXI_RUSER_WIDTH	= 0;
		parameter integer C_M00_AXI_BUSER_WIDTH	= 0;

		logic  m00_axis_aclk;
		logic  m00_axis_aresetn;
		logic  m00_axis_tvalid;
		logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata;
		logic  m00_axis_tlast;
		logic  m00_axis_tready;

		// Ports of Axi Slave Bus Interface S00_AXIS
		logic  s00_axis_aclk;
		logic  s00_axis_aresetn;
		logic  s00_axis_tready;
		logic [C_S00_AXIS_TID_WIDTH-1 : 0] s00_axis_tid;
		logic [C_S00_AXIS_TUSER_WIDTH-1 : 0] s00_axis_tuser;
		logic  s00_axis_tvalid;

		// Ports of Axi Slave Bus Interface S00_AXI
		logic  s00_axi_aclk;
		logic  s00_axi_aresetn;
		logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_awid;
		logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr;
		logic [7 : 0] s00_axi_awlen;
		logic [2 : 0] s00_axi_awsize;
		logic [1 : 0] s00_axi_awburst;
		logic  s00_axi_awlock;
		logic [3 : 0] s00_axi_awcache;
		logic [2 : 0] s00_axi_awprot;
		logic [3 : 0] s00_axi_awqos;
		logic [3 : 0] s00_axi_awregion;
		logic [C_S00_AXI_AWUSER_WIDTH-1 : 0] s00_axi_awuser;
		logic  s00_axi_awvalid;
		logic  s00_axi_awready;
		logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata;
		logic [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb;
		logic  s00_axi_wlast;
		logic [C_S00_AXI_WUSER_WIDTH-1 : 0] s00_axi_wuser;
		logic  s00_axi_wvalid;
		logic  s00_axi_wready;
		logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid;
		logic [1 : 0] s00_axi_bresp;
		logic [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser;
		logic  s00_axi_bvalid;
		logic  s00_axi_bready;
		logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_arid;
		logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr;
		logic [7 : 0] s00_axi_arlen;
		logic [2 : 0] s00_axi_arsize;
		logic [1 : 0] s00_axi_arburst;
		logic  s00_axi_arlock;
		logic [3 : 0] s00_axi_arcache;
		logic [2 : 0] s00_axi_arprot;
		logic [3 : 0] s00_axi_arqos;
		logic [3 : 0] s00_axi_arregion;
		logic [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser;
		logic  s00_axi_arvalid;
		logic  s00_axi_arready;
		logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_rid;
		logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata;
		logic [1 : 0] s00_axi_rresp;
		logic  s00_axi_rlast;
		logic [C_S00_AXI_RUSER_WIDTH-1 : 0] s00_axi_ruser;
		logic  s00_axi_rvalid;
		logic  s00_axi_rready;

		// Ports of Axi Master Bus Interface M00_AXI
		logic  m00_axi_aclk;
		logic  m00_axi_aresetn;
		logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid;
		logic [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr;
		logic [7 : 0] m00_axi_awlen;
		logic [2 : 0] m00_axi_awsize;
		logic [1 : 0] m00_axi_awburst;
		logic  m00_axi_awlock;
		logic [3 : 0] m00_axi_awcache;
		logic [2 : 0] m00_axi_awprot;
		logic [3 : 0] m00_axi_awqos;
		logic [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser;
		logic  m00_axi_awvalid;
		logic  m00_axi_awready;
		logic [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata;
		logic [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb;
		logic  m00_axi_wlast;
		logic [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser;
		logic  m00_axi_wvalid;
		logic  m00_axi_wready;
		logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid;
		logic [1 : 0] m00_axi_bresp;
		logic [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser;
		logic  m00_axi_bvalid;
		logic  m00_axi_bready;
		logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid;
		logic [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr;
		logic [7 : 0] m00_axi_arlen;
		logic [2 : 0] m00_axi_arsize;
		logic [1 : 0] m00_axi_arburst;
		logic  m00_axi_arlock;
		logic [3 : 0] m00_axi_arcache;
		logic [2 : 0] m00_axi_arprot;
		logic [3 : 0] m00_axi_arqos;
		logic [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser;
	    logic  m00_axi_arvalid;
		logic  m00_axi_arready;
		logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid;
		logic [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata;
		logic [1 : 0] m00_axi_rresp;
		logic  m00_axi_rlast;
		logic [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser;
		logic  m00_axi_rvalid;
		logic  m00_axi_rready;
		
//		logic [ERASE_ADDR_WIDTH-1:0] erase_addr;
//        logic erase_valid;
//        logic erase_ready;
		logic[1:0] mode;
		logic[3:0] write_id;
		logic clk, rst;
		
		assign m00_axis_aclk = clk;
        assign s00_axis_aclk = clk;
        assign s00_axi_aclk = clk;
        assign m00_axi_aclk = clk;
        
        assign m00_axis_aresetn = rst;
        assign s00_axis_aresetn = rst;
        assign s00_axi_aresetn = rst;
        assign m00_axi_aresetn = rst;
		
		AXI_request_arbiter dut(.*);

always begin 
#1 clk <= ~clk;
end

// interface reaction
always begin
@(clk iff m00_axi_arvalid == 1)
m00_axi_arready <= 1;
#2 m00_axi_arready <= 0;

#20 m00_axi_rvalid <= 1'b1;
@(clk iff m00_axi_rready == 1)
m00_axi_rvalid <= 1'b0;
end

always begin
@(clk iff m00_axi_awvalid == 1)
m00_axi_awready <= 1'b1;
#2 m00_axi_awready <= 0;

@(clk iff m00_axi_wvalid == 1)
m00_axi_wready <= 1;
#2 m00_axi_wready <= 0;


#20 m00_axi_bvalid <= 1;
m00_axi_bid = write_id;
@(clk iff m00_axi_bready == 1);
m00_axi_bvalid <= 0;
end

always begin
@(clk iff m00_axis_tvalid == 1)
m00_axis_tready <= 1;
// mode <= m00_axis_tdata[MODE_HIGH_ADDR:MODE_LOW_ADDR];
#2 m00_axis_tready <= 0;

#20 s00_axis_tvalid <= 1;
s00_axis_tuser <= mode;
@(clk iff s00_axis_tready == 1)
s00_axis_tvalid <= 0;
end

task read_test(input logic[3:0] id, input logic[3:0] user);
    mode = 0;
    @(clk);
    s00_axi_arvalid <= 1'b1;
    s00_axi_arid <= id;
    s00_axi_araddr <= '0;
    s00_axi_aruser <= user;
    
    @(clk iff s00_axi_arready == 1)
    s00_axi_arvalid <= 1'b0;
   

    @(clk iff s00_axi_rvalid)
    s00_axi_rready <= 1'b1;
    #2 s00_axi_rready <= 1'b0;
    
    $display("Read Test Passed!");

endtask

task write_test(input logic[3:0] id, input logic[3:0] user);
    @(clk);
    mode = 1;
    write_id = id;
    s00_axi_awvalid <= 1'b1;
    s00_axi_awid <= id;
    s00_axi_awaddr <= '0;
    s00_axi_awuser <= user;
    
    @(clk iff s00_axi_awready == 1)
    s00_axi_awvalid <= 1'b0;
    
    #20
    @(clk)
    s00_axi_wvalid <= 1'b1;
    
    @(clk iff s00_axi_wready)
    s00_axi_wvalid <= 1'b0;

    @(clk iff s00_axi_bvalid)
    s00_axi_bready <= 1'b1;
    #2 s00_axi_bready <= 1'b0;

    
    $display("Write Test Passed!");

endtask


initial begin
    clk = 0;
    rst = 0;
    m00_axis_tready = '0;
    s00_axis_tvalid = '0;
    m00_axi_arready = '0;
    m00_axi_awready = '0;
    s00_axi_bready = '0;
    
    #2 rst = 1;
    
    #10;
    
    read_test(2,0);
    read_test(4,1);
    
    #30
    write_test(3,0);
    #30
    write_test(5,4'b0001);
    
    $finish;
    
end


endmodule
