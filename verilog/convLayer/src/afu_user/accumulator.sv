
`include "common.vh"

module accumulator (
  input clk,    // Clock
  input reset,  // Asynchronous reset active low
  // data
  input complex_t in,
  output complex_t out,
  // control, the valid data is between start and stop, must be larger than 11 elements
  input start,
  input stop,
  output output_valid // indicate the output is valid on the next cycle
);

  reg [3:0] counter;

  always@(posedge clk) begin
    if (reset) begin
      counter <= 0;
    end else if (start) begin
      counter <= 0;
    end else if (counter < 4'b1011) begin
      counter <= counter + 1;
    end
  end

  complex_t in_feedback, out_feedback;

  assign in_feedback.r = (counter == 4'b1011) ? out_feedback.r : 0;
  assign in_feedback.i = (counter == 4'b1011) ? out_feedback.i : 0;


  // instantiate first adder
  complexAdd feedback (
    .clk     (clk),
    .reset   (reset),
    .in0     (in),
    .in1     (in_feedback),
    .out     (out_feedback),
    .next    (),
    .next_out()
    );

  // instantiate delay accumulator
  delay_accumulator delay_accumulator_inst (
    .clk     (clk),
    .reset   (reset),
    .in      (out_feedback),
    .out     (out),
    .next    (stop),
    .next_out(output_valid)
    );

endmodule


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



module shiftRegFIFOComplex_special (
  input clk,
  input complex_t in,
  output complex_t out_delay_four,
  output complex_t out_delay_seven
  );
  
  localparam depth = 7;

  integer i;
  complex_t mem [0:depth-1];

  always@(posedge clk) begin
    for (i=1; i<depth; i=i+1) begin
      mem[i] <= mem[i-1];
    end
    mem[0] <= in;
  end

  assign out_delay_seven = mem[depth-1];
  assign out_delay_four = mem[4-1];

endmodule


/* accumulate 11 number start from next signal is asserted */
module delay_accumulator (
  input clk,
  input reset,
  // data
  input complex_t in,
  output complex_t out,
  // control
  input next, // when next is asserted, the next consecutive data is valid
  output next_out
  );
  integer i;

  // we have to set in0_reg to 0 on the 11th clk when next is asserted
  reg [3:0] counter;

  always@(posedge clk) begin
    if (reset) begin
      counter <= 0;
    end else if (next) begin
      counter <= 0;
    end else if (counter < 4'b1011) begin
      counter <= counter + 1;
    end
  end

  // four complexAdder pipeline
  complex_t in0_reg, out0;
  shiftRegFIFOComplex #(1) shiftRegFIFOComplex_stage0 (.clk(clk), .in (in), .out(in0_reg));

  complex_t in0_wire;

  assign in0_wire.r = (counter == 4'b1011) ? 32'h0 : in.r;
  assign in0_wire.i = (counter == 4'b1011) ? 32'h0 : in.i;

  complexAdd adder0 (
    .clk     (clk),
    .reset   (reset),
    .in0     (in0_wire),
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
  complex_t in3_reg, out3;

  shiftRegFIFOComplex_special shiftRegFIFOComplex_stage2 (
    .clk(clk),
    .in(out1),
    .out_delay_four (in2_reg),
    .out_delay_seven(in3_reg)
    );

  //shiftRegFIFOComplex #(4) shiftRegFIFOComplex_stage2 (.clk(clk), .in (out1), .out(in2_reg));

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
  // shiftRegFIFOComplex #(7) shiftRegFIFOComplex_stage2_half (.clk(clk), .in (out1), .out(in3_reg));

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

  shiftRegFIFO #(51, 1) shiftRegFIFO_next (.clk(clk), .X  (next), .Y  (next_out));

endmodule


