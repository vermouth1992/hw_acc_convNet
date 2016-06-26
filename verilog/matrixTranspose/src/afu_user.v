module afu_user # (
  parameter DATA_WIDTH = 16,
  parameter BUFF_DEPTH_BITS = 3
) (
  input clk,    // Clock
  input reset,  // Asynchronous reset active low
  // input fifo
  input [511:0] input_fifo_din,
  input input_fifo_we,
  output input_fifo_full,
  output input_fifo_almost_full,
  output [BUFF_DEPTH_BITS-1:0] input_fifo_count,
  // output fifo
  output [511:0] output_fifo_dout,
  input output_fifo_re,
  output output_fifo_empty,
  output output_fifo_almost_empty,
  // other information
  input [31:0] ctx_length
);
  // input fifo
  wire [511:0] input_fifo_dout;
  wire input_fifo_re;
  wire input_fifo_empty;
  // output fifo
  wire [511:0] output_fifo_din;
  // uut
  reg start;
  wire clk_en;
  wire start_next_stage;

  syn_read_fifo #(.FIFO_WIDTH(512),
                  .FIFO_DEPTH_BITS(BUFF_DEPTH_BITS),       // transfer size 1 -> 32 entries
                  .FIFO_ALMOSTFULL_THRESHOLD(2**(BUFF_DEPTH_BITS)-4),
                  .FIFO_ALMOSTEMPTY_THRESHOLD(2)
                 ) input_fifo (
                .clk                (clk),
                .reset              (reset),
                .din                (input_fifo_din),
                .we                 (input_fifo_we),
                .re                 (input_fifo_re),
                .dout               (input_fifo_dout),
                .empty              (input_fifo_empty),
                .almostempty        (),
                .full               (input_fifo_full),
                .count              (input_fifo_count),
                .almostfull         (input_fifo_almost_full)
            );

  wire [DATA_WIDTH-1:0] in0;
  wire [DATA_WIDTH-1:0] in1;
  wire [DATA_WIDTH-1:0] in2;
  wire [DATA_WIDTH-1:0] in3;
  wire [DATA_WIDTH-1:0] in4;
  wire [DATA_WIDTH-1:0] in5;
  wire [DATA_WIDTH-1:0] in6;
  wire [DATA_WIDTH-1:0] in7;
  wire [DATA_WIDTH-1:0] in8;
  wire [DATA_WIDTH-1:0] in9;
  wire [DATA_WIDTH-1:0] in10;
  wire [DATA_WIDTH-1:0] in11;
  wire [DATA_WIDTH-1:0] in12;
  wire [DATA_WIDTH-1:0] in13;
  wire [DATA_WIDTH-1:0] in14;
  wire [DATA_WIDTH-1:0] in15;
  wire [DATA_WIDTH-1:0] in16;
  wire [DATA_WIDTH-1:0] in17;
  wire [DATA_WIDTH-1:0] in18;
  wire [DATA_WIDTH-1:0] in19;
  wire [DATA_WIDTH-1:0] in20;
  wire [DATA_WIDTH-1:0] in21;
  wire [DATA_WIDTH-1:0] in22;
  wire [DATA_WIDTH-1:0] in23;
  wire [DATA_WIDTH-1:0] in24;
  wire [DATA_WIDTH-1:0] in25;
  wire [DATA_WIDTH-1:0] in26;
  wire [DATA_WIDTH-1:0] in27;
  wire [DATA_WIDTH-1:0] in28;
  wire [DATA_WIDTH-1:0] in29;
  wire [DATA_WIDTH-1:0] in30;
  wire [DATA_WIDTH-1:0] in31;
  wire [DATA_WIDTH-1:0] in32;
  wire [DATA_WIDTH-1:0] in33;
  wire [DATA_WIDTH-1:0] in34;
  wire [DATA_WIDTH-1:0] in35;
  wire [DATA_WIDTH-1:0] in36;
  wire [DATA_WIDTH-1:0] in37;
  wire [DATA_WIDTH-1:0] in38;
  wire [DATA_WIDTH-1:0] in39;
  wire [DATA_WIDTH-1:0] in40;
  wire [DATA_WIDTH-1:0] in41;
  wire [DATA_WIDTH-1:0] in42;
  wire [DATA_WIDTH-1:0] in43;
  wire [DATA_WIDTH-1:0] in44;
  wire [DATA_WIDTH-1:0] in45;
  wire [DATA_WIDTH-1:0] in46;
  wire [DATA_WIDTH-1:0] in47;
  wire [DATA_WIDTH-1:0] in48;
  wire [DATA_WIDTH-1:0] in49;
  wire [DATA_WIDTH-1:0] in50;
  wire [DATA_WIDTH-1:0] in51;
  wire [DATA_WIDTH-1:0] in52;
  wire [DATA_WIDTH-1:0] in53;
  wire [DATA_WIDTH-1:0] in54;
  wire [DATA_WIDTH-1:0] in55;
  wire [DATA_WIDTH-1:0] in56;
  wire [DATA_WIDTH-1:0] in57;
  wire [DATA_WIDTH-1:0] in58;
  wire [DATA_WIDTH-1:0] in59;
  wire [DATA_WIDTH-1:0] in60;
  wire [DATA_WIDTH-1:0] in61;
  wire [DATA_WIDTH-1:0] in62;
  wire [DATA_WIDTH-1:0] in63;

  wire [DATA_WIDTH-1:0] out0;
  wire [DATA_WIDTH-1:0] out1;
  wire [DATA_WIDTH-1:0] out2;
  wire [DATA_WIDTH-1:0] out3;
  wire [DATA_WIDTH-1:0] out4;
  wire [DATA_WIDTH-1:0] out5;
  wire [DATA_WIDTH-1:0] out6;
  wire [DATA_WIDTH-1:0] out7;
  wire [DATA_WIDTH-1:0] out8;
  wire [DATA_WIDTH-1:0] out9;
  wire [DATA_WIDTH-1:0] out10;
  wire [DATA_WIDTH-1:0] out11;
  wire [DATA_WIDTH-1:0] out12;
  wire [DATA_WIDTH-1:0] out13;
  wire [DATA_WIDTH-1:0] out14;
  wire [DATA_WIDTH-1:0] out15;
  wire [DATA_WIDTH-1:0] out16;
  wire [DATA_WIDTH-1:0] out17;
  wire [DATA_WIDTH-1:0] out18;
  wire [DATA_WIDTH-1:0] out19;
  wire [DATA_WIDTH-1:0] out20;
  wire [DATA_WIDTH-1:0] out21;
  wire [DATA_WIDTH-1:0] out22;
  wire [DATA_WIDTH-1:0] out23;
  wire [DATA_WIDTH-1:0] out24;
  wire [DATA_WIDTH-1:0] out25;
  wire [DATA_WIDTH-1:0] out26;
  wire [DATA_WIDTH-1:0] out27;
  wire [DATA_WIDTH-1:0] out28;
  wire [DATA_WIDTH-1:0] out29;
  wire [DATA_WIDTH-1:0] out30;
  wire [DATA_WIDTH-1:0] out31;
  wire [DATA_WIDTH-1:0] out32;
  wire [DATA_WIDTH-1:0] out33;
  wire [DATA_WIDTH-1:0] out34;
  wire [DATA_WIDTH-1:0] out35;
  wire [DATA_WIDTH-1:0] out36;
  wire [DATA_WIDTH-1:0] out37;
  wire [DATA_WIDTH-1:0] out38;
  wire [DATA_WIDTH-1:0] out39;
  wire [DATA_WIDTH-1:0] out40;
  wire [DATA_WIDTH-1:0] out41;
  wire [DATA_WIDTH-1:0] out42;
  wire [DATA_WIDTH-1:0] out43;
  wire [DATA_WIDTH-1:0] out44;
  wire [DATA_WIDTH-1:0] out45;
  wire [DATA_WIDTH-1:0] out46;
  wire [DATA_WIDTH-1:0] out47;
  wire [DATA_WIDTH-1:0] out48;
  wire [DATA_WIDTH-1:0] out49;
  wire [DATA_WIDTH-1:0] out50;
  wire [DATA_WIDTH-1:0] out51;
  wire [DATA_WIDTH-1:0] out52;
  wire [DATA_WIDTH-1:0] out53;
  wire [DATA_WIDTH-1:0] out54;
  wire [DATA_WIDTH-1:0] out55;
  wire [DATA_WIDTH-1:0] out56;
  wire [DATA_WIDTH-1:0] out57;
  wire [DATA_WIDTH-1:0] out58;
  wire [DATA_WIDTH-1:0] out59;
  wire [DATA_WIDTH-1:0] out60;
  wire [DATA_WIDTH-1:0] out61;
  wire [DATA_WIDTH-1:0] out62;
  wire [DATA_WIDTH-1:0] out63;

  assign in0 = input_fifo_dout[7:0];
  assign in1 = input_fifo_dout[15:8];
  assign in2 = input_fifo_dout[23:16];
  assign in3 = input_fifo_dout[31:24];
  assign in4 = input_fifo_dout[39:32];
  assign in5 = input_fifo_dout[47:40];
  assign in6 = input_fifo_dout[55:48];
  assign in7 = input_fifo_dout[63:56];
  assign in8 = input_fifo_dout[71:64];
  assign in9 = input_fifo_dout[79:72];
  assign in10 = input_fifo_dout[87:80];
  assign in11 = input_fifo_dout[95:88];
  assign in12 = input_fifo_dout[103:96];
  assign in13 = input_fifo_dout[111:104];
  assign in14 = input_fifo_dout[119:112];
  assign in15 = input_fifo_dout[127:120];
  assign in16 = input_fifo_dout[135:128];
  assign in17 = input_fifo_dout[143:136];
  assign in18 = input_fifo_dout[151:144];
  assign in19 = input_fifo_dout[159:152];
  assign in20 = input_fifo_dout[167:160];
  assign in21 = input_fifo_dout[175:168];
  assign in22 = input_fifo_dout[183:176];
  assign in23 = input_fifo_dout[191:184];
  assign in24 = input_fifo_dout[199:192];
  assign in25 = input_fifo_dout[207:200];
  assign in26 = input_fifo_dout[215:208];
  assign in27 = input_fifo_dout[223:216];
  assign in28 = input_fifo_dout[231:224];
  assign in29 = input_fifo_dout[239:232];
  assign in30 = input_fifo_dout[247:240];
  assign in31 = input_fifo_dout[255:248];
  assign in32 = input_fifo_dout[263:256];
  assign in33 = input_fifo_dout[271:264];
  assign in34 = input_fifo_dout[279:272];
  assign in35 = input_fifo_dout[287:280];
  assign in36 = input_fifo_dout[295:288];
  assign in37 = input_fifo_dout[303:296];
  assign in38 = input_fifo_dout[311:304];
  assign in39 = input_fifo_dout[319:312];
  assign in40 = input_fifo_dout[327:320];
  assign in41 = input_fifo_dout[335:328];
  assign in42 = input_fifo_dout[343:336];
  assign in43 = input_fifo_dout[351:344];
  assign in44 = input_fifo_dout[359:352];
  assign in45 = input_fifo_dout[367:360];
  assign in46 = input_fifo_dout[375:368];
  assign in47 = input_fifo_dout[383:376];
  assign in48 = input_fifo_dout[391:384];
  assign in49 = input_fifo_dout[399:392];
  assign in50 = input_fifo_dout[407:400];
  assign in51 = input_fifo_dout[415:408];
  assign in52 = input_fifo_dout[423:416];
  assign in53 = input_fifo_dout[431:424];
  assign in54 = input_fifo_dout[439:432];
  assign in55 = input_fifo_dout[447:440];
  assign in56 = input_fifo_dout[455:448];
  assign in57 = input_fifo_dout[463:456];
  assign in58 = input_fifo_dout[471:464];
  assign in59 = input_fifo_dout[479:472];
  assign in60 = input_fifo_dout[487:480];
  assign in61 = input_fifo_dout[495:488];
  assign in62 = input_fifo_dout[503:496];
  assign in63 = input_fifo_dout[511:504];

  assign output_fifo_din = {out63, out62, out61, out60, out59, out58, out57, out56, out55, out54, out53, out52, out51, out50, out49, out48, 
                            out47, out46, out45, out44, out43, out42, out41, out40, out39, out38, out37, out36, out35, out34, out33, out32, 
                            out31, out30, out29, out28, out27, out26, out25, out24, out23, out22, out21, out20, out19, out18, out17, out16, 
                            out15, out14, out13, out12, out11, out10, out9, out8, out7, out6, out5, out4, out3, out2, out1, out0
                            };

  assign input_fifo_re = (reset == 1'b1) ? 1'b0 : ~input_fifo_empty;

  always @(posedge clk) begin
    if (reset) begin
      start <= 1'b0;
    end else if (input_fifo_re == 1'b1) begin
      start <= 1'b1;
    end else begin
      start <= 1'b0;
    end
  end

  reg [31:0] ctx_input_count;

  always@(posedge clk) begin
    if (reset) begin
      ctx_input_count <= 0;
    end else if (input_fifo_re) begin
      ctx_input_count <= ctx_input_count + 1'b1;
    end
  end

  assign clk_en = (ctx_input_count == ctx_length) ? 1'b1 : start;

  streamMatrixTransposeTop64x64 # (
    .DATA_WIDTH(DATA_WIDTH)
    ) uut (
    .clk(clk),
    .clk_en(clk_en),
    .start(start),
    .reset(reset),
    .in0(in0),
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .in4(in4),
    .in5(in5),
    .in6(in6),
    .in7(in7),
    .in8(in8),
    .in9(in9),
    .in10(in10),
    .in11(in11),
    .in12(in12),
    .in13(in13),
    .in14(in14),
    .in15(in15),
    .in16(in16),
    .in17(in17),
    .in18(in18),
    .in19(in19),
    .in20(in20),
    .in21(in21),
    .in22(in22),
    .in23(in23),
    .in24(in24),
    .in25(in25),
    .in26(in26),
    .in27(in27),
    .in28(in28),
    .in29(in29),
    .in30(in30),
    .in31(in31),
    .in32(in32),
    .in33(in33),
    .in34(in34),
    .in35(in35),
    .in36(in36),
    .in37(in37),
    .in38(in38),
    .in39(in39),
    .in40(in40),
    .in41(in41),
    .in42(in42),
    .in43(in43),
    .in44(in44),
    .in45(in45),
    .in46(in46),
    .in47(in47),
    .in48(in48),
    .in49(in49),
    .in50(in50),
    .in51(in51),
    .in52(in52),
    .in53(in53),
    .in54(in54),
    .in55(in55),
    .in56(in56),
    .in57(in57),
    .in58(in58),
    .in59(in59),
    .in60(in60),
    .in61(in61),
    .in62(in62),
    .in63(in63),
    .start_next_stage(start_next_stage),
    .out0(out0),
    .out1(out1),
    .out2(out2),
    .out3(out3),
    .out4(out4),
    .out5(out5),
    .out6(out6),
    .out7(out7),
    .out8(out8),
    .out9(out9),
    .out10(out10),
    .out11(out11),
    .out12(out12),
    .out13(out13),
    .out14(out14),
    .out15(out15),
    .out16(out16),
    .out17(out17),
    .out18(out18),
    .out19(out19),
    .out20(out20),
    .out21(out21),
    .out22(out22),
    .out23(out23),
    .out24(out24),
    .out25(out25),
    .out26(out26),
    .out27(out27),
    .out28(out28),
    .out29(out29),
    .out30(out30),
    .out31(out31),
    .out32(out32),
    .out33(out33),
    .out34(out34),
    .out35(out35),
    .out36(out36),
    .out37(out37),
    .out38(out38),
    .out39(out39),
    .out40(out40),
    .out41(out41),
    .out42(out42),
    .out43(out43),
    .out44(out44),
    .out45(out45),
    .out46(out46),
    .out47(out47),
    .out48(out48),
    .out49(out49),
    .out50(out50),
    .out51(out51),
    .out52(out52),
    .out53(out53),
    .out54(out54),
    .out55(out55),
    .out56(out56),
    .out57(out57),
    .out58(out58),
    .out59(out59),
    .out60(out60),
    .out61(out61),
    .out62(out62),
    .out63(out63)
  );

  wire output_fifo_we;

  assign output_fifo_we = start_next_stage & clk_en;

  syn_read_fifo #(.FIFO_WIDTH(512),
                  .FIFO_DEPTH_BITS(BUFF_DEPTH_BITS),       // transfer size 1 -> 32 entries
                  .FIFO_ALMOSTFULL_THRESHOLD(2**(BUFF_DEPTH_BITS)-4),
                  .FIFO_ALMOSTEMPTY_THRESHOLD(2)
                 ) output_fifo (
                .clk                (clk),
                .reset              (reset),
                .din                (output_fifo_din),
                .we                 (output_fifo_we),
                .re                 (output_fifo_re),
                .dout               (output_fifo_dout),
                .empty              (output_fifo_empty),
                .almostempty        (output_fifo_almost_empty),
                .full               (),
                .count              (),
                .almostfull         ()
            );

endmodule
