/*
 * Dynamic range fixed point multiply-accumulate unit
 */

/* Notes right_shift_amount = Qc - (Qa + Qb), where Qa, Qb is the number of fraction bits of input and 
 * Qc is the number of fraction bits of output
 */
module mac_fxp # (
  parameter MULTIPLIER_CYCLE = 6
  ) (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input rst,  // active high reset is preferred on FPGA
  // data
  input [15:0] operand_a,
  input [15:0] operand_b,
  output [15:0] out,
  // control
  input start,
  input end,
  output output_valid,
  // config
  input [4:0] right_shift_amount    // this must be registered from outside, use to implement dynamic range
);

  wire [31:0] multiply_output;
  wire [39:0] signed_ext_multiply_output;  // we extend 8 bits to prevent overflow during accumulation

  reg signed [39:0] accumulator_reg;

  multfxp # (.WIDTH_A(16),
             .WIDTH_B(16),
             .CYCLES(MULTIPLIER_CYCLE)
    ) multfxp_inst (
      .clk   (clk),
      .enable(clk_en),
      .rst   (rst),
      .a     (operand_a),
      .b     (operand_b),
      .out   (multiply_output)
    );

  // signed extend multiply output
  assign signed_ext_multiply_output = {8{multiply_output[31]}, multiply_output};

  wire [39:0] internal_output;

  // The adder should be combinational
  addfxp # (.width(40)
    ) addfxp_inst (
      .clk(clk),
      .a  (signed_ext_multiply_output),
      .b  (accumulator_reg),
      .q  (internal_output)
    );

  wire [39:0] internal_output_truncate;
  // truncate the output
  assign internal_output_truncate = $signed(internal_output_truncate) >>> right_shift_amount;
  assign out = {internal_output_truncate[39], internal_output_truncate[14:0]};

  shiftRegFIFO #(MULTIPLIER_CYCLE, 1) output_valid_fifo (.X  (end), .Y  (output_valid), .clk(clk));

  always_ff @(posedge clk) begin
    if (start) begin
      accumulator_reg <= 0;
    else begin
      accumulator_reg <= internal_output;
    end
  end

endmodule


module multfxp # (
  parameter WIDTH_A = 16,
  parameter WIDTH_B = 16,
  parameter CYCLES = 3  // The synthesis tool will automatically pipeline the design
  ) (
  input clk,
  input enable, 
  input rst, 
  input signed [WIDTH_A-1:0] a, 
  input signed [WIDTH_B-1:0] b, 
  output [WIDTH_A+WIDTH_B-1:0] out
  );
  reg signed [WIDTH_A+WIDTH_B-1:0]    q[CYCLES-1:0];
  integer              i;

  assign               out = q[CYCLES-1];

  always @(posedge clk) begin
    q[0] <= a * b;
    for (i = 1; i < CYCLES; i=i+1) begin
        q[i] <= q[i-1];
    end
  end
endmodule 


module addfxp(a, b, q, clk);

   parameter width = 16;
   
   input signed [width-1:0]  a, b;
   input                     clk;   
   output signed [width-1:0] q;

   assign                    q = a + b;
   
endmodule

module shiftRegFIFO(X, Y, clk);
   parameter depth=1, width=1;

   output [width-1:0] Y;
   input  [width-1:0] X;
   input              clk;

   reg [width-1:0]    mem [depth-1:0];
   integer            index;

   assign Y = mem[depth-1];

   always @ (posedge clk) begin
      for(index=1;index<depth;index=index+1) begin
         mem[index] <= mem[index-1];
      end
      mem[0]<=X;
   end
endmodule

