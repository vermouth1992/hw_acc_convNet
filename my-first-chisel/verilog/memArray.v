module single_port_ram(input clk,
    input [31:0] io_data,
    input [1:0] io_addr,
    input  io_we,
    output[31:0] io_q
);

  reg [31:0] out;
  wire[31:0] T0;
  wire[31:0] T1;
  reg [31:0] myMem [3:0];
  wire[31:0] T2;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    out = {1{$random}};
    for (initvar = 0; initvar < 4; initvar = initvar+1)
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
  reg [1:0] address_7;
  wire[1:0] T105;
  wire[1:0] T1;
  wire[1:0] T2;
  wire[1:0] T3;
  wire[1:0] T4;
  wire[1:0] T5;
  wire[1:0] T6;
  wire T7;
  wire T8;
  reg [1:0] state;
  wire[1:0] T106;
  wire[1:0] T9;
  wire[1:0] T10;
  wire[1:0] T11;
  wire T12;
  wire T13;
  wire T14;
  reg [1:0] counter;
  wire[1:0] T107;
  wire[1:0] T15;
  wire[1:0] T16;
  wire[1:0] T17;
  wire[1:0] T18;
  wire[1:0] T19;
  wire[1:0] T20;
  wire T21;
  wire T22;
  wire T23;
  wire T24;
  wire[1:0] T25;
  wire T26;
  wire T27;
  wire T28;
  wire T29;
  wire[1:0] T30;
  wire T31;
  wire T32;
  wire T33;
  wire T34;
  reg [1:0] address_6;
  wire[1:0] T108;
  wire[1:0] T35;
  wire[1:0] T36;
  wire[1:0] T37;
  wire[1:0] T38;
  wire[1:0] T39;
  wire[1:0] T40;
  wire[1:0] T41;
  wire[1:0] T42;
  wire T43;
  wire T44;
  reg [1:0] address_5;
  wire[1:0] T109;
  wire[1:0] T45;
  wire[1:0] T46;
  wire[1:0] T47;
  wire[1:0] T48;
  wire[1:0] T49;
  wire[1:0] T50;
  wire[1:0] T51;
  wire[1:0] T52;
  wire T53;
  wire T54;
  reg [1:0] address_4;
  wire[1:0] T110;
  wire[1:0] T55;
  wire[1:0] T56;
  wire[1:0] T57;
  wire[1:0] T58;
  wire[1:0] T59;
  wire[1:0] T60;
  wire[1:0] T61;
  wire[1:0] T62;
  wire T63;
  wire T64;
  reg [1:0] address_3;
  wire[1:0] T111;
  wire[1:0] T65;
  wire[1:0] T66;
  wire[1:0] T67;
  wire[1:0] T68;
  wire[1:0] T69;
  wire[1:0] T70;
  wire[1:0] T71;
  wire[1:0] T72;
  wire T73;
  wire T74;
  reg [1:0] address_2;
  wire[1:0] T112;
  wire[1:0] T75;
  wire[1:0] T76;
  wire[1:0] T77;
  wire[1:0] T78;
  wire[1:0] T79;
  wire[1:0] T80;
  wire[1:0] T81;
  wire[1:0] T82;
  wire T83;
  wire T84;
  reg [1:0] address_1;
  wire[1:0] T113;
  wire[1:0] T85;
  wire[1:0] T86;
  wire[1:0] T87;
  wire[1:0] T88;
  wire[1:0] T89;
  wire[1:0] T90;
  wire[1:0] T91;
  wire[1:0] T92;
  wire T93;
  wire T94;
  reg [1:0] address_0;
  wire[1:0] T114;
  wire[1:0] T95;
  wire[1:0] T96;
  wire[1:0] T97;
  wire[1:0] T98;
  wire[1:0] T99;
  wire[1:0] T100;
  wire[1:0] T101;
  wire[1:0] T102;
  wire T103;
  reg  start_next_stage_reg;
  wire T115;
  wire T104;
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
    address_7 = {1{$random}};
    state = {1{$random}};
    counter = {1{$random}};
    address_6 = {1{$random}};
    address_5 = {1{$random}};
    address_4 = {1{$random}};
    address_3 = {1{$random}};
    address_2 = {1{$random}};
    address_1 = {1{$random}};
    address_0 = {1{$random}};
    start_next_stage_reg = {1{$random}};
  end
// synthesis translate_on
`endif

  assign T0 = io_start & io_clk_en;
  assign T105 = reset ? 2'h0 : T1;
  assign T1 = T31 ? T30 : T2;
  assign T2 = T28 ? 2'h0 : T3;
  assign T3 = T26 ? T25 : T4;
  assign T4 = T13 ? 2'h3 : T5;
  assign T5 = T7 ? T6 : address_7;
  assign T6 = address_7 + 2'h1;
  assign T7 = T12 & T8;
  assign T8 = state == 2'h0;
  assign T106 = reset ? 2'h0 : T9;
  assign T9 = T28 ? 2'h1 : T10;
  assign T10 = T13 ? 2'h2 : T11;
  assign T11 = T7 ? 2'h1 : state;
  assign T12 = io_clk_en & io_start;
  assign T13 = T23 & T14;
  assign T14 = counter == 2'h3;
  assign T107 = reset ? 2'h0 : T15;
  assign T15 = T21 ? T20 : T16;
  assign T16 = T23 ? T19 : T17;
  assign T17 = T7 ? T18 : counter;
  assign T18 = counter + 2'h1;
  assign T19 = counter + 2'h1;
  assign T20 = counter + 2'h1;
  assign T21 = T12 & T22;
  assign T22 = state == 2'h2;
  assign T23 = T12 & T24;
  assign T24 = state == 2'h1;
  assign T25 = address_7 + 2'h1;
  assign T26 = T23 & T27;
  assign T27 = T14 ^ 1'h1;
  assign T28 = T21 & T29;
  assign T29 = counter == 2'h3;
  assign T30 = address_7 - 2'h1;
  assign T31 = T21 & T32;
  assign T32 = T29 ^ 1'h1;
  assign T33 = io_start & io_clk_en;
  assign T34 = io_start & io_clk_en;
  assign T108 = reset ? 2'h0 : T35;
  assign T35 = T31 ? T42 : T36;
  assign T36 = T28 ? 2'h0 : T37;
  assign T37 = T26 ? T41 : T38;
  assign T38 = T13 ? 2'h2 : T39;
  assign T39 = T7 ? T40 : address_6;
  assign T40 = address_6 + 2'h1;
  assign T41 = address_6 + 2'h1;
  assign T42 = address_6 - 2'h1;
  assign T43 = io_start & io_clk_en;
  assign T44 = io_start & io_clk_en;
  assign T109 = reset ? 2'h0 : T45;
  assign T45 = T31 ? T52 : T46;
  assign T46 = T28 ? 2'h0 : T47;
  assign T47 = T26 ? T51 : T48;
  assign T48 = T13 ? 2'h1 : T49;
  assign T49 = T7 ? T50 : address_5;
  assign T50 = address_5 + 2'h1;
  assign T51 = address_5 + 2'h1;
  assign T52 = address_5 - 2'h1;
  assign T53 = io_start & io_clk_en;
  assign T54 = io_start & io_clk_en;
  assign T110 = reset ? 2'h0 : T55;
  assign T55 = T31 ? T62 : T56;
  assign T56 = T28 ? 2'h0 : T57;
  assign T57 = T26 ? T61 : T58;
  assign T58 = T13 ? 2'h0 : T59;
  assign T59 = T7 ? T60 : address_4;
  assign T60 = address_4 + 2'h1;
  assign T61 = address_4 + 2'h1;
  assign T62 = address_4 - 2'h1;
  assign T63 = io_start & io_clk_en;
  assign T64 = io_start & io_clk_en;
  assign T111 = reset ? 2'h0 : T65;
  assign T65 = T31 ? T72 : T66;
  assign T66 = T28 ? 2'h0 : T67;
  assign T67 = T26 ? T71 : T68;
  assign T68 = T13 ? 2'h3 : T69;
  assign T69 = T7 ? T70 : address_3;
  assign T70 = address_3 + 2'h1;
  assign T71 = address_3 + 2'h1;
  assign T72 = address_3 - 2'h1;
  assign T73 = io_start & io_clk_en;
  assign T74 = io_start & io_clk_en;
  assign T112 = reset ? 2'h0 : T75;
  assign T75 = T31 ? T82 : T76;
  assign T76 = T28 ? 2'h0 : T77;
  assign T77 = T26 ? T81 : T78;
  assign T78 = T13 ? 2'h2 : T79;
  assign T79 = T7 ? T80 : address_2;
  assign T80 = address_2 + 2'h1;
  assign T81 = address_2 + 2'h1;
  assign T82 = address_2 - 2'h1;
  assign T83 = io_start & io_clk_en;
  assign T84 = io_start & io_clk_en;
  assign T113 = reset ? 2'h0 : T85;
  assign T85 = T31 ? T92 : T86;
  assign T86 = T28 ? 2'h0 : T87;
  assign T87 = T26 ? T91 : T88;
  assign T88 = T13 ? 2'h1 : T89;
  assign T89 = T7 ? T90 : address_1;
  assign T90 = address_1 + 2'h1;
  assign T91 = address_1 + 2'h1;
  assign T92 = address_1 - 2'h1;
  assign T93 = io_start & io_clk_en;
  assign T94 = io_start & io_clk_en;
  assign T114 = reset ? 2'h0 : T95;
  assign T95 = T31 ? T102 : T96;
  assign T96 = T28 ? 2'h0 : T97;
  assign T97 = T26 ? T101 : T98;
  assign T98 = T13 ? 2'h0 : T99;
  assign T99 = T7 ? T100 : address_0;
  assign T100 = address_0 + 2'h1;
  assign T101 = address_0 + 2'h1;
  assign T102 = address_0 - 2'h1;
  assign T103 = io_start & io_clk_en;
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
  assign T115 = reset ? 1'h0 : T104;
  assign T104 = T21 ? 1'h1 : start_next_stage_reg;
  single_port_ram single_port_ram(.clk(clk),
       .io_data( io_in_0 ),
       .io_addr( address_0 ),
       .io_we( T103 ),
       .io_q( single_port_ram_io_q )
  );
  single_port_ram single_port_ram_1(.clk(clk),
       .io_data( io_in_1 ),
       .io_addr( address_0 ),
       .io_we( T94 ),
       .io_q( single_port_ram_1_io_q )
  );
  single_port_ram single_port_ram_2(.clk(clk),
       .io_data( io_in_2 ),
       .io_addr( address_1 ),
       .io_we( T93 ),
       .io_q( single_port_ram_2_io_q )
  );
  single_port_ram single_port_ram_3(.clk(clk),
       .io_data( io_in_3 ),
       .io_addr( address_1 ),
       .io_we( T84 ),
       .io_q( single_port_ram_3_io_q )
  );
  single_port_ram single_port_ram_4(.clk(clk),
       .io_data( io_in_4 ),
       .io_addr( address_2 ),
       .io_we( T83 ),
       .io_q( single_port_ram_4_io_q )
  );
  single_port_ram single_port_ram_5(.clk(clk),
       .io_data( io_in_5 ),
       .io_addr( address_2 ),
       .io_we( T74 ),
       .io_q( single_port_ram_5_io_q )
  );
  single_port_ram single_port_ram_6(.clk(clk),
       .io_data( io_in_6 ),
       .io_addr( address_3 ),
       .io_we( T73 ),
       .io_q( single_port_ram_6_io_q )
  );
  single_port_ram single_port_ram_7(.clk(clk),
       .io_data( io_in_7 ),
       .io_addr( address_3 ),
       .io_we( T64 ),
       .io_q( single_port_ram_7_io_q )
  );
  single_port_ram single_port_ram_8(.clk(clk),
       .io_data( io_in_8 ),
       .io_addr( address_4 ),
       .io_we( T63 ),
       .io_q( single_port_ram_8_io_q )
  );
  single_port_ram single_port_ram_9(.clk(clk),
       .io_data( io_in_9 ),
       .io_addr( address_4 ),
       .io_we( T54 ),
       .io_q( single_port_ram_9_io_q )
  );
  single_port_ram single_port_ram_10(.clk(clk),
       .io_data( io_in_10 ),
       .io_addr( address_5 ),
       .io_we( T53 ),
       .io_q( single_port_ram_10_io_q )
  );
  single_port_ram single_port_ram_11(.clk(clk),
       .io_data( io_in_11 ),
       .io_addr( address_5 ),
       .io_we( T44 ),
       .io_q( single_port_ram_11_io_q )
  );
  single_port_ram single_port_ram_12(.clk(clk),
       .io_data( io_in_12 ),
       .io_addr( address_6 ),
       .io_we( T43 ),
       .io_q( single_port_ram_12_io_q )
  );
  single_port_ram single_port_ram_13(.clk(clk),
       .io_data( io_in_13 ),
       .io_addr( address_6 ),
       .io_we( T34 ),
       .io_q( single_port_ram_13_io_q )
  );
  single_port_ram single_port_ram_14(.clk(clk),
       .io_data( io_in_14 ),
       .io_addr( address_7 ),
       .io_we( T33 ),
       .io_q( single_port_ram_14_io_q )
  );
  single_port_ram single_port_ram_15(.clk(clk),
       .io_data( io_in_15 ),
       .io_addr( address_7 ),
       .io_we( T0 ),
       .io_q( single_port_ram_15_io_q )
  );

  always @(posedge clk) begin
    if(reset) begin
      address_7 <= 2'h0;
    end else if(T31) begin
      address_7 <= T30;
    end else if(T28) begin
      address_7 <= 2'h0;
    end else if(T26) begin
      address_7 <= T25;
    end else if(T13) begin
      address_7 <= 2'h3;
    end else if(T7) begin
      address_7 <= T6;
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
      counter <= 2'h0;
    end else if(T21) begin
      counter <= T20;
    end else if(T23) begin
      counter <= T19;
    end else if(T7) begin
      counter <= T18;
    end
    if(reset) begin
      address_6 <= 2'h0;
    end else if(T31) begin
      address_6 <= T42;
    end else if(T28) begin
      address_6 <= 2'h0;
    end else if(T26) begin
      address_6 <= T41;
    end else if(T13) begin
      address_6 <= 2'h2;
    end else if(T7) begin
      address_6 <= T40;
    end
    if(reset) begin
      address_5 <= 2'h0;
    end else if(T31) begin
      address_5 <= T52;
    end else if(T28) begin
      address_5 <= 2'h0;
    end else if(T26) begin
      address_5 <= T51;
    end else if(T13) begin
      address_5 <= 2'h1;
    end else if(T7) begin
      address_5 <= T50;
    end
    if(reset) begin
      address_4 <= 2'h0;
    end else if(T31) begin
      address_4 <= T62;
    end else if(T28) begin
      address_4 <= 2'h0;
    end else if(T26) begin
      address_4 <= T61;
    end else if(T13) begin
      address_4 <= 2'h0;
    end else if(T7) begin
      address_4 <= T60;
    end
    if(reset) begin
      address_3 <= 2'h0;
    end else if(T31) begin
      address_3 <= T72;
    end else if(T28) begin
      address_3 <= 2'h0;
    end else if(T26) begin
      address_3 <= T71;
    end else if(T13) begin
      address_3 <= 2'h3;
    end else if(T7) begin
      address_3 <= T70;
    end
    if(reset) begin
      address_2 <= 2'h0;
    end else if(T31) begin
      address_2 <= T82;
    end else if(T28) begin
      address_2 <= 2'h0;
    end else if(T26) begin
      address_2 <= T81;
    end else if(T13) begin
      address_2 <= 2'h2;
    end else if(T7) begin
      address_2 <= T80;
    end
    if(reset) begin
      address_1 <= 2'h0;
    end else if(T31) begin
      address_1 <= T92;
    end else if(T28) begin
      address_1 <= 2'h0;
    end else if(T26) begin
      address_1 <= T91;
    end else if(T13) begin
      address_1 <= 2'h1;
    end else if(T7) begin
      address_1 <= T90;
    end
    if(reset) begin
      address_0 <= 2'h0;
    end else if(T31) begin
      address_0 <= T102;
    end else if(T28) begin
      address_0 <= 2'h0;
    end else if(T26) begin
      address_0 <= T101;
    end else if(T13) begin
      address_0 <= 2'h0;
    end else if(T7) begin
      address_0 <= T100;
    end
    if(reset) begin
      start_next_stage_reg <= 1'h0;
    end else if(T21) begin
      start_next_stage_reg <= 1'h1;
    end
  end
endmodule

