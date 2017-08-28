
/* 4 group of 16 complex multiplier array, 
 * in total 64 complex multipler, reach the maximum harp dsp resources
 */

`include "common.vh"


/* 4x4 complex multiplier array */
module complexMultArray (
  input clk,
  input reset,
  input complex_fxp_t image [0:15][0:15],
  input complex_fxp_t kernel [0:15][0:15],
  output complex_fxp_t out [0:15][0:15],
  input next,
  output next_out
  );

  // instantiation
  wire next_out_inst[0:15][0:15];

  genvar i, j;
  generate
    for (i=0; i<16; i=i+1) begin: mult_inst_outer
      for (j=0; j<16; j=j+1) begin: mult_inst_inner
        complexMultCanonicalfxp16fxp16 complexMultCanonicalfxp16fxp16_inst (
          .clk     (clk),
          .reset   (reset),
          .in0     (image[i][j]),
          .in1     (kernel[i][j]),
          .out     (out[i][j]),
          .next    (next),
          .next_out(next_out_inst[i][j])
          );
      end // mult_inst_inner
    end // mult_inst_outer
  endgenerate

  assign next_out = next_out_inst[0][0];

endmodule // complexMultArray


module complexAccumulatorArray (
  input clk,
  input reset,
  input complex_fxp_t in [0:15][0:15],
  output complex_fxp_t out [0:15][0:15],
  // control
  input in_valid,
  output output_valid
  );

  wire output_valid_inst [0:15][0:15];
  // instantiate 16 accumulator
  genvar i, j;
  generate
    for (i=0; i<16; i=i+1) begin: accumulator_inst_outer
      for (j=0; j<16; j=j+1) begin: accumulator_inst_inner
        accumulator accumulator_inst (
          .clk         (clk),
          .reset       (reset),
          .in          (in[i][j]),
          .out         (out[i][j]),
          .in_valid    (in_valid),
          .output_valid(output_valid_inst[i][j])
          );
      end
    end
  endgenerate

  assign output_valid = output_valid_inst[0][0];

endmodule
