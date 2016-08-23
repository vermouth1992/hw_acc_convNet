
/*
 * This module compute the fft of the input image and store in memory
 * The output should 
 */

`include "common.vh" 

module convLayerFFT (
  input clk,    // Clock
  input reset,  // Synchronous reset active high
  // control
  input next,   // the valid data is on the next cycle
  output next_out,
  // data
  input [511:0] cacheline_in,  // cache line data
  output complex_t out [0:3][0:3][0:3]
);

  // 4 fft4_2d_io
  intf_fft_2d #(4) fft4_2d_io[0:3](clk, reset);
  // instantiate 4 fft_2d
  genvar i, j, k;
  generate
    for (i=0; i<4; i=i+1) begin: fft4_2d_inst_gen
      fft_2d #(4, 0) fft4_2d_inst(fft4_2d_io[i]);
    end
  endgenerate

  // reformat cacheline to vector
  wire [31:0] tile [0:3][0:3];
  generate
    for (i = 0; i < 4; i = i + 1) begin: tile_assignment
      for (j = 0; j < 4; j = j + 1) begin: tile_assignment_inner
        assign tile[i][j] = cacheline_in[128 * i + 32 * j + 31 : 128 * i + 32 * j];
      end
    end
  endgenerate

  // io input
  generate
    for (i=0; i<4; i=i+1) begin: assign_io_fft4_2d
      assign fft4_2d_io[i].in[0][0].r = tile[i][0];
      assign fft4_2d_io[i].in[0][1].r = tile[i][1];
      assign fft4_2d_io[i].in[0][2].r = 0;
      assign fft4_2d_io[i].in[0][3].r = 0;
      assign fft4_2d_io[i].in[1][0].r = tile[i][2];
      assign fft4_2d_io[i].in[1][1].r = tile[i][3];
      assign fft4_2d_io[i].in[1][2].r = 0;
      assign fft4_2d_io[i].in[1][3].r = 0;
      for (j=2; j<4; j=j+1) begin: zero_assign_0_outer
        for (k=0; k<4; k=k+1) begin: zero_assign_0_inner
          assign fft4_2d_io[i].in[j][k].r = 0;
        end
      end
      for (j=0; j<4; j=j+1) begin: zero_assign_1_outer
        for (k=0; k<4; k=k+1) begin: zero_assign_1_inner
          assign fft4_2d_io[i].in[j][k].i = 0;
        end
      end
    end
  endgenerate

  // assgin next signal
  generate
    for (i=0; i<4; i=i+1) begin: next_io
      assign fft4_2d_io[i].next = next;
    end
  endgenerate

  // if it is not correct, then use AND gate
  assign next_out = fft4_2d_io[0].next_out;

  // assign output
  generate
    for (i=0; i<4; i=i+1) begin: out_i
      assign out[i] = fft4_2d_io[i].out;
    end
  endgenerate
  
endmodule

/* 4 ifft_2d instances in parallel */ 
module convLayerIFFT (
  input clk,
  input reset,
  // control
  input next,
  output output_valid,
  // data
  input complex_t in [0:3][0:3][0:3],
  output [511:0] cacheline_out   // the output will be in consecutive 4 cycles
  );

  complex_t out [0:3][0:3][0:3];
  wire next_out;

  // 4 fft_2d_io
  intf_fft_2d #(4) fft4_2d_io[0:3](clk, reset);
  // instantiate 4 fft_2d
  genvar i, j, k;
  generate
    for (i=0; i<4; i=i+1) begin: fft4_2d_inst_gen
      fft_2d #(4, 1) fft4_2d_inst(fft4_2d_io[i]);
    end
  endgenerate

  // assign input signal
  generate
    for (i=0; i<4; i=i+1) begin: in_i
      assign fft4_2d_io[i].in = in[i];
    end
  endgenerate

  // assign output
  generate
    for (i=0; i<4; i=i+1) begin: out_i
      assign out[i] = fft4_2d_io[i].out;
    end
  endgenerate

  // assgin next signal
  generate
    for (i=0; i<4; i=i+1) begin: next_io
      assign fft4_2d_io[i].next = next;
    end
  endgenerate

  // if it is not correct, then use AND gate
  assign next_out = fft4_2d_io[0].next_out;

  // select the real part
  logic [31:0] out_real [0:3][0:3][0:3];

  generate
    for (i=0; i<4; i=i+1) begin: select_real_outer
      for (j=0; j<4; j=j+1) begin: select_real_middle
        for (k=0; k<4; k=k+1) begin: select_real_inner
          assign out_real[i][j][k] = out[i][j][k].r;
        end
      end
    end
  endgenerate

  // reformat to 4 cachelines
  logic [511:0] out_wire [0:3];

  generate
    for (i=0; i<4; i=i+1) begin: cacheline_index
      for (j=0; j<4; j=j+1) begin: reformat_outer
        for (k=0; k<4; k=k+1) begin: reformat_inner
          assign out_wire[i][128*k+32*k+31:128*j+32*k] = out_real[i][j][k];
        end
      end
    end
  endgenerate

  // 4 registers, not mem
  reg [511:0] out_reg [0:3];

  integer m;

  // register the output when next_out is high
  always@(posedge clk) begin
    if (next_out) begin
      for (m=0; m<4; m=m+1) begin
        out_reg[m] <= out_wire[m];
      end
    end
  end

  // control signal
  reg [2:0] counter;

  always@(posedge clk) begin
    if (reset) begin
      counter <= 3'b100;
    end else if (next_out) begin
      counter <= 3'b000;
    end else if (counter < 3'b100) begin
      counter <= counter + 1;
    end
  end

  assign output_valid = ~counter[2];   // if counter[2] == 1, then not valid, else valid

  // cacheline out based on counter
  assign cacheline_out = (counter[1:0] == 2'b00) ? out_reg[0] :
                         (counter[1:0] == 2'b01) ? out_reg[1] :
                         (counter[1:0] == 2'b10) ? out_reg[2] :
                         out_reg[3];

endmodule
