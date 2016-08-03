//****************************************************************************
// Copyright (c) 2011-2014, Intel Corporation
//
// Redistribution  and  use  in source  and  binary  forms,  with  or  without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of  source code  must retain the  above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name  of Intel Corporation  nor the names of its contributors
//   may be used to  endorse or promote  products derived  from this  software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,  THE
// IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT  SHALL THE COPYRIGHT OWNER  OR CONTRIBUTORS BE
// LIABLE  FOR  ANY  DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR
// CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT LIMITED  TO,  PROCUREMENT  OF
// SUBSTITUTE GOODS OR SERVICES;  LOSS OF USE,  DATA, OR PROFITS;  OR BUSINESS
// INTERRUPTION)  HOWEVER CAUSED  AND ON ANY THEORY  OF LIABILITY,  WHETHER IN
// CONTRACT,  STRICT LIABILITY,  OR TORT  (INCLUDING NEGLIGENCE  OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,  EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//****************************************************************************
//------------------------------------------------------------------------
// May 29, 2015, James C. Hoe, Carnegie Mellon University
//
// Modifications to aalsdk_splrm-4.1.5//rtl_src/afu2/afu_io.v
//
// afu_io modified to receive and return spl meta data from afu_core
//    (using all 14 bits)
// afu io modified to forward write responses in addition to
//    read reponses to afu_core.
//------------------------------------------------------------------------
//------------------------------------------------------------------------
// June 2015, Eriko Nurvitadhi, Intel Labs
//
// Simplify by removing scratch csr and block transfer
//------------------------------------------------------------------------


`define MAX_TRANSFER_SIZE_1
`include "spl_defines.vh"


module afu_io #(MDATA = 14) 
  (
    input  wire                             clk,
    input  wire                             reset_n,
    input  wire                             spl_enable,
    input  wire                             spl_reset,
    
    // AFU TX read request
    output reg                              afu_tx_rd_valid,
    output reg [98:0]                       afu_tx_rd_hdr   /* synthesis syn_preserve=1 */,
    
    // AFU TX write request
    output reg                              afu_tx_wr_valid,
    output reg                              afu_tx_intr_valid   /* synthesis syn_preserve=1 */,
    output reg [98:0]                       afu_tx_wr_hdr   /* synthesis syn_preserve=1 */,
    output reg [511:0]                      afu_tx_data,
    
    // AFU RX read response
    input  wire                             spl_rx_rd_valid,  // latched and passed thru to Core
    input  wire                             spl_rx_wr_valid0, // deadend
    input  wire                             spl_rx_cfg_valid, // latched and passed thru to CSR
    input  wire                             spl_rx_intr_valid0, // deadend
    input  wire                             spl_rx_umsg_valid, // deadend
    input  wire [17:0]                      spl_rx_hdr0, // latched and passed thru
    input  wire [511:0]                     spl_rx_data, // latched and passed thru
    
    // AFU RX write response
    input  wire                             spl_rx_wr_valid1, // deadned
    input  wire                             spl_rx_intr_valid1, // deadend
    input  wire [17:0]                      spl_rx_hdr1, // deadend
       
    // RX, afu_io --> afu_csr
    output reg                              io_rx_csr_valid,
    output reg [13:0]                       io_rx_csr_addr,
    output reg [31:0]                       io_rx_csr_data,
    
    // RX_RD response, afu_io --> afu_core
    output  reg                              io_rx_rd_valid,
    output  reg  [511:0]                     io_rx_rd_data,    
    output  reg  [MDATA-1:0]                       io_rx_rd_mdata,    

    // RX_RD response, afu_io --> afu_core
    output  reg                              io_rx_wr_valid0,
    output  reg  [MDATA-1:0]                       io_rx_wr_mdata0,    
    output  reg                              io_rx_wr_valid1,
    output  reg  [MDATA-1:0]                       io_rx_wr_mdata1,    
        
    // TX_RD request, afu_core --> afu_io
    input  wire                             cor_tx_rd_valid,  // core requesting read, happens next cycle
    input  wire [57:0]                      cor_tx_rd_addr,
    input  wire [MDATA-1:0]                 cor_tx_rd_mdata,
    
    // TX_WR request, afu_core --> afu_io
    input  wire                             cor_tx_wr_valid, // core requesting a write, happens next cycle
    input  wire                             cor_tx_dsr_valid,
    input  wire                             cor_tx_fence_valid,
    input  wire                             cor_tx_done_valid,        
    input  wire [57:0]                      cor_tx_wr_addr, 
    input  wire [511:0]                     cor_tx_wr_data,
    input  wire [MDATA-1:0]                 cor_tx_wr_mdata       
);

    //-------------------------------------------------------            
    // TX_WR, drive afu_tx_wr port
    //-------------------------------------------------------
    always @(posedge clk) begin
        if ((~reset_n) | spl_reset) begin
            afu_tx_wr_valid <= 1'b0;
            afu_tx_intr_valid <= 1'b0;
        end

        else begin
            afu_tx_wr_valid <= 1'b0;
            afu_tx_intr_valid <= 1'b0;

            // Construct tx_wr header
            // See CCI Specification for details on the header format
            if (cor_tx_wr_valid) begin  // core wants to write
                afu_tx_wr_valid <= 1'b1;
                
                case ({cor_tx_dsr_valid, cor_tx_fence_valid, cor_tx_done_valid})
                    3'b100 : begin      // DSR
                        //                     98:93   92:67    66      65:61  60:56   55:52
                        afu_tx_wr_hdr <= {6'h0, 26'b0, 1'b0, 5'b0 ,5'b0, `CCI_REQ_WR ,6'b0, cor_tx_wr_addr[31:0], 8'h3, 6'h0};
                    end
                    
                    3'b010 : begin      // fence
                        afu_tx_wr_hdr <= {6'b0, 26'b0, 6'b0 ,5'b0, `CCI_REQ_WR_FENCE ,6'b0, 32'b0, 14'b0};
                    end
                    
                    3'b001 : begin      // done
                        afu_tx_wr_hdr <= {6'd0, cor_tx_wr_addr[57:32], 1'b1, 5'b0 ,5'b0, `CCI_REQ_WR ,6'b0, cor_tx_wr_addr[31:0], 8'h3, 6'h0};
                    end                    

                    default : begin     // mem_wr
                        afu_tx_wr_hdr <= {6'd0, cor_tx_wr_addr[57:32], 1'b1, 5'b0 ,5'b0, `CCI_REQ_WR ,6'b0, cor_tx_wr_addr[31:0], /*8'h3,*/ cor_tx_wr_mdata[13:0]};

                    end
                endcase
                    
                afu_tx_data <= cor_tx_wr_data;
            end
        end
    end    
    
                
    //-------------------------------------------------------            
    // TX_RD, drive afu_tx_rd port
    //-------------------------------------------------------
    // core requesting a read, happens next cycle
    always @(posedge clk) begin
        if ((~reset_n) | spl_reset) begin
            afu_tx_rd_valid <= 1'b0;
        end

        else begin
            afu_tx_rd_valid <= 1'b0;
            
            // Construct tx_rd header
            // See CCI Specification for details on the header format
            if (cor_tx_rd_valid) begin
                afu_tx_rd_valid <= 1'b1;
                afu_tx_rd_hdr <= {6'd0, cor_tx_rd_addr[57:32], 6'b0 ,5'b0, `CCI_REQ_RD ,6'b0, cor_tx_rd_addr[31:0], /*8'h2,*/ cor_tx_rd_mdata};
            end
        end
    end    
    
                    
    //-------------------------------------------------------            
    // RX CSR, forward to afu_csr
    //-------------------------------------------------------
    always @(posedge clk) begin
        if ((~reset_n) | spl_reset) begin
            io_rx_csr_valid <= 1'b0;
        end

        else begin
            io_rx_csr_valid <= spl_rx_cfg_valid;
            io_rx_csr_addr  <= spl_rx_hdr0[13:0];
            io_rx_csr_data  <= spl_rx_data[31:0];        
        end
    end
    

    //-------------------------------------------------------            
    // RX read and write responses, forward data to afu_core
    //-------------------------------------------------------
    always @(posedge clk) begin
       io_rx_rd_valid  <= spl_rx_rd_valid;
       io_rx_rd_data   <= spl_rx_data;        
       io_rx_rd_mdata  <= spl_rx_hdr0[MDATA-1:0];

       io_rx_wr_valid0 <= spl_rx_wr_valid0;
       io_rx_wr_mdata0 <= spl_rx_hdr0[MDATA-1:0];
       io_rx_wr_valid1 <= spl_rx_wr_valid1;
       io_rx_wr_mdata1 <= spl_rx_hdr1[MDATA-1:0];
    end

endmodule

