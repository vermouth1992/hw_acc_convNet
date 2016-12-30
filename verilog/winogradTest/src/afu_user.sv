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

  wire [31:0] pe_data_in [0:3][0:3];
  wire [31:0] pe_data_out [0:1][0:1];

  genvar i, j;
  generate
    for (i=0; i<4; i=i+1) begin: pe_data_in_first
      for (j=0; j<4; j=j+1) begin: pe_data_in_second
        assign pe_data_in[i][j] = input_fifo_dout[128*i+32*j+31 : 128*i+32*j];
      end
    end

    for (i=0; i<2; i=i+1) begin: pe_data_out_first
      for (j=0; j<2; j=j+1) begin: pe_data_out_second
        assign output_fifo_din[128*i+32*j+31 : 128*i+32*j] = pe_data_out[i][j];
      end
    end

    for (i=2; i<4; i=i+1) begin: fft_input_generate_first
      for (j=2; j<4; j=j+1) begin: fft_input_generate_second
        assign output_fifo_din[128*i+32*j+31 : 128*i+32*j] = 0;
      end
    end

  endgenerate

  wire next, next_out;
  processing_element pe_inst (
    .clk      (clk),
    .reset    (reset),
    .data_in  (pe_data_in),
    .filter_in(pe_data_in),
    .data_out (pe_data_out),
    .next     (next),
    .next_out (next_out)
    );

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
