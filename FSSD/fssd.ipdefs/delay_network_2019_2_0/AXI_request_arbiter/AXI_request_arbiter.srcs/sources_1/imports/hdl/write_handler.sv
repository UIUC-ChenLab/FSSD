`timescale 1ns / 1ps

module write_handler #(
    	// Users to add parameters here
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

		//parameter ERASE_ADDR_WIDTH          = 32,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 4,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_S00_AXI_AWUSER_WIDTH	= 4,

        // Parameters of Axi Master Bus Interface M00_AXI
		parameter integer C_M00_AXI_ID_WIDTH	= 4,
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M00_AXI_AWUSER_WIDTH	= 0,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 64
)
(
        // Ports of FIFO
		input logic fifo_full,
        output logic fifo_wr,
        output logic [C_S00_AXI_ID_WIDTH-1:0] fifo_din,

		// Ports of Axi Slave Bus Interface S00_AXI
		input logic  s00_axi_aclk,
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


		// Ports of Axi Master Bus Interface M00_AXIS
		output logic  m00_axis_tvalid,
		output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		output logic  m00_axis_tlast,
		input logic  m00_axis_tready,
		
		// Ports of Axi Master Bus Interface M00_AXI
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
		input logic  m00_axi_awready
);

    localparam READ_MODE = 0, WRITE_MODE = 1, ERASE_MODE = 2;

    localparam NOT_IN_CACHE = 0, IN_CACHE = 1;
    
    enum int {halt, send_to_dram, send_to_dn, send_to_fifo, resp} state, next_state;

    
    // state transition logic
    always_ff @(posedge s00_axi_aclk) begin
        if (~s00_axi_aresetn) begin
            state <= halt;
        end
        else begin
            state <= next_state;
        end
    end
    
    // next state logic
    always_comb begin
        next_state = state;
        case(state)
            halt: begin
                if (s00_axi_awvalid & ~fifo_full) begin
                    next_state = send_to_dram;
                end
            end
            
            send_to_dram: begin
                if (m00_axi_awready) begin
                    if (s00_axi_awuser == NOT_IN_CACHE)
                        next_state = send_to_dn;
                    else if (s00_axi_awuser == IN_CACHE)
                        next_state = send_to_fifo;
                end
            end
            
            
            send_to_dn: begin
                if (m00_axis_tready) begin
                    next_state = resp;
                end
            end 
            
            send_to_fifo: begin
                next_state = resp;
            end
            
            resp: begin
                next_state = halt;
            end
            
        endcase
    end

    // state behavior
    always_comb begin

		m00_axi_awvalid = '0;
		m00_axis_tvalid = '0;
		m00_axis_tdata = '0;
		s00_axi_awready = '0;
		fifo_wr = '0;
        
        case(state)
            send_to_dram: begin
                m00_axi_awvalid = 1'b1;
            end
            
            send_to_fifo: begin
                fifo_wr = 1'b1;
            end
            
            send_to_dn: begin
                m00_axis_tdata[ADDR_HIGH_ADDR:ADDR_LOW_ADDR] = s00_axi_awaddr;
                m00_axis_tdata[MODE_HIGH_ADDR:MODE_LOW_ADDR] = WRITE_MODE;
                m00_axis_tdata[TAG_HIGH_ADDR:TAG_LOW_ADDR] = s00_axi_awid;
                m00_axis_tvalid = 1;
            end
            
            resp: begin
                s00_axi_awready = 1'b1;
            end
            
            default:;
        endcase
    end

    assign m00_axi_awid = s00_axi_awid;
    assign m00_axi_awaddr = s00_axi_awaddr;
	assign m00_axi_awlen = s00_axi_awlen;
	assign m00_axi_awsize = s00_axi_awsize;
	assign m00_axi_awburst = s00_axi_awburst;
	assign m00_axi_awlock = s00_axi_awlock;
	assign m00_axi_awcache = s00_axi_awcache;
	assign m00_axi_awprot = s00_axi_awprot;
	assign m00_axi_awqos = s00_axi_awqos;
	assign m00_axi_awuser = '0;
	
	assign fifo_din = s00_axi_awid;

endmodule