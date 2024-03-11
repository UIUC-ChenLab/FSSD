`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2022 11:16:16 PM
// Design Name: 
// Module Name: b_channel_interconnect
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


module b_channel_interconnect #(
        // Parameters of Axi Slave Bus Interface M02_AXI
		parameter integer C_M02_AXI_ID_WIDTH	= 4,
		parameter integer C_M02_AXI_BUSER_WIDTH	= 0,
		
		// Parameters of Axi Slave Bus Interface M01_AXI
		parameter integer C_M01_AXI_ID_WIDTH	= 4,
		parameter integer C_M01_AXI_BUSER_WIDTH	= 0,
		
		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 4,
		parameter integer C_S00_AXI_BUSER_WIDTH	= 0
		
)
(
        // Ports for M02_AXI
    	input logic [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_bid,
		input logic [1 : 0] m02_axi_bresp,
		input logic [C_M02_AXI_BUSER_WIDTH-1 : 0] m02_axi_buser,
		input logic  m02_axi_bvalid,
		output logic  m02_axi_bready,
		
		// Ports for M01_AXI
		input logic [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_bid,
		input logic [1 : 0] m01_axi_bresp,
		input logic [C_M01_AXI_BUSER_WIDTH-1 : 0] m01_axi_buser,
		input logic  m01_axi_bvalid,
		output logic  m01_axi_bready,
		
		// Ports of Axi Slave Bus Interface S00_AXI
		input logic  s00_axi_aclk,
		input logic  s00_axi_aresetn,
		
		output logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid,
		output logic [1 : 0] s00_axi_bresp,
		output logic [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser,
		output logic  s00_axi_bvalid,
		input logic  s00_axi_bready
    );
    
    enum int {halt, load_01_interface, load_02_interface, resp_01_interface, resp_02_interface} state, next_state;
    
    always_ff @(posedge s00_axi_aclk) begin
        if (~s00_axi_aresetn) begin
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
                if (m01_axi_bvalid) begin
                    next_state = load_01_interface;
                end
                else if (m02_axi_bvalid) begin
                    next_state = load_02_interface;
                end
            end
            
            load_01_interface: begin
                if (s00_axi_bready) begin
                    next_state = resp_01_interface;
                end
            end
            
            load_02_interface: begin
                if (s00_axi_bready) begin
                    next_state = resp_02_interface;
                end
            end
            
            resp_01_interface, resp_02_interface: begin
                next_state = halt;
            end
            
        endcase
    end
    
    always_comb begin
        s00_axi_bid = '0;
		s00_axi_bresp = '0;
		s00_axi_buser = '0;
		s00_axi_bvalid = '0;
		
		m01_axi_bready = '0;
		m02_axi_bready = '0;
		
		case (state)
            load_01_interface: begin
                s00_axi_bid = m01_axi_bid;
                s00_axi_bresp = m01_axi_bresp;
                s00_axi_buser = m01_axi_buser;
                s00_axi_bvalid = 1'b1;
            end
            
            load_02_interface: begin
                s00_axi_bid = m02_axi_bid;
                s00_axi_bresp = m02_axi_bresp;
                s00_axi_buser = m02_axi_buser;
                s00_axi_bvalid = 1'b1;
            end
            
            resp_01_interface: begin
                m01_axi_bready = 1'b1;
            end
            
            resp_02_interface: begin
                m02_axi_bready = 1'b1;
            end
            
            default:;
		endcase
		
    end
    
endmodule
