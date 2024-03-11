`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 10:20:11 PM
// Design Name: 
// Module Name: dn_response_handler
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


module dn_response_handler #(
		// Users to add parameters here
        parameter KEY_WIDTH                 = 4,
		parameter VAL_WIDTH                 = 128,
		
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


		// Parameters of Axi Slave Bus Interface S02_AXI
		parameter integer C_S02_AXI_ID_WIDTH	= 4,
		parameter integer C_S02_AXI_BUSER_WIDTH	= 0,

		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S00_AXIS_TID_WIDTH	= 4,
		parameter integer C_S00_AXIS_TUSER_WIDTH = 2,

		// Parameters of Axi Master Bus Interface M02_AXI
		parameter integer C_M02_AXI_ID_WIDTH	= 4,
		parameter integer C_M02_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M02_AXI_ARUSER_WIDTH	= 0
)
(
        		// Users to add ports here
        output logic read,
        output logic [KEY_WIDTH-1:0] key_r,
        input logic [VAL_WIDTH-1:0] val_o,
        input logic valid_o,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		output logic [C_S02_AXI_ID_WIDTH-1 : 0] s02_axi_bid,
		output logic [1 : 0] s02_axi_bresp,
		output logic [C_S02_AXI_BUSER_WIDTH-1 : 0] s02_axi_buser,
		output logic  s02_axi_bvalid,
		input logic  s02_axi_bready,
		
		// Ports of Axi Slave Bus Interface S00_AXIS
		input logic  s00_axis_aclk,
		input logic  s00_axis_aresetn,
		output logic  s00_axis_tready,
		input logic [C_S00_AXIS_TID_WIDTH-1 : 0] s00_axis_tid,
		input logic [C_S00_AXIS_TUSER_WIDTH-1 : 0] s00_axis_tuser,
		input logic  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXI
		
		output logic [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_arid,
		output logic [C_M02_AXI_ADDR_WIDTH-1 : 0] m02_axi_araddr,
		output logic [7 : 0] m02_axi_arlen,
		output logic [2 : 0] m02_axi_arsize,
		output logic [1 : 0] m02_axi_arburst,
		output logic  m02_axi_arlock,
		output logic [3 : 0] m02_axi_arcache,
		output logic [2 : 0] m02_axi_arprot,
		output logic [3 : 0] m02_axi_arqos,
		output logic [C_M02_AXI_ARUSER_WIDTH-1 : 0] m02_axi_aruser,
		output logic  m02_axi_arvalid,
		input logic  m02_axi_arready
    );
    

	// Add user logic here
    localparam READ_MODE = 0, WRITE_MODE = 1, ERASE_MODE = 2;
    
    enum int {halt, fetch_data, load_data, send, write_resp, resp} state, next_state;
    
    logic[5:0] mode;
    logic[VAL_WIDTH-1:0] data_buffer = '0;
    assign mode = data_buffer[MODE_HIGH_ADDR:MODE_LOW_ADDR];
    
    logic ld_data, ar_valid, b_valid, t_ready;
    
    always_ff @(posedge s00_axis_aclk) begin
        if (ld_data & valid_o) 
            data_buffer <= val_o;
        else
            data_buffer <= data_buffer;
    end
    
    always_ff @(posedge s00_axis_aclk) begin
        if (~s00_axis_aresetn) begin
            state <= halt;
        end
        else begin
            state <= next_state;
        end    
    end
    
    always_comb begin
        next_state = state;
        
        case(state)
            halt: begin
                if (s00_axis_tvalid) begin
                    if (s00_axis_tuser == READ_MODE)
                        next_state = fetch_data;
                    else if (s00_axis_tuser == WRITE_MODE)
                        next_state = write_resp;
                    else if (s00_axis_tuser == ERASE_MODE)
                        next_state = resp;
                end
            end
            fetch_data: begin
                next_state = load_data;
            end    
            load_data: begin
                next_state = send;
            end
            send: begin
                if (m02_axi_arready)
                    next_state = resp;
            end            
            write_resp: begin
                if (s02_axi_bready)
                    next_state = resp;
            end
            resp: begin
                next_state = halt;
            end
            default:;
        endcase
        
        ld_data = 0;
        ar_valid = 0;
        b_valid = 0;
        t_ready = 0;
        read = 0;
        key_r = '0;
        case(state)
            load_data: begin
                ld_data = 1;
            end
            fetch_data: begin
                read = 1;
                key_r = s00_axis_tid;
            end
            send: begin
                ar_valid = 1;
            end
            write_resp: begin
                b_valid = 1;
            end
            resp: begin
                t_ready = 1;
            end
            default:;
        endcase
    end

    assign s02_axi_bvalid = b_valid;
    assign m02_axi_arvalid = ar_valid;
    assign s00_axis_tready = t_ready;

    assign s02_axi_bid = s00_axis_tid;
    assign s02_axi_bresp = '0;
    
    assign m02_axi_arid = data_buffer[TAG_HIGH_ADDR:TAG_LOW_ADDR];
    assign m02_axi_araddr = data_buffer[ADDR_HIGH_ADDR:ADDR_LOW_ADDR];
    assign m02_axi_arlen = data_buffer[LEN_HIGH_ADDR:LEN_LOW_ADDR];
    assign m02_axi_arsize = data_buffer[SIZE_HIGH_ADDR:SIZE_LOW_ADDR];
    assign m02_axi_arburst = data_buffer[BURST_HIGH_ADDR:BURST_LOW_ADDR];
    assign m02_axi_arlock = data_buffer[LOCK_ADDR];
    assign m02_axi_arcache = data_buffer[CACHE_HIGH_ADDR:CACHE_LOW_ADDR];
    assign m02_axi_arprot = data_buffer[PROT_HIGH_ADDR:PROT_LOW_ADDR];
    assign m02_axi_arqos = data_buffer[QOS_HIGH_ADDR:QOS_LOW_ADDR];
    assign m02_axi_aruser = '0;
	// User logic ends
	
endmodule
