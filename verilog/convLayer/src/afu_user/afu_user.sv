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

`include "common.vh"

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

  // datapath

  // FFT array
  reg next_image_fft;  // set by FSM
  // used by other modules
  wire next_out_image_fft;
  complex_t out_image_fft [0:3][0:3][0:3];

  wire [511:0] cacheline_in_fft;
  assign cacheline_in_fft = rd_rsp_data;

  convLayerFFT convLayerFFT_inst (
    .clk         (clk),
    .reset       (reset),
    .next        (next_image_fft),
    .next_out    (next_out_image_fft),
    .cacheline_in(cacheline_in_fft),
    .out         (out_image_fft)
    );

  // image mem array
  reg [12:0] read_address_image_mem;   // set by FSM
  // used by other modules
  complex_t out_image_mem [0:3][0:3][0:3];

  reg we_image_mem;
  always@(posedge clk) begin
    we_image_mem <= next_out_image_fft;  // image write is one cycle delay of next_out_fft
  end

  reg [12:0] write_address_image_mem;
  always@(posedge clk) begin
    if (reset) begin
      write_address_image_mem <= 0;
    end else if (we_image_mem) begin
      write_address_image_mem <= write_address_image_mem + 1;   // always write to the next location
    end
  end

  complex_t in_image_mem [0:3][0:3][0:3];
  assign in_image_mem = out_image_fft;   // input to image memory is fft output

  memBlockImage_top memBlockImage_top_inst (
    .clk          (clk),
    .write_address(write_address_image_mem),
    .read_address (read_address_image_mem),
    .we           (we_image_mem),
    .in           (in_image_mem),
    .out          (out_image_mem)
    );

  // kernel mem array
  reg we_kernel_mem;   // set by FSM
  reg [8:0] read_address_kernel_mem;  // set by FSM
  
  reg [8:0] write_address_kernel_mem;
  always@(posedge clk) begin
    if (reset) begin
      write_address_kernel_mem <= 0;
    end else if (we_kernel_mem) begin
      write_address_kernel_mem <= write_address_kernel_mem + 1;
    end
  end

  // set by FSM
  reg select_block_rd_kernel_mem, select_block_we_kernel_mem, select_sub_block_we_kernel_mem;
  
  complex_t in_kernel_mem [0:1][0:3];  // one cacheline
  // connect to cacheline_in
  wire [511:0] cacheline_in_kernel;
  assign cacheline_in_kernel = rd_rsp_data;

  genvar i, j;
  generate
    for (i=0; i<2; i=i+1) begin: memBlockKernel_top_outer
      for (j=0; j<4; j=j+1) begin: memBlockKernel_top_inner
        assign in_kernel_mem[i][j].r = cacheline_in_kernel[256*i+64*j+31:256*i+64*j];
        assign in_kernel_mem[i][j].i = cacheline_in_kernel[256*i+64*j+63:256*i+64*j+32];
      end
    end
  endgenerate

  // used by other modules
  complex_t out_kernel_mem [0:3][0:3];

  memBlockKernel_top memBlockKernel_top_inst (
    .clk                (clk),
    .we                 (we_kernel_mem),
    .read_address       (read_address_kernel_mem),
    .write_address      (write_address_kernel_mem),
    .select_block_rd    (select_block_rd_kernel_mem),
    .select_block_we    (select_block_we_kernel_mem),
    .select_sub_block_we(select_sub_block_we_kernel_mem),
    .in                 (in_kernel_mem),
    .out                (out_kernel_mem)
    );

  // multiplier array
  complex_t in_multiplier_image [0:3][0:3][0:3];
  assign in_multiplier_image = out_image_mem;

  complex_t in_multiplier_kernel [0:3][0:3];
  assign in_multiplier_kernel = out_kernel_mem;

  // set by FSM
  reg next_multiplier;
  // used by other modules
  complex_t out_multiplier [0:3][0:3][0:3];
  wire next_out_multiplier;

  complexMultArrayParallel complexMultArrayParallel_inst (
    .clk (clk),
    .reset (reset),
    .image (in_multiplier_image),
    .kernel (in_multiplier_kernel),
    .out (out_multiplier),
    .next (next_multiplier),
    .next_out (next_out_multiplier)
    );

  // accumulator array
  complex_t in_accumulator [0:3][0:3][0:3];
  assign in_accumulator = out_multiplier;

  // used by other modules
  complex_t out_accumulator [0:3][0:3][0:3];
  wire output_valid_accumulator;

  // The output of multiplier should be in burst mode (consecutive next_out_multiplier be high)
  reg start_accumulator, stop_accumulator;

  // delay next_out_multiplier
  reg next_out_multiplier_reg;
  always@(posedge clk) begin
    next_out_multiplier_reg <= next_out_multiplier;
  end

  assign start_accumulator = ~next_out_multiplier_reg & next_out_multiplier;
  assign stop_accumulator = next_out_multiplier_reg & ~next_out_multiplier;

  complexAccumulatorArrayParallel complexAccumulatorArrayParallel_inst (
    .clk (clk),
    .reset (reset),
    .in (in_accumulator),
    .out (out_accumulator),
    .start (start_accumulator),
    .stop (stop_accumulator),
    .output_valid (output_valid_accumulator)
    );

  // IFFT array
  reg next_ifft;
  assign next_ifft = output_valid_accumulator;

  complex_t in_ifft [0:3][0:3][0:3];
  assign in_ifft = out_accumulator;

  // used by other modules
  wire output_valid_ifft;
  wire [511:0] cacheline_out_ifft;

  convLayerIFFT convLayerIFFT_inst (
    .clk          (clk),
    .reset        (reset),
    .next         (next_ifft),
    .output_valid (output_valid_ifft),
    .in           (in_ifft),
    .cacheline_out(cacheline_out_ifft)
    );


  /********* AFU USER FSM **************/

  // state for memory request, currently, it is a image oriented approach
  enum {TX_RD_STATE_IDLE, TX_RD_STATE_IMAGE, TX_RD_STATE_KERNEL_0, TX_RD_STATE_KERNEL_1, TX_RD_STATE_DONE} read_req_state;

  // afu_context info extraction
  reg [ADDR_LMT-1:0] filter_offset_addr;
  reg [31:0] num_input_feature_maps, num_output_feature_maps;
  reg [ADDR_LMT-1:0] current_read_image_addr, current_read_filter_addr;  // read address from shared memory
  reg [31:0] num_cl_output_buffer;
  reg [31:0] num_cl_filter;
  
  reg [31:0] current_cycle_already_read_cl_image;
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
            $display("num of cacheline in output buffer = %d", afu_context[223:192]);  // in order to track the filter read
            $display("filter offset address = %h", afu_context[256+64-1:256]);   // filter address # of cacheline
            $display("num input feature map = %d", afu_context[351:320]);   // D1, used for accumulate
            $display("num output feature map = %d", afu_context[415:384]);  // D2
            $display("num of cacheline in filter region = %d", afu_context[479:448]);
            // synthesis translate_on
            filter_offset_addr <= afu_context[256+ADDR_LMT-1+6:256+6];    // has to be cacheline aligned
            num_input_feature_maps <= afu_context[351:320];
            num_output_feature_maps <= afu_context[415:384];
            num_cl_output_buffer <= afu_context[223:192];
            num_cl_filter <= afu_context[479:448];
            read_req_state <= TX_RD_STATE_CONFIG;
            current_cycle_already_read_cl_image <= 0;
          end
        end
        TX_RD_STATE_IMAGE: begin
          if (~rd_req_almostfull) begin
            if (current_read_image_addr < filter_offset_addr && current_cycle_already_read_cl_image < NUM_CACHELINE_IMAGE_MOST) begin
              rd_req_addr <= current_read_image_addr;
              current_read_image_addr <= current_read_image_addr + 1;
              rd_req_en <= 1'b1;
              rd_rsp_mdata[0] <= 1'b0;   // 0 represents image
              current_cycle_already_read_cl_image <= current_cycle_already_read_cl_image + 1;
            end else begin
              rd_req_en <= 1'b0;
              current_cycle_already_read_cl_image <= 0;
              current_read_filter_addr <= filter_offset_addr;
              read_req_state <= TX_RD_STATE_KERNEL_0;
            end
          end else begin    // QPI read request almost full
            rd_req_en <= 1'b0;
          end
        end
        TX_RD_STATE_KERNEL_0: begin
          // TODO: filter_buffer_almost_full is to be set
          if (~rd_req_almostfull) begin
            
          end else begin  // QPI read request almost full
            rd_req_en <= 1'b0;
          end
        end
        TX_RD_STATE_KERNEL_1: begin
          if (~rd_req_almostfull) begin

          end else begin
            rd_req_en <= 1'b0;
          end
        end
        TX_RD_STATE_DONE: begin end
        default: begin end;
      endcase
    end
  end


  // read response FSM, forward data to FFT or kernel memory
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





