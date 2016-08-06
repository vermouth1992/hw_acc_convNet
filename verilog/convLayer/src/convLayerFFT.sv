
/*
 * This module compute the fft of the input image and store in memory
 * The output should 
 */

`include "common.vh" 

module convLayerFFT (
  input clk,    // Clock
  input reset,  // Synchronous reset active high
  input [31:0] ctx_length,
  input input_valid,   // the valid data is on the next cycle
  input [511:0] cacheline_in,  // cache line data
  output reg output_valid,
  output [511:0] cacheline_out
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

  // instantiate 4 image mem block, connect all the control info together
  reg [12:0] read_address;
  reg [12:0] write_address;
  reg we;
  wire fft_next_out;
  assign fft_next_out = fft4_2d_io[0].next_out & fft4_2d_io[1].next_out & fft4_2d_io[2].next_out & fft4_2d_io[3].next_out;

  intf_block_mem_image block_mem_image_io[0:3](clk);

  generate
    for (i=0; i<4; i=i+1) begin: image_block_array
      memBlockImage memBlockImage_inst(block_mem_image_io[i]);
      assign block_mem_image_io[i].in = fft4_2d_io[i].out;     // connect the output of 2dfft to mem block
      assign block_mem_image_io[i].we = we;
      assign block_mem_image_io[i].read_address = read_address;
      assign block_mem_image_io[i].write_address = write_address;
    end
  endgenerate

  // cacheline out based on the select signal
  /* output first fft_2d real */
  // reformat cacheline to vector
  wire [31:0] tile_out [0:3][0:3];
  generate
    for (i = 0; i < 4; i = i + 1) begin: tile_assignment
      for (j = 0; j < 4; j = j + 1) begin: tile_assignment_inner
        assign cacheline_out[128 * i + 32 * j + 31 : 128 * i + 32 * j] = tile_out[i][j];
        assign tile_out[i][j] = block_mem_image_io[i].out[i][j].r;
      end
    end
  endgenerate


  // control signal, first write all the data to memory block, then read all the data out

  // write logic
  always@(posedge clk) begin
    if (reset) begin
      write_address <= 0;
    end else if (we) begin
      write_address <= write_address + 1;
    end
    we <= fft_next_out;
  end

  // read logic
  always@(posedge clk) begin
    if (reset) begin
      read_address <= 0;
    end else if (write_address == ctx_length && read_address != ctx_length) begin
      output_valid <= 1;
      read_address <= read_address + 1;
    end
  end

endmodule