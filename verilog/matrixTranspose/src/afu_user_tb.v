`timescale 1ns/1ps

module afu_user_tb; /* this is automatically generated */
  
  parameter CLOCK_PERIOD = 10;
  parameter DATA_WIDTH = 16;
  
  reg           clk;
  reg           reset;
  reg   [511:0] input_fifo_din;
  reg           input_fifo_we;
  wire  [511:0] output_fifo_dout;
  wire          output_fifo_re;
  wire          output_fifo_empty;
  wire  [31:0]  ctx_length;

  integer input_file;
  integer output_file;

  always #(CLOCK_PERIOD/2) clk = ~clk;

  afu_user #(
    .DATA_WIDTH(DATA_WIDTH)
  ) inst_afu_user (
    .clk                      (clk),
    .reset                    (reset),
    .input_fifo_din           (input_fifo_din),
    .input_fifo_we            (input_fifo_we),
    .input_fifo_full          (),
    .input_fifo_almost_full   (),
    .input_fifo_count         (),
    .output_fifo_dout         (output_fifo_dout),
    .output_fifo_re           (output_fifo_re),
    .output_fifo_empty        (output_fifo_empty),
    .output_fifo_almost_empty (),
    .ctx_length               (ctx_length)
  );

  // reset
  initial begin
    input_file = $fopen("src/input_trace.txt", "r")
    output_file = $fopen("out/trace.txt", "w");
    clk = 0;
    reset = 1;
    input_fifo_we = 0;
    input_fifo_din = 0;
    $fscanf(input_file, "%h", ctx_length);
    @(posedge clk);
    reset = 0;
  end

  always@(posedge clk) begin
    if (!$feof(input_file)) begin
      $fscanf(input_file, "%h %h", input_fifo_din, input_fifo_we);
    end
  end

  reg [31:0] ctx_length_count;
  always@(posedge clk) begin
    if (reset) begin
      ctx_length_count <= 0;
    end else if (output_fifo_re) begin
      ctx_length_count <= ctx_length_count + 1'b1;
    end
  end

  always@(posedge clk) begin
    if (~reset && ctx_length != 0 && ctx_length == ctx_length_count) begin
      $stop;
    end
  end 

  // output fifo
  assign output_fifo_re = (reset) ? 1'b0 : ~output_fifo_empty;
  // delay 1 cycle
  reg output_fifo_re_reg;
  always@(posedge clk) begin
    output_fifo_re_reg <= output_fifo_re;
    if (output_fifo_re_reg) begin
      $fdisplay(output_file, "%h", output_fifo_dout);
    end
  end
endmodule


