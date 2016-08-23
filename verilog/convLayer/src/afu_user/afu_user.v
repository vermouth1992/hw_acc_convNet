// Copyright (c) 2014-2015, Intel Corporation
//
// Redistribution  and  use  in source  and  binary  forms,  with  or  without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of  source code  must retain the  above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name  of Intel Corporation  nor the names of its contributors
//   may be used to  endorse or promote  products derived  from this  software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,  THE
// IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT  SHALL THE COPYRIGHT OWNER  OR CONTRIBUTORS BE
// LIABLE  FOR  ANY  DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR
// CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT LIMITED  TO,  PROCUREMENT  OF
// SUBSTITUTE GOODS OR SERVICES;  LOSS OF USE,  DATA, OR PROFITS;  OR BUSINESS
// INTERRUPTION)  HOWEVER CAUSED  AND ON ANY THEORY  OF LIABILITY,  WHETHER IN
// CONTRACT,  STRICT LIABILITY,  OR TORT  (INCLUDING NEGLIGENCE  OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,  EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

/* 1. note that the address should be transform to relative address 
 *
 */

module afu_user #(ADDR_LMT = 20, MDATA = 14, CACHE_WIDTH = 512) (
  input 		    clk, 
  input 		    reset_n, 

  // Read Request
  output reg [ADDR_LMT-1:0]    rd_req_addr, 
  output reg [MDATA-1:0] 	    rd_req_mdata, 
  output reg		    rd_req_en, 
  input 		    rd_req_almostfull, 

  // Read Response
  input 		    rd_rsp_valid, 
  input [MDATA-1:0] 	    rd_rsp_mdata, 
  input [CACHE_WIDTH-1:0]  rd_rsp_data, 

  // Write Request 
  output reg [ADDR_LMT-1:0]    wr_req_addr, 
  output reg [MDATA-1:0] 	    wr_req_mdata, 
  output reg [CACHE_WIDTH-1:0] wr_req_data, 
  output reg		    wr_req_en, 
  input 		    wr_req_almostfull, 

  // Write Response 
  input 		    wr_rsp0_valid, 
  input [MDATA-1:0] 	    wr_rsp0_mdata, 
  input 		    wr_rsp1_valid, 
  input [MDATA-1:0] 	    wr_rsp1_mdata, 

  // Start input signal
  input 		    start, 

  // Done output signal 
  output reg 		    done, 

  // Control info from software
  input [511:0] 	    afu_context
  );

  localparam NUM_CACHELINE_IMAGE_MOST = 2 ** 13;   // 8192

  wire reset;
  assign reset = ~reset_n;

  // state for memory request, currently, it is a image oriented approach
  enum {TX_RD_STATE_IDLE, TX_RD_STATE_CONFIG, TX_RD_STATE_IMAGE, TX_RD_STATE_KERNEL, TX_RD_STATE_DONE} read_req_state;

  // afu_context info extraction
  reg [ADDR_LMT-1:0] filter_offset_addr;
  reg [31:0] num_input_feature_maps, num_output_feature_maps;
  reg [ADDR_LMT-1:0] current_read_image_addr, current_read_filter_addr;  // read address
  reg [31:0] num_cl_image, num_cl_image_to_read;
  reg [31:0] num_cl_filter, num_cl_filter_to_read;
  // currently, we don't need meta data to communicate
  // reg [MDATA-1:0] current_read_image_mdata, current_read_filter_mdata;   // representing cache line index
  // read request FSM
  always@(posedge clk) begin
    if (reset) begin
      read_req_state <= TX_RD_STATE_IDLE;
      rd_req_en <= 0;
      current_read_image_addr <= 0;
    end else begin
      case (read_req_state)
        TX_RD_STATE_IDLE: begin
          if (start) begin
            // synthesis translate_off
            $display("src = %h", afu_context[127:64]);
            $display("dest = %h", afu_context[191:128]);
            $display("num_cl_image = %d", afu_context[223:192]);  // in order to track the filter read
            $display("filter offset address = %h", afu_context[256+64-1:256]);   // filter address # of cacheline
            $display("num input feature map = %d", afu_context[351:320]);   // D1
            $display("num output feature map = %d", afu_context[415:384]);  // D2
            $display("num of cacheline in filter region = %d", afu_context[479:448]);
            // synthesis translate_on
            filter_offset_addr <= afu_context[256+ADDR_LMT-1+6:256+6];    // has to be cacheline aligned
            num_input_feature_maps <= afu_context[351:320];
            num_output_feature_maps <= afu_context[415:384];
            num_cl_image <= afu_context[223:192];
            num_cl_filter <= afu_context[479:448];
            read_req_state <= TX_RD_STATE_CONFIG;
          end
        end
        TX_RD_STATE_CONFIG: begin
          // if total number of image in cl is smaller or equal to 8192
          if (num_cl_image <= NUM_CACHELINE_IMAGE_MOST) begin
            num_cl_image_to_read <= num_cl_image;
          end else begin
            num_cl_image_to_read <= NUM_CACHELINE_IMAGE_MOST;
          end
          num_cl_filter_to_read <= num_cl_filter;
          current_read_filter_addr <= filter_offset_addr;
          read_req_state <= TX_RD_STATE_IMAGE;
        end
        TX_RD_STATE_IMAGE: begin
          if (~rd_req_almostfull && num_cl_image_to_read != 0) begin
            rd_req_addr <= current_read_image_addr;
            current_read_image_addr <= current_read_image_addr + 1;
            rd_req_en <= 1'b1;
            rd_rsp_mdata[0] <= 1'b0;   // 0 represents image
            // reduce the current cl num to read
            num_cl_image_to_read <= num_cl_image_to_read - 1;
            // reduce the total number of cl to read
            num_cl_image <= num_cl_image - 1;
          end else if (num_cl_image_to_read == 0) begin
            read_req_state <= TX_RD_STATE_KERNEL;
            rd_req_en <= 1'b0;
          end else begin
            rd_req_en <= 1'b0;
          end
        end
        TX_RD_STATE_KERNEL: begin
          // TODO: filter_buffer_almost_full is to be set
          if (~rd_req_almostfull && num_cl_filter_to_read != 0 && ~filter_buffer_almost_full) begin
            rd_req_addr <= current_read_filter_addr;
            current_read_filter_addr <= current_read_filter_addr + 1;
            rd_req_en <= 1'b1;
            rd_rsp_mdata[0] <= 1'b1;  // 1 represents kernel
            num_cl_filter_to_read <= num_cl_filter_to_read - 1;
          end else if (num_cl_filter_to_read == 0) begin
            rd_req_en <= 1'b0;
            if (num_cl_image == 0) begin
              read_req_state <= TX_RD_STATE_DONE;
            end else begin
              read_req_state <= TX_RD_STATE_CONFIG;
            end
          end else begin
            rd_req_en <= 1'b0;
          end
        end
        TX_RD_STATE_DONE: begin end
        default: begin end;
      endcase
    end
  end


  // read response FSM
  enum {RX_RD_STATE_IDLE, RX_RD_STATE_RUN} read_rsp_state;
  always@(posedge clk) begin 
    if (reset) begin
      read_rsp_state <= RX_RD_STATE_IDLE;
    end else begin
      case (read_rsp_state)
        RX_RD_STATE_IDLE: begin
          if (start) begin
            read_rsp_state <= RX_RD_STATE_RUN;
          end
        end

        RX_RD_STATE_RUN: begin
          if (rd_rsp_valid) begin
            // forware data and last bit of meta data to convLayerFFT unit
          end
        end
      endcase
    end
  end

  // write request FSM

  // write response FSM (maybe used for synchronization)

endmodule // afu_user





