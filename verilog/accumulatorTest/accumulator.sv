
/* Accumulator support for size 3-512, ...
 * The FSM is config -> run -> done -> config (Size, determined by D1)
 * All the accumulators can actually use a single FSM
 */

// module accumulator # (
//   parameter MAX_SIZE_BITS = 9    // 512
// ) (
//   input clk,    // Clock
//   input reset,  // Synchronous reset active high
//   // data
//   input complex_t in,
//   output complex_t out,
//   // control
//   input next,    // indicate the data on the next cycle is valid input
//   output next_out // indicate the data on the next cycle is valid output
//   // config
//   input config_valid,
//   input [MAX_SIZE_BITS-1:0] config_length,
//   output busy   // indicate whether run or wait for config
// );


// endmodule


module shiftRegFIFOComplex # (
  parameter depth = 1
) (
  input clk,
  input complex_t in,
  output complex_t out
  );
  
  integer i;
  complex_t mem [0:depth-1];

  always@(posedge clk) begin
    for (i=1; i<depth; i=i+1) begin
      mem[i] <= mem[i-1];
    end
    mem[0] <= in;
  end

  assign out = mem[depth-1];

endmodule


module delay_accumulator (
  input clk,
  input reset,
  // data
  input complex_t in,
  output complex_t out,
  // control
  input next, // when next is asserted, the next consecutive data is valid
  output next_out,
  );
  integer i;

  // four complexAdder pipeline
  complex_t in0_reg, out0;
  shiftRegFIFOComplex #(1) shiftRegFIFOComplex_stage0 (.clk(clk), .in (in), .out(in0_reg));

  complexAdd adder0 (
    .clk     (clk),
    .reset   (reset),
    .in0     (in),
    .in1     (in0_reg),
    .out     (out0),
    .next    (),
    .next_out()
    );

  // second adder
  complex_t in1_reg, out1;
  shiftRegFIFOComplex #(2) shiftRegFIFOComplex_stage1 (.clk(clk), .in (out0), .out(in1_reg));

  complexAdd adder1 (
    .clk     (clk),
    .reset   (reset),
    .in0     (out0),
    .in1     (in1_reg),
    .out     (out1),
    .next    (),
    .next_out()
    );

  // third adder
  complex_t in2_reg, out2;
  shiftRegFIFOComplex #(4) shiftRegFIFOComplex_stage2 (.clk(clk), .in (out1), .out(in2_reg));

  complexAdd adder2 (
    .clk     (clk),
    .reset   (reset),
    .in0     (out1),
    .in1     (in2_reg),
    .out     (out2),
    .next    (),
    .next_out()
    );

  // fourth adder
  complex_t in3_reg; out3;
  shiftRegFIFOComplex #(7) shiftRegFIFOComplex_stage2_half (.clk(clk), .in (out1), .out(in3_reg));

  complexAdd adder3 (
    .clk     (clk),
    .reset   (reset),
    .in0     (out2),
    .in1     (in3_reg),
    .out     (out3),
    .next    (),
    .next_out()
    );

  assign out = out3;

  shiftRegFIFO #(100, 1) shiftRegFIFO_next (.clk(clk), .X  (next), .Y  (next_out));

endmodule


module delay_accumulator_tb;
  reg clk;
  reg reset;
  reg next;
  wire next_out;

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
    test_in = `{32'h43480000, 32'h43480000};
    @(posedge clk);
    next = 0;
  end

  always@(posedge clk) begin
    test_in.r <= test_in.r + 8'h10;
    test_in.i <= test_in.i + 8'h10;
  end

endmodule
