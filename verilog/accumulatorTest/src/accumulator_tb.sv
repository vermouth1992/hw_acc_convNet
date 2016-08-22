
`include "common.vh"

module delay_accumulator_tb;
  reg clk;
  reg reset;
  reg next;
  wire next_out;

  reg [3:0] counter;

  initial begin
    clk = 0;
  end

  always #10 clk <= ~clk;

  complex_t test_in, test_out;

  delay_accumulator uut (
    .clk     (clk),
    .reset   (reset),
    .in      (test_in),
    .out     (test_out),
    .next    (next),
    .next_out(next_out)
    );

  // test vector
  initial begin
    reset = 1;
    #15;
    reset = 0;
    next = 1;
    @(posedge clk);
    next = 0;
  end

  always@(posedge clk) begin
    if (reset) begin
      test_in <= '{32'h43480000, 32'h43480000};
      counter <= 0;
    end else if (counter != 11) begin
      test_in.r <= test_in.r + 32'h00010000;
      test_in.i <= test_in.i + 32'h00010000;
      counter <= counter + 1;
    end
  end

endmodule


module accumulator_tb;
  reg clk;
  reg reset;

  initial begin
    clk = 0;
  end

  always #10 clk <= ~clk;

  complex_t in, out;
  reg start, stop;
  wire output_valid;

  // uut specific
  accumulator uut (
    .clk         (clk),
    .reset       (reset),
    .in          (in),
    .out         (out),
    .start       (start),
    .stop        (stop),
    .output_valid(output_valid)
    );

  reg [31:0] counter;

  initial begin
    start = 0;
    stop = 0;
    reset = 1;
    #15;
    reset = 0;
    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;
    repeat(64) @(posedge clk);
    stop = 1;
    @(posedge clk);
    stop = 0;
    wait(output_valid == 1);
    @(posedge clk);
    $display("output is %h + j * %h", out.r, out.i);
  end

  always@(posedge clk) begin
    if (reset) begin
      in <= '{32'h43480000, 32'h43480000};
      counter <= 0;
    end else if (counter != 11) begin
      in.r <= in.r + 32'h00010000;
      in.i <= in.i + 32'h00010000;
      counter <= counter + 1;
    end
  end

endmodule
