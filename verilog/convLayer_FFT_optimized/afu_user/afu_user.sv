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

module afu_user #(ADDR_LMT = 58, MDATA = 14, CACHE_WIDTH = 512) (
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
  output [CACHE_WIDTH-1:0] wr_req_data, 
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
  input [511:0] 	    afu_context,

  output reg uafu_wr_fence_valid
  );

  localparam IMAGE_MEM_DEPTH_BITS = 5;   // this is for test purpose, must be greater or equal to 9 (512)
  localparam KERNEL_MEM_DEPTH_BITS = 4;

  localparam NUM_CACHELINE_IMAGE_MOST = 2 ** IMAGE_MEM_DEPTH_BITS;   // 8192
  localparam NUM_CACHELINE_KERNEL_MOST = 2 ** (KERNEL_MEM_DEPTH_BITS + 1); // 512

  wire reset;
  assign reset = ~reset_n;

  // datapath

  // create a registered rd_rsp_data
  reg [511:0] rd_rsp_data_reg;
  always@(posedge clk) begin
    rd_rsp_data_reg <= rd_rsp_data;
  end

  // FFT array
  wire next_image_fft;  // set by FSM
  // used by other modules
  wire next_out_image_fft;
  complex_t out_image_fft [0:3][0:3];

  wire [511:0] cacheline_in_fft;
  assign cacheline_in_fft = rd_rsp_data_reg;

  convLayerFFT convLayerFFT_inst (
    .clk         (clk),
    .reset       (reset),
    .next        (next_image_fft),
    .next_out    (next_out_image_fft),
    .cacheline_in(cacheline_in_fft),
    .out         (out_image_fft)
    );

  // image mem array
  reg [IMAGE_MEM_DEPTH_BITS-1:0] read_address_image_mem;   // set by FSM
  reg select_block_we_image_mem, select_block_rd_image_mem; // set by FSM
  // used by other modules
  complex_t out_image_mem [0:3][0:3];

  reg we_image_mem;
  always@(posedge clk) begin
    if (reset) begin
      we_image_mem <= 0;
    end else begin
      we_image_mem <= next_out_image_fft;  // image write is one cycle delay of next_out_fft
    end
  end

  // the write address must be separate for FSM
  reg [IMAGE_MEM_DEPTH_BITS-1:0] write_address_image_mem [0:1];
  genvar i;
  generate
    for (i=0; i<2; i=i+1) begin: image_mem_wr_addr
      always@(posedge clk) begin
        if (reset) begin
          write_address_image_mem[i] <= 0;
        end else if (we_image_mem && select_block_we_image_mem == i) begin
          write_address_image_mem[i] <= write_address_image_mem[i] + 1;   // always write to the next location
        end
      end
    end
  endgenerate

  complex_t in_image_mem [0:3][0:3];
  assign in_image_mem = out_image_fft;   // input to image memory is fft output

  memBlockImage_top #(IMAGE_MEM_DEPTH_BITS) memBlockImage_top_inst (
    .clk            (clk),
    .write_address  (write_address_image_mem),
    .read_address   (read_address_image_mem),
    .select_block_we(select_block_we_image_mem),
    .select_block_rd(select_block_rd_image_mem),
    .we             (we_image_mem),
    .in             (in_image_mem),
    .out            (out_image_mem)
    );

  // set by FSM
  reg select_block_rd_kernel_mem, select_block_we_kernel_mem, select_sub_block_we_kernel_mem;

  // kernel mem array
  wire we_kernel_mem;   // set by FSM
  reg [KERNEL_MEM_DEPTH_BITS-1:0] read_address_kernel_mem;  // set by FSM
  
  reg [KERNEL_MEM_DEPTH_BITS-1:0] write_address_kernel_mem;
  always@(posedge clk) begin
    if (reset) begin
      write_address_kernel_mem <= 0;
    end else if (we_kernel_mem && select_sub_block_we_kernel_mem == 1'b1) begin
      write_address_kernel_mem <= write_address_kernel_mem + 1;
    end
  end
  
  complex_t in_kernel_mem [0:1][0:3];  // one cacheline
  // connect to cacheline_in
  wire [511:0] cacheline_in_kernel;
  assign cacheline_in_kernel = rd_rsp_data;

  genvar j;
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

  memBlockKernel_top #(KERNEL_MEM_DEPTH_BITS) memBlockKernel_top_inst (
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
  complex_t in_multiplier_image [0:3][0:3];
  assign in_multiplier_image = out_image_mem;

  complex_t in_multiplier_kernel [0:3][0:3];
  assign in_multiplier_kernel = out_kernel_mem;

  // set by FSM
  reg next_multiplier;
  // used by other modules
  complex_t out_multiplier [0:3][0:3];
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
  complex_t in_accumulator [0:3][0:3];
  assign in_accumulator = out_multiplier;

  // used by other modules
  complex_t out_accumulator [0:3][0:3];
  wire output_valid_accumulator;

  // The output of multiplier should be in burst mode (consecutive next_out_multiplier be high)
  wire start_accumulator, stop_accumulator;

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
  wire next_ifft;
  assign next_ifft = output_valid_accumulator;

  complex_t in_ifft [0:3][0:3];
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


  reg [57:0] current_commited_image_addr;
  reg [57:0] filter_offset_addr;

  always@(posedge clk) begin
    if (reset) begin
      current_commited_image_addr <= 0;
    end else if (we_image_mem) begin
      current_commited_image_addr <= current_commited_image_addr + 1;
    end
  end


  /********* AFU USER FSM **************/
  // we need a fsm to indicate each kernel memory's status
  enum {VACANT, FILL, FULL, DRAIN} kernel_status_0, kernel_status_1, image_status_0, image_status_1;

  // kernel 0 mem block
  always@(posedge clk) begin
    if (reset) begin
      kernel_status_0 <= VACANT;
    end else begin
      case (kernel_status_0)
        VACANT: begin
          if (select_block_we_kernel_mem == 0 && write_address_kernel_mem != 0) begin
            kernel_status_0 <= FILL;
          end
        end

        FILL: begin
          if (select_block_we_kernel_mem == 1) begin
            kernel_status_0 <= FULL;
          end
        end

        FULL: begin
          if (select_block_rd_kernel_mem == 0 && read_address_kernel_mem != 0) begin
            kernel_status_0 <= DRAIN;
          end
        end

        DRAIN: begin
          if (read_address_kernel_mem == 0) begin
            if (select_block_rd_image_mem == 1'b0 && read_address_image_mem == write_address_image_mem[0]) begin
              kernel_status_0 <= VACANT;
            end else if (select_block_rd_image_mem == 1'b1 && read_address_image_mem == write_address_image_mem[1]) begin
              kernel_status_0 <= VACANT;
            end
          end
        end

        default: begin end   // not gonna happen
      endcase
    end
  end

  // kernel 1 mem block
  always@(posedge clk) begin
    if (reset) begin
      kernel_status_1 <= VACANT;
    end else begin
      case (kernel_status_1)
        VACANT: begin
          if (select_block_we_kernel_mem == 1 && write_address_kernel_mem != 0) begin
            kernel_status_1 <= FILL;
          end
        end

        FILL: begin
          if (select_block_we_kernel_mem == 0) begin
            kernel_status_1 <= FULL;
          end
        end

        FULL: begin
          if (select_block_rd_kernel_mem == 1 && read_address_kernel_mem != 0) begin
            kernel_status_1 <= DRAIN;
          end
        end

        DRAIN: begin
          if (read_address_kernel_mem == 0) begin
            if (select_block_rd_image_mem == 1'b0 && read_address_image_mem == write_address_image_mem[0]) begin
              kernel_status_1 <= VACANT;
            end else if (select_block_rd_image_mem == 1'b1 && read_address_image_mem == write_address_image_mem[1]) begin
              kernel_status_1 <= VACANT;
            end
          end
        end

        default: begin end   // not gonna happen
      endcase
    end
  end

  // indicate the already read kernel
  reg [31:0] current_cycle_already_process_num_kernel;
  reg [31:0] num_output_feature_maps;

  // image 0 mem fsm
  always@(posedge clk) begin
    if (reset) begin
      image_status_0 <= VACANT;
    end else begin
      case (image_status_0)
        VACANT: begin
          if (select_block_we_image_mem == 0 && write_address_image_mem[0] != 0) begin
            image_status_0 <= FILL;
          end
        end
        
        // the mem status may stuck at FILL status
        FILL: begin
          if (select_block_we_image_mem == 1 || current_commited_image_addr == filter_offset_addr) begin
            image_status_0 <= FULL;
          end
        end

        FULL: begin
          if (select_block_rd_image_mem == 0 && read_address_image_mem != 0) begin
            image_status_0 <= DRAIN;
          end
        end

        DRAIN: begin
          if (select_block_rd_image_mem == 0 && read_address_kernel_mem == 0 && read_address_image_mem == write_address_image_mem[0] && current_cycle_already_process_num_kernel == 0) begin
            image_status_0 <= VACANT;
          end
        end

        default: begin end
      endcase
    end
  end

  // image 1 mem fsm
  always@(posedge clk) begin
    if (reset) begin
      image_status_1 <= VACANT;
    end else begin
      case (image_status_1)
        VACANT: begin
          if (select_block_we_image_mem == 1 && write_address_image_mem[1] != 0) begin
            image_status_1 <= FILL;
          end
        end
        
        // the mem status may stuck at FILL status
        FILL: begin
          if (select_block_we_image_mem == 0 || current_commited_image_addr == filter_offset_addr) begin
            image_status_1 <= FULL;
          end
        end

        FULL: begin
          if (select_block_rd_image_mem == 1 && read_address_image_mem != 0) begin
            image_status_1 <= DRAIN;
          end
        end

        DRAIN: begin
          if (select_block_rd_image_mem == 1 && read_address_kernel_mem == 0 && read_address_image_mem == write_address_image_mem[0] && current_cycle_already_process_num_kernel == 0) begin
            image_status_1 <= VACANT;
          end
        end

        default: begin end
      endcase
    end
  end

  // state for memory request, currently, it is a image oriented approach
  enum {TX_RD_STATE_IDLE, TX_RD_STATE_IMAGE_PREPARE, TX_RD_STATE_IMAGE, 
        TX_RD_STATE_KERNEL_PREPARE, TX_RD_STATE_KERNEL, TX_RD_STATE_DONE} read_req_state;

  // afu_context info extraction
  // constant
  reg [57:0] dest_offset_addr;
  reg [57:0] end_output_addr;

  // status address
  reg [57:0] current_read_image_addr;
  reg [57:0] current_read_filter_addr;  // read address from shared memory
  reg [57:0] current_write_addr;
  
  // status number
  reg [31:0] num_cl_output_buffer;
  reg [31:0] num_input_feature_maps;
  reg [31:0] current_cycle_already_read_cl_image;
  reg [31:0] current_cycle_already_read_cl_kernel;  // 1024 a time

  // helper logic
  reg [1:0] first_two_kernel_counter;

  reg uafu_wr_fence_on_off;

  // read request FSM
  always@(posedge clk) begin
    if (reset) begin
      read_req_state <= TX_RD_STATE_IDLE;
      rd_req_en <= 0;
      current_read_image_addr <= 0;
      rd_req_mdata <= 0;
      first_two_kernel_counter <= 0;
    end else begin
      case (read_req_state)
        TX_RD_STATE_IDLE: begin
          if (start) begin
            // synthesis translate_off
            $display("src = %h", afu_context[127:64]);
            $display("dest = %h", afu_context[191:128]);
            $display("whether use fence or not = %d", afu_context[223:192]);  // in order to track the filter read
            $display("filter address = %h", afu_context[256+64-1:256]);   // filter address # of cacheline
            $display("end of output buffer = %d", afu_context[320+64-1:320]);   
            $display("num input feature map = %d", afu_context[415:384]);  // D1, used for accumulate
            $display("num output feature map = %d", afu_context[447:416]); // D2
            $display("dest offset = %h", afu_context[511:448]);
            // synthesis translate_on
            filter_offset_addr <= afu_context[256+64-1:256+6];    // has to be cacheline aligned
            end_output_addr <= afu_context[320+64-1:320+6];
            num_input_feature_maps <= afu_context[415:384];
            num_output_feature_maps <= afu_context[447:416];
            dest_offset_addr <= afu_context[511:448+6];
            read_req_state <= TX_RD_STATE_IMAGE_PREPARE;
            current_cycle_already_read_cl_image <= 0;
            current_read_filter_addr <= afu_context[256+64-1:256+6];
            uafu_wr_fence_on_off <= afu_context[192];
          end
        end

        TX_RD_STATE_IMAGE_PREPARE: begin
          if (image_status_0 == VACANT || image_status_1 == VACANT) begin
            read_req_state <= TX_RD_STATE_IMAGE;
          end else begin
            read_req_state <= TX_RD_STATE_KERNEL_PREPARE;
          end
        end
        TX_RD_STATE_IMAGE: begin
          if (~rd_req_almostfull) begin
            if (current_read_image_addr < filter_offset_addr && current_cycle_already_read_cl_image < NUM_CACHELINE_IMAGE_MOST) begin
              rd_req_addr <= current_read_image_addr;
              current_read_image_addr <= current_read_image_addr + 1;
              rd_req_en <= 1'b1;
              rd_req_mdata[0] <= 0;   // 0 represents image
              current_cycle_already_read_cl_image <= current_cycle_already_read_cl_image + 1;
            end else begin
              rd_req_en <= 1'b0;
              current_cycle_already_read_cl_image <= 0;
              read_req_state <= TX_RD_STATE_KERNEL_PREPARE;
            end
          end else begin    // QPI read request almost full
            rd_req_en <= 1'b0;
          end
        end

        TX_RD_STATE_KERNEL_PREPARE: begin
          if (kernel_status_0 == VACANT || kernel_status_1 == VACANT) begin
            read_req_state <= TX_RD_STATE_KERNEL;
            current_cycle_already_read_cl_kernel <= 0;
          end
        end

        TX_RD_STATE_KERNEL: begin
          // TODO: filter_buffer_almost_full is to be set
          if (~rd_req_almostfull) begin
            if (current_cycle_already_read_cl_kernel < NUM_CACHELINE_KERNEL_MOST) begin
              // get the next read address
              current_read_filter_addr <= current_read_filter_addr + 1;
              rd_req_addr <= current_read_filter_addr;
              rd_req_en <= 1'b1;
              rd_req_mdata[0] <= 1;   // 1 represent kernel
              current_cycle_already_read_cl_kernel <= current_cycle_already_read_cl_kernel + 1;
            end else if (current_read_filter_addr == dest_offset_addr) begin // if all the kernel is read
              rd_req_en <= 1'b0;
              current_read_filter_addr <= filter_offset_addr;
              if (current_read_image_addr == filter_offset_addr && image_status_0 == VACANT && image_status_1 == VACANT) begin
                read_req_state <= TX_RD_STATE_DONE;
              end else begin
                read_req_state <= TX_RD_STATE_KERNEL_PREPARE;
              end
            end else begin      // there are still kernel to be read
              rd_req_en <= 1'b0;
              if (first_two_kernel_counter == 2'b01) begin
                read_req_state <= TX_RD_STATE_IMAGE_PREPARE;  // only when K1 is fill can image be empty
                first_two_kernel_counter <= 0;
              end else begin
                read_req_state <= TX_RD_STATE_KERNEL_PREPARE;
                first_two_kernel_counter <= first_two_kernel_counter + 1;
              end
            end
          end else begin  // QPI read request almost full
            rd_req_en <= 1'b0;
          end
        end

        /* finish all the read */
        TX_RD_STATE_DONE: begin end

        default: begin end
      endcase
    end
  end


  // read response FSM, forward data to FFT or kernel memory

  always@(posedge clk) begin 
    if (reset) begin
      select_block_we_kernel_mem <= 0;
      select_sub_block_we_kernel_mem <= 0;
      select_block_we_image_mem <= 0;
    end else begin
      // select sub_block
      if (we_kernel_mem) begin
        select_sub_block_we_kernel_mem <= ~select_sub_block_we_kernel_mem;
      end
      // select kernel block
      if (we_kernel_mem && write_address_kernel_mem == '1 && select_sub_block_we_kernel_mem == 1'b1) begin
        select_block_we_kernel_mem <= ~select_block_we_kernel_mem;
      end
      // select image block
      if (we_image_mem) begin
        if ((select_block_we_image_mem == 0 && write_address_image_mem[0] == '1) || (select_block_we_image_mem == 1 && write_address_image_mem[1] == '1)) begin
          select_block_we_image_mem <= ~select_block_we_image_mem;
        end
      end
    end
  end

  // if valid and mdata is 0, forward to FFT array
  assign next_image_fft = (start == 1'b1 && rd_rsp_valid == 1'b1 && rd_rsp_mdata[0] == 1'b0) ? 1'b1 : 1'b0;
  // if valid and mdata is 1, forward to kernel memory
  assign we_kernel_mem = (start == 1'b1 && rd_rsp_valid == 1'b1 && rd_rsp_mdata[0] == 1'b1) ? 1'b1 : 1'b0;

  // create a syn fifo as buffer
  wire [511:0] output_fifo_din;
  reg output_fifo_we;

  // used by write request fsm
  reg output_fifo_re;
  wire [511:0] output_fifo_dout;
  wire output_fifo_empty;

  syn_read_fifo #(.FIFO_WIDTH(512),
                  .FIFO_DEPTH_BITS(3),       // transfer size 1 -> 32 entries
                  .FIFO_ALMOSTFULL_THRESHOLD(2**(3)-4),
                  .FIFO_ALMOSTEMPTY_THRESHOLD(2)
                 ) output_fifo (
                .clk                (clk),
                .reset              (reset),
                .din                (output_fifo_din),
                .we                 (output_fifo_we),
                .re                 (output_fifo_re),
                .dout               (output_fifo_dout),
                .empty              (output_fifo_empty),
                .almostempty        (),
                .full               (),
                .count              (),
                .almostfull         ()
            );

  assign output_fifo_din = cacheline_out_ifft;
  always@(posedge clk) begin
    output_fifo_we <= output_valid_ifft;
  end

  // write request FSM
  // TODO: add concurrent processing and ReLU layer (zero threshold)
  enum {TX_WR_DATA, TX_WR_WAIT, TX_WR_FENCE, TX_WR_FLAG} write_req_state;

  always@(posedge clk) begin
    if (reset) begin
      write_req_state <= TX_WR_DATA;
      output_fifo_re <= 1'b0;
      wr_req_en <= 1'b0;
      wr_req_mdata <= 0;
      current_write_addr <= 1;
      uafu_wr_fence_valid <= 0;
    end else begin
      case (write_req_state)
        TX_WR_DATA: begin
          if (wr_req_almostfull == 1'b0 && output_fifo_empty == 1'b0) begin
            output_fifo_re <= 1'b1;
            write_req_state <= TX_WR_WAIT;
          end
          wr_req_en <= 0;
          if (current_write_addr == end_output_addr) begin
            done <= 1;
          end else begin
            done <= 0;
          end
        end

        TX_WR_WAIT: begin
          output_fifo_re <= 1'b0;
          wr_req_en <= 1'b1;
          wr_req_addr <= current_write_addr;
          current_write_addr <= current_write_addr + 1;
          write_req_state <= TX_WR_FENCE;
        end

        TX_WR_FENCE: begin
          if (wr_req_almostfull == 1'b0) begin
            wr_req_en <= 1'b1;
            uafu_wr_fence_valid <= uafu_wr_fence_on_off;
            write_req_state <= TX_WR_FLAG;
          end else begin
            wr_req_en <= 1'b0;
            uafu_wr_fence_valid <= 1'b0;
          end
        end

        TX_WR_FLAG: begin
          uafu_wr_fence_valid <= 1'b0;
          wr_req_addr <= 0;    // the first destination cacheline is used for synchronization
          if (~wr_req_almostfull) begin
            wr_req_en <= 1'b1;
            write_req_state <= TX_WR_DATA;
          end else begin
            wr_req_en <= 1'b0;
          end
        end
      endcase
    end
  end

  assign wr_req_data = (wr_req_addr == 0) ? current_write_addr : output_fifo_dout;


  // run fsm, consume data from image memory and kernel memory and send to multiplier array
  enum {EXEC_IDLE, EXEC_PREPARE, EXEC_RUN} exec_state;

  // used for select_rd from kernel memory
  reg current_kernel_exec;
  reg current_image_exec;
  // these two used for boundary, increase 1 bit for easy comparison
  reg [KERNEL_MEM_DEPTH_BITS:0] current_read_address_kernel_mem_start;
  reg [KERNEL_MEM_DEPTH_BITS:0] current_read_address_kernel_mem_end;
  // these two is the current address
  reg [KERNEL_MEM_DEPTH_BITS:0] current_read_address_kernel_mem;
  reg [IMAGE_MEM_DEPTH_BITS-1:0] current_read_address_image_mem;

  always@(posedge clk) begin
    if (reset) begin
      exec_state <= EXEC_IDLE;
      current_kernel_exec <= 0;
      current_image_exec <= 0;
      next_multiplier <= 0;
      current_cycle_already_process_num_kernel <= 0;   // D2
    end else begin
      case (exec_state)
        EXEC_IDLE: begin
          current_read_address_kernel_mem <= 0;
          current_read_address_image_mem <= 0;
          current_read_address_kernel_mem_start <= 0;
          current_read_address_kernel_mem_end <= num_input_feature_maps[9:0];
          select_block_rd_kernel_mem <= current_kernel_exec;
          select_block_rd_image_mem <= current_image_exec;

          case ({current_image_exec, current_kernel_exec})
            2'b00: begin
              if ((image_status_0 == FULL || image_status_0 == DRAIN) && kernel_status_0 == FULL) begin
                exec_state <= EXEC_RUN;
              end
            end

            2'b01: begin
              if ((image_status_0 == FULL || image_status_0 == DRAIN) && kernel_status_1 == FULL) begin
                exec_state <= EXEC_RUN;
              end
            end

            2'b10: begin
              if ((image_status_1 == FULL || image_status_1 == DRAIN)  && kernel_status_0 == FULL) begin
                exec_state <= EXEC_RUN;
              end
            end

            2'b11: begin
              if ((image_status_1 == FULL || image_status_1 == DRAIN) && kernel_status_1 == FULL) begin
                exec_state <= EXEC_RUN;
              end
            end
          
            default: begin end
          endcase
        end

        // prepare for next kernel cycle
        EXEC_PREPARE: begin
          current_read_address_kernel_mem <= current_read_address_kernel_mem_start;
          current_read_address_image_mem <= 0;
          exec_state <= EXEC_RUN;
        end

        EXEC_RUN: begin
          // for each kernel, multiply with all the image
          if (current_read_address_kernel_mem < current_read_address_kernel_mem_end) begin
            next_multiplier <= 1'b1;
            current_read_address_kernel_mem <= current_read_address_kernel_mem + 1;
            current_read_address_image_mem <= current_read_address_image_mem + 1;
          end else if ((select_block_rd_image_mem == 0 && current_read_address_image_mem == write_address_image_mem[0]) || (select_block_rd_image_mem == 1 && current_read_address_image_mem == write_address_image_mem[1])) begin // this iteration, image finished
            if (current_read_address_kernel_mem[KERNEL_MEM_DEPTH_BITS-1:0] == 0) begin   // if this kernel mem is all consumed
              exec_state <= EXEC_IDLE;
              current_kernel_exec <= ~current_kernel_exec; // switch kernel mem
              // switch image mem if necessary
              if (current_cycle_already_process_num_kernel == num_output_feature_maps - 1) begin
                current_cycle_already_process_num_kernel <= 0;   // D2
                current_image_exec <= ~current_image_exec;
              end else begin  // this kernel mem is finished, but remains kernel to be processed
                current_cycle_already_process_num_kernel <= current_cycle_already_process_num_kernel + 1;
              end
            end else begin    // prepare for the next kernel tile inside the same kernel mem
              exec_state <= EXEC_PREPARE;
              current_cycle_already_process_num_kernel <= current_cycle_already_process_num_kernel + 1;
            end
            next_multiplier <= 1'b0;
            // this kernel tile is processed for this image mem
            
            current_read_address_kernel_mem_start <= current_read_address_kernel_mem_start + num_input_feature_maps[8:0];
            current_read_address_kernel_mem_end <= current_read_address_kernel_mem_end + num_input_feature_maps[8:0];
          end else begin
            next_multiplier <= 1'b0;
            current_read_address_kernel_mem <= current_read_address_kernel_mem_start;
          end

        end

        default : begin end
      endcase
    end
  end

  always@(posedge clk) begin
    read_address_image_mem <= current_read_address_image_mem;
    read_address_kernel_mem <= current_read_address_kernel_mem[KERNEL_MEM_DEPTH_BITS-1:0];
  end

  // write response FSM (maybe used for synchronization)

endmodule // afu_user





