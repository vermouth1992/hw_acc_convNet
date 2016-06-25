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

  integer output_file;

  always #(CLOCK_PERIOD/2) clk = ~clk;

  afu_user #(
    .DATA_WIDTH(DATA_WIDTH)
  ) afu_user_uut (
    .clk               (clk),
    .reset             (reset),
    .input_fifo_din    (input_fifo_din),
    .input_fifo_we     (input_fifo_we),
    .input_fifo_full   (),
    .output_fifo_dout  (output_fifo_dout),
    .output_fifo_re    (output_fifo_re),
    .output_fifo_empty (output_fifo_empty)
  );

  // reset
  initial begin
    output_file = $fopen("out/trace.txt", "w");
    clk = 0;
    reset = 1;
    input_fifo_we = 0;
    input_fifo_din = 0;
    @(posedge clk);
    reset = 0;
  end

  assign output_fifo_re = (reset) ? 1'b0 : ~output_fifo_empty;

  initial begin
    // input logic
    repeat(20)@(posedge clk) begin
      input_fifo_din <= $random;
      input_fifo_we <= 1'b1;
    end
    input_fifo_din = 0;
    wait(output_fifo_dout == 0);
    @(posedge clk);
    $stop;
    $fclose(output_file);
  end

  always@(posedge clk) begin
    $fdisplay(output_file, "time = %0d, input = %h, input_fifo_we = %h", 
      $time, input_fifo_din, input_fifo_we);
  end

  // delay 1 cycle
  reg output_fifo_re_reg;
  always@(posedge clk) begin
    output_fifo_re_reg <= output_fifo_re;
    if (output_fifo_re_reg) begin
      $fdisplay(output_file, "time = %0d, output = %h, output_fifo_re = %h", 
        $time, output_fifo_dout, output_fifo_re);
    end
  end
endmodule


