module crossbarShiftUp(input clk, input reset,
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
  wire[31:0] T1;
  wire[31:0] T2;
  wire[31:0] T3;
  wire T4;
  wire T5;
  reg [3:0] timestamp;
  wire[3:0] T77;
  wire[3:0] T6;
  wire[3:0] T7;
  wire T8;
  wire T9;
  wire T10;
  wire T11;
  wire T12;
  wire T13;
  wire T14;
  wire T15;
  reg [31:0] out_reg_1;
  wire[31:0] T16;
  wire[31:0] T17;
  wire[31:0] T18;
  wire[31:0] T19;
  reg [31:0] out_reg_2;
  wire[31:0] T20;
  wire[31:0] T21;
  wire[31:0] T22;
  wire[31:0] T23;
  reg [31:0] out_reg_3;
  wire[31:0] T24;
  wire[31:0] T25;
  wire[31:0] T26;
  wire[31:0] T27;
  reg [31:0] out_reg_4;
  wire[31:0] T28;
  wire[31:0] T29;
  wire[31:0] T30;
  wire[31:0] T31;
  reg [31:0] out_reg_5;
  wire[31:0] T32;
  wire[31:0] T33;
  wire[31:0] T34;
  wire[31:0] T35;
  reg [31:0] out_reg_6;
  wire[31:0] T36;
  wire[31:0] T37;
  wire[31:0] T38;
  wire[31:0] T39;
  reg [31:0] out_reg_7;
  wire[31:0] T40;
  wire[31:0] T41;
  wire[31:0] T42;
  wire[31:0] T43;
  reg [31:0] out_reg_8;
  wire[31:0] T44;
  wire[31:0] T45;
  wire[31:0] T46;
  wire[31:0] T47;
  reg [31:0] out_reg_9;
  wire[31:0] T48;
  wire[31:0] T49;
  wire[31:0] T50;
  wire[31:0] T51;
  reg [31:0] out_reg_10;
  wire[31:0] T52;
  wire[31:0] T53;
  wire[31:0] T54;
  wire[31:0] T55;
  reg [31:0] out_reg_11;
  wire[31:0] T56;
  wire[31:0] T57;
  wire[31:0] T58;
  wire[31:0] T59;
  reg [31:0] out_reg_12;
  wire[31:0] T60;
  wire[31:0] T61;
  wire[31:0] T62;
  wire[31:0] T63;
  reg [31:0] out_reg_13;
  wire[31:0] T64;
  wire[31:0] T65;
  wire[31:0] T66;
  wire[31:0] T67;
  reg [31:0] out_reg_14;
  wire[31:0] T68;
  wire[31:0] T69;
  wire[31:0] T70;
  wire[31:0] T71;
  reg [31:0] out_reg_15;
  wire[31:0] T72;
  wire[31:0] T73;
  wire[31:0] T74;
  wire[31:0] T75;
  reg  start_next_stage_reg;
  wire T78;
  wire T76;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    out_reg_0 = {1{$random}};
    timestamp = {1{$random}};
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
  assign T0 = T14 ? io_in_6 : T1;
  assign T1 = T12 ? io_in_4 : T2;
  assign T2 = T10 ? io_in_2 : T3;
  assign T3 = T4 ? io_in_0 : out_reg_0;
  assign T4 = T9 & T5;
  assign T5 = timestamp == 4'h0;
  assign T77 = reset ? 4'h0 : T6;
  assign T6 = T8 ? T7 : timestamp;
  assign T7 = timestamp + 4'h1;
  assign T8 = io_clk_en & io_start;
  assign T9 = io_start & io_clk_en;
  assign T10 = T9 & T11;
  assign T11 = timestamp == 4'h1;
  assign T12 = T9 & T13;
  assign T13 = timestamp == 4'h2;
  assign T14 = T9 & T15;
  assign T15 = timestamp == 4'h3;
  assign io_out_1 = out_reg_1;
  assign T16 = T14 ? io_in_7 : T17;
  assign T17 = T12 ? io_in_5 : T18;
  assign T18 = T10 ? io_in_3 : T19;
  assign T19 = T4 ? io_in_1 : out_reg_1;
  assign io_out_2 = out_reg_2;
  assign T20 = T14 ? io_in_8 : T21;
  assign T21 = T12 ? io_in_6 : T22;
  assign T22 = T10 ? io_in_4 : T23;
  assign T23 = T4 ? io_in_2 : out_reg_2;
  assign io_out_3 = out_reg_3;
  assign T24 = T14 ? io_in_9 : T25;
  assign T25 = T12 ? io_in_7 : T26;
  assign T26 = T10 ? io_in_5 : T27;
  assign T27 = T4 ? io_in_3 : out_reg_3;
  assign io_out_4 = out_reg_4;
  assign T28 = T14 ? io_in_10 : T29;
  assign T29 = T12 ? io_in_8 : T30;
  assign T30 = T10 ? io_in_6 : T31;
  assign T31 = T4 ? io_in_4 : out_reg_4;
  assign io_out_5 = out_reg_5;
  assign T32 = T14 ? io_in_11 : T33;
  assign T33 = T12 ? io_in_9 : T34;
  assign T34 = T10 ? io_in_7 : T35;
  assign T35 = T4 ? io_in_5 : out_reg_5;
  assign io_out_6 = out_reg_6;
  assign T36 = T14 ? io_in_12 : T37;
  assign T37 = T12 ? io_in_10 : T38;
  assign T38 = T10 ? io_in_8 : T39;
  assign T39 = T4 ? io_in_6 : out_reg_6;
  assign io_out_7 = out_reg_7;
  assign T40 = T14 ? io_in_13 : T41;
  assign T41 = T12 ? io_in_11 : T42;
  assign T42 = T10 ? io_in_9 : T43;
  assign T43 = T4 ? io_in_7 : out_reg_7;
  assign io_out_8 = out_reg_8;
  assign T44 = T14 ? io_in_14 : T45;
  assign T45 = T12 ? io_in_12 : T46;
  assign T46 = T10 ? io_in_10 : T47;
  assign T47 = T4 ? io_in_8 : out_reg_8;
  assign io_out_9 = out_reg_9;
  assign T48 = T14 ? io_in_15 : T49;
  assign T49 = T12 ? io_in_13 : T50;
  assign T50 = T10 ? io_in_11 : T51;
  assign T51 = T4 ? io_in_9 : out_reg_9;
  assign io_out_10 = out_reg_10;
  assign T52 = T14 ? io_in_0 : T53;
  assign T53 = T12 ? io_in_14 : T54;
  assign T54 = T10 ? io_in_12 : T55;
  assign T55 = T4 ? io_in_10 : out_reg_10;
  assign io_out_11 = out_reg_11;
  assign T56 = T14 ? io_in_1 : T57;
  assign T57 = T12 ? io_in_15 : T58;
  assign T58 = T10 ? io_in_13 : T59;
  assign T59 = T4 ? io_in_11 : out_reg_11;
  assign io_out_12 = out_reg_12;
  assign T60 = T14 ? io_in_2 : T61;
  assign T61 = T12 ? io_in_0 : T62;
  assign T62 = T10 ? io_in_14 : T63;
  assign T63 = T4 ? io_in_12 : out_reg_12;
  assign io_out_13 = out_reg_13;
  assign T64 = T14 ? io_in_3 : T65;
  assign T65 = T12 ? io_in_1 : T66;
  assign T66 = T10 ? io_in_15 : T67;
  assign T67 = T4 ? io_in_13 : out_reg_13;
  assign io_out_14 = out_reg_14;
  assign T68 = T14 ? io_in_4 : T69;
  assign T69 = T12 ? io_in_2 : T70;
  assign T70 = T10 ? io_in_0 : T71;
  assign T71 = T4 ? io_in_14 : out_reg_14;
  assign io_out_15 = out_reg_15;
  assign T72 = T14 ? io_in_5 : T73;
  assign T73 = T12 ? io_in_3 : T74;
  assign T74 = T10 ? io_in_1 : T75;
  assign T75 = T4 ? io_in_15 : out_reg_15;
  assign io_start_next_stage = start_next_stage_reg;
  assign T78 = reset ? 1'h0 : T76;
  assign T76 = T8 ? 1'h1 : start_next_stage_reg;

  always @(posedge clk) begin
    if(T14) begin
      out_reg_0 <= io_in_6;
    end else if(T12) begin
      out_reg_0 <= io_in_4;
    end else if(T10) begin
      out_reg_0 <= io_in_2;
    end else if(T4) begin
      out_reg_0 <= io_in_0;
    end
    if(reset) begin
      timestamp <= 4'h0;
    end else if(T8) begin
      timestamp <= T7;
    end
    if(T14) begin
      out_reg_1 <= io_in_7;
    end else if(T12) begin
      out_reg_1 <= io_in_5;
    end else if(T10) begin
      out_reg_1 <= io_in_3;
    end else if(T4) begin
      out_reg_1 <= io_in_1;
    end
    if(T14) begin
      out_reg_2 <= io_in_8;
    end else if(T12) begin
      out_reg_2 <= io_in_6;
    end else if(T10) begin
      out_reg_2 <= io_in_4;
    end else if(T4) begin
      out_reg_2 <= io_in_2;
    end
    if(T14) begin
      out_reg_3 <= io_in_9;
    end else if(T12) begin
      out_reg_3 <= io_in_7;
    end else if(T10) begin
      out_reg_3 <= io_in_5;
    end else if(T4) begin
      out_reg_3 <= io_in_3;
    end
    if(T14) begin
      out_reg_4 <= io_in_10;
    end else if(T12) begin
      out_reg_4 <= io_in_8;
    end else if(T10) begin
      out_reg_4 <= io_in_6;
    end else if(T4) begin
      out_reg_4 <= io_in_4;
    end
    if(T14) begin
      out_reg_5 <= io_in_11;
    end else if(T12) begin
      out_reg_5 <= io_in_9;
    end else if(T10) begin
      out_reg_5 <= io_in_7;
    end else if(T4) begin
      out_reg_5 <= io_in_5;
    end
    if(T14) begin
      out_reg_6 <= io_in_12;
    end else if(T12) begin
      out_reg_6 <= io_in_10;
    end else if(T10) begin
      out_reg_6 <= io_in_8;
    end else if(T4) begin
      out_reg_6 <= io_in_6;
    end
    if(T14) begin
      out_reg_7 <= io_in_13;
    end else if(T12) begin
      out_reg_7 <= io_in_11;
    end else if(T10) begin
      out_reg_7 <= io_in_9;
    end else if(T4) begin
      out_reg_7 <= io_in_7;
    end
    if(T14) begin
      out_reg_8 <= io_in_14;
    end else if(T12) begin
      out_reg_8 <= io_in_12;
    end else if(T10) begin
      out_reg_8 <= io_in_10;
    end else if(T4) begin
      out_reg_8 <= io_in_8;
    end
    if(T14) begin
      out_reg_9 <= io_in_15;
    end else if(T12) begin
      out_reg_9 <= io_in_13;
    end else if(T10) begin
      out_reg_9 <= io_in_11;
    end else if(T4) begin
      out_reg_9 <= io_in_9;
    end
    if(T14) begin
      out_reg_10 <= io_in_0;
    end else if(T12) begin
      out_reg_10 <= io_in_14;
    end else if(T10) begin
      out_reg_10 <= io_in_12;
    end else if(T4) begin
      out_reg_10 <= io_in_10;
    end
    if(T14) begin
      out_reg_11 <= io_in_1;
    end else if(T12) begin
      out_reg_11 <= io_in_15;
    end else if(T10) begin
      out_reg_11 <= io_in_13;
    end else if(T4) begin
      out_reg_11 <= io_in_11;
    end
    if(T14) begin
      out_reg_12 <= io_in_2;
    end else if(T12) begin
      out_reg_12 <= io_in_0;
    end else if(T10) begin
      out_reg_12 <= io_in_14;
    end else if(T4) begin
      out_reg_12 <= io_in_12;
    end
    if(T14) begin
      out_reg_13 <= io_in_3;
    end else if(T12) begin
      out_reg_13 <= io_in_1;
    end else if(T10) begin
      out_reg_13 <= io_in_15;
    end else if(T4) begin
      out_reg_13 <= io_in_13;
    end
    if(T14) begin
      out_reg_14 <= io_in_4;
    end else if(T12) begin
      out_reg_14 <= io_in_2;
    end else if(T10) begin
      out_reg_14 <= io_in_0;
    end else if(T4) begin
      out_reg_14 <= io_in_14;
    end
    if(T14) begin
      out_reg_15 <= io_in_5;
    end else if(T12) begin
      out_reg_15 <= io_in_3;
    end else if(T10) begin
      out_reg_15 <= io_in_1;
    end else if(T4) begin
      out_reg_15 <= io_in_15;
    end
    if(reset) begin
      start_next_stage_reg <= 1'h0;
    end else if(T8) begin
      start_next_stage_reg <= 1'h1;
    end
  end
endmodule

