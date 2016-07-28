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

  intf_fft fft_io(clk, reset);
  intf_fft ifft_io(clk, reset);

  fft_wrapper fft_inst(fft_io);
  ifft_wrapper ifft_inst(ifft_io);

  genvar i;
  generate
    for (i=0; i<16; i=i+1) begin: fft_input_generate
      assign fft_io.in[i] = input_fifo_dout[32*i+31:32*i];
      assign ifft_io.in[i] = fft_io.out[i];
      assign output_fifo_din[32*i+31:32*i] = ifft_io.out[i];
    end
  endgenerate

  // input re
  assign input_fifo_re = ~input_fifo_empty;
  // io next
  assign fft_io.next = input_fifo_re;
  assign ifft_io.next = fft_io.next_out;

  always@(posedge clk) begin
    output_fifo_we <= ifft_io.next_out;
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
