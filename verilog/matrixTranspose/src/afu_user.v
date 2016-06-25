module afu_user # (
  parameter DATA_WIDTH = 16
) (
  input clk,    // Clock
  input reset,  // Asynchronous reset active low
  // input fifo
  input [511:0] input_fifo_din,
  input input_fifo_we,
  output input_fifo_full,
  output input_fifo_almost_full,
  output input_fifo_count,
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
                  .FIFO_DEPTH_BITS(3),       // transfer size 1 -> 32 entries
                  .FIFO_ALMOSTFULL_THRESHOLD(2**(3)-4),
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

  assign in0 = input_fifo_dout[15:0];
  assign in1 = input_fifo_dout[31:16];
  assign in2 = input_fifo_dout[47:32];
  assign in3 = input_fifo_dout[63:48];
  assign in4 = input_fifo_dout[79:64];
  assign in5 = input_fifo_dout[95:80];
  assign in6 = input_fifo_dout[111:96];
  assign in7 = input_fifo_dout[127:112];
  assign in8 = input_fifo_dout[143:128];
  assign in9 = input_fifo_dout[159:144];
  assign in10 = input_fifo_dout[175:160];
  assign in11 = input_fifo_dout[191:176];
  assign in12 = input_fifo_dout[207:192];
  assign in13 = input_fifo_dout[223:208];
  assign in14 = input_fifo_dout[239:224];
  assign in15 = input_fifo_dout[255:240];
  assign in16 = input_fifo_dout[271:256];
  assign in17 = input_fifo_dout[287:272];
  assign in18 = input_fifo_dout[303:288];
  assign in19 = input_fifo_dout[319:304];
  assign in20 = input_fifo_dout[335:320];
  assign in21 = input_fifo_dout[351:336];
  assign in22 = input_fifo_dout[367:352];
  assign in23 = input_fifo_dout[383:368];
  assign in24 = input_fifo_dout[399:384];
  assign in25 = input_fifo_dout[415:400];
  assign in26 = input_fifo_dout[431:416];
  assign in27 = input_fifo_dout[447:432];
  assign in28 = input_fifo_dout[463:448];
  assign in29 = input_fifo_dout[479:464];
  assign in30 = input_fifo_dout[495:480];
  assign in31 = input_fifo_dout[511:496];

  assign output_fifo_din = {out31, out30, out29, out28, out27, out26, out25, out24, 
                            out23, out22, out21, out20, out19, out18, out17, out16, 
                            out15, out14, out13, out12, out11, out10, out9, out8, 
                            out7, out6, out5, out4, out3, out2, out1, out0
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

  streamMatrixTransposeTop32x32 # (
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
    .out31(out31)
  );

  wire output_fifo_we;

  assign output_fifo_we = start_next_stage & clk_en;

  syn_read_fifo #(.FIFO_WIDTH(512),
                  .FIFO_DEPTH_BITS(3),       // transfer size 1 -> 32 entries
                  .FIFO_ALMOSTFULL_THRESHOLD(2**(3)-4),
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
