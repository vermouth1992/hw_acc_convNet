
interface intf_fft4_2d (
  input clk,
  input reset
  );
  complex_t in [0:3][0:3];
  complex_t out [0:3][0:3];
  logic next, next_out;
endinterface

module fft4_2d (
  intf_fft4_2d fft_2d_io
);

  intf_fft4 fft_1d_io_first(fft_2d_io.clk, fft_2d_io.reset) [0:3];
  intf_fft4 fft_1d_io_second(fft_2d_io.clk, fft_2d_io.reset) [0:3];

  genvar i, j;
  // matrix transpose
  generate
    for (i=0; i<4; i=i+1) begin: matrix_traspose_loop_over_fft_inst
      for (j=0 ;j<4; j=j+1) begin :matrix_traspose_loop_over_io
        assign fft_1d_io_second[i].in[j] = fft_1d_io_first[j].out[i];
      end
    end
  endgenerate


  generate
    for (i=0; i<4; i=i+1) begin: fft_array
      // first
      assign fft_1d_io_first[i].next = fft_2d_io.next;
      assign fft_1d_io_first[i].in = fft_2d_io.in[i];
      // second
      assign fft_1d_io_second[i].next = fft_1d_io_first[i].next_out;
      assign fft_2d_io.out[i] = fft_1d_io_second[i].out;
    end
  endgenerate

  assign fft_2d_io.next_out = fft_1d_io_second[0].next_out;

endmodule