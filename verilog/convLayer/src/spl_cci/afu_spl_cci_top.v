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


`define MAX_TRANSFER_SIZE_1
`include "spl_defines.vh"

module afu_spl_cci_top(
    input  wire             clk,
    input  wire             reset_n,
    input  wire             linkup
);

    wire                    spl_enable;
    wire                    spl_reset;

    // wires connecting SPL and CCI
    wire                    cci_tx_rd_almostfull;
    wire                    spl_tx_rd_valid;
    wire [60:0]             spl_tx_rd_hdr;
    wire                    cci_tx_wr_almostfull;
    wire                    spl_tx_wr_valid;
    wire                    spl_tx_intr_valid;
    wire [60:0]             spl_tx_wr_hdr;
    wire [511:0]            spl_tx_data;
    wire                    cci_rx_rd_valid;
    wire                    cci_rx_wr_valid0;
    wire                    cci_rx_cfg_valid;
    wire                    cci_rx_intr_valid0;
    wire                    cci_rx_umsg_valid;
    wire [17:0]             cci_rx_hdr0;
    wire [511:0]            cci_rx_data;
    wire                    cci_rx_wr_valid1;
    wire                    cci_rx_intr_valid1;
    wire [17:0]             cci_rx_hdr1;
                
    // wire to connect afu_top and spl_top
    wire                    spl_tx_rd_almostfull;
    wire                    afu_tx_rd_valid;
    wire                    spl_ctx_base;
    wire [98:0]             afu_tx_rd_hdr;
    wire                    spl_tx_wr_almostfull;
    wire                    afu_tx_wr_valid;
    wire                    afu_tx_intr_valid;
    wire [98:0]             afu_tx_wr_hdr;
    wire [511:0]            afu_tx_data;    
    wire                    spl_rx_rd_valid;
    wire                    spl_rx_wr_valid0;
    wire                    spl_rx_cfg_valid;
    wire                    spl_rx_intr_valid0;
    wire                    spl_rx_umsg_valid;
    wire [17:0]             spl_rx_hdr0;
    wire [511:0]            spl_rx_data;
    wire                    spl_rx_wr_valid1;
    wire                    spl_rx_intr_valid1;
    wire [17:0]             spl_rx_hdr1;
    
    
    spl_cci_top spl_top(
        .clk                        (clk),
        .reset_n                    (reset_n),
        .linkup                     (linkup),
        .spl_enable                 (spl_enable),
        .spl_reset                  (spl_reset),           
    
        // AFU TX read request
        .spl_tx_rd_almostfull       (spl_tx_rd_almostfull),
        .afu_tx_rd_valid            (afu_tx_rd_valid),
        .afu_tx_rd_hdr              (afu_tx_rd_hdr),
    
        // AFU TX write request
        .spl_tx_wr_almostfull       (spl_tx_wr_almostfull),
        .afu_tx_wr_valid            (afu_tx_wr_valid),
        .afu_tx_intr_valid          (afu_tx_intr_valid),
        .afu_tx_wr_hdr              (afu_tx_wr_hdr),    
        .afu_tx_data                (afu_tx_data),
    
        // AFU RX read response
        .spl_rx_rd_valid            (spl_rx_rd_valid),
        .spl_rx_wr_valid0           (spl_rx_wr_valid0),
        .spl_rx_cfg_valid           (spl_rx_cfg_valid),
        .spl_rx_intr_valid0         (spl_rx_intr_valid0),
        .spl_rx_umsg_valid          (spl_rx_umsg_valid),
        .spl_rx_hdr0                (spl_rx_hdr0),
        .spl_rx_data                (spl_rx_data),
    
        // AFU RX write response
        .spl_rx_wr_valid1           (spl_rx_wr_valid1),
        .spl_rx_intr_valid1         (spl_rx_intr_valid1),
        .spl_rx_hdr1                (spl_rx_hdr1),
    
        // CCI TX read request
        .cci_tx_rd_almostfull       (cci_tx_rd_almostfull),
        .spl_tx_rd_valid            (spl_tx_rd_valid),
        .spl_tx_rd_hdr              (spl_tx_rd_hdr),
    
        // CCI TX write request
        .cci_tx_wr_almostfull       (cci_tx_wr_almostfull),
        .spl_tx_wr_valid            (spl_tx_wr_valid),
        .spl_tx_intr_valid          (spl_tx_intr_valid),
        .spl_tx_wr_hdr              (spl_tx_wr_hdr),    
        .spl_tx_data                (spl_tx_data),
    
        // CCI RX read response
        .cci_rx_rd_valid            (cci_rx_rd_valid),
        .cci_rx_wr_valid0           (cci_rx_wr_valid0),
        .cci_rx_cfg_valid           (cci_rx_cfg_valid),
        .cci_rx_intr_valid0         (cci_rx_intr_valid0),
        .cci_rx_umsg_valid          (cci_rx_umsg_valid),
        .cci_rx_hdr0                (cci_rx_hdr0),
        .cci_rx_data                (cci_rx_data),
    
        // CCI RX write response
        .cci_rx_wr_valid1           (cci_rx_wr_valid1),
        .cci_rx_intr_valid1         (cci_rx_intr_valid1),
        .cci_rx_hdr1                (cci_rx_hdr1)
    );


    afu_top afu_top(
        .clk                        (clk),
        .reset_n                    (reset_n),
        .spl_enable                 (spl_enable),
        .spl_reset                  (spl_reset),
        
        // AFU TX read request
        .spl_tx_rd_almostfull       (spl_tx_rd_almostfull),
        .afu_tx_rd_valid            (afu_tx_rd_valid),
        .afu_tx_rd_hdr              (afu_tx_rd_hdr),
    
        // AFU TX write request
        .spl_tx_wr_almostfull       (spl_tx_wr_almostfull),
        .afu_tx_wr_valid            (afu_tx_wr_valid),
        .afu_tx_intr_valid          (afu_tx_intr_valid),
        .afu_tx_wr_hdr              (afu_tx_wr_hdr),    
        .afu_tx_data                (afu_tx_data),
    
        // AFU RX read response
        .spl_rx_rd_valid            (spl_rx_rd_valid),
        .spl_rx_wr_valid0           (spl_rx_wr_valid0),
        .spl_rx_cfg_valid           (spl_rx_cfg_valid),
        .spl_rx_intr_valid0         (spl_rx_intr_valid0),
        .spl_rx_umsg_valid          (spl_rx_umsg_valid),
        .spl_rx_hdr0                (spl_rx_hdr0),
        .spl_rx_data                (spl_rx_data),
    
        // AFU RX write response
        .spl_rx_wr_valid1           (spl_rx_wr_valid1),
        .spl_rx_intr_valid1         (spl_rx_intr_valid1),
        .spl_rx_hdr1                (spl_rx_hdr1)
    );
    
    
endmodule    
