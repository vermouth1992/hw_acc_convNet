
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
  output complex_t out [0:3][0:3]
);

  // 4 fft4_2d_io
  intf_fft_2d #(4) fft4_2d_io (clk, reset);
  // instantiate 4 fft_2d
  genvar i, j, k;
  
  fft_2d #(4, 0) fft4_2d_inst(fft4_2d_io);

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
    for (j=0; j<4; j=j+1) begin: zero_assign_0_outer
      for (k=0; k<4; k=k+1) begin: zero_assign_0_inner
        assign fft4_2d_io.in[j][k].r = tile[j][k];
      end
    end
    for (j=0; j<4; j=j+1) begin: zero_assign_1_outer
      for (k=0; k<4; k=k+1) begin: zero_assign_1_inner
        assign fft4_2d_io.in[j][k].i = 0;
      end
    end
  endgenerate

  // assgin next signal
  assign fft4_2d_io.next = next;

  // if it is not correct, then use AND gate
  assign next_out = fft4_2d_io.next_out;

  // assign output
  assign out = fft4_2d_io.out;
  
endmodule

/* 4 ifft_2d instances in parallel */ 
module convLayerIFFT (
  input clk,
  input reset,
  // control
  input next,
  output output_valid,
  // data
  input complex_t in [0:3][0:3],
  output [511:0] cacheline_out   // the output will be in consecutive 4 cycles
  );

  complex_t out [0:3][0:3];
  wire next_out;

  // 4 fft_2d_io
  intf_fft_2d #(4) fft4_2d_io (clk, reset);
  // instantiate 4 fft_2d
  genvar i, j, k;
  
  fft_2d #(4, 1) fft4_2d_inst(fft4_2d_io);

  // assign input signal
  assign fft4_2d_io.in = in;

  // assign output
  assign out = fft4_2d_io.out;

  // assgin next signal
  assign fft4_2d_io.next = next;

  // if it is not correct, then use AND gate
  assign next_out = fft4_2d_io.next_out;

  // select the real part
  logic [31:0] out_real [0:3][0:3];

  generate
    for (j=0; j<4; j=j+1) begin: select_real_middle
      for (k=0; k<4; k=k+1) begin: select_real_inner
        assign out_real[j][k] = out[j][k].r;
      end
    end
  endgenerate

  // reformat to 4 cachelines
  logic [511:0] out_wire;

  generate
    for (j=0; j<4; j=j+1) begin: reformat_outer
      for (k=0; k<4; k=k+1) begin: reformat_inner
        assign out_wire[128*j+32*k+31:128*j+32*k] = out_real[j][k];
      end
    end
  endgenerate


  assign output_valid = next_out;

  assign cacheline_out = out_wire;

endmodule
