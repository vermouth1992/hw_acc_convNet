
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

`include "common.vh"

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


// module accumulator (
//   input clk,    // Clock
//   input reset,  // Asynchronous reset active low
//   // data
//   input complex_t in,
//   output complex_t out,
//   // control
//   input start,
//   output output_valid, // indicate the output is valid
//   input config_valid,
//   input [9:0] config_length,
//   output busy
// );

//   reg [9:0] length;

//   enum {IDLE, FILL, RUN, DRAIN} state;

//   reg delay_accumulator_next;

//   // FSM
//   always@(posedge clk or posedge reset) begin
//     state <= IDLE;
//     busy <= 0;
//     output_valid <= 0;
//   end else begin
//     case (state)
//       IDLE: begin
//         if (config_valid) begin
//           length <= config_length;
//         end
//         if (start) begin
//           state <= FILL;
//         end
//       end

//       FILL: begin
        

//       default : /* default */;
//     endcase

//   end

//   // data path
//   complex_t in1;
//   complex_t out_temp;

//   complexAdd complexAdd_inst (
//     .clk     (clk),
//     .reset   (reset),
//     .in0     (in),
//     .in1     (in1),
//     .out     (out_temp),
//     .next    (),
//     .next_out()
//     );

//   assign in1 = (state == RUN) ? out_temp : `{32'h0, 32'h0};

//   delay_accumulator delay_accumulator_inst (
//     .clk     (clk),
//     .reset   (reset),
//     .in      (out_temp),
//     .out     (out),
//     .next    (delay_accumulator_next),
//     .next_out(next_out),
//     );

//   assign output_valid = next_out;

// endmodule


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
    if (next) begin
      counter <= 0;
    end else if (counter < 4'b1011) begin
      counter <= counter + 1;
    end
  end

  // four complexAdder pipeline
  complex_t in0_reg, out0;
  shiftRegFIFOComplex #(1) shiftRegFIFOComplex_stage0 (.clk(clk), .in (in), .out(in0_reg));

  complex_t in0_wire;

  assign in0_wire = (counter == 4'b1011) ? '{0, 0} : in;

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
