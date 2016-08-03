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
  output reg    wr_req_en, 
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

  wire reset;

  reg [1:0] mode;

  assign reset = ~reset_n;

  enum logic [2:0] {IDLE=3'b001, RUN=3'b010, DONE=3'b100} state;

  // always@(posedge start) begin
  //   if (reset) begin
  //     done_reg <= 1'b0;
  //   end else if (start) begin
  //     done_reg <= 1'b1;
  //     // synthesis translate_off
  //     $display("src = %h", afu_context[127:64]);
  //     $display("dest = %h", afu_context[191:128]);
  //     $display("num_cl = %d", afu_context[223:192]);
  //     $display("filter address = %h", afu_context[319:256]);
  //     $display("num input feature map = %d", afu_context[383:320]);
  //     $display("num output feature map = %d", afu_context[447:384]);
  //     // synthesis translate_on 
  //   end
  // end
  reg [ADDR_LMT-1:0] num_cl;   // the number of cache line in each buffer must be the same

  reg [ADDR_LMT-1:0] read_response_num;
  reg [ADDR_LMT-1:0] write_response_num;

  always@(posedge clk) begin
    if (reset) begin
      done <= 0;
      state <= IDLE;
      rd_req_addr <= 0;
      wr_req_addr <= 0;
      rd_req_en <= 0;
      wr_req_en <= 0;
      read_response_num <= 0;
      write_response_num <= 0;
      // meta data are all set to 0
      rd_req_mdata <= 0;
      wr_req_mdata <= 0;
    end else begin
      case(state)
        IDLE: begin
          if (start) begin
            mode <= afu_context[257:256];  // 2'b01 for read only, 2'b10 for write only, 2'b11 for read/write, set by sw
            num_cl <= afu_context[ADDR_LMT+192-1:192];
            state <= RUN;
            if (afu_context[256] == 1'b1) begin
              rd_req_en <= 1'b1;
            end
            if (afu_context[257] == 1'b1) begin
              wr_req_en <= 1'b1;
            end
          end
        end
        RUN: begin
          // read request
          if (mode[0] == 1'b1 && ~rd_req_almostfull && rd_req_addr < num_cl) begin
            rd_req_en <= 1'b1;
            rd_req_addr <= rd_req_addr + 1'b1;
          end else begin
            rd_req_en <= 1'b0;
          end
          // read response
          if (rd_rsp_valid) begin
            read_response_num <= read_response_num + 1'b1;
          end

          // write request
          if (mode[1] == 1'b1 && ~wr_req_almostfull && wr_req_addr < num_cl) begin
            wr_req_en <= 1'b1;
            wr_req_addr <= wr_req_addr + 1'b1;
          end else begin
            wr_req_en <= 1'b0;
          end
          // write response
          case ({wr_rsp0_valid, wr_rsp1_valid})
            2'b00: begin end
            2'b01: begin write_response_num <= write_response_num + 1; end
            2'b10: begin write_response_num <= write_response_num + 1; end
            2'b11: begin write_response_num <= write_response_num + 2; end
          endcase // {wr_rsp0_valid, wr_rsp1_valid}

          // next state logic
          case (mode)
            2'b00: begin state <= DONE; end
            2'b01: begin
              if (read_response_num == num_cl) begin
                state <= DONE;
              end
            end
            2'b10: begin
              if (write_response_num == num_cl) begin
                state <= DONE;
              end
            end
            2'b11: begin
              if (write_response_num == num_cl && read_response_num == num_cl) begin
                state <= DONE;
              end
            end
          endcase
        end
        DONE: begin
          done <= 1'b1;
        end
      endcase
    end
  end
     
endmodule // afu_user





