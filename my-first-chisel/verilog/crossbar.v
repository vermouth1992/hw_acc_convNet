module crossbar(input clk, input reset,
    input  io_clk_en,
    input  io_start,
    output io_start_next_stage,
    input [31:0] io_in_15,
    input [31:0] io_in_14,
    input [31:0] io_in_13,
    input [31:0] io_in_12,
    input [31:0] io_in_11,
    input [31:0] io_in_10,
    input [31:0] io_in_9,
    input [31:0] io_in_8,
    input [31:0] io_in_7,
    input [31:0] io_in_6,
    input [31:0] io_in_5,
    input [31:0] io_in_4,
    input [31:0] io_in_3,
    input [31:0] io_in_2,
    input [31:0] io_in_1,
    input [31:0] io_in_0,
    output[31:0] io_out_15,
    output[31:0] io_out_14,
    output[31:0] io_out_13,
    output[31:0] io_out_12,
    output[31:0] io_out_11,
    output[31:0] io_out_10,
    output[31:0] io_out_9,
    output[31:0] io_out_8,
    output[31:0] io_out_7,
    output[31:0] io_out_6,
    output[31:0] io_out_5,
    output[31:0] io_out_4,
    output[31:0] io_out_3,
    output[31:0] io_out_2,
    output[31:0] io_out_1,
    output[31:0] io_out_0
);

  reg [31:0] out_reg_0;
  wire[31:0] T0;
  wire T1;
  reg [31:0] out_reg_1;
  wire[31:0] T2;
  reg [31:0] out_reg_2;
  wire[31:0] T3;
  reg [31:0] out_reg_3;
  wire[31:0] T4;
  reg [31:0] out_reg_4;
  wire[31:0] T5;
  reg [31:0] out_reg_5;
  wire[31:0] T6;
  reg [31:0] out_reg_6;
  wire[31:0] T7;
  reg [31:0] out_reg_7;
  wire[31:0] T8;
  reg [31:0] out_reg_8;
  wire[31:0] T9;
  reg [31:0] out_reg_9;
  wire[31:0] T10;
  reg [31:0] out_reg_10;
  wire[31:0] T11;
  reg [31:0] out_reg_11;
  wire[31:0] T12;
  reg [31:0] out_reg_12;
  wire[31:0] T13;
  reg [31:0] out_reg_13;
  wire[31:0] T14;
  reg [31:0] out_reg_14;
  wire[31:0] T15;
  reg [31:0] out_reg_15;
  wire[31:0] T16;
  reg  start_next_stage_reg;
  wire T19;
  wire T17;
  wire T18;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    out_reg_0 = {1{$random}};
    out_reg_1 = {1{$random}};
    out_reg_2 = {1{$random}};
    out_reg_3 = {1{$random}};
    out_reg_4 = {1{$random}};
    out_reg_5 = {1{$random}};
    out_reg_6 = {1{$random}};
    out_reg_7 = {1{$random}};
    out_reg_8 = {1{$random}};
    out_reg_9 = {1{$random}};
    out_reg_10 = {1{$random}};
    out_reg_11 = {1{$random}};
    out_reg_12 = {1{$random}};
    out_reg_13 = {1{$random}};
    out_reg_14 = {1{$random}};
    out_reg_15 = {1{$random}};
    start_next_stage_reg = {1{$random}};
  end
// synthesis translate_on
`endif

  assign io_out_0 = out_reg_0;
  assign T0 = T1 ? io_in_0 : out_reg_0;
  assign T1 = io_clk_en & io_start;
  assign io_out_1 = out_reg_1;
  assign T2 = T1 ? io_in_8 : out_reg_1;
  assign io_out_2 = out_reg_2;
  assign T3 = T1 ? io_in_2 : out_reg_2;
  assign io_out_3 = out_reg_3;
  assign T4 = T1 ? io_in_10 : out_reg_3;
  assign io_out_4 = out_reg_4;
  assign T5 = T1 ? io_in_4 : out_reg_4;
  assign io_out_5 = out_reg_5;
  assign T6 = T1 ? io_in_12 : out_reg_5;
  assign io_out_6 = out_reg_6;
  assign T7 = T1 ? io_in_6 : out_reg_6;
  assign io_out_7 = out_reg_7;
  assign T8 = T1 ? io_in_14 : out_reg_7;
  assign io_out_8 = out_reg_8;
  assign T9 = T1 ? io_in_1 : out_reg_8;
  assign io_out_9 = out_reg_9;
  assign T10 = T1 ? io_in_9 : out_reg_9;
  assign io_out_10 = out_reg_10;
  assign T11 = T1 ? io_in_3 : out_reg_10;
  assign io_out_11 = out_reg_11;
  assign T12 = T1 ? io_in_11 : out_reg_11;
  assign io_out_12 = out_reg_12;
  assign T13 = T1 ? io_in_5 : out_reg_12;
  assign io_out_13 = out_reg_13;
  assign T14 = T1 ? io_in_13 : out_reg_13;
  assign io_out_14 = out_reg_14;
  assign T15 = T1 ? io_in_7 : out_reg_14;
  assign io_out_15 = out_reg_15;
  assign T16 = T1 ? io_in_15 : out_reg_15;
  assign io_start_next_stage = start_next_stage_reg;
  assign T19 = reset ? 1'h0 : T17;
  assign T17 = T18 ? 1'h1 : start_next_stage_reg;
  assign T18 = io_start & io_clk_en;

  always @(posedge clk) begin
    if(T1) begin
      out_reg_0 <= io_in_0;
    end
    if(T1) begin
      out_reg_1 <= io_in_8;
    end
    if(T1) begin
      out_reg_2 <= io_in_2;
    end
    if(T1) begin
      out_reg_3 <= io_in_10;
    end
    if(T1) begin
      out_reg_4 <= io_in_4;
    end
    if(T1) begin
      out_reg_5 <= io_in_12;
    end
    if(T1) begin
      out_reg_6 <= io_in_6;
    end
    if(T1) begin
      out_reg_7 <= io_in_14;
    end
    if(T1) begin
      out_reg_8 <= io_in_1;
    end
    if(T1) begin
      out_reg_9 <= io_in_9;
    end
    if(T1) begin
      out_reg_10 <= io_in_3;
    end
    if(T1) begin
      out_reg_11 <= io_in_11;
    end
    if(T1) begin
      out_reg_12 <= io_in_5;
    end
    if(T1) begin
      out_reg_13 <= io_in_13;
    end
    if(T1) begin
      out_reg_14 <= io_in_7;
    end
    if(T1) begin
      out_reg_15 <= io_in_15;
    end
    if(reset) begin
      start_next_stage_reg <= 1'h0;
    end else if(T18) begin
      start_next_stage_reg <= 1'h1;
    end
  end
endmodule

