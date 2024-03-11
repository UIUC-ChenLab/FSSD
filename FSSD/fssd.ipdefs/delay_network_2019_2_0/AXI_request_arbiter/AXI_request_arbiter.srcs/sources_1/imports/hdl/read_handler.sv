`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 02:23:44 PM
// Design Name: 
// Module Name: read_handler
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


module read_handler #(
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

        parameter KEY_WIDTH                 = 4,
		parameter VAL_WIDTH                 = 128,
		//parameter ERASE_ADDR_WIDTH          = 32,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 4,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_S00_AXI_ARUSER_WIDTH	= 4,

        // Parameters of Axi Master Bus Interface M01_AXI
		parameter integer C_M01_AXI_ID_WIDTH	= 4,
		parameter integer C_M01_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M01_AXI_ARUSER_WIDTH	= 0,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 64
)
(
        // Ports of CAM
		input logic cam_full,
        output logic write,
        output logic [KEY_WIDTH-1:0] key_w,
        output logic [VAL_WIDTH-1:0] val_i,

		// Ports of Axi Slave Bus Interface S00_AXI
		input logic  s00_axi_aclk,
		input logic  s00_axi_aresetn,
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

		// Ports of Axi Master Bus Interface M00_AXIS
		input logic  m00_axis_aclk,
		input logic  m00_axis_aresetn,
		output logic  m00_axis_tvalid,
		output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
		input logic  m00_axis_tready,
		
		// Ports of Axi Master Bus Interface M01_AXI
		output logic [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_arid,
		output logic [C_M01_AXI_ADDR_WIDTH-1 : 0] m01_axi_araddr,
		output logic [7 : 0] m01_axi_arlen,
		output logic [2 : 0] m01_axi_arsize,
		output logic [1 : 0] m01_axi_arburst,
		output logic  m01_axi_arlock,
		output logic [3 : 0] m01_axi_arcache,
		output logic [2 : 0] m01_axi_arprot,
		output logic [3 : 0] m01_axi_arqos,
		output logic [C_M01_AXI_ARUSER_WIDTH-1 : 0] m01_axi_aruser,
		output logic  m01_axi_arvalid,
		input logic  m01_axi_arready
		
    );

    localparam READ_MODE = 0, WRITE_MODE = 1, ERASE_MODE = 2;

    localparam NOT_IN_CACHE = 0, IN_CACHE = 1;

    enum int {halt, load_buffer, send_to_dn, send_to_cam, send_to_dram} state, next_state; 
    
    // use local counter as key to store in CAM
    logic [KEY_WIDTH-1:0] count = '0;
    logic incr_counter;
    always_ff @(posedge s00_axi_aclk) begin
        if (~s00_axi_aresetn) begin
            count <= '0;
        end
        else if (incr_counter) begin
            if (count == ((1 << KEY_WIDTH) - 1)) begin
                count <= '0;
            end
            else begin
                count <= count + 1'b1;
            end
        end
    end

    logic [VAL_WIDTH-1:0] req_buffer;
    logic [VAL_WIDTH-1:0] req_buffer_n;
    logic ld_buf;
    always_ff @(posedge s00_axi_aclk) begin
        if (~s00_axi_aresetn) begin
            req_buffer <= '0;
        end
        else if (ld_buf) begin
            req_buffer <= req_buffer_n;
        end
    end

    always_comb begin
        req_buffer_n = '0;
        req_buffer_n[ADDR_HIGH_ADDR:ADDR_LOW_ADDR] = s00_axi_araddr;
        req_buffer_n[MODE_HIGH_ADDR:MODE_LOW_ADDR] <= READ_MODE;
        req_buffer_n[TAG_HIGH_ADDR:TAG_LOW_ADDR] <= s00_axi_arid;
        req_buffer_n[SIZE_HIGH_ADDR:SIZE_LOW_ADDR] <= s00_axi_arsize;
        req_buffer_n[LEN_HIGH_ADDR:LEN_LOW_ADDR] = s00_axi_arlen;
        req_buffer_n[BURST_HIGH_ADDR:BURST_LOW_ADDR] = s00_axi_arburst;
        req_buffer_n[LOCK_ADDR] = s00_axi_arlock;
        req_buffer_n[CACHE_HIGH_ADDR:CACHE_LOW_ADDR] = s00_axi_arcache;
        req_buffer_n[PROT_HIGH_ADDR:PROT_LOW_ADDR] = s00_axi_arprot;
        req_buffer_n[QOS_HIGH_ADDR:QOS_LOW_ADDR] = s00_axi_arqos;
    end

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
        case (state)
            halt: begin
                if (s00_axi_arvalid & ~cam_full) begin
                    next_state = load_buffer;
                end
            end
            
            load_buffer: begin
                if (s00_axi_aruser == NOT_IN_CACHE) begin
                    next_state = send_to_cam;
                end
                else if (s00_axi_aruser == IN_CACHE) begin
                    next_state = send_to_dram;
                end
            end
        
            send_to_dram: begin
                if (m01_axi_arready == 1) begin
                    next_state = halt;
                end
            end
        
            send_to_cam: begin
                next_state = send_to_dn;
            end
            
            send_to_dn: begin
                if (m00_axis_tready == 1) begin
                    next_state = halt;
                end
            end
        
            default:;
        endcase
    end
    
    // state behavior
    always_comb begin
        val_i = '0;
        m00_axis_tvalid = '0;
        m00_axis_tdata = '0;
        s00_axi_arready = 0;
        write = '0;
        key_w = '0;
        incr_counter = '0;
        ld_buf = '0;
        m01_axi_arid = '0;
		m01_axi_araddr = '0;
		m01_axi_arlen = '0;
		m01_axi_arsize = '0;
		m01_axi_arburst = '0;
		m01_axi_arlock = '0;
		m01_axi_arcache = '0;
		m01_axi_arprot = '0;
		m01_axi_arqos = '0;
		m01_axi_arvalid = '0;
        
        case (state)
            load_buffer: begin
                ld_buf = 1'b1;
                s00_axi_arready = 1'b1;
            end
            
            send_to_cam: begin
                val_i = req_buffer;
                key_w = count;
                write = 1'b1;
            end
            
            send_to_dn: begin
                m00_axis_tdata[ADDR_HIGH_ADDR:ADDR_LOW_ADDR] = req_buffer[ADDR_HIGH_ADDR:ADDR_LOW_ADDR];
                m00_axis_tdata[MODE_HIGH_ADDR:MODE_LOW_ADDR] = READ_MODE;
                m00_axis_tdata[TAG_HIGH_ADDR:TAG_LOW_ADDR] = count;
                m00_axis_tvalid = 1'b1;
            end
            
            send_to_dram: begin
                m01_axi_arid = req_buffer[TAG_HIGH_ADDR:TAG_LOW_ADDR];
		        m01_axi_araddr = req_buffer[ADDR_HIGH_ADDR:ADDR_LOW_ADDR];
		        m01_axi_arlen = req_buffer[LEN_HIGH_ADDR:LEN_LOW_ADDR];
		        m01_axi_arsize = req_buffer[SIZE_HIGH_ADDR:SIZE_LOW_ADDR];
		        m01_axi_arburst = req_buffer[BURST_HIGH_ADDR:BURST_LOW_ADDR];
		        m01_axi_arlock = req_buffer[LOCK_ADDR];
		        m01_axi_arcache = req_buffer[CACHE_HIGH_ADDR:CACHE_LOW_ADDR];
		        m01_axi_arprot = req_buffer[PROT_HIGH_ADDR:PROT_LOW_ADDR];
		        m01_axi_arqos = req_buffer[QOS_HIGH_ADDR:QOS_LOW_ADDR];
		        m01_axi_arvalid = 1'b1;
            end
            
            default:;
            
        endcase
        
    end
    
endmodule
