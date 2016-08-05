
/*
 * This module compute the fft of the input image and store in memory
 * The output should 
 */

`include "common.vh" 

module convLayerFFT (
  input clk,    // Clock
  input reset,  // Synchronous reset active high
  input [511:0] cacheline,  // cache line data
  input input_valid,   // the valid data is on the next cycle
  output complex_t out[0:3][0:3][0:3],  // 64 complex number
);

  // 4 fft4_2d_io
  intf_fft4_2d fft4_2d_io[0:3](clk, reset);
  // instantiate 4 fft4_2d
  genvar i, j, k;
  generate
    for (i=0; i<4; i=i+1) begin: fft4_2d_inst_gen
      fft4_2d fft4_2d_inst(fft4_2d_io[i]);
    end
  endgenerate

  // reformat cacheline to vector
  wire [31:0] tile [0:3][0:3];
  generate
    for (i = 0; i < 4; i = i + 1) begin: tile_assignment
      for (j = 0; j < 4; j = j + 1) begin: tile_assignment_inner
        assign tile[i][j] = cacheline[128 * i + 32 * j + 31 : 128 * i + 32 * j];
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
      for (j=2; j<4; j=j+1) begin: zero_assign
        for (k=0; k<4; k=k+1) begin: zero_assign_inner
          assign fft4_2d_io[i].in[j][k].r = 0;
        end
      end
      for (j=0; j<4; j=j+1) begin: zero_assign
        for (k=0; k<4; k=k+1) begin: zero_assign_inner
          assign fft4_2d_io[i].in[j][k].i = 0;
        end
      end
    end
  endgenerate

  // assgin next signal
  generate
    for (i=0; i<4; i=i+1) begin: next_io
      assign fft4_2d_io[i].next = input_valid;
    end
  endgenerate

  // instantiate 4 image mem block
  intf_block_mem_image block_mem_image_io[0:3](clk);
  generate
    for (i=0; i<4; i=i+1) begin: image_block_array
      memBlockImage memBlockImage_inst(block_mem_image_io[i]);
      assign block_mem_image_io[i].in = fft4_2d_io[i].out;     // connect the output of 2dfft to mem block
    end
  endgenerate



endmodule