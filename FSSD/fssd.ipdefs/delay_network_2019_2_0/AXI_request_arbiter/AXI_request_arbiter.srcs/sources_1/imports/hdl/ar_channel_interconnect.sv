`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2022 10:41:14 PM
// Design Name: 
// Module Name: ar_channel_interconnect
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


module ar_channel_interconnect #(
        // Parameters of Axi Master Bus Interface M00_AXI
		parameter integer C_M00_AXI_ID_WIDTH	= 4,
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M00_AXI_ARUSER_WIDTH	= 0,
		
		// Parameters of Axi Master Bus Interface S02_AXI
		parameter integer C_S02_AXI_ID_WIDTH	= 4,
		parameter integer C_S02_AXI_ADDR_WIDTH	= 32,
		parameter integer C_S02_AXI_ARUSER_WIDTH	= 0,
		
		// Parameters of Axi Master Bus Interface S01_AXI
		parameter integer C_S01_AXI_ID_WIDTH	= 4,
		parameter integer C_S01_AXI_ADDR_WIDTH	= 32,
		parameter integer C_S01_AXI_ARUSER_WIDTH	= 0
)
(
        // Ports of Axi Master Bus Interface S01_AXI
        input logic [C_S01_AXI_ID_WIDTH-1 : 0] s01_axi_arid,
		input logic [C_S01_AXI_ADDR_WIDTH-1 : 0] s01_axi_araddr,
		input logic [7 : 0] s01_axi_arlen,
		input logic [2 : 0] s01_axi_arsize,
		input logic [1 : 0] s01_axi_arburst,
		input logic  s01_axi_arlock,
		input logic [3 : 0] s01_axi_arcache,
		input logic [2 : 0] s01_axi_arprot,
		input logic [3 : 0] s01_axi_arqos,
		input logic [C_S01_AXI_ARUSER_WIDTH-1 : 0] s01_axi_aruser,
		input logic  s01_axi_arvalid,
		output logic  s01_axi_arready,
		
		// Ports of Axi Master Bus Interface S02_AXI
		input logic [C_S02_AXI_ID_WIDTH-1 : 0] s02_axi_arid,
		input logic [C_S02_AXI_ADDR_WIDTH-1 : 0] s02_axi_araddr,
		input logic [7 : 0] s02_axi_arlen,
		input logic [2 : 0] s02_axi_arsize,
		input logic [1 : 0] s02_axi_arburst,
		input logic  s02_axi_arlock,
		input logic [3 : 0] s02_axi_arcache,
		input logic [2 : 0] s02_axi_arprot,
		input logic [3 : 0] s02_axi_arqos,
		input logic [C_S02_AXI_ARUSER_WIDTH-1 : 0] s02_axi_aruser,
		input logic  s02_axi_arvalid,
		output logic  s02_axi_arready,
		
		// Ports of Axi Master Bus Interface M00_AXI
		input logic  m00_axi_aclk,
		input logic  m00_axi_aresetn,
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
		input logic  m00_axi_arready

    );
    
    enum int {halt, load_01_interface, load_02_interface, resp_01_interface, resp_02_interface} state, next_state;
    
    always_ff @(posedge m00_axi_aclk) begin
        if (~m00_axi_aresetn) begin
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
                if (s01_axi_arvalid) begin
                    next_state = load_01_interface;
                end
                else if (s02_axi_arvalid) begin
                    next_state = load_02_interface;
                end
            end
            
            load_01_interface: begin
                if (m00_axi_arready) begin
                    next_state = resp_01_interface;
                end
            end
            
            load_02_interface: begin
                if (m00_axi_arready) begin
                    next_state = resp_02_interface;
                end
            end
            
            resp_01_interface, resp_02_interface: begin
                next_state = halt;
            end
            
        endcase
    end
    
    always_comb begin
        m00_axi_arid = '0;
		m00_axi_araddr = '0;
		m00_axi_arlen = '0;
		m00_axi_arsize = '0;
		m00_axi_arburst = '0;
		m00_axi_arlock = '0;
		m00_axi_arcache = '0;
		m00_axi_arprot = '0;
		m00_axi_arqos = '0;
		m00_axi_aruser = '0;
		m00_axi_arvalid = '0;
		
		s01_axi_arready = '0;
		s02_axi_arready = '0;
		
		case (state)
            load_01_interface: begin
                m00_axi_arid = s01_axi_arid;
                m00_axi_araddr = s01_axi_araddr;
                m00_axi_arlen = s01_axi_arlen;
                m00_axi_arsize = s01_axi_arsize;
                m00_axi_arburst = s01_axi_arburst;
                m00_axi_arlock = s01_axi_arlock;
                m00_axi_arcache = s01_axi_arcache;
                m00_axi_arprot = s01_axi_arprot;
                m00_axi_arqos = s01_axi_arqos;
                m00_axi_aruser = s01_axi_aruser;
                m00_axi_arvalid = 1'b1;
            end
            
            load_02_interface: begin
                m00_axi_arid = s02_axi_arid;
                m00_axi_araddr = s02_axi_araddr;
                m00_axi_arlen = s02_axi_arlen;
                m00_axi_arsize = s02_axi_arsize;
                m00_axi_arburst = s02_axi_arburst;
                m00_axi_arlock = s02_axi_arlock;
                m00_axi_arcache = s02_axi_arcache;
                m00_axi_arprot = s02_axi_arprot;
                m00_axi_arqos = s02_axi_arqos;
                m00_axi_aruser = s02_axi_aruser;
                m00_axi_arvalid = 1'b1;
            end
            
            resp_01_interface: begin
                s01_axi_arready = 1'b1;
            end
            
            resp_02_interface: begin
                s02_axi_arready = 1'b1;
            end
            
            default:;
		endcase
		
    end
    
    
endmodule
