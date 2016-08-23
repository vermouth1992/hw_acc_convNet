
/*
 * This module compute the fft of the input image and store in memory
 * The output should 
 */

`include "common.vh" 

module convLayerFFT (
  input clk,    // Clock
  input reset,  // Synchronous reset active high
  // data
  input next,   // the valid data is on the next cycle
  output next_out,
  input [511:0] cacheline_in,  // cache line data
  output complex_t out [0:3][0:3][0:3]
);

  // 4 fft4_2d_io
  intf_fft_2d #(4) fft4_2d_io[0:3](clk, reset);
  // instantiate 4 fft_2d
  genvar i, j, k;
  generate
    for (i=0; i<4; i=i+1) begin: fft4_2d_inst_gen
      fft_2d #(4) fft4_2d_inst(fft4_2d_io[i]);
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
