/* ../verilog/generated/crossbar16x16.v
 * This file is automatically generated by Chi Zhang
 * k = 2, M = 8
 */
module crossbar16x16 # (
  parameter DATA_WIDTH = 32
) (
  input [1-1:0] clk,
  input [1-1:0] clk_en,
  input [1-1:0] reset,
  input [1-1:0] start,
  input [DATA_WIDTH-1:0] in0,
  input [DATA_WIDTH-1:0] in1,
  input [DATA_WIDTH-1:0] in2,
  input [DATA_WIDTH-1:0] in3,
  input [DATA_WIDTH-1:0] in4,
  input [DATA_WIDTH-1:0] in5,
  input [DATA_WIDTH-1:0] in6,
  input [DATA_WIDTH-1:0] in7,
  input [DATA_WIDTH-1:0] in8,
  input [DATA_WIDTH-1:0] in9,
  input [DATA_WIDTH-1:0] in10,
  input [DATA_WIDTH-1:0] in11,
  input [DATA_WIDTH-1:0] in12,
  input [DATA_WIDTH-1:0] in13,
  input [DATA_WIDTH-1:0] in14,
  input [DATA_WIDTH-1:0] in15,
  output reg [1-1:0] start_next_stage,
  output reg [DATA_WIDTH-1:0] out0,
  output reg [DATA_WIDTH-1:0] out1,
  output reg [DATA_WIDTH-1:0] out2,
  output reg [DATA_WIDTH-1:0] out3,
  output reg [DATA_WIDTH-1:0] out4,
  output reg [DATA_WIDTH-1:0] out5,
  output reg [DATA_WIDTH-1:0] out6,
  output reg [DATA_WIDTH-1:0] out7,
  output reg [DATA_WIDTH-1:0] out8,
  output reg [DATA_WIDTH-1:0] out9,
  output reg [DATA_WIDTH-1:0] out10,
  output reg [DATA_WIDTH-1:0] out11,
  output reg [DATA_WIDTH-1:0] out12,
  output reg [DATA_WIDTH-1:0] out13,
  output reg [DATA_WIDTH-1:0] out14,
  output reg [DATA_WIDTH-1:0] out15
);

  always@(posedge clk) begin
    if (reset) begin
      start_next_stage <= 1'b0;
    end else if (clk_en & start) begin
      start_next_stage <= start;
    end
  end

  always@(posedge clk) begin
    if (clk_en & start) begin
      out0 <= in0;
      out1 <= in8;
      out2 <= in2;
      out3 <= in10;
      out4 <= in4;
      out5 <= in12;
      out6 <= in6;
      out7 <= in14;
      out8 <= in1;
      out9 <= in9;
      out10 <= in3;
      out11 <= in11;
      out12 <= in5;
      out13 <= in13;
      out14 <= in7;
      out15 <= in15;
    end
  end

endmodule
