
/* 4 group of 16 complex multiplier array, 
 * in total 64 complex multipler, reach the maximum harp dsp resources
 */

`include "common.vh"


/* 4x4 complex multiplier array */
module complexMultArray (
  input clk,
  input reset,
  input complex_t image [0:3][0:3],
  input complex_t kernel [0:3][0:3],
  output complex_t out [0:3][0:3],
  input next,
  output next_out
  );

  // instantiation
  wire next_out_inst[0:3][0:3];

  genvar i, j;
  generate
    for (i=0; i<4; i=i+1) begin: mult_inst_outer
      for (j=0; j<4; j=j+4) begin: mult_inst_inner
        complexMultConventionfp32fp32 complexMultConventionfp32fp32_inst (
          .clk     (clk),
          .reset   (reset),
          .in0     (image[i][j]),
          .in1     (kernel[i][j]),
          .out     (out[i][j]),
          .next    (next),
          .next_out(next_out_inst[i][j]),
          );
      end // mult_inst_inner
    end // mult_inst_outer
  endgenerate

  assign next_out = next_out_inst[0][0];

endmodule // complexMultArray


module complexAccumulatorArray (
  input clk,
  input reset,
  input clear,
  );

endmodule

/* 4 complexMultArray in parallel, 4 tile in parallel */
module complexMultArrayParallel (
  input clk,
  input reset,
  input complex_t image [0:3][0:3][0:3],
  input complex_t kernel [0:3][0:3],
  output complex_t out [0:3][0:3][0:3],
  input next,
  output next_out
  );

  wire next_out_inst [0:3];

  genvar i;
  generate
    for(i=0; i<4; i=i+1) begin: parallel_inst
      complexMultArray complexMultArray_inst (
        .clk     (clk),
        .reset   (reset),
        .image   (image[i]),
        .kernel  (kernel),
        .out     (out[i]),
        .next    (next),
        .next_out(next_out_inst[i])
        );
    end
  endgenerate

  assign next_out = next_out_inst[0];

endmodule
