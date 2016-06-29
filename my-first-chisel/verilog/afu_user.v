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
  assign T2 = T1 ? io_in_4 : out_reg_1;
  assign io_out_2 = out_reg_2;
  assign T3 = T1 ? io_in_8 : out_reg_2;
  assign io_out_3 = out_reg_3;
  assign T4 = T1 ? io_in_12 : out_reg_3;
  assign io_out_4 = out_reg_4;
  assign T5 = T1 ? io_in_1 : out_reg_4;
  assign io_out_5 = out_reg_5;
  assign T6 = T1 ? io_in_5 : out_reg_5;
  assign io_out_6 = out_reg_6;
  assign T7 = T1 ? io_in_9 : out_reg_6;
  assign io_out_7 = out_reg_7;
  assign T8 = T1 ? io_in_13 : out_reg_7;
  assign io_out_8 = out_reg_8;
  assign T9 = T1 ? io_in_2 : out_reg_8;
  assign io_out_9 = out_reg_9;
  assign T10 = T1 ? io_in_6 : out_reg_9;
  assign io_out_10 = out_reg_10;
  assign T11 = T1 ? io_in_10 : out_reg_10;
  assign io_out_11 = out_reg_11;
  assign T12 = T1 ? io_in_14 : out_reg_11;
  assign io_out_12 = out_reg_12;
  assign T13 = T1 ? io_in_3 : out_reg_12;
  assign io_out_13 = out_reg_13;
  assign T14 = T1 ? io_in_7 : out_reg_13;
  assign io_out_14 = out_reg_14;
  assign T15 = T1 ? io_in_11 : out_reg_14;
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
      out_reg_1 <= io_in_4;
    end
    if(T1) begin
      out_reg_2 <= io_in_8;
    end
    if(T1) begin
      out_reg_3 <= io_in_12;
    end
    if(T1) begin
      out_reg_4 <= io_in_1;
    end
    if(T1) begin
      out_reg_5 <= io_in_5;
    end
    if(T1) begin
      out_reg_6 <= io_in_9;
    end
    if(T1) begin
      out_reg_7 <= io_in_13;
    end
    if(T1) begin
      out_reg_8 <= io_in_2;
    end
    if(T1) begin
      out_reg_9 <= io_in_6;
    end
    if(T1) begin
      out_reg_10 <= io_in_10;
    end
    if(T1) begin
      out_reg_11 <= io_in_14;
    end
    if(T1) begin
      out_reg_12 <= io_in_3;
    end
    if(T1) begin
      out_reg_13 <= io_in_7;
    end
    if(T1) begin
      out_reg_14 <= io_in_11;
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

module crossbarShiftDown(input clk, input reset,
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
  wire T2;
  reg  timestamp;
  wire T23;
  wire T3;
  wire T4;
  wire T5;
  wire T6;
  reg [31:0] out_reg_1;
  wire[31:0] T7;
  reg [31:0] out_reg_2;
  wire[31:0] T8;
  reg [31:0] out_reg_3;
  wire[31:0] T9;
  reg [31:0] out_reg_4;
  wire[31:0] T10;
  reg [31:0] out_reg_5;
  wire[31:0] T11;
  reg [31:0] out_reg_6;
  wire[31:0] T12;
  reg [31:0] out_reg_7;
  wire[31:0] T13;
  reg [31:0] out_reg_8;
  wire[31:0] T14;
  reg [31:0] out_reg_9;
  wire[31:0] T15;
  reg [31:0] out_reg_10;
  wire[31:0] T16;
  reg [31:0] out_reg_11;
  wire[31:0] T17;
  reg [31:0] out_reg_12;
  wire[31:0] T18;
  reg [31:0] out_reg_13;
  wire[31:0] T19;
  reg [31:0] out_reg_14;
  wire[31:0] T20;
  reg [31:0] out_reg_15;
  wire[31:0] T21;
  reg  start_next_stage_reg;
  wire T24;
  wire T22;

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
  assign T0 = T1 ? io_in_0 : out_reg_0;
  assign T1 = T6 & T2;
  assign T2 = timestamp == 1'h0;
  assign T23 = reset ? 1'h0 : T3;
  assign T3 = T5 ? T4 : timestamp;
  assign T4 = timestamp + 1'h1;
  assign T5 = io_clk_en & io_start;
  assign T6 = io_start & io_clk_en;
  assign io_out_1 = out_reg_1;
  assign T7 = T1 ? io_in_1 : out_reg_1;
  assign io_out_2 = out_reg_2;
  assign T8 = T1 ? io_in_2 : out_reg_2;
  assign io_out_3 = out_reg_3;
  assign T9 = T1 ? io_in_3 : out_reg_3;
  assign io_out_4 = out_reg_4;
  assign T10 = T1 ? io_in_4 : out_reg_4;
  assign io_out_5 = out_reg_5;
  assign T11 = T1 ? io_in_5 : out_reg_5;
  assign io_out_6 = out_reg_6;
  assign T12 = T1 ? io_in_6 : out_reg_6;
  assign io_out_7 = out_reg_7;
  assign T13 = T1 ? io_in_7 : out_reg_7;
  assign io_out_8 = out_reg_8;
  assign T14 = T1 ? io_in_8 : out_reg_8;
  assign io_out_9 = out_reg_9;
  assign T15 = T1 ? io_in_9 : out_reg_9;
  assign io_out_10 = out_reg_10;
  assign T16 = T1 ? io_in_10 : out_reg_10;
  assign io_out_11 = out_reg_11;
  assign T17 = T1 ? io_in_11 : out_reg_11;
  assign io_out_12 = out_reg_12;
  assign T18 = T1 ? io_in_12 : out_reg_12;
  assign io_out_13 = out_reg_13;
  assign T19 = T1 ? io_in_13 : out_reg_13;
  assign io_out_14 = out_reg_14;
  assign T20 = T1 ? io_in_14 : out_reg_14;
  assign io_out_15 = out_reg_15;
  assign T21 = T1 ? io_in_15 : out_reg_15;
  assign io_start_next_stage = start_next_stage_reg;
  assign T24 = reset ? 1'h0 : T22;
  assign T22 = T5 ? 1'h1 : start_next_stage_reg;

  always @(posedge clk) begin
    if(T1) begin
      out_reg_0 <= io_in_0;
    end
    if(reset) begin
      timestamp <= 1'h0;
    end else if(T5) begin
      timestamp <= T4;
    end
    if(T1) begin
      out_reg_1 <= io_in_1;
    end
    if(T1) begin
      out_reg_2 <= io_in_2;
    end
    if(T1) begin
      out_reg_3 <= io_in_3;
    end
    if(T1) begin
      out_reg_4 <= io_in_4;
    end
    if(T1) begin
      out_reg_5 <= io_in_5;
    end
    if(T1) begin
      out_reg_6 <= io_in_6;
    end
    if(T1) begin
      out_reg_7 <= io_in_7;
    end
    if(T1) begin
      out_reg_8 <= io_in_8;
    end
    if(T1) begin
      out_reg_9 <= io_in_9;
    end
    if(T1) begin
      out_reg_10 <= io_in_10;
    end
    if(T1) begin
      out_reg_11 <= io_in_11;
    end
    if(T1) begin
      out_reg_12 <= io_in_12;
    end
    if(T1) begin
      out_reg_13 <= io_in_13;
    end
    if(T1) begin
      out_reg_14 <= io_in_14;
    end
    if(T1) begin
      out_reg_15 <= io_in_15;
    end
    if(reset) begin
      start_next_stage_reg <= 1'h0;
    end else if(T5) begin
      start_next_stage_reg <= 1'h1;
    end
  end
endmodule

module single_port_ram(input clk,
    input [31:0] io_data,
    input  io_addr,
    input  io_we,
    output[31:0] io_q
);

  reg [31:0] out;
  wire[31:0] T0;
  wire[31:0] T1;
  reg [31:0] myMem [0:0];
  wire[31:0] T2;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    out = {1{$random}};
    for (initvar = 0; initvar < 1; initvar = initvar+1)
      myMem[initvar] = {1{$random}};
  end
// synthesis translate_on
`endif

  assign io_q = out;
  assign T0 = io_we ? T1 : out;
  assign T1 = myMem[io_addr];

  always @(posedge clk) begin
    if(io_we) begin
      out <= T1;
    end
    if (io_we)
      myMem[io_addr] <= io_data;
  end
endmodule

module memArray(input clk, input reset,
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

  wire T0;
  reg  address_3;
  wire T73;
  wire T1;
  wire T2;
  wire T3;
  wire T4;
  wire T5;
  wire T6;
  wire T7;
  wire T8;
  reg [1:0] state;
  wire[1:0] T74;
  wire[1:0] T9;
  wire[1:0] T10;
  wire[1:0] T11;
  wire T12;
  wire T13;
  wire T14;
  reg  counter;
  wire T75;
  wire T15;
  wire T16;
  wire T17;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  wire T22;
  wire T23;
  wire T24;
  wire T25;
  wire T26;
  wire T27;
  wire T28;
  wire T29;
  wire T30;
  wire T31;
  wire T32;
  wire T33;
  wire T34;
  wire T35;
  wire T36;
  reg  address_2;
  wire T76;
  wire T37;
  wire T38;
  wire T39;
  wire T40;
  wire T41;
  wire T42;
  wire T43;
  wire T44;
  wire T45;
  wire T46;
  wire T47;
  wire T48;
  reg  address_1;
  wire T77;
  wire T49;
  wire T50;
  wire T51;
  wire T52;
  wire T53;
  wire T54;
  wire T55;
  wire T56;
  wire T57;
  wire T58;
  wire T59;
  wire T60;
  reg  address_0;
  wire T78;
  wire T61;
  wire T62;
  wire T63;
  wire T64;
  wire T65;
  wire T66;
  wire T67;
  wire T68;
  wire T69;
  wire T70;
  wire T71;
  reg  start_next_stage_reg;
  wire T79;
  wire T72;
  wire[31:0] single_port_ram_io_q;
  wire[31:0] single_port_ram_1_io_q;
  wire[31:0] single_port_ram_2_io_q;
  wire[31:0] single_port_ram_3_io_q;
  wire[31:0] single_port_ram_4_io_q;
  wire[31:0] single_port_ram_5_io_q;
  wire[31:0] single_port_ram_6_io_q;
  wire[31:0] single_port_ram_7_io_q;
  wire[31:0] single_port_ram_8_io_q;
  wire[31:0] single_port_ram_9_io_q;
  wire[31:0] single_port_ram_10_io_q;
  wire[31:0] single_port_ram_11_io_q;
  wire[31:0] single_port_ram_12_io_q;
  wire[31:0] single_port_ram_13_io_q;
  wire[31:0] single_port_ram_14_io_q;
  wire[31:0] single_port_ram_15_io_q;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    address_3 = {1{$random}};
    state = {1{$random}};
    counter = {1{$random}};
    address_2 = {1{$random}};
    address_1 = {1{$random}};
    address_0 = {1{$random}};
    start_next_stage_reg = {1{$random}};
  end
// synthesis translate_on
`endif

  assign T0 = io_start & io_clk_en;
  assign T73 = reset ? 1'h0 : T1;
  assign T1 = T31 ? T30 : T2;
  assign T2 = T28 ? 1'h0 : T3;
  assign T3 = T26 ? T25 : T4;
  assign T4 = T13 ? 1'h0 : T5;
  assign T5 = T7 ? T6 : address_3;
  assign T6 = address_3 + 1'h1;
  assign T7 = T12 & T8;
  assign T8 = state == 2'h0;
  assign T74 = reset ? 2'h0 : T9;
  assign T9 = T28 ? 2'h1 : T10;
  assign T10 = T13 ? 2'h2 : T11;
  assign T11 = T7 ? 2'h1 : state;
  assign T12 = io_clk_en & io_start;
  assign T13 = T23 & T14;
  assign T14 = counter == 1'h0;
  assign T75 = reset ? 1'h0 : T15;
  assign T15 = T21 ? T20 : T16;
  assign T16 = T23 ? T19 : T17;
  assign T17 = T7 ? T18 : counter;
  assign T18 = counter + 1'h1;
  assign T19 = counter + 1'h1;
  assign T20 = counter + 1'h1;
  assign T21 = T12 & T22;
  assign T22 = state == 2'h2;
  assign T23 = T12 & T24;
  assign T24 = state == 2'h1;
  assign T25 = address_3 + 1'h1;
  assign T26 = T23 & T27;
  assign T27 = T14 ^ 1'h1;
  assign T28 = T21 & T29;
  assign T29 = counter == 1'h0;
  assign T30 = address_3 - 1'h1;
  assign T31 = T21 & T32;
  assign T32 = T29 ^ 1'h1;
  assign T33 = io_start & io_clk_en;
  assign T34 = io_start & io_clk_en;
  assign T35 = io_start & io_clk_en;
  assign T36 = io_start & io_clk_en;
  assign T76 = reset ? 1'h0 : T37;
  assign T37 = T31 ? T44 : T38;
  assign T38 = T28 ? 1'h0 : T39;
  assign T39 = T26 ? T43 : T40;
  assign T40 = T13 ? 1'h0 : T41;
  assign T41 = T7 ? T42 : address_2;
  assign T42 = address_2 + 1'h1;
  assign T43 = address_2 + 1'h1;
  assign T44 = address_2 - 1'h1;
  assign T45 = io_start & io_clk_en;
  assign T46 = io_start & io_clk_en;
  assign T47 = io_start & io_clk_en;
  assign T48 = io_start & io_clk_en;
  assign T77 = reset ? 1'h0 : T49;
  assign T49 = T31 ? T56 : T50;
  assign T50 = T28 ? 1'h0 : T51;
  assign T51 = T26 ? T55 : T52;
  assign T52 = T13 ? 1'h0 : T53;
  assign T53 = T7 ? T54 : address_1;
  assign T54 = address_1 + 1'h1;
  assign T55 = address_1 + 1'h1;
  assign T56 = address_1 - 1'h1;
  assign T57 = io_start & io_clk_en;
  assign T58 = io_start & io_clk_en;
  assign T59 = io_start & io_clk_en;
  assign T60 = io_start & io_clk_en;
  assign T78 = reset ? 1'h0 : T61;
  assign T61 = T31 ? T68 : T62;
  assign T62 = T28 ? 1'h0 : T63;
  assign T63 = T26 ? T67 : T64;
  assign T64 = T13 ? 1'h0 : T65;
  assign T65 = T7 ? T66 : address_0;
  assign T66 = address_0 + 1'h1;
  assign T67 = address_0 + 1'h1;
  assign T68 = address_0 - 1'h1;
  assign T69 = io_start & io_clk_en;
  assign T70 = io_start & io_clk_en;
  assign T71 = io_start & io_clk_en;
  assign io_out_0 = single_port_ram_io_q;
  assign io_out_1 = single_port_ram_1_io_q;
  assign io_out_2 = single_port_ram_2_io_q;
  assign io_out_3 = single_port_ram_3_io_q;
  assign io_out_4 = single_port_ram_4_io_q;
  assign io_out_5 = single_port_ram_5_io_q;
  assign io_out_6 = single_port_ram_6_io_q;
  assign io_out_7 = single_port_ram_7_io_q;
  assign io_out_8 = single_port_ram_8_io_q;
  assign io_out_9 = single_port_ram_9_io_q;
  assign io_out_10 = single_port_ram_10_io_q;
  assign io_out_11 = single_port_ram_11_io_q;
  assign io_out_12 = single_port_ram_12_io_q;
  assign io_out_13 = single_port_ram_13_io_q;
  assign io_out_14 = single_port_ram_14_io_q;
  assign io_out_15 = single_port_ram_15_io_q;
  assign io_start_next_stage = start_next_stage_reg;
  assign T79 = reset ? 1'h0 : T72;
  assign T72 = T21 ? 1'h1 : start_next_stage_reg;
  single_port_ram single_port_ram(.clk(clk),
       .io_data( io_in_0 ),
       .io_addr( address_0 ),
       .io_we( T71 ),
       .io_q( single_port_ram_io_q )
  );
  single_port_ram single_port_ram_1(.clk(clk),
       .io_data( io_in_1 ),
       .io_addr( address_0 ),
       .io_we( T70 ),
       .io_q( single_port_ram_1_io_q )
  );
  single_port_ram single_port_ram_2(.clk(clk),
       .io_data( io_in_2 ),
       .io_addr( address_0 ),
       .io_we( T69 ),
       .io_q( single_port_ram_2_io_q )
  );
  single_port_ram single_port_ram_3(.clk(clk),
       .io_data( io_in_3 ),
       .io_addr( address_0 ),
       .io_we( T60 ),
       .io_q( single_port_ram_3_io_q )
  );
  single_port_ram single_port_ram_4(.clk(clk),
       .io_data( io_in_4 ),
       .io_addr( address_1 ),
       .io_we( T59 ),
       .io_q( single_port_ram_4_io_q )
  );
  single_port_ram single_port_ram_5(.clk(clk),
       .io_data( io_in_5 ),
       .io_addr( address_1 ),
       .io_we( T58 ),
       .io_q( single_port_ram_5_io_q )
  );
  single_port_ram single_port_ram_6(.clk(clk),
       .io_data( io_in_6 ),
       .io_addr( address_1 ),
       .io_we( T57 ),
       .io_q( single_port_ram_6_io_q )
  );
  single_port_ram single_port_ram_7(.clk(clk),
       .io_data( io_in_7 ),
       .io_addr( address_1 ),
       .io_we( T48 ),
       .io_q( single_port_ram_7_io_q )
  );
  single_port_ram single_port_ram_8(.clk(clk),
       .io_data( io_in_8 ),
       .io_addr( address_2 ),
       .io_we( T47 ),
       .io_q( single_port_ram_8_io_q )
  );
  single_port_ram single_port_ram_9(.clk(clk),
       .io_data( io_in_9 ),
       .io_addr( address_2 ),
       .io_we( T46 ),
       .io_q( single_port_ram_9_io_q )
  );
  single_port_ram single_port_ram_10(.clk(clk),
       .io_data( io_in_10 ),
       .io_addr( address_2 ),
       .io_we( T45 ),
       .io_q( single_port_ram_10_io_q )
  );
  single_port_ram single_port_ram_11(.clk(clk),
       .io_data( io_in_11 ),
       .io_addr( address_2 ),
       .io_we( T36 ),
       .io_q( single_port_ram_11_io_q )
  );
  single_port_ram single_port_ram_12(.clk(clk),
       .io_data( io_in_12 ),
       .io_addr( address_3 ),
       .io_we( T35 ),
       .io_q( single_port_ram_12_io_q )
  );
  single_port_ram single_port_ram_13(.clk(clk),
       .io_data( io_in_13 ),
       .io_addr( address_3 ),
       .io_we( T34 ),
       .io_q( single_port_ram_13_io_q )
  );
  single_port_ram single_port_ram_14(.clk(clk),
       .io_data( io_in_14 ),
       .io_addr( address_3 ),
       .io_we( T33 ),
       .io_q( single_port_ram_14_io_q )
  );
  single_port_ram single_port_ram_15(.clk(clk),
       .io_data( io_in_15 ),
       .io_addr( address_3 ),
       .io_we( T0 ),
       .io_q( single_port_ram_15_io_q )
  );

  always @(posedge clk) begin
    if(reset) begin
      address_3 <= 1'h0;
    end else if(T31) begin
      address_3 <= T30;
    end else if(T28) begin
      address_3 <= 1'h0;
    end else if(T26) begin
      address_3 <= T25;
    end else if(T13) begin
      address_3 <= 1'h0;
    end else if(T7) begin
      address_3 <= T6;
    end
    if(reset) begin
      state <= 2'h0;
    end else if(T28) begin
      state <= 2'h1;
    end else if(T13) begin
      state <= 2'h2;
    end else if(T7) begin
      state <= 2'h1;
    end
    if(reset) begin
      counter <= 1'h0;
    end else if(T21) begin
      counter <= T20;
    end else if(T23) begin
      counter <= T19;
    end else if(T7) begin
      counter <= T18;
    end
    if(reset) begin
      address_2 <= 1'h0;
    end else if(T31) begin
      address_2 <= T44;
    end else if(T28) begin
      address_2 <= 1'h0;
    end else if(T26) begin
      address_2 <= T43;
    end else if(T13) begin
      address_2 <= 1'h0;
    end else if(T7) begin
      address_2 <= T42;
    end
    if(reset) begin
      address_1 <= 1'h0;
    end else if(T31) begin
      address_1 <= T56;
    end else if(T28) begin
      address_1 <= 1'h0;
    end else if(T26) begin
      address_1 <= T55;
    end else if(T13) begin
      address_1 <= 1'h0;
    end else if(T7) begin
      address_1 <= T54;
    end
    if(reset) begin
      address_0 <= 1'h0;
    end else if(T31) begin
      address_0 <= T68;
    end else if(T28) begin
      address_0 <= 1'h0;
    end else if(T26) begin
      address_0 <= T67;
    end else if(T13) begin
      address_0 <= 1'h0;
    end else if(T7) begin
      address_0 <= T66;
    end
    if(reset) begin
      start_next_stage_reg <= 1'h0;
    end else if(T21) begin
      start_next_stage_reg <= 1'h1;
    end
  end
endmodule

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
  wire T1;
  wire T2;
  reg  timestamp;
  wire T23;
  wire T3;
  wire T4;
  wire T5;
  wire T6;
  reg [31:0] out_reg_1;
  wire[31:0] T7;
  reg [31:0] out_reg_2;
  wire[31:0] T8;
  reg [31:0] out_reg_3;
  wire[31:0] T9;
  reg [31:0] out_reg_4;
  wire[31:0] T10;
  reg [31:0] out_reg_5;
  wire[31:0] T11;
  reg [31:0] out_reg_6;
  wire[31:0] T12;
  reg [31:0] out_reg_7;
  wire[31:0] T13;
  reg [31:0] out_reg_8;
  wire[31:0] T14;
  reg [31:0] out_reg_9;
  wire[31:0] T15;
  reg [31:0] out_reg_10;
  wire[31:0] T16;
  reg [31:0] out_reg_11;
  wire[31:0] T17;
  reg [31:0] out_reg_12;
  wire[31:0] T18;
  reg [31:0] out_reg_13;
  wire[31:0] T19;
  reg [31:0] out_reg_14;
  wire[31:0] T20;
  reg [31:0] out_reg_15;
  wire[31:0] T21;
  reg  start_next_stage_reg;
  wire T24;
  wire T22;

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
  assign T0 = T1 ? io_in_0 : out_reg_0;
  assign T1 = T6 & T2;
  assign T2 = timestamp == 1'h0;
  assign T23 = reset ? 1'h0 : T3;
  assign T3 = T5 ? T4 : timestamp;
  assign T4 = timestamp + 1'h1;
  assign T5 = io_clk_en & io_start;
  assign T6 = io_start & io_clk_en;
  assign io_out_1 = out_reg_1;
  assign T7 = T1 ? io_in_1 : out_reg_1;
  assign io_out_2 = out_reg_2;
  assign T8 = T1 ? io_in_2 : out_reg_2;
  assign io_out_3 = out_reg_3;
  assign T9 = T1 ? io_in_3 : out_reg_3;
  assign io_out_4 = out_reg_4;
  assign T10 = T1 ? io_in_4 : out_reg_4;
  assign io_out_5 = out_reg_5;
  assign T11 = T1 ? io_in_5 : out_reg_5;
  assign io_out_6 = out_reg_6;
  assign T12 = T1 ? io_in_6 : out_reg_6;
  assign io_out_7 = out_reg_7;
  assign T13 = T1 ? io_in_7 : out_reg_7;
  assign io_out_8 = out_reg_8;
  assign T14 = T1 ? io_in_8 : out_reg_8;
  assign io_out_9 = out_reg_9;
  assign T15 = T1 ? io_in_9 : out_reg_9;
  assign io_out_10 = out_reg_10;
  assign T16 = T1 ? io_in_10 : out_reg_10;
  assign io_out_11 = out_reg_11;
  assign T17 = T1 ? io_in_11 : out_reg_11;
  assign io_out_12 = out_reg_12;
  assign T18 = T1 ? io_in_12 : out_reg_12;
  assign io_out_13 = out_reg_13;
  assign T19 = T1 ? io_in_13 : out_reg_13;
  assign io_out_14 = out_reg_14;
  assign T20 = T1 ? io_in_14 : out_reg_14;
  assign io_out_15 = out_reg_15;
  assign T21 = T1 ? io_in_15 : out_reg_15;
  assign io_start_next_stage = start_next_stage_reg;
  assign T24 = reset ? 1'h0 : T22;
  assign T22 = T5 ? 1'h1 : start_next_stage_reg;

  always @(posedge clk) begin
    if(T1) begin
      out_reg_0 <= io_in_0;
    end
    if(reset) begin
      timestamp <= 1'h0;
    end else if(T5) begin
      timestamp <= T4;
    end
    if(T1) begin
      out_reg_1 <= io_in_1;
    end
    if(T1) begin
      out_reg_2 <= io_in_2;
    end
    if(T1) begin
      out_reg_3 <= io_in_3;
    end
    if(T1) begin
      out_reg_4 <= io_in_4;
    end
    if(T1) begin
      out_reg_5 <= io_in_5;
    end
    if(T1) begin
      out_reg_6 <= io_in_6;
    end
    if(T1) begin
      out_reg_7 <= io_in_7;
    end
    if(T1) begin
      out_reg_8 <= io_in_8;
    end
    if(T1) begin
      out_reg_9 <= io_in_9;
    end
    if(T1) begin
      out_reg_10 <= io_in_10;
    end
    if(T1) begin
      out_reg_11 <= io_in_11;
    end
    if(T1) begin
      out_reg_12 <= io_in_12;
    end
    if(T1) begin
      out_reg_13 <= io_in_13;
    end
    if(T1) begin
      out_reg_14 <= io_in_14;
    end
    if(T1) begin
      out_reg_15 <= io_in_15;
    end
    if(reset) begin
      start_next_stage_reg <= 1'h0;
    end else if(T5) begin
      start_next_stage_reg <= 1'h1;
    end
  end
endmodule

module streamMatrixTransposeTop(input clk, input reset,
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

  wire crossbar_io_start_next_stage;
  wire[31:0] crossbar_io_out_15;
  wire[31:0] crossbar_io_out_14;
  wire[31:0] crossbar_io_out_13;
  wire[31:0] crossbar_io_out_12;
  wire[31:0] crossbar_io_out_11;
  wire[31:0] crossbar_io_out_10;
  wire[31:0] crossbar_io_out_9;
  wire[31:0] crossbar_io_out_8;
  wire[31:0] crossbar_io_out_7;
  wire[31:0] crossbar_io_out_6;
  wire[31:0] crossbar_io_out_5;
  wire[31:0] crossbar_io_out_4;
  wire[31:0] crossbar_io_out_3;
  wire[31:0] crossbar_io_out_2;
  wire[31:0] crossbar_io_out_1;
  wire[31:0] crossbar_io_out_0;
  wire crossbarShift_io_start_next_stage;
  wire[31:0] crossbarShift_io_out_15;
  wire[31:0] crossbarShift_io_out_14;
  wire[31:0] crossbarShift_io_out_13;
  wire[31:0] crossbarShift_io_out_12;
  wire[31:0] crossbarShift_io_out_11;
  wire[31:0] crossbarShift_io_out_10;
  wire[31:0] crossbarShift_io_out_9;
  wire[31:0] crossbarShift_io_out_8;
  wire[31:0] crossbarShift_io_out_7;
  wire[31:0] crossbarShift_io_out_6;
  wire[31:0] crossbarShift_io_out_5;
  wire[31:0] crossbarShift_io_out_4;
  wire[31:0] crossbarShift_io_out_3;
  wire[31:0] crossbarShift_io_out_2;
  wire[31:0] crossbarShift_io_out_1;
  wire[31:0] crossbarShift_io_out_0;
  wire crossbarShift_1_io_start_next_stage;
  wire[31:0] crossbarShift_1_io_out_15;
  wire[31:0] crossbarShift_1_io_out_14;
  wire[31:0] crossbarShift_1_io_out_13;
  wire[31:0] crossbarShift_1_io_out_12;
  wire[31:0] crossbarShift_1_io_out_11;
  wire[31:0] crossbarShift_1_io_out_10;
  wire[31:0] crossbarShift_1_io_out_9;
  wire[31:0] crossbarShift_1_io_out_8;
  wire[31:0] crossbarShift_1_io_out_7;
  wire[31:0] crossbarShift_1_io_out_6;
  wire[31:0] crossbarShift_1_io_out_5;
  wire[31:0] crossbarShift_1_io_out_4;
  wire[31:0] crossbarShift_1_io_out_3;
  wire[31:0] crossbarShift_1_io_out_2;
  wire[31:0] crossbarShift_1_io_out_1;
  wire[31:0] crossbarShift_1_io_out_0;
  wire memArray_io_start_next_stage;
  wire[31:0] memArray_io_out_15;
  wire[31:0] memArray_io_out_14;
  wire[31:0] memArray_io_out_13;
  wire[31:0] memArray_io_out_12;
  wire[31:0] memArray_io_out_11;
  wire[31:0] memArray_io_out_10;
  wire[31:0] memArray_io_out_9;
  wire[31:0] memArray_io_out_8;
  wire[31:0] memArray_io_out_7;
  wire[31:0] memArray_io_out_6;
  wire[31:0] memArray_io_out_5;
  wire[31:0] memArray_io_out_4;
  wire[31:0] memArray_io_out_3;
  wire[31:0] memArray_io_out_2;
  wire[31:0] memArray_io_out_1;
  wire[31:0] memArray_io_out_0;


  assign io_out_0 = crossbarShift_1_io_out_0;
  assign io_out_1 = crossbarShift_1_io_out_1;
  assign io_out_2 = crossbarShift_1_io_out_2;
  assign io_out_3 = crossbarShift_1_io_out_3;
  assign io_out_4 = crossbarShift_1_io_out_4;
  assign io_out_5 = crossbarShift_1_io_out_5;
  assign io_out_6 = crossbarShift_1_io_out_6;
  assign io_out_7 = crossbarShift_1_io_out_7;
  assign io_out_8 = crossbarShift_1_io_out_8;
  assign io_out_9 = crossbarShift_1_io_out_9;
  assign io_out_10 = crossbarShift_1_io_out_10;
  assign io_out_11 = crossbarShift_1_io_out_11;
  assign io_out_12 = crossbarShift_1_io_out_12;
  assign io_out_13 = crossbarShift_1_io_out_13;
  assign io_out_14 = crossbarShift_1_io_out_14;
  assign io_out_15 = crossbarShift_1_io_out_15;
  assign io_start_next_stage = crossbarShift_1_io_start_next_stage;
  crossbar crossbar(.clk(clk), .reset(reset),
       .io_clk_en( io_clk_en ),
       .io_start( io_start ),
       .io_start_next_stage( crossbar_io_start_next_stage ),
       .io_in_15( io_in_15 ),
       .io_in_14( io_in_14 ),
       .io_in_13( io_in_13 ),
       .io_in_12( io_in_12 ),
       .io_in_11( io_in_11 ),
       .io_in_10( io_in_10 ),
       .io_in_9( io_in_9 ),
       .io_in_8( io_in_8 ),
       .io_in_7( io_in_7 ),
       .io_in_6( io_in_6 ),
       .io_in_5( io_in_5 ),
       .io_in_4( io_in_4 ),
       .io_in_3( io_in_3 ),
       .io_in_2( io_in_2 ),
       .io_in_1( io_in_1 ),
       .io_in_0( io_in_0 ),
       .io_out_15( crossbar_io_out_15 ),
       .io_out_14( crossbar_io_out_14 ),
       .io_out_13( crossbar_io_out_13 ),
       .io_out_12( crossbar_io_out_12 ),
       .io_out_11( crossbar_io_out_11 ),
       .io_out_10( crossbar_io_out_10 ),
       .io_out_9( crossbar_io_out_9 ),
       .io_out_8( crossbar_io_out_8 ),
       .io_out_7( crossbar_io_out_7 ),
       .io_out_6( crossbar_io_out_6 ),
       .io_out_5( crossbar_io_out_5 ),
       .io_out_4( crossbar_io_out_4 ),
       .io_out_3( crossbar_io_out_3 ),
       .io_out_2( crossbar_io_out_2 ),
       .io_out_1( crossbar_io_out_1 ),
       .io_out_0( crossbar_io_out_0 )
  );
  crossbarShiftDown crossbarShift(.clk(clk), .reset(reset),
       .io_clk_en( io_clk_en ),
       .io_start( crossbar_io_start_next_stage ),
       .io_start_next_stage( crossbarShift_io_start_next_stage ),
       .io_in_15( crossbar_io_out_15 ),
       .io_in_14( crossbar_io_out_14 ),
       .io_in_13( crossbar_io_out_13 ),
       .io_in_12( crossbar_io_out_12 ),
       .io_in_11( crossbar_io_out_11 ),
       .io_in_10( crossbar_io_out_10 ),
       .io_in_9( crossbar_io_out_9 ),
       .io_in_8( crossbar_io_out_8 ),
       .io_in_7( crossbar_io_out_7 ),
       .io_in_6( crossbar_io_out_6 ),
       .io_in_5( crossbar_io_out_5 ),
       .io_in_4( crossbar_io_out_4 ),
       .io_in_3( crossbar_io_out_3 ),
       .io_in_2( crossbar_io_out_2 ),
       .io_in_1( crossbar_io_out_1 ),
       .io_in_0( crossbar_io_out_0 ),
       .io_out_15( crossbarShift_io_out_15 ),
       .io_out_14( crossbarShift_io_out_14 ),
       .io_out_13( crossbarShift_io_out_13 ),
       .io_out_12( crossbarShift_io_out_12 ),
       .io_out_11( crossbarShift_io_out_11 ),
       .io_out_10( crossbarShift_io_out_10 ),
       .io_out_9( crossbarShift_io_out_9 ),
       .io_out_8( crossbarShift_io_out_8 ),
       .io_out_7( crossbarShift_io_out_7 ),
       .io_out_6( crossbarShift_io_out_6 ),
       .io_out_5( crossbarShift_io_out_5 ),
       .io_out_4( crossbarShift_io_out_4 ),
       .io_out_3( crossbarShift_io_out_3 ),
       .io_out_2( crossbarShift_io_out_2 ),
       .io_out_1( crossbarShift_io_out_1 ),
       .io_out_0( crossbarShift_io_out_0 )
  );
  memArray memArray(.clk(clk), .reset(reset),
       .io_clk_en( io_clk_en ),
       .io_start( crossbarShift_io_start_next_stage ),
       .io_start_next_stage( memArray_io_start_next_stage ),
       .io_in_15( crossbarShift_io_out_15 ),
       .io_in_14( crossbarShift_io_out_14 ),
       .io_in_13( crossbarShift_io_out_13 ),
       .io_in_12( crossbarShift_io_out_12 ),
       .io_in_11( crossbarShift_io_out_11 ),
       .io_in_10( crossbarShift_io_out_10 ),
       .io_in_9( crossbarShift_io_out_9 ),
       .io_in_8( crossbarShift_io_out_8 ),
       .io_in_7( crossbarShift_io_out_7 ),
       .io_in_6( crossbarShift_io_out_6 ),
       .io_in_5( crossbarShift_io_out_5 ),
       .io_in_4( crossbarShift_io_out_4 ),
       .io_in_3( crossbarShift_io_out_3 ),
       .io_in_2( crossbarShift_io_out_2 ),
       .io_in_1( crossbarShift_io_out_1 ),
       .io_in_0( crossbarShift_io_out_0 ),
       .io_out_15( memArray_io_out_15 ),
       .io_out_14( memArray_io_out_14 ),
       .io_out_13( memArray_io_out_13 ),
       .io_out_12( memArray_io_out_12 ),
       .io_out_11( memArray_io_out_11 ),
       .io_out_10( memArray_io_out_10 ),
       .io_out_9( memArray_io_out_9 ),
       .io_out_8( memArray_io_out_8 ),
       .io_out_7( memArray_io_out_7 ),
       .io_out_6( memArray_io_out_6 ),
       .io_out_5( memArray_io_out_5 ),
       .io_out_4( memArray_io_out_4 ),
       .io_out_3( memArray_io_out_3 ),
       .io_out_2( memArray_io_out_2 ),
       .io_out_1( memArray_io_out_1 ),
       .io_out_0( memArray_io_out_0 )
  );
  crossbarShiftUp crossbarShift_1(.clk(clk), .reset(reset),
       .io_clk_en( io_clk_en ),
       .io_start( memArray_io_start_next_stage ),
       .io_start_next_stage( crossbarShift_1_io_start_next_stage ),
       .io_in_15( memArray_io_out_15 ),
       .io_in_14( memArray_io_out_14 ),
       .io_in_13( memArray_io_out_13 ),
       .io_in_12( memArray_io_out_12 ),
       .io_in_11( memArray_io_out_11 ),
       .io_in_10( memArray_io_out_10 ),
       .io_in_9( memArray_io_out_9 ),
       .io_in_8( memArray_io_out_8 ),
       .io_in_7( memArray_io_out_7 ),
       .io_in_6( memArray_io_out_6 ),
       .io_in_5( memArray_io_out_5 ),
       .io_in_4( memArray_io_out_4 ),
       .io_in_3( memArray_io_out_3 ),
       .io_in_2( memArray_io_out_2 ),
       .io_in_1( memArray_io_out_1 ),
       .io_in_0( memArray_io_out_0 ),
       .io_out_15( crossbarShift_1_io_out_15 ),
       .io_out_14( crossbarShift_1_io_out_14 ),
       .io_out_13( crossbarShift_1_io_out_13 ),
       .io_out_12( crossbarShift_1_io_out_12 ),
       .io_out_11( crossbarShift_1_io_out_11 ),
       .io_out_10( crossbarShift_1_io_out_10 ),
       .io_out_9( crossbarShift_1_io_out_9 ),
       .io_out_8( crossbarShift_1_io_out_8 ),
       .io_out_7( crossbarShift_1_io_out_7 ),
       .io_out_6( crossbarShift_1_io_out_6 ),
       .io_out_5( crossbarShift_1_io_out_5 ),
       .io_out_4( crossbarShift_1_io_out_4 ),
       .io_out_3( crossbarShift_1_io_out_3 ),
       .io_out_2( crossbarShift_1_io_out_2 ),
       .io_out_1( crossbarShift_1_io_out_1 ),
       .io_out_0( crossbarShift_1_io_out_0 )
  );
endmodule

module afu_user(input clk, input reset,
    input [511:0] input_fifo_din,
    input  input_fifo_we,
    output input_fifo_full,
    output input_fifo_almost_full,
    output[5:0] input_fifo_count,
    output[511:0] output_fifo_dout,
    input  output_fifo_re,
    output output_fifo_empty,
    output output_fifo_almost_empty,
    input [31:0] ctx_length
);

  wire T0;
  wire T1;
  wire T2;
  reg [31:0] ctx_output_count;
  wire[31:0] T46;
  wire[31:0] T3;
  wire[31:0] T4;
  wire[511:0] T5;
  wire[511:0] T6;
  wire[255:0] T7;
  wire[127:0] T8;
  wire[63:0] T9;
  wire[63:0] T10;
  wire[127:0] T11;
  wire[63:0] T12;
  wire[63:0] T13;
  wire[255:0] T14;
  wire[127:0] T15;
  wire[63:0] T16;
  wire[63:0] T17;
  wire[127:0] T18;
  wire[63:0] T19;
  wire[63:0] T20;
  wire[31:0] T21;
  wire[31:0] T22;
  wire[31:0] T23;
  wire[31:0] T24;
  wire[31:0] T25;
  wire[31:0] T26;
  wire[31:0] T27;
  wire[31:0] T28;
  wire[31:0] T29;
  wire[31:0] T30;
  wire[31:0] T31;
  wire[31:0] T32;
  wire[31:0] T33;
  wire[31:0] T34;
  wire[31:0] T35;
  wire[31:0] T36;
  reg  start_reg;
  wire T47;
  wire T37;
  wire T38;
  wire T39;
  wire T40;
  wire T41;
  reg [31:0] ctx_input_count;
  wire[31:0] T48;
  wire[31:0] T42;
  wire[31:0] T43;
  wire T44;
  wire T45;
  wire[5:0] T49;
  wire[511:0] syn_read_fifo_dout;
  wire syn_read_fifo_empty;
  wire syn_read_fifo_full;
  wire syn_read_fifo_count;
  wire syn_read_fifo_almostfull;
  wire[511:0] syn_read_fifo_1_dout;
  wire syn_read_fifo_1_empty;
  wire syn_read_fifo_1_almostempty;
  wire streamMatrixTransposeTop_io_start_next_stage;
  wire[31:0] streamMatrixTransposeTop_io_out_15;
  wire[31:0] streamMatrixTransposeTop_io_out_14;
  wire[31:0] streamMatrixTransposeTop_io_out_13;
  wire[31:0] streamMatrixTransposeTop_io_out_12;
  wire[31:0] streamMatrixTransposeTop_io_out_11;
  wire[31:0] streamMatrixTransposeTop_io_out_10;
  wire[31:0] streamMatrixTransposeTop_io_out_9;
  wire[31:0] streamMatrixTransposeTop_io_out_8;
  wire[31:0] streamMatrixTransposeTop_io_out_7;
  wire[31:0] streamMatrixTransposeTop_io_out_6;
  wire[31:0] streamMatrixTransposeTop_io_out_5;
  wire[31:0] streamMatrixTransposeTop_io_out_4;
  wire[31:0] streamMatrixTransposeTop_io_out_3;
  wire[31:0] streamMatrixTransposeTop_io_out_2;
  wire[31:0] streamMatrixTransposeTop_io_out_1;
  wire[31:0] streamMatrixTransposeTop_io_out_0;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    ctx_output_count = {1{$random}};
    start_reg = {1{$random}};
    ctx_input_count = {1{$random}};
  end
// synthesis translate_on
`endif

  assign T0 = T2 ? 1'h0 : T1;
  assign T1 = streamMatrixTransposeTop_io_start_next_stage & T40;
  assign T2 = ctx_length == ctx_output_count;
  assign T46 = reset ? 32'h0 : T3;
  assign T3 = T0 ? T4 : ctx_output_count;
  assign T4 = ctx_output_count + 32'h1;
  assign T5 = T6;
  assign T6 = {T14, T7};
  assign T7 = {T11, T8};
  assign T8 = {T10, T9};
  assign T9 = {streamMatrixTransposeTop_io_out_1, streamMatrixTransposeTop_io_out_0};
  assign T10 = {streamMatrixTransposeTop_io_out_3, streamMatrixTransposeTop_io_out_2};
  assign T11 = {T13, T12};
  assign T12 = {streamMatrixTransposeTop_io_out_5, streamMatrixTransposeTop_io_out_4};
  assign T13 = {streamMatrixTransposeTop_io_out_7, streamMatrixTransposeTop_io_out_6};
  assign T14 = {T18, T15};
  assign T15 = {T17, T16};
  assign T16 = {streamMatrixTransposeTop_io_out_9, streamMatrixTransposeTop_io_out_8};
  assign T17 = {streamMatrixTransposeTop_io_out_11, streamMatrixTransposeTop_io_out_10};
  assign T18 = {T20, T19};
  assign T19 = {streamMatrixTransposeTop_io_out_13, streamMatrixTransposeTop_io_out_12};
  assign T20 = {streamMatrixTransposeTop_io_out_15, streamMatrixTransposeTop_io_out_14};
  assign T21 = syn_read_fifo_dout[31:0];
  assign T22 = syn_read_fifo_dout[63:32];
  assign T23 = syn_read_fifo_dout[95:64];
  assign T24 = syn_read_fifo_dout[127:96];
  assign T25 = syn_read_fifo_dout[159:128];
  assign T26 = syn_read_fifo_dout[191:160];
  assign T27 = syn_read_fifo_dout[223:192];
  assign T28 = syn_read_fifo_dout[255:224];
  assign T29 = syn_read_fifo_dout[287:256];
  assign T30 = syn_read_fifo_dout[319:288];
  assign T31 = syn_read_fifo_dout[351:320];
  assign T32 = syn_read_fifo_dout[383:352];
  assign T33 = syn_read_fifo_dout[415:384];
  assign T34 = syn_read_fifo_dout[447:416];
  assign T35 = syn_read_fifo_dout[479:448];
  assign T36 = syn_read_fifo_dout[511:480];
  assign T47 = reset ? 1'h0 : T37;
  assign T37 = T39 ? 1'h0 : T38;
  assign T38 = T44 ? 1'h1 : start_reg;
  assign T39 = T44 ^ 1'h1;
  assign T40 = T41 ? 1'h1 : start_reg;
  assign T41 = ctx_length == ctx_input_count;
  assign T48 = reset ? 32'h0 : T42;
  assign T42 = T44 ? T43 : ctx_input_count;
  assign T43 = ctx_input_count + 32'h1;
  assign T44 = reset ? 1'h0 : T45;
  assign T45 = ~ syn_read_fifo_empty;
  assign output_fifo_almost_empty = syn_read_fifo_1_almostempty;
  assign output_fifo_empty = syn_read_fifo_1_empty;
  assign output_fifo_dout = syn_read_fifo_1_dout;
  assign input_fifo_count = T49;
  assign T49 = {5'h0, syn_read_fifo_count};
  assign input_fifo_almost_full = syn_read_fifo_almostfull;
  assign input_fifo_full = syn_read_fifo_full;
  syn_read_fifo #(.FIFO_WIDTH(512),.FIFO_DEPTH_BITS(6),.FIFO_ALMOSTFULL_THRESHOLD(60),.FIFO_ALMOSTEMPTY_THRESHOLD(2))
  syn_read_fifo(.clk(clk), .reset(reset),
       .din( input_fifo_din ),
       .we( input_fifo_we ),
       .re( T44 ),
       .dout( syn_read_fifo_dout ),
       .empty( syn_read_fifo_empty ),
       //.almostempty(  )
       .full( syn_read_fifo_full ),
       .count( syn_read_fifo_count ),
       .almostfull( syn_read_fifo_almostfull )
  );
  streamMatrixTransposeTop streamMatrixTransposeTop(.clk(clk), .reset(reset),
       .io_clk_en( T40 ),
       .io_start( start_reg ),
       .io_start_next_stage( streamMatrixTransposeTop_io_start_next_stage ),
       .io_in_15( T36 ),
       .io_in_14( T35 ),
       .io_in_13( T34 ),
       .io_in_12( T33 ),
       .io_in_11( T32 ),
       .io_in_10( T31 ),
       .io_in_9( T30 ),
       .io_in_8( T29 ),
       .io_in_7( T28 ),
       .io_in_6( T27 ),
       .io_in_5( T26 ),
       .io_in_4( T25 ),
       .io_in_3( T24 ),
       .io_in_2( T23 ),
       .io_in_1( T22 ),
       .io_in_0( T21 ),
       .io_out_15( streamMatrixTransposeTop_io_out_15 ),
       .io_out_14( streamMatrixTransposeTop_io_out_14 ),
       .io_out_13( streamMatrixTransposeTop_io_out_13 ),
       .io_out_12( streamMatrixTransposeTop_io_out_12 ),
       .io_out_11( streamMatrixTransposeTop_io_out_11 ),
       .io_out_10( streamMatrixTransposeTop_io_out_10 ),
       .io_out_9( streamMatrixTransposeTop_io_out_9 ),
       .io_out_8( streamMatrixTransposeTop_io_out_8 ),
       .io_out_7( streamMatrixTransposeTop_io_out_7 ),
       .io_out_6( streamMatrixTransposeTop_io_out_6 ),
       .io_out_5( streamMatrixTransposeTop_io_out_5 ),
       .io_out_4( streamMatrixTransposeTop_io_out_4 ),
       .io_out_3( streamMatrixTransposeTop_io_out_3 ),
       .io_out_2( streamMatrixTransposeTop_io_out_2 ),
       .io_out_1( streamMatrixTransposeTop_io_out_1 ),
       .io_out_0( streamMatrixTransposeTop_io_out_0 )
  );
  syn_read_fifo #(.FIFO_WIDTH(512),.FIFO_DEPTH_BITS(6),.FIFO_ALMOSTFULL_THRESHOLD(60),.FIFO_ALMOSTEMPTY_THRESHOLD(2))
  syn_read_fifo_1(.clk(clk), .reset(reset),
       .din( T5 ),
       .we( T0 ),
       .re( output_fifo_re ),
       .dout( syn_read_fifo_1_dout ),
       .empty( syn_read_fifo_1_empty ),
       .almostempty( syn_read_fifo_1_almostempty )
       //.full(  )
       //.count(  )
       //.almostfull(  )
  );

  always @(posedge clk) begin
    if(reset) begin
      ctx_output_count <= 32'h0;
    end else if(T0) begin
      ctx_output_count <= T4;
    end
    if(reset) begin
      start_reg <= 1'h0;
    end else if(T39) begin
      start_reg <= 1'h0;
    end else if(T44) begin
      start_reg <= 1'h1;
    end
    if(reset) begin
      ctx_input_count <= 32'h0;
    end else if(T44) begin
      ctx_input_count <= T43;
    end
  end
endmodule

