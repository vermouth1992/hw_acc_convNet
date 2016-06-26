/* ../verilog/matrixTranspose/src/crossbarShiftDown.v
 * This file is automatically generated by Chi Zhang
 * k = 2, M = 16
 */
module crossbarShiftDown # (
  parameter DATA_WIDTH = 32
) (
  input [1-1:0] clk,
  input [1-1:0] clk_en,
  input [1-1:0] start,
  input [1-1:0] reset,
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
  input [DATA_WIDTH-1:0] in16,
  input [DATA_WIDTH-1:0] in17,
  input [DATA_WIDTH-1:0] in18,
  input [DATA_WIDTH-1:0] in19,
  input [DATA_WIDTH-1:0] in20,
  input [DATA_WIDTH-1:0] in21,
  input [DATA_WIDTH-1:0] in22,
  input [DATA_WIDTH-1:0] in23,
  input [DATA_WIDTH-1:0] in24,
  input [DATA_WIDTH-1:0] in25,
  input [DATA_WIDTH-1:0] in26,
  input [DATA_WIDTH-1:0] in27,
  input [DATA_WIDTH-1:0] in28,
  input [DATA_WIDTH-1:0] in29,
  input [DATA_WIDTH-1:0] in30,
  input [DATA_WIDTH-1:0] in31,
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
  output reg [DATA_WIDTH-1:0] out15,
  output reg [DATA_WIDTH-1:0] out16,
  output reg [DATA_WIDTH-1:0] out17,
  output reg [DATA_WIDTH-1:0] out18,
  output reg [DATA_WIDTH-1:0] out19,
  output reg [DATA_WIDTH-1:0] out20,
  output reg [DATA_WIDTH-1:0] out21,
  output reg [DATA_WIDTH-1:0] out22,
  output reg [DATA_WIDTH-1:0] out23,
  output reg [DATA_WIDTH-1:0] out24,
  output reg [DATA_WIDTH-1:0] out25,
  output reg [DATA_WIDTH-1:0] out26,
  output reg [DATA_WIDTH-1:0] out27,
  output reg [DATA_WIDTH-1:0] out28,
  output reg [DATA_WIDTH-1:0] out29,
  output reg [DATA_WIDTH-1:0] out30,
  output reg [DATA_WIDTH-1:0] out31
);

  reg [3-1:0] timestamp;

  always@(posedge clk) begin
    if (reset) begin
      start_next_stage <= 1'b0;
      timestamp <= 3'b000;
    end else if (clk_en & start) begin
      start_next_stage <= start;
      timestamp <= timestamp + 1;
    end
  end

  always@(posedge clk) begin
    if (clk_en & start) begin
      case (timestamp)
        3'b000: begin
          out0 <= in0;
          out1 <= in1;
          out2 <= in2;
          out3 <= in3;
          out4 <= in4;
          out5 <= in5;
          out6 <= in6;
          out7 <= in7;
          out8 <= in8;
          out9 <= in9;
          out10 <= in10;
          out11 <= in11;
          out12 <= in12;
          out13 <= in13;
          out14 <= in14;
          out15 <= in15;
          out16 <= in16;
          out17 <= in17;
          out18 <= in18;
          out19 <= in19;
          out20 <= in20;
          out21 <= in21;
          out22 <= in22;
          out23 <= in23;
          out24 <= in24;
          out25 <= in25;
          out26 <= in26;
          out27 <= in27;
          out28 <= in28;
          out29 <= in29;
          out30 <= in30;
          out31 <= in31;
        end
        3'b001: begin
          out0 <= in30;
          out1 <= in31;
          out2 <= in0;
          out3 <= in1;
          out4 <= in2;
          out5 <= in3;
          out6 <= in4;
          out7 <= in5;
          out8 <= in6;
          out9 <= in7;
          out10 <= in8;
          out11 <= in9;
          out12 <= in10;
          out13 <= in11;
          out14 <= in12;
          out15 <= in13;
          out16 <= in14;
          out17 <= in15;
          out18 <= in16;
          out19 <= in17;
          out20 <= in18;
          out21 <= in19;
          out22 <= in20;
          out23 <= in21;
          out24 <= in22;
          out25 <= in23;
          out26 <= in24;
          out27 <= in25;
          out28 <= in26;
          out29 <= in27;
          out30 <= in28;
          out31 <= in29;
        end
        3'b010: begin
          out0 <= in28;
          out1 <= in29;
          out2 <= in30;
          out3 <= in31;
          out4 <= in0;
          out5 <= in1;
          out6 <= in2;
          out7 <= in3;
          out8 <= in4;
          out9 <= in5;
          out10 <= in6;
          out11 <= in7;
          out12 <= in8;
          out13 <= in9;
          out14 <= in10;
          out15 <= in11;
          out16 <= in12;
          out17 <= in13;
          out18 <= in14;
          out19 <= in15;
          out20 <= in16;
          out21 <= in17;
          out22 <= in18;
          out23 <= in19;
          out24 <= in20;
          out25 <= in21;
          out26 <= in22;
          out27 <= in23;
          out28 <= in24;
          out29 <= in25;
          out30 <= in26;
          out31 <= in27;
        end
        3'b011: begin
          out0 <= in26;
          out1 <= in27;
          out2 <= in28;
          out3 <= in29;
          out4 <= in30;
          out5 <= in31;
          out6 <= in0;
          out7 <= in1;
          out8 <= in2;
          out9 <= in3;
          out10 <= in4;
          out11 <= in5;
          out12 <= in6;
          out13 <= in7;
          out14 <= in8;
          out15 <= in9;
          out16 <= in10;
          out17 <= in11;
          out18 <= in12;
          out19 <= in13;
          out20 <= in14;
          out21 <= in15;
          out22 <= in16;
          out23 <= in17;
          out24 <= in18;
          out25 <= in19;
          out26 <= in20;
          out27 <= in21;
          out28 <= in22;
          out29 <= in23;
          out30 <= in24;
          out31 <= in25;
        end
        3'b100: begin
          out0 <= in24;
          out1 <= in25;
          out2 <= in26;
          out3 <= in27;
          out4 <= in28;
          out5 <= in29;
          out6 <= in30;
          out7 <= in31;
          out8 <= in0;
          out9 <= in1;
          out10 <= in2;
          out11 <= in3;
          out12 <= in4;
          out13 <= in5;
          out14 <= in6;
          out15 <= in7;
          out16 <= in8;
          out17 <= in9;
          out18 <= in10;
          out19 <= in11;
          out20 <= in12;
          out21 <= in13;
          out22 <= in14;
          out23 <= in15;
          out24 <= in16;
          out25 <= in17;
          out26 <= in18;
          out27 <= in19;
          out28 <= in20;
          out29 <= in21;
          out30 <= in22;
          out31 <= in23;
        end
        3'b101: begin
          out0 <= in22;
          out1 <= in23;
          out2 <= in24;
          out3 <= in25;
          out4 <= in26;
          out5 <= in27;
          out6 <= in28;
          out7 <= in29;
          out8 <= in30;
          out9 <= in31;
          out10 <= in0;
          out11 <= in1;
          out12 <= in2;
          out13 <= in3;
          out14 <= in4;
          out15 <= in5;
          out16 <= in6;
          out17 <= in7;
          out18 <= in8;
          out19 <= in9;
          out20 <= in10;
          out21 <= in11;
          out22 <= in12;
          out23 <= in13;
          out24 <= in14;
          out25 <= in15;
          out26 <= in16;
          out27 <= in17;
          out28 <= in18;
          out29 <= in19;
          out30 <= in20;
          out31 <= in21;
        end
        3'b110: begin
          out0 <= in20;
          out1 <= in21;
          out2 <= in22;
          out3 <= in23;
          out4 <= in24;
          out5 <= in25;
          out6 <= in26;
          out7 <= in27;
          out8 <= in28;
          out9 <= in29;
          out10 <= in30;
          out11 <= in31;
          out12 <= in0;
          out13 <= in1;
          out14 <= in2;
          out15 <= in3;
          out16 <= in4;
          out17 <= in5;
          out18 <= in6;
          out19 <= in7;
          out20 <= in8;
          out21 <= in9;
          out22 <= in10;
          out23 <= in11;
          out24 <= in12;
          out25 <= in13;
          out26 <= in14;
          out27 <= in15;
          out28 <= in16;
          out29 <= in17;
          out30 <= in18;
          out31 <= in19;
        end
        3'b111: begin
          out0 <= in18;
          out1 <= in19;
          out2 <= in20;
          out3 <= in21;
          out4 <= in22;
          out5 <= in23;
          out6 <= in24;
          out7 <= in25;
          out8 <= in26;
          out9 <= in27;
          out10 <= in28;
          out11 <= in29;
          out12 <= in30;
          out13 <= in31;
          out14 <= in0;
          out15 <= in1;
          out16 <= in2;
          out17 <= in3;
          out18 <= in4;
          out19 <= in5;
          out20 <= in6;
          out21 <= in7;
          out22 <= in8;
          out23 <= in9;
          out24 <= in10;
          out25 <= in11;
          out26 <= in12;
          out27 <= in13;
          out28 <= in14;
          out29 <= in15;
          out30 <= in16;
          out31 <= in17;
        end
      endcase
    end
  end

endmodule
