/* ../verilog/matrixTranspose/src/crossbarShiftDown64x64.v
 * This file is automatically generated by Chi Zhang
 * k = 4, M = 16
 */
module crossbarShiftDown64x64 # (
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
  input [DATA_WIDTH-1:0] in32,
  input [DATA_WIDTH-1:0] in33,
  input [DATA_WIDTH-1:0] in34,
  input [DATA_WIDTH-1:0] in35,
  input [DATA_WIDTH-1:0] in36,
  input [DATA_WIDTH-1:0] in37,
  input [DATA_WIDTH-1:0] in38,
  input [DATA_WIDTH-1:0] in39,
  input [DATA_WIDTH-1:0] in40,
  input [DATA_WIDTH-1:0] in41,
  input [DATA_WIDTH-1:0] in42,
  input [DATA_WIDTH-1:0] in43,
  input [DATA_WIDTH-1:0] in44,
  input [DATA_WIDTH-1:0] in45,
  input [DATA_WIDTH-1:0] in46,
  input [DATA_WIDTH-1:0] in47,
  input [DATA_WIDTH-1:0] in48,
  input [DATA_WIDTH-1:0] in49,
  input [DATA_WIDTH-1:0] in50,
  input [DATA_WIDTH-1:0] in51,
  input [DATA_WIDTH-1:0] in52,
  input [DATA_WIDTH-1:0] in53,
  input [DATA_WIDTH-1:0] in54,
  input [DATA_WIDTH-1:0] in55,
  input [DATA_WIDTH-1:0] in56,
  input [DATA_WIDTH-1:0] in57,
  input [DATA_WIDTH-1:0] in58,
  input [DATA_WIDTH-1:0] in59,
  input [DATA_WIDTH-1:0] in60,
  input [DATA_WIDTH-1:0] in61,
  input [DATA_WIDTH-1:0] in62,
  input [DATA_WIDTH-1:0] in63,
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
  output reg [DATA_WIDTH-1:0] out31,
  output reg [DATA_WIDTH-1:0] out32,
  output reg [DATA_WIDTH-1:0] out33,
  output reg [DATA_WIDTH-1:0] out34,
  output reg [DATA_WIDTH-1:0] out35,
  output reg [DATA_WIDTH-1:0] out36,
  output reg [DATA_WIDTH-1:0] out37,
  output reg [DATA_WIDTH-1:0] out38,
  output reg [DATA_WIDTH-1:0] out39,
  output reg [DATA_WIDTH-1:0] out40,
  output reg [DATA_WIDTH-1:0] out41,
  output reg [DATA_WIDTH-1:0] out42,
  output reg [DATA_WIDTH-1:0] out43,
  output reg [DATA_WIDTH-1:0] out44,
  output reg [DATA_WIDTH-1:0] out45,
  output reg [DATA_WIDTH-1:0] out46,
  output reg [DATA_WIDTH-1:0] out47,
  output reg [DATA_WIDTH-1:0] out48,
  output reg [DATA_WIDTH-1:0] out49,
  output reg [DATA_WIDTH-1:0] out50,
  output reg [DATA_WIDTH-1:0] out51,
  output reg [DATA_WIDTH-1:0] out52,
  output reg [DATA_WIDTH-1:0] out53,
  output reg [DATA_WIDTH-1:0] out54,
  output reg [DATA_WIDTH-1:0] out55,
  output reg [DATA_WIDTH-1:0] out56,
  output reg [DATA_WIDTH-1:0] out57,
  output reg [DATA_WIDTH-1:0] out58,
  output reg [DATA_WIDTH-1:0] out59,
  output reg [DATA_WIDTH-1:0] out60,
  output reg [DATA_WIDTH-1:0] out61,
  output reg [DATA_WIDTH-1:0] out62,
  output reg [DATA_WIDTH-1:0] out63
);

  reg [2-1:0] timestamp;

  always@(posedge clk) begin
    if (reset) begin
      start_next_stage <= 1'b0;
      timestamp <= 2'b00;
    end else if (clk_en & start) begin
      start_next_stage <= start;
      timestamp <= timestamp + 1;
    end
  end

  always@(posedge clk) begin
    if (clk_en & start) begin
      case (timestamp)
        2'b00: begin
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
          out32 <= in32;
          out33 <= in33;
          out34 <= in34;
          out35 <= in35;
          out36 <= in36;
          out37 <= in37;
          out38 <= in38;
          out39 <= in39;
          out40 <= in40;
          out41 <= in41;
          out42 <= in42;
          out43 <= in43;
          out44 <= in44;
          out45 <= in45;
          out46 <= in46;
          out47 <= in47;
          out48 <= in48;
          out49 <= in49;
          out50 <= in50;
          out51 <= in51;
          out52 <= in52;
          out53 <= in53;
          out54 <= in54;
          out55 <= in55;
          out56 <= in56;
          out57 <= in57;
          out58 <= in58;
          out59 <= in59;
          out60 <= in60;
          out61 <= in61;
          out62 <= in62;
          out63 <= in63;
        end
        2'b01: begin
          out0 <= in60;
          out1 <= in61;
          out2 <= in62;
          out3 <= in63;
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
          out32 <= in28;
          out33 <= in29;
          out34 <= in30;
          out35 <= in31;
          out36 <= in32;
          out37 <= in33;
          out38 <= in34;
          out39 <= in35;
          out40 <= in36;
          out41 <= in37;
          out42 <= in38;
          out43 <= in39;
          out44 <= in40;
          out45 <= in41;
          out46 <= in42;
          out47 <= in43;
          out48 <= in44;
          out49 <= in45;
          out50 <= in46;
          out51 <= in47;
          out52 <= in48;
          out53 <= in49;
          out54 <= in50;
          out55 <= in51;
          out56 <= in52;
          out57 <= in53;
          out58 <= in54;
          out59 <= in55;
          out60 <= in56;
          out61 <= in57;
          out62 <= in58;
          out63 <= in59;
        end
        2'b10: begin
          out0 <= in56;
          out1 <= in57;
          out2 <= in58;
          out3 <= in59;
          out4 <= in60;
          out5 <= in61;
          out6 <= in62;
          out7 <= in63;
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
          out32 <= in24;
          out33 <= in25;
          out34 <= in26;
          out35 <= in27;
          out36 <= in28;
          out37 <= in29;
          out38 <= in30;
          out39 <= in31;
          out40 <= in32;
          out41 <= in33;
          out42 <= in34;
          out43 <= in35;
          out44 <= in36;
          out45 <= in37;
          out46 <= in38;
          out47 <= in39;
          out48 <= in40;
          out49 <= in41;
          out50 <= in42;
          out51 <= in43;
          out52 <= in44;
          out53 <= in45;
          out54 <= in46;
          out55 <= in47;
          out56 <= in48;
          out57 <= in49;
          out58 <= in50;
          out59 <= in51;
          out60 <= in52;
          out61 <= in53;
          out62 <= in54;
          out63 <= in55;
        end
        2'b11: begin
          out0 <= in52;
          out1 <= in53;
          out2 <= in54;
          out3 <= in55;
          out4 <= in56;
          out5 <= in57;
          out6 <= in58;
          out7 <= in59;
          out8 <= in60;
          out9 <= in61;
          out10 <= in62;
          out11 <= in63;
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
          out32 <= in20;
          out33 <= in21;
          out34 <= in22;
          out35 <= in23;
          out36 <= in24;
          out37 <= in25;
          out38 <= in26;
          out39 <= in27;
          out40 <= in28;
          out41 <= in29;
          out42 <= in30;
          out43 <= in31;
          out44 <= in32;
          out45 <= in33;
          out46 <= in34;
          out47 <= in35;
          out48 <= in36;
          out49 <= in37;
          out50 <= in38;
          out51 <= in39;
          out52 <= in40;
          out53 <= in41;
          out54 <= in42;
          out55 <= in43;
          out56 <= in44;
          out57 <= in45;
          out58 <= in46;
          out59 <= in47;
          out60 <= in48;
          out61 <= in49;
          out62 <= in50;
          out63 <= in51;
        end
      endcase
    end
  end

endmodule
