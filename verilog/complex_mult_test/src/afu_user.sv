
`include "common.vh"

module afu_user # (
  parameter DATA_WIDTH = 32,
  parameter BUFF_DEPTH_BITS = 3
) (
  input clk,    // Clock
  input reset,  // Asynchronous reset active low
  // input fifo
  input [511:0] input_fifo_din,
  input input_fifo_we,
  output input_fifo_full,
  output input_fifo_almost_full,
  output [BUFF_DEPTH_BITS-1:0] input_fifo_count,
  // output fifo
  output [511:0] output_fifo_dout,
  input output_fifo_re,
  output output_fifo_empty,
  output output_fifo_almost_empty,
  // other information
  input [31:0] ctx_length
);
  // input fifo
  wire [511:0] input_fifo_dout;
  wire input_fifo_re;
  wire input_fifo_empty;
  // output fifo
  wire [511:0] output_fifo_din;
  reg output_fifo_we;

  syn_read_fifo #(.FIFO_WIDTH(512),
                  .FIFO_DEPTH_BITS(BUFF_DEPTH_BITS),       // transfer size 1 -> 32 entries
                  .FIFO_ALMOSTFULL_THRESHOLD(2**(BUFF_DEPTH_BITS)-4),
                  .FIFO_ALMOSTEMPTY_THRESHOLD(2)
                 ) input_fifo (
                .clk                (clk),
                .reset              (reset),
                .din                (input_fifo_din),
                .we                 (input_fifo_we),
                .re                 (input_fifo_re),
                .dout               (input_fifo_dout),
                .empty              (input_fifo_empty),
                .almostempty        (),
                .full               (input_fifo_full),
                .count              (input_fifo_count),
                .almostfull         (input_fifo_almost_full)
            );

  complex_t io_in [0:7];   // 8 complex word/cache line
  complex_t io_out[0:7];

  genvar i;
  generate
    for (i=0; i<8; i=i+1) begin: complex_mult_io
      assign io_in[i].r = input_fifo_dout[64*i+31:64*i];
      assign io_in[i].i = input_fifo_dout[64*i+63:64*i+32];
      assign output_fifo_din[64*i+31:64*i] = io_out[i].r;
      assign output_fifo_din[64*i+63:64*i+32] = io_out[i].i;
    end
  endgenerate
    
  wire next;

  generate
    for (i=0; i<7; i=i+1) begin: complex_mult_array
      complexMultCanonicalfp32fp32 complex_mult_inst(.clk(clk), .reset(reset), .in0(io_in[i]), .in1(io_in[i+1]), .out(io_out[i]), .next(next), .next_out());
    end
  endgenerate
  wire next_out;
  complexMultCanonicalfp32fp32 complex_mult_inst1(.clk(clk), .reset(reset), .in0(io_in[7]), .in1(io_in[0]), .out(io_out[7]), .next(next), .next_out(next_out));

  // input re
  assign input_fifo_re = ~input_fifo_empty;
  // io next
  assign next = input_fifo_re;

  always@(posedge clk) begin
    output_fifo_we <= next_out;
  end

  syn_read_fifo #(.FIFO_WIDTH(512),
                  .FIFO_DEPTH_BITS(BUFF_DEPTH_BITS),       // transfer size 1 -> 32 entries
                  .FIFO_ALMOSTFULL_THRESHOLD(2**(BUFF_DEPTH_BITS)-4),
                  .FIFO_ALMOSTEMPTY_THRESHOLD(2)
                 ) output_fifo (
                .clk                (clk),
                .reset              (reset),
                .din                (output_fifo_din),
                .we                 (output_fifo_we),
                .re                 (output_fifo_re),
                .dout               (output_fifo_dout),
                .empty              (output_fifo_empty),
                .almostempty        (output_fifo_almost_empty),
                .full               (),
                .count              (),
                .almostfull         ()
            );

endmodule
