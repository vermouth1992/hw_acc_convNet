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
// Modifications to aalsdk_splrm-4.1.5//rtl_src/afu2/afu_core.v
//
// This version preserves the original initialization and wrap-up
// (matched up to splapp.cpp). As in the original, after configuration,
// the fsm's in this file enters "RUN" mode.  In this version,
// during "RUN" mode, SPL interface control is given to the usr 
// application logic in the afu_user module.
//
// The logic in afu_user should ignore SPL I/O until it is enabled
// by re2xy_go.  All 512 bits of the ctx_word is passed
// into afu_user.  Upper 256 bits (currently unused) can be used to
// convey additional application specific configuration words from
// splapp.cpp. The logic in afu_user signals completion by asserting
// and holding afu2re_TestCmp.
//
// Other changes (relative to 4.1.5 original)
// 1. afu_core is modified to receive write responses in addition to
//    read reponses.
// 2. afu_core is modified to generate and receive spl meta data
//    (using all 14 bits)
//------------------------------------------------------------------------
// June 2015, Eriko Nurvitadhi, Intel Labs
//
// Simplify by removing scratch csr, block transfer, and combining read req 
// and read rsp fsms. Also change afu_user naming to improve readability.
//------------------------------------------------------------------------


`include "spl_defines.vh"

module afu_core #(MDATA = 14) 
  (
    input  wire                             clk,
    input  wire                             reset_n,

    input  wire                             spl_enable,
    input  wire                             spl_reset,

    // TX_RD request, afu_core --> afu_io
    input  wire                             spl_tx_rd_almostfull,
    output reg                              cor_tx_rd_valid,
    output reg [57:0] 			    cor_tx_rd_addr,
    output reg [MDATA-1:0] 	            cor_tx_rd_mdata,		


    // TX_WR request, afu_core --> afu_io
    input  wire                             spl_tx_wr_almostfull, 
    output reg                              cor_tx_wr_valid,
    output reg                              cor_tx_dsr_valid,
    output reg                              cor_tx_fence_valid,
    output reg                              cor_tx_done_valid,
    output reg [57:0] 			    cor_tx_wr_addr,
    output reg [511:0] 			    cor_tx_wr_data,
    output reg [MDATA-1:0] 		    cor_tx_wr_mdata,		

    // RX_RD response, afu_io --> afu_core
    input  wire                             io_rx_rd_valid,
    input  wire [511:0] 		    io_rx_rd_data, 
    input  wire [MDATA-1:0] 		    io_rx_rd_mdata, 

    // RX_WR response, afu_io --> afu_core
    input  wire                             io_rx_wr_valid0,
    input  wire [MDATA-1:0] 		    io_rx_wr_mdata0, 
    input  wire                             io_rx_wr_valid1,
    input  wire [MDATA-1:0] 		    io_rx_wr_mdata1, 

    // afu_csr --> afu_core, afu_id
    input  wire                             csr_id_valid,
    output reg                              csr_id_done,
    input  wire [31:0] 			    csr_id_addr,

    // afu_csr --> afu_core, afu_ctx
    input  wire                             csr_ctx_base_valid,
    input  wire [57:0] 			    csr_ctx_base
    );

   // synthesis translate_off
   reg [31:0] 				    TICK;
   always @(posedge clk) begin
    if (!reset_n) begin
      TICK <= 0;
    end else begin
      TICK <= TICK+1;
    end
  end
   // synthesis translate_on

   localparam [2:0]
   TX_RD_STATE_IDLE       = 3'b000,
   TX_RD_STATE_CTX        = 3'b001,
   TX_RD_STATE_RUN        = 3'b101;

   localparam [2:0] 
   TX_WR_STATE_IDLE       = 3'b000,
   TX_WR_STATE_CTX        = 3'b001,
   TX_WR_STATE_RUN        = 3'b010,
   TX_WR_STATE_STATUS     = 3'b011,
   TX_WR_STATE_FENCE      = 3'b100,
   TX_WR_STATE_TASKDONE   = 3'b101;

   localparam [5:0] 
   AFU_CSR__LATENCY_CNT        = 6'b00_0100,
   AFU_CSR__PERFORMANCE_CNT    = 6'b00_0101;

   localparam 	    AFU_ID               = 128'h7D2F_AE3B_B549_43E1_B575_7C6D_9473_07FE;
   
   reg [2:0] 	    tx_rd_state;
   reg [2:0] 	    tx_wr_state;

   reg 		    ctx_valid;

   reg [57:0] 	    ctx_src_ptr; // source buffer pointer (in CL #)
   reg [57:0] 	    ctx_dst_ptr; // dest buffer pointer (in CL #)
   reg [511:0] 	    ctx_word;    // full AFU context 

   wire 	    tx_rd_valid;
   wire [5:0] 	    tx_rd_len;
   wire [57:0] 	    tx_rd_addr;
   wire [MDATA-1:0] tx_rd_mdata;

   wire [31:0] 	    dsr_latency_cnt_addr;
   wire [31:0] 	    dsr_performance_cnt_addr;
   reg [31:0] 	    dsr_latency_cnt;
   reg [31:0] 	    dsr_performance_cnt;

   wire 	    csr_id_update;

   reg [57:0] 	    status_addr;
   reg 		    status_addr_valid;
   reg 		    status_addr_cr;

  // Assert to tell WRITE FSM to issue wr_req to write AFU_ID to memory  
  assign 	    csr_id_update = 
     // afu_csr module has the pointer to DSM in its CSR (i.e., AFU_CSR_DSR_BASE)
     csr_id_valid   & 
     // WRITE FSM in this module has not issue wr_req to write AFU_ID to memory
     (~csr_id_done) & 
     // SPL able to receive wr_req
     (~spl_tx_wr_almostfull); 

   // Pointers to performance counters in memory (i.e., in DSM) 
   assign 	    dsr_latency_cnt_addr = csr_id_addr + AFU_CSR__LATENCY_CNT;
   assign 	    dsr_performance_cnt_addr = csr_id_addr + AFU_CSR__PERFORMANCE_CNT;

   localparam 	    ADDR_LMT=32;
   localparam 	    CACHE_WIDTH=512;

   wire [ADDR_LMT-1:0]    uafu_rd_req_addr;
   wire [MDATA-1:0]       uafu_rd_req_mdata;
   wire 	          uafu_rd_req_en;

   wire [ADDR_LMT-1:0]    uafu_wr_req_addr;
   wire [MDATA-1:0]       uafu_wr_req_mdata;
   wire [CACHE_WIDTH-1:0] uafu_wr_req_data;
   wire 		  uafu_wr_req_en; 

   wire 		  uafu_done; 

   wire uafu_wr_fence_valid;

   //-----------------------------------------------------------
   // AFU user module.   
   // - Its 'start' input is asserted after initialization steps are done. 
   // - It asserts 'done' output after it has finished running 
   // - When its running, it can perform memory operations using 
   //   rd_req*, rd_rsp*, wr_req*, and wr_rsp* ports
   // - Control information can go in afu_context
   //-----------------------------------------------------------
   afu_user #(
     .ADDR_LMT(ADDR_LMT),
     .MDATA   (MDATA),
     .CACHE_WIDTH (CACHE_WIDTH)
     )
   afu_user (
     .clk(clk),
     .reset_n(reset_n & (~spl_reset)),

      // wr req 
      .wr_req_addr       (uafu_wr_req_addr),
      .wr_req_mdata      (uafu_wr_req_mdata),
      .wr_req_data       (uafu_wr_req_data),
      .wr_req_en         (uafu_wr_req_en),
      .wr_req_almostfull (spl_tx_wr_almostfull),

      // rd req 
      .rd_req_addr       (uafu_rd_req_addr),
      .rd_req_mdata      (uafu_rd_req_mdata),
      .rd_req_en         (uafu_rd_req_en),
      .rd_req_almostfull (spl_tx_rd_almostfull),

      // rd rsp 
      .rd_rsp_valid      (io_rx_rd_valid),
      .rd_rsp_mdata      (io_rx_rd_mdata),
      .rd_rsp_data       (io_rx_rd_data),

      // wr rsp 
      .wr_rsp0_valid     (io_rx_wr_valid0),
      .wr_rsp0_mdata     (io_rx_wr_mdata0),

      .wr_rsp1_valid     (io_rx_wr_valid1),
      .wr_rsp1_mdata     (io_rx_wr_mdata1),

      // ctrl 
      .start ( (tx_rd_state==TX_RD_STATE_RUN)&&
       (tx_wr_state==TX_WR_STATE_RUN) ),
      .done        (uafu_done),
      .afu_context (ctx_word),
      .status_addr (status_addr),
      .uafu_wr_fence_valid(uafu_wr_fence_valid)
      );

   //-----------------------------------------------------------
   // WRITE FSM
   //-----------------------------------------------------------
   always @(posedge clk) begin
    if ((~reset_n) | spl_reset) begin
     cor_tx_wr_valid <= 1'b0;
     cor_tx_wr_mdata <= 0;
     cor_tx_dsr_valid <= 1'b0;
     cor_tx_fence_valid <= 1'b0;
     cor_tx_done_valid <= 1'b0;
     csr_id_done <= 1'b0;
     tx_wr_state <= TX_WR_STATE_IDLE;
   end

   else begin
     cor_tx_wr_valid <= 1'b0;
     cor_tx_wr_mdata <= 0;
     cor_tx_dsr_valid <= 1'b0;
     cor_tx_fence_valid <= 1'b0;
     csr_id_done <= 1'b0;

     case (tx_wr_state)
       TX_WR_STATE_IDLE : begin
        if (csr_id_update) begin
                 // Issue wr_req to write AFU_ID
                 cor_tx_wr_valid  <= 1'b1;
                 cor_tx_dsr_valid <= 1'b1;
                 cor_tx_wr_addr   <= {26'b0, csr_id_addr};
                 cor_tx_wr_data   <= {384'b0, AFU_ID};
                 csr_id_done      <= 1'b1; 
                 tx_wr_state      <= TX_WR_STATE_CTX;
               end
             end

             TX_WR_STATE_CTX : begin
              // Wait for AFU_CTX to be read from mem (set by READ FSM)
              if(ctx_valid) tx_wr_state <= TX_WR_STATE_RUN;
            end 

            TX_WR_STATE_RUN : begin
              // afu_user not done, handle its wr_req
              if (!uafu_done) begin
               cor_tx_wr_valid <= uafu_wr_req_en;
               cor_tx_wr_addr  <= ctx_dst_ptr + uafu_wr_req_addr;
               cor_tx_wr_data  <= uafu_wr_req_data;
               cor_tx_wr_mdata <= uafu_wr_req_mdata;
               cor_tx_fence_valid <= uafu_wr_fence_valid;
             end else begin
              // afu_user done executing
              if (~spl_tx_wr_almostfull) begin
                    // Issue wr_req to write performance counter to mem
                    cor_tx_wr_valid <= 1'b1;
                    cor_tx_dsr_valid <= 1'b1;
                    cor_tx_wr_addr <= {26'b0, dsr_latency_cnt_addr};
                    cor_tx_wr_data <= {448'b0, dsr_latency_cnt};
                    tx_wr_state <= TX_WR_STATE_STATUS;
                  end
                end 
              end

              TX_WR_STATE_STATUS : begin
                if (~spl_tx_wr_almostfull) begin
                 // Issue wr_req to write performance counter to mem
                 cor_tx_wr_valid <= 1'b1;
                 cor_tx_dsr_valid <= 1'b1;
                 cor_tx_wr_addr <= {26'b0, dsr_performance_cnt_addr};
                 cor_tx_wr_data <= {448'b0, dsr_performance_cnt};
                 tx_wr_state <= TX_WR_STATE_FENCE;
               end
             end

             TX_WR_STATE_FENCE : begin
              if (~spl_tx_wr_almostfull) begin
                 // Issue fence 
                 cor_tx_wr_valid <= 1'b1;
                 cor_tx_fence_valid <= 1'b1;
                 tx_wr_state <= TX_WR_STATE_TASKDONE;
               end
             end

             TX_WR_STATE_TASKDONE : begin
              if ((~spl_tx_wr_almostfull) & (~cor_tx_done_valid)) begin
                 // Issue wr_req to write 1 to status bit in AFU context
                 cor_tx_wr_valid <= 1'b1;
                 cor_tx_done_valid <= 1'b1;
                 cor_tx_wr_addr <= status_addr;
                 cor_tx_wr_data[0] <= 1'b1;
               end
             end

           endcase 
         end
       end

   //-----------------------------------------------------
   // READ FSM 
   //-----------------------------------------------------
   always @(posedge clk) begin
    if ((~reset_n) | spl_reset) begin
     cor_tx_rd_valid   <= 1'b0;
     cor_tx_rd_mdata   <= 0;
     status_addr_valid <= 1'b0;
     status_addr_cr    <= 1'b0;
     tx_rd_state       <= TX_RD_STATE_IDLE; 
     ctx_valid         <= 1'b0;
   end

   else begin
     cor_tx_rd_valid <= 1'b0;
     cor_tx_rd_mdata <= 0;
     dsr_performance_cnt <= dsr_performance_cnt + 1'b1;

     case (tx_rd_state)
       TX_RD_STATE_IDLE : begin
        if (csr_ctx_base_valid & spl_enable & (~spl_tx_rd_almostfull)) begin
                 // Issue rd_req to read AFU context from mem[csr_ctx_base]
                 cor_tx_rd_valid <= 1'b1;
                 cor_tx_rd_addr  <= csr_ctx_base;
                 dsr_latency_cnt <= 32'b0;
                 tx_rd_state     <= TX_RD_STATE_CTX;

                 // calculate pointer to second cacheline in AFU context, containing status bit
                 // This is step 1 of 2. Addition split into two steps for timing
                 {status_addr_cr, status_addr[28:0]} <= csr_ctx_base[28:0] + 1'b1;
               end
             end

             TX_RD_STATE_CTX : begin
              // This is step 2 of 2 in calculating pointer to status bit in memory
              if (~status_addr_valid) begin
               status_addr_valid <= 1'b1;
               status_addr[57:29] <= csr_ctx_base[57:29] + status_addr_cr;
             end

              // Performance counter, measure read latency 
              dsr_latency_cnt <= dsr_latency_cnt + 1'b1;

              // Receive rd_rsp containing AFU context
              if (io_rx_rd_valid) begin
                 ctx_src_ptr <= io_rx_rd_data[127:70];   // source buffer pointer
                 ctx_dst_ptr <= io_rx_rd_data[191:134];  // dest buffer pointer
		             ctx_word    <= io_rx_rd_data;           // keep entire afu context
                ctx_valid   <= 1'b1;
                dsr_performance_cnt <= 32'b0;
                tx_rd_state <= TX_RD_STATE_RUN;
              end
            end 

            TX_RD_STATE_RUN : begin
              // afu_user is running, handle any rd_req from it
              cor_tx_rd_valid <= uafu_rd_req_en;
              cor_tx_rd_addr  <= ctx_src_ptr +      // base pointer to src buffer in memory
              uafu_rd_req_addr;  // offset produced by afu_user
              cor_tx_rd_mdata <= uafu_rd_req_mdata;
         end
       endcase 
     end
   end

 endmodule

