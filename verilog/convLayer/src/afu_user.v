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

  wire reset;
  assign reset = ~reset_n;

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


endmodule // afu_user





