
`include "common.vh"

module fft_2d #(
  parameter WIDTH = 4,
  parameter IS_INVERSE = 0
) (
  intf_fft_2d fft_2d_io
);

  intf_fft #(WIDTH) fft_1d_io_first[0:WIDTH-1](fft_2d_io.clk, fft_2d_io.reset);
  intf_fft #(WIDTH) fft_1d_io_second[0:WIDTH-1](fft_2d_io.clk, fft_2d_io.reset);

  genvar i, j;
  // generate fft instance
  generate
    for (i=0; i<WIDTH; i=i+1) begin: fft_instance
      if (IS_INVERSE == 0) begin
        if (WIDTH == 4) begin
          fft4_wrapper fft_inst_first_array(fft_1d_io_first[i]);
          fft4_wrapper fft_inst_second_array(fft_1d_io_second[i]);
        end else if (WIDTH == 8) begin
          fft8_wrapper fft_inst_first_array(fft_1d_io_first[i]);
          fft8_wrapper fft_inst_second_array(fft_1d_io_second[i]);
        end
      end else if (IS_INVERSE == 1) begin
        if (WIDTH == 4) begin
          ifft4_wrapper fft_inst_first_array(fft_1d_io_first[i]);
          ifft4_wrapper fft_inst_second_array(fft_1d_io_second[i]);
        end else if (WIDTH == 8) begin
          ifft8_wrapper fft_inst_first_array(fft_1d_io_first[i]);
          ifft8_wrapper fft_inst_second_array(fft_1d_io_second[i]);
        end
      end
    end
  endgenerate

  // matrix transpose
  generate
    for (i=0; i<WIDTH; i=i+1) begin: matrix_traspose_loop_over_fft_inst
      for (j=0 ;j<WIDTH; j=j+1) begin :matrix_traspose_loop_over_io
        assign fft_1d_io_second[i].in[j] = fft_1d_io_first[j].out[i];
      end
    end
  endgenerate


  generate
    for (i=0; i<WIDTH; i=i+1) begin: fft_array
      // first
      assign fft_1d_io_first[i].next = fft_2d_io.next;
      assign fft_1d_io_first[i].in = fft_2d_io.in[i];
      // second
      assign fft_1d_io_second[i].next = fft_1d_io_first[i].next_out;
      assign fft_2d_io.out[i] = fft_1d_io_second[i].out;
    end
  endgenerate

  // may used and gatet
  assign fft_2d_io.next_out = fft_1d_io_second[0].next_out;

endmodule
