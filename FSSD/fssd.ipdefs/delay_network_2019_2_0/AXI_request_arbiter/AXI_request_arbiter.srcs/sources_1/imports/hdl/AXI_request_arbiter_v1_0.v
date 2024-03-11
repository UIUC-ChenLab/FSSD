
`timescale 1 ns / 1 ps

	module AXI_request_arbiter #
	(
		// Users to add parameters here
        parameter KEY_WIDTH                 = 4,
		parameter VAL_WIDTH                 = 128,
		parameter CAM_DEPTH                 = 16,
		
		//parameter ERASE_ADDR_WIDTH          = 32,
		
        parameter USER_HIGH_ADDR            = 105,
        parameter USER_LOW_ADDR             = 59,
        parameter LEN_HIGH_ADDR             = 105,
        parameter LEN_LOW_ADDR              = 98,
        parameter BURST_HIGH_ADDR           = 96,
        parameter BURST_LOW_ADDR            = 95,
        parameter QOS_HIGH_ADDR             = 94,
        parameter QOS_LOW_ADDR              = 91,
        parameter LOCK_ADDR                 = 90,
        parameter CACHE_HIGH_ADDR           = 85,
        parameter CACHE_LOW_ADDR            = 82,
        parameter PROT_HIGH_ADDR            = 80,
        parameter PROT_LOW_ADDR             = 78,
        parameter SIZE_HIGH_ADDR            = 70,
        parameter SIZE_LOW_ADDR             = 62,
        
        parameter TAG_HIGH_ADDR             = 37,
        parameter TAG_LOW_ADDR              = 34,
        parameter MODE_HIGH_ADDR            = 33,
        parameter MODE_LOW_ADDR             = 32,
        parameter ADDR_HIGH_ADDR            = 31,
        parameter ADDR_LOW_ADDR             = 0,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 4,
		parameter integer C_S00_AXI_DATA_WIDTH	= 512,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_S00_AXI_AWUSER_WIDTH	= 4,
		parameter integer C_S00_AXI_ARUSER_WIDTH	= 4,
		parameter integer C_S00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_BUSER_WIDTH	= 0,

		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TDATA_WIDTH	= 0,
		parameter integer C_S00_AXIS_TID_WIDTH	= 4,
		parameter integer C_S00_AXIS_TUSER_WIDTH = 2,

		// Parameters of Axi Master Bus Interface M00_AXI
		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h00000000,
		parameter integer C_M00_AXI_BURST_LEN	= 16,
		parameter integer C_M00_AXI_ID_WIDTH	= 4,
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M00_AXI_DATA_WIDTH	= 512,
		parameter integer C_M00_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_BUSER_WIDTH	= 0,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 64
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input   s00_axi_aclk,
		input logic  s00_axi_aresetn,
		input logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_awid,
		input logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input logic [7 : 0] s00_axi_awlen,
		input logic [2 : 0] s00_axi_awsize,
		input logic [1 : 0] s00_axi_awburst,
		input logic  s00_axi_awlock,
		input logic [3 : 0] s00_axi_awcache,
		input logic [2 : 0] s00_axi_awprot,
		input logic [3 : 0] s00_axi_awqos,
		input logic [3 : 0] s00_axi_awregion,
		input logic [C_S00_AXI_AWUSER_WIDTH-1 : 0] s00_axi_awuser,
		input logic  s00_axi_awvalid,
		output logic  s00_axi_awready,
		input logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input logic [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input logic  s00_axi_wlast,
		input logic [C_S00_AXI_WUSER_WIDTH-1 : 0] s00_axi_wuser,
		input logic  s00_axi_wvalid,
		output logic  s00_axi_wready,
		output logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid,
		output logic [1 : 0] s00_axi_bresp,
		output logic [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser,
		output logic  s00_axi_bvalid,
		input logic  s00_axi_bready,
		input logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_arid,
		input logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input logic [7 : 0] s00_axi_arlen,
		input logic [2 : 0] s00_axi_arsize,
		input logic [1 : 0] s00_axi_arburst,
		input logic  s00_axi_arlock,
		input logic [3 : 0] s00_axi_arcache,
		input logic [2 : 0] s00_axi_arprot,
		input logic [3 : 0] s00_axi_arqos,
		input logic [3 : 0] s00_axi_arregion,
		input logic [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser,
		input logic  s00_axi_arvalid,
		output logic  s00_axi_arready,
		output logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_rid,
		output logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output logic [1 : 0] s00_axi_rresp,
		output logic  s00_axi_rlast,
		output logic [C_S00_AXI_RUSER_WIDTH-1 : 0] s00_axi_ruser,
		output logic  s00_axi_rvalid,
		input logic  s00_axi_rready,

		// Ports of Axi Slave Bus Interface S00_AXIS
		input logic  s00_axis_aclk,
		input logic  s00_axis_aresetn,
		output logic  s00_axis_tready,
		input logic [C_S00_AXIS_TID_WIDTH-1 : 0] s00_axis_tid,
		input logic [C_S00_AXIS_TUSER_WIDTH-1 : 0] s00_axis_tuser,
		input logic  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXI
		input logic  m00_axi_aclk,
		input logic  m00_axi_aresetn,
		output logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid,
		output logic [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
		output logic [7 : 0] m00_axi_awlen,
		output logic [2 : 0] m00_axi_awsize,
		output logic [1 : 0] m00_axi_awburst,
		output logic  m00_axi_awlock,
		output logic [3 : 0] m00_axi_awcache,
		output logic [2 : 0] m00_axi_awprot,
		output logic [3 : 0] m00_axi_awqos,
		output logic [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser,
		output logic  m00_axi_awvalid,
		input logic  m00_axi_awready,
		output logic [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
		output logic [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
		output logic  m00_axi_wlast,
		output logic [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser,
		output logic  m00_axi_wvalid,
		input logic  m00_axi_wready,
		input logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid,
		input logic [1 : 0] m00_axi_bresp,
		input logic [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser,
		input logic  m00_axi_bvalid,
		output logic  m00_axi_bready,
		output logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid,
		output logic [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
		output logic [7 : 0] m00_axi_arlen,
		output logic [2 : 0] m00_axi_arsize,
		output logic [1 : 0] m00_axi_arburst,
		output logic  m00_axi_arlock,
		output logic [3 : 0] m00_axi_arcache,
		output logic [2 : 0] m00_axi_arprot,
		output logic [3 : 0] m00_axi_arqos,
		output logic [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser,
		output logic  m00_axi_arvalid,
		input logic  m00_axi_arready,
		input logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid,
		input logic [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
		input logic [1 : 0] m00_axi_rresp,
		input logic  m00_axi_rlast,
		input logic [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser,
		input logic  m00_axi_rvalid,
		output logic  m00_axi_rready,

		// Ports of Axi Master Bus Interface M00_AXIS
		input logic  m00_axis_aclk,
		input logic  m00_axis_aresetn,
		output logic  m00_axis_tvalid,
		output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output logic  m00_axis_tlast,
		input logic  m00_axis_tready
	);


	// Add user logic here
    // internal connection
    
    // CAM
    logic write, read, cam_full, valid_o;
    logic [KEY_WIDTH-1:0] key_w;
    logic [KEY_WIDTH-1:0] key_r;
    logic [VAL_WIDTH-1:0] val_i;
    logic [VAL_WIDTH-1:0] val_o;
    
    // FIFO
    logic fifo_full, fifo_empty;
    logic fifo_wr, fifo_rd;
    logic [C_S00_AXI_ID_WIDTH-1:0] fifo_din;
    logic [C_S00_AXI_ID_WIDTH-1:0] fifo_dout;
    
    // rw to dn
    logic  m00_read_axis_tvalid;
	logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_read_axis_tdata;
	logic  m00_read_axis_tready;
	logic  m00_write_axis_tvalid;
	logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_write_axis_tdata;
	logic  m00_write_axis_tready;
    
    // read handler to dram
    logic [C_M00_AXI_ID_WIDTH-1 : 0] m01_axi_arid;
	logic [C_M00_AXI_ADDR_WIDTH-1 : 0] m01_axi_araddr;
	logic [7 : 0] m01_axi_arlen;
	logic [2 : 0] m01_axi_arsize;
	logic [1 : 0] m01_axi_arburst;
	logic  m01_axi_arlock;
	logic [3 : 0] m01_axi_arcache;
	logic [2 : 0] m01_axi_arprot;
	logic [3 : 0] m01_axi_arqos;
	logic [C_M00_AXI_ARUSER_WIDTH-1 : 0] m01_axi_aruser;
	logic  m01_axi_arvalid;
	logic  m01_axi_arready;   
    
    // dram write_response to s00
    logic [C_S00_AXI_ID_WIDTH-1 : 0] s01_axi_bid;
	logic [1 : 0] s01_axi_bresp;
	logic [C_S00_AXI_BUSER_WIDTH-1 : 0] s01_axi_buser;
	logic  s01_axi_bvalid;
	logic  s01_axi_bready;
    
    // dn to s00
    logic [C_S00_AXI_ID_WIDTH-1 : 0] s02_axi_bid;
	logic [1 : 0] s02_axi_bresp;
	logic [C_S00_AXI_BUSER_WIDTH-1 : 0] s02_axi_buser;
	logic  s02_axi_bvalid;
	logic  s02_axi_bready;
    
    // dn to dram
    logic [C_M00_AXI_ID_WIDTH-1 : 0] m02_axi_arid;
	logic [C_M00_AXI_ADDR_WIDTH-1 : 0] m02_axi_araddr;
	logic [7 : 0] m02_axi_arlen;
	logic [2 : 0] m02_axi_arsize;
	logic [1 : 0] m02_axi_arburst;
	logic  m02_axi_arlock;
	logic [3 : 0] m02_axi_arcache;
	logic [2 : 0] m02_axi_arprot;
	logic [3 : 0] m02_axi_arqos;
	logic [C_M00_AXI_ARUSER_WIDTH-1 : 0] m02_axi_aruser;
	logic  m02_axi_arvalid;
	logic  m02_axi_arready;
    
    assign m00_axis_tlast = m00_axis_tvalid;
    
    // Read Reequest Handling
    read_handler #(
        .USER_HIGH_ADDR(USER_HIGH_ADDR),
        .USER_LOW_ADDR(USER_LOW_ADDR),
        .LEN_HIGH_ADDR(LEN_HIGH_ADDR),
        .LEN_LOW_ADDR(LEN_LOW_ADDR),
        .BURST_HIGH_ADDR(BURST_HIGH_ADDR),
        .BURST_LOW_ADDR(BURST_LOW_ADDR),
        .QOS_HIGH_ADDR(QOS_HIGH_ADDR),
        .QOS_LOW_ADDR(QOS_LOW_ADDR),
        .LOCK_ADDR(LOCK_ADDR),
        .CACHE_HIGH_ADDR(CACHE_HIGH_ADDR),
        .CACHE_LOW_ADDR(CACHE_LOW_ADDR),
        .PROT_HIGH_ADDR(PROT_HIGH_ADDR),
        .PROT_LOW_ADDR(PROT_LOW_ADDR),
        .SIZE_HIGH_ADDR(SIZE_HIGH_ADDR),
        .SIZE_LOW_ADDR(SIZE_LOW_ADDR),
        .TAG_HIGH_ADDR(TAG_HIGH_ADDR),
        .TAG_LOW_ADDR(TAG_LOW_ADDR),
        .MODE_HIGH_ADDR(MODE_HIGH_ADDR),
        .MODE_LOW_ADDR(MODE_LOW_ADDR),
        .ADDR_HIGH_ADDR(ADDR_HIGH_ADDR),
        .ADDR_LOW_ADDR(ADDR_LOW_ADDR),

        .KEY_WIDTH(KEY_WIDTH),
		.VAL_WIDTH(VAL_WIDTH),
		// Parameters of Axi Slave Bus Interface S00_AXI
		.C_S00_AXI_ID_WIDTH(C_S00_AXI_ID_WIDTH),
		.C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH),
		.C_S00_AXI_ARUSER_WIDTH(C_S00_AXI_ARUSER_WIDTH),
        // Parameters of Axi Master Bus Interface M01_AXI
		.C_M01_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_M01_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_M01_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH),
		// Parameters of Axi Master Bus Interface M00_AXIS
		.C_M00_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH)
    ) read_driver(
        // Ports of CAM
		.cam_full,
        .write,
        .key_w,
        .val_i,
		// Ports of Axi Slave Bus Interface S00_AXI
		.s00_axi_aclk,
		.s00_axi_aresetn,
		.s00_axi_arid,
		.s00_axi_araddr,
		.s00_axi_arlen,
		.s00_axi_arsize,
		.s00_axi_arburst,
		.s00_axi_arlock,
		.s00_axi_arcache,
		.s00_axi_arprot,
		.s00_axi_arqos,
		.s00_axi_arregion,
		.s00_axi_aruser,
		.s00_axi_arvalid,
		.s00_axi_arready,
		// Ports of Axi Master Bus Interface M00_AXIS
		.m00_axis_aclk,
		.m00_axis_aresetn,
		.m00_axis_tvalid(m00_read_axis_tvalid),
		.m00_axis_tdata(m00_read_axis_tdata),
		.m00_axis_tready(m00_read_axis_tready),
		// Ports of Axi Master Bus Interface M01_AXI
		.m01_axi_arid,
		.m01_axi_araddr,
		.m01_axi_arlen,
		.m01_axi_arsize,
		.m01_axi_arburst,
		.m01_axi_arlock,
		.m01_axi_arcache,
		.m01_axi_arprot,
		.m01_axi_arqos,
		.m01_axi_aruser,
		.m01_axi_arvalid,
		.m01_axi_arready    
    );
    
    cam #(
        .key_width(KEY_WIDTH),
        .val_width(VAL_WIDTH),
        .depth(CAM_DEPTH)
    ) read_request_buffer (
        .clk(m00_axi_aclk),
        .arstn(m00_axi_aresetn),
        .read,
        .write,
        .key_r,
        .key_w,
        .val_i,
        .val_o,
        .valid_o,
        .cam_full
    );
    
    // R channel pass through
    assign s00_axi_rid = m00_axi_rid;
	assign s00_axi_rdata = m00_axi_rdata;
	assign s00_axi_rresp = m00_axi_rresp;
	assign s00_axi_rlast = m00_axi_rlast;
	assign s00_axi_ruser = m00_axi_ruser;
	assign s00_axi_rvalid = m00_axi_rvalid;
	
	assign m00_axi_rready = s00_axi_rready;
    
    
    // Write Request Handling
    write_handler #(
        .USER_HIGH_ADDR(USER_HIGH_ADDR),
        .USER_LOW_ADDR(USER_LOW_ADDR),
        .LEN_HIGH_ADDR(LEN_HIGH_ADDR),
        .LEN_LOW_ADDR(LEN_LOW_ADDR),
        .BURST_HIGH_ADDR(BURST_HIGH_ADDR),
        .BURST_LOW_ADDR(BURST_LOW_ADDR),
        .QOS_HIGH_ADDR(QOS_HIGH_ADDR),
        .QOS_LOW_ADDR(QOS_LOW_ADDR),
        .LOCK_ADDR(LOCK_ADDR),
        .CACHE_HIGH_ADDR(CACHE_HIGH_ADDR),
        .CACHE_LOW_ADDR(CACHE_LOW_ADDR),
        .PROT_HIGH_ADDR(PROT_HIGH_ADDR),
        .PROT_LOW_ADDR(PROT_LOW_ADDR),
        .SIZE_HIGH_ADDR(SIZE_HIGH_ADDR),
        .SIZE_LOW_ADDR(SIZE_LOW_ADDR),
        .TAG_HIGH_ADDR(TAG_HIGH_ADDR),
        .TAG_LOW_ADDR(TAG_LOW_ADDR),
        .MODE_HIGH_ADDR(MODE_HIGH_ADDR),
        .MODE_LOW_ADDR(MODE_LOW_ADDR),
        .ADDR_HIGH_ADDR(ADDR_HIGH_ADDR),
        .ADDR_LOW_ADDR(ADDR_LOW_ADDR),
        // Parameters of Axi Slave Bus Interface S00_AXI
		.C_S00_AXI_ID_WIDTH(C_S00_AXI_ID_WIDTH),
		.C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH),
		.C_S00_AXI_AWUSER_WIDTH(C_S00_AXI_AWUSER_WIDTH),
        // Parameters of Axi Master Bus Interface M00_AXI
		.C_M00_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_M00_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_M00_AXI_AWUSER_WIDTH(C_M00_AXI_AWUSER_WIDTH),
		// Parameters of Axi Master Bus Interface M00_AXIS
		.C_M00_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH)
    ) write_driver (
        // Ports of FIFO
		.fifo_full,
        .fifo_wr,
        .fifo_din,
		// Ports of Axi Slave Bus Interface S00_AXI
		.s00_axi_aclk,
		.s00_axi_aresetn,
		.s00_axi_awid,
		.s00_axi_awaddr,
		.s00_axi_awlen,
		.s00_axi_awsize,
		.s00_axi_awburst,
		.s00_axi_awlock,
		.s00_axi_awcache,
		.s00_axi_awprot,
		.s00_axi_awqos,
		.s00_axi_awregion,
		.s00_axi_awuser,
		.s00_axi_awvalid,
		.s00_axi_awready,
		// Ports of Axi Master Bus Interface M00_AXIS
		.m00_axis_tvalid(m00_write_axis_tvalid),
		.m00_axis_tdata(m00_write_axis_tdata),
		.m00_axis_tlast(m00_write_axis_tlast),
		.m00_axis_tready(m00_write_axis_tready),
		// Ports of Axi Master Bus Interface M00_AXI
		.m00_axi_awid,
		.m00_axi_awaddr,
		.m00_axi_awlen,
		.m00_axi_awsize,
		.m00_axi_awburst,
		.m00_axi_awlock,
		.m00_axi_awcache,
		.m00_axi_awprot,
		.m00_axi_awqos,
		.m00_axi_awuser,
		.m00_axi_awvalid,
		.m00_axi_awready
    );


    // W channel pass through
    assign m00_axi_wdata = s00_axi_wdata;
	assign m00_axi_wstrb = s00_axi_wstrb;
	assign m00_axi_wlast = s00_axi_wlast;
	assign m00_axi_wuser = s00_axi_wuser;
	assign m00_axi_wvalid = s00_axi_wvalid;
	
	assign s00_axi_wready = m00_axi_wready;

    // Write Response Handling
    write_response_handler #(
        // Parameters of Axi Master Bus Interface M00_AXI
		.C_M00_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_M00_AXI_BUSER_WIDTH(C_M00_AXI_BUSER_WIDTH),
		// Parameters of Axi Slave Bus Interface S01_AXI
		.C_S01_AXI_ID_WIDTH(C_S00_AXI_ID_WIDTH),
		.C_S01_AXI_BUSER_WIDTH(C_S00_AXI_BUSER_WIDTH)
    ) write_response_filter (
        // Ports of Axi Master Bus Interface M00_AXI
		.m00_axi_aclk,
		.m00_axi_aresetn,
		.m00_axi_bid,
		.m00_axi_bresp,
		.m00_axi_buser,
		.m00_axi_bvalid,
		.m00_axi_bready,
		// Ports of Axi Master Bus Interface S01_AXI
        .s01_axi_bid,
		.s01_axi_bresp,
		.s01_axi_buser,
		.s01_axi_bvalid,
		.s01_axi_bready,	
		// Ports of FIFO Interface
		.fifo_dout,
		.fifo_empty,
		.fifo_rd
    );


    // DN Response Handling
    dn_response_handler #(
        .USER_HIGH_ADDR(USER_HIGH_ADDR),
        .USER_LOW_ADDR(USER_LOW_ADDR),
        .LEN_HIGH_ADDR(LEN_HIGH_ADDR),
        .LEN_LOW_ADDR(LEN_LOW_ADDR),
        .BURST_HIGH_ADDR(BURST_HIGH_ADDR),
        .BURST_LOW_ADDR(BURST_LOW_ADDR),
        .QOS_HIGH_ADDR(QOS_HIGH_ADDR),
        .QOS_LOW_ADDR(QOS_LOW_ADDR),
        .LOCK_ADDR(LOCK_ADDR),
        .CACHE_HIGH_ADDR(CACHE_HIGH_ADDR),
        .CACHE_LOW_ADDR(CACHE_LOW_ADDR),
        .PROT_HIGH_ADDR(PROT_HIGH_ADDR),
        .PROT_LOW_ADDR(PROT_LOW_ADDR),
        .SIZE_HIGH_ADDR(SIZE_HIGH_ADDR),
        .SIZE_LOW_ADDR(SIZE_LOW_ADDR),
        .TAG_HIGH_ADDR(TAG_HIGH_ADDR),
        .TAG_LOW_ADDR(TAG_LOW_ADDR),
        .MODE_HIGH_ADDR(MODE_HIGH_ADDR),
        .MODE_LOW_ADDR(MODE_LOW_ADDR),
        .ADDR_HIGH_ADDR(ADDR_HIGH_ADDR),
        .ADDR_LOW_ADDR(ADDR_LOW_ADDR),

        .KEY_WIDTH(KEY_WIDTH),
		.VAL_WIDTH(VAL_WIDTH),
		// Parameters of Axi Slave Bus Interface S02_AXI
		.C_S02_AXI_ID_WIDTH(C_S00_AXI_ID_WIDTH),
		.C_S02_AXI_BUSER_WIDTH(C_S00_AXI_BUSER_WIDTH),
		// Parameters of Axi Slave Bus Interface S00_AXIS
		.C_S00_AXIS_TID_WIDTH(C_S00_AXIS_TID_WIDTH),
		.C_S00_AXIS_TUSER_WIDTH(C_S00_AXIS_TUSER_WIDTH),
		// Parameters of Axi Master Bus Interface M02_AXI
		.C_M02_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_M02_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_M02_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH)
    ) dn_response_arbiter (
        .read,
        .key_r,
        .val_o,
        .valid_o,
		// Ports of Axi Slave Bus Interface S00_AXI
		.s02_axi_bid,
		.s02_axi_bresp,
		.s02_axi_buser,
		.s02_axi_bvalid,
		.s02_axi_bready,	
		// Ports of Axi Slave Bus Interface S00_AXIS
		.s00_axis_aclk,
		.s00_axis_aresetn,
		.s00_axis_tready,
		.s00_axis_tid,
		.s00_axis_tuser,
		.s00_axis_tvalid,
		// Ports of Axi Master Bus Interface M00_AXI
		.m02_axi_arid,
		.m02_axi_araddr,
		.m02_axi_arlen,
		.m02_axi_arsize,
		.m02_axi_arburst,
		.m02_axi_arlock,
		.m02_axi_arcache,
		.m02_axi_arprot,
		.m02_axi_arqos,
		.m02_axi_aruser,
		.m02_axi_arvalid,
		.m02_axi_arready
    );

    // Interconnect

    // AXIS: read/write driver to DN
    merge_rw_interconnect merge_rw_req (
        .ACLK(m00_axis_aclk),                                  // input wire ACLK
        .ARESETN(m00_axis_aresetn),                            // input wire ARESETN
        .S00_AXIS_ACLK(m00_axis_aclk),                // input wire S00_AXIS_ACLK
        .S01_AXIS_ACLK(m00_axis_aclk),                // input wire S01_AXIS_ACLK
        .S00_AXIS_ARESETN(m00_axis_aresetn),          // input wire S00_AXIS_ARESETN
        .S01_AXIS_ARESETN(m00_axis_aresetn),          // input wire S01_AXIS_ARESETN
        .S00_AXIS_TVALID(m00_read_axis_tvalid),            // input wire S00_AXIS_TVALID
        .S01_AXIS_TVALID(m00_write_axis_tvalid),            // input wire S01_AXIS_TVALID
        .S00_AXIS_TREADY(m00_read_axis_tready),            // output wire S00_AXIS_TREADY
        .S01_AXIS_TREADY(m00_write_axis_tready),            // output wire S01_AXIS_TREADY
        .S00_AXIS_TDATA(m00_read_axis_tdata),              // input wire [63 : 0] S00_AXIS_TDATA
        .S01_AXIS_TDATA(m00_write_axis_tdata),              // input wire [63 : 0] S01_AXIS_TDATA
        .M00_AXIS_ACLK(m00_axis_aclk),                // input wire M00_AXIS_ACLK
        .M00_AXIS_ARESETN(m00_axis_aresetn),          // input wire M00_AXIS_ARESETN
        .M00_AXIS_TVALID(m00_axis_tvalid),            // output wire M00_AXIS_TVALID
        .M00_AXIS_TREADY(m00_axis_tready),            // input wire M00_AXIS_TREADY
        .M00_AXIS_TDATA(m00_axis_tdata),              // output wire [63 : 0] M00_AXIS_TDATA
        .S00_ARB_REQ_SUPPRESS('0),  // input wire S00_ARB_REQ_SUPPRESS
        .S01_ARB_REQ_SUPPRESS('0)  // input wire S01_ARB_REQ_SUPPRESS
    );
    
    assign m00_axis_tlast = m00_axis_tvalid;

    // AR to DRAM
    ar_channel_interconnect #(
        // Parameters of Axi Master Bus Interface M00_AXI
		.C_M00_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_M00_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_M00_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH),
		// Parameters of Axi Master Bus Interface S02_AXI
		.C_S02_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_S02_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_S02_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH),
		// Parameters of Axi Master Bus Interface S01_AXI
		.C_S01_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_S01_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_S01_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH)
    ) ar_xconnect (
        // Ports of Axi Master Bus Interface S01_AXI
        .s01_axi_arid(m01_axi_arid),
		.s01_axi_araddr(m01_axi_araddr),
		.s01_axi_arlen(m01_axi_arlen),
		.s01_axi_arsize(m01_axi_arsize),
		.s01_axi_arburst(m01_axi_arburst),
		.s01_axi_arlock(m01_axi_arburst),
		.s01_axi_arcache(m01_axi_arcache),
		.s01_axi_arprot(m01_axi_arprot),
		.s01_axi_arqos(m01_axi_arqos),
		.s01_axi_aruser(m01_axi_aruser),
		.s01_axi_arvalid(m01_axi_arvalid),
		.s01_axi_arready(m01_axi_arready),
		// Ports of Axi Master Bus Interface S02_AXI
		.s02_axi_arid(m02_axi_arid),
		.s02_axi_araddr(m02_axi_araddr),
		.s02_axi_arlen(m02_axi_arlen),
		.s02_axi_arsize(m02_axi_arsize),
		.s02_axi_arburst(m02_axi_arburst),
		.s02_axi_arlock(m02_axi_arburst),
		.s02_axi_arcache(m02_axi_arcache),
		.s02_axi_arprot(m02_axi_arprot),
		.s02_axi_arqos(m02_axi_arqos),
		.s02_axi_aruser(m02_axi_aruser),
		.s02_axi_arvalid(m02_axi_arvalid),
		.s02_axi_arready(m02_axi_arready),
		// Ports of Axi Master Bus Interface M00_AXI
		.m00_axi_aclk,
		.m00_axi_aresetn,
		.m00_axi_arid,
		.m00_axi_araddr,
		.m00_axi_arlen,
		.m00_axi_arsize,
		.m00_axi_arburst,
		.m00_axi_arlock,
		.m00_axi_arcache,
		.m00_axi_arprot,
		.m00_axi_arqos,
		.m00_axi_aruser,
		.m00_axi_arvalid,
		.m00_axi_arready
    );

    // B to S00
    b_channel_interconnect #(
        // Parameters of Axi Slave Bus Interface M02_AXI
		.C_M02_AXI_ID_WIDTH(C_S00_AXI_ID_WIDTH),
		.C_M02_AXI_BUSER_WIDTH(C_S00_AXI_BUSER_WIDTH),
		// Parameters of Axi Slave Bus Interface M01_AXI
		.C_M01_AXI_ID_WIDTH(C_S00_AXI_ID_WIDTH),
		.C_M01_AXI_BUSER_WIDTH(C_S00_AXI_BUSER_WIDTH),
		// Parameters of Axi Slave Bus Interface S00_AXI
		.C_S00_AXI_ID_WIDTH(C_S00_AXI_ID_WIDTH),
		.C_S00_AXI_BUSER_WIDTH(C_S00_AXI_BUSER_WIDTH)
    ) b_xconnect (
        // Ports for M02_AXI
    	.m02_axi_bid(s02_axi_bid),
		.m02_axi_bresp(s02_axi_bresp),
		.m02_axi_buser(s02_axi_buser),
		.m02_axi_bvalid(s02_axi_bvalid),
		.m02_axi_bready(s02_axi_bready),
		// Ports for M01_AXI
		.m01_axi_bid(s01_axi_bid),
		.m01_axi_bresp(s01_axi_bresp),
		.m01_axi_buser(s01_axi_buser),
		.m01_axi_bvalid(s01_axi_bvalid),
		.m01_axi_bready(s01_axi_bready),
		// Ports of Axi Slave Bus Interface S00_AXI
		.s00_axi_aclk,
		.s00_axi_aresetn,	
		.s00_axi_bid,
		.s00_axi_bresp,
		.s00_axi_buser,
		.s00_axi_bvalid,
		.s00_axi_bready
    );

    // FIFO
    write_id_fifo write_cached_req_fifo(
        .clk(s00_axi_aclk),                  // input wire clk
        .srst(!s00_axi_aresetn),                // input wire srst
        .din(fifo_din),                  // input wire [3 : 0] din
        .wr_en(fifo_wr),              // input wire wr_en
        .rd_en(fifo_rd),              // input wire rd_en
        .dout(fifo_dout),                // output wire [3 : 0] dout
        .full(fifo_full),                // output wire full
        .empty(fifo_empty),              // output wire empty
        .wr_rst_busy(),  // output wire wr_rst_busy
        .rd_rst_busy()  // output wire rd_rst_busy
    );


	// User logic ends

	endmodule
