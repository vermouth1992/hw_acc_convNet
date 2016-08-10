
/*
 * This module compute the fft of the input image and store in memory
 * The output should 
 */

`include "common.vh" 

module convLayerFFT (
  input clk,    // Clock
  input reset,  // Synchronous reset active high
  // data
  input image_or_filter,   // 0 for image and 1 for filter
  input input_valid,   // the valid data is on the next cycle
  input [511:0] cacheline_in,  // cache line data
  output reg output_valid,
  output [511:0] cacheline_out,
);

  // 4 fft4_2d_io
  intf_fft_2d #(4) fft4_2d_io[0:3](clk, reset);
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
      assign fft4_2d_io[i].next = input_valid;
    end
  endgenerate

  // instantiate 4 image mem block, connect all the control info together
  reg [12:0] image_read_address;
  reg [12:0] image_write_address;
  reg image_we;
  wire fft_next_out;
  assign fft_next_out = fft4_2d_io[0].next_out & fft4_2d_io[1].next_out & fft4_2d_io[2].next_out & fft4_2d_io[3].next_out;

  intf_block_mem_image block_mem_image_io[0:3](clk);

  generate
    for (i=0; i<4; i=i+1) begin: image_block_array
      memBlockImage memBlockImage_inst(block_mem_image_io[i]);
      assign block_mem_image_io[i].in = fft4_2d_io[i].out;     // connect the output of 2dfft to mem block
      assign block_mem_image_io[i].we = image_we;
      assign block_mem_image_io[i].read_address = image_read_address;
      assign block_mem_image_io[i].write_address = image_write_address;
    end
  endgenerate


  reg kernel_we;
  reg [8:0] kernel_read_address;
  reg [8:0] kernel_write_address;

  intf_block_mem_kernel block_mem_kernel_io [0:1] (clk);

  generate
    for(i=0; i<2; i=i+1) begin: kernel_block_array
      memBlockKernel memBlockKernel_inst(block_mem_kernel_io[i]);
      


  // control signal, first write all the data to memory block, then read all the data out
  enum {WRITE_IMAGE, WRITE_KERNEL_0, WRITE_KERNEL_1, WRITE_DONE} write_state;

  always@(posedge clk) begin
    if (reset) begin
      write_state <= WRITE_IMAGE;
      image_write_address <= 0;
    end else begin
      image_we <= fft_next_out;
      case (write_state)
        WRITE_IMAGE: begin
          if (image_we) begin
            image_write_address <= image_write_address + 1;
          end
          if (image_or_filter == 1'b0) begin
            write_state <= WRITE_KERNEL_0;
          end
        end

        WRITE_KERNEL_0: begin


  
endmodule
