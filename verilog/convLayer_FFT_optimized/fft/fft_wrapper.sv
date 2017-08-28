`include "common.vh"

/* 2d fft, data parallelism is 32. The input conforms to harp */
module fft_2d_16x16 (
  input clk,    // Clock
  input reset,  // Synchronous reset active high
  // data
  input complex_fxp_t in [0:1][0:15],
  output complex_fxp_t out [0:1][0:15], // each time, there are two 16 complex data out
  // control
  input valid_in,   // data is valid at the same cycle as valid_in
  output valid_out  // valid_out is 1 cycle ahead
);

  /* start row fft */

  // transform cacheline to real fixed point data
  complex_fxp_t row_fft_in [0:1][0:15],
  complex_fxp_t row_fft_out[0:1][0:15];

  assign row_fft_in = in;

  // genvar i, j;
  // generate
  //   for (i = 0; i < 2; i=i+1) begin: for_each_1d_fft
  //     for (j = 0; j < 16; j=j+1) begin: for_each_data
  //       assign row_fft_in[i][j].r = cacheline_in_delay[256 * i + 16 * j + 15 : 256 * i + 16 * j];
  //       assign row_fft_in[i][j].i = 0;
  //     end
  //   end
  // endgenerate

  wire row_fft_valid_out;

  generate
    for (i = 0; i < 2; i=i+1) begin: row_fft_1d
      fft_1d_16 fft_1d_16_inst_row (
        .clk     (clk),
        .reset   (reset),
        .in      (row_fft_in[i]),
        .out     (row_fft_out[i]),
        .next    (valid_in),
        .next_out(row_fft_valid_out)
        );
    end
  endgenerate

  /* end row fft */

  /* start transpose */

  wire [31:0] input_stream [0:31];
  wire [31:0] output_stream [0:31];
  wire spn_valid_out;

  // connect row_fft_out to input_stream
  generate
    for (i = 0; i < 2; i=i+1) begin: for_each_1d_fft_spn_in
      for (j = 0; j < 16; j=j+1) begin: for_each_data_spn_in
        assign input_stream[i*16+j] = row_fft_out[i][j];
      end
    end
  endgenerate

  spn spn_inst (
    .clk          (clk),
    .rst          (reset),
    .valid_in     (row_fft_valid_out),
    .input_stream (input_stream),
    .valid_out    (spn_valid_out),
    .output_stream(output_stream)
    );

  /* end transpose */

  /* start column fft */

  // transform cacheline to real fixed point data
  complex_fxp_t column_fft_in [0:1][0:15];
  complex_fxp_t column_fft_out[0:1][0:15];

  // connect column_fft_in to output_stream
  generate
    for (i = 0; i < 2; i=i+1) begin: for_each_1d_fft_spn_out
      for (j = 0; j < 16; j=j+1) begin: for_each_data_spn_out
        assign column_fft_in[i][j] = output_stream[i*16+j];
      end
    end
  endgenerate

  wire column_fft_valid_out;

  generate
    for (i = 0; i < 2; i=i+1) begin: column_fft_1d
      fft_1d_16 fft_1d_16_inst_column (
        .clk     (clk),
        .reset   (reset),
        .in      (column_fft_in[i]),
        .out     (column_fft_out[i]),
        .next    (spn_valid_out),
        .next_out(column_fft_valid_out)
        );
    end
  endgenerate

  /* end column fft */

  // assign output
  assign out = column_fft_out;
  assign valid_out = column_fft_valid_out;

endmodule





module fft_1d_16 (
  input clk,    // Clock
  input reset,  // Synchronous reset active high
  input complex_fxp_t in [0:15],
  output complex_fxp_t out [0:15],
  input next,
  output next_out
);

  dft_top inst_dft_top (
      .clk      (clk),
      .reset    (reset),
      .next     (next),
      .next_out (next_out),
      .X0       (in[0].r),
      .Y0       (out[0].r),
      .X1       (in[0].i),
      .Y1       (out[0].i),
      .X2       (in[1].r),
      .Y2       (out[1].r),
      .X3       (in[1].i),
      .Y3       (out[1].i),
      .X4       (in[2].r),
      .Y4       (out[2].r),
      .X5       (in[2].i),
      .Y5       (out[2].i),
      .X6       (in[3].r),
      .Y6       (out[3].r),
      .X7       (in[3].i),
      .Y7       (out[3].i),
      .X8       (in[4].r),
      .Y8       (out[4].r),
      .X9       (in[4].i),
      .Y9       (out[4].i),
      .X10      (in[5].r),
      .Y10      (out[5].r),
      .X11      (in[5].i),
      .Y11      (out[5].i),
      .X12      (in[6].r),
      .Y12      (out[6].r),
      .X13      (in[6].i),
      .Y13      (out[6].i),
      .X14      (in[7].r),
      .Y14      (out[7].r),
      .X15      (in[7].i),
      .Y15      (out[7].i),
      .X16      (in[8].r),
      .Y16      (out[8].r),
      .X17      (in[8].i),
      .Y17      (out[8].i),
      .X18      (in[9].r),
      .Y18      (out[9].r),
      .X19      (in[9].i),
      .Y19      (out[9].i),
      .X20      (in[10].r),
      .Y20      (out[10].r),
      .X21      (in[10].i),
      .Y21      (out[10].i),
      .X22      (in[11].r),
      .Y22      (out[11].r),
      .X23      (in[11].i),
      .Y23      (out[11].i),
      .X24      (in[12].r),
      .Y24      (out[12].r),
      .X25      (in[12].i),
      .Y25      (out[12].i),
      .X26      (in[13].r),
      .Y26      (out[13].r),
      .X27      (in[13].i),
      .Y27      (out[13].i),
      .X28      (in[14].r),
      .Y28      (out[14].r),
      .X29      (in[14].i),
      .Y29      (out[14].i),
      .X30      (in[15].r),
      .Y30      (out[15].r),
      .X31      (in[15].i),
      .Y31      (out[15].i)
    );


endmodule