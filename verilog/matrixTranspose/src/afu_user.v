module afu_user # (
  parameter DATA_WIDTH = 32,
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

  assign in0 = input_fifo_dout[31:0];
  assign in1 = input_fifo_dout[63:32];
  assign in2 = input_fifo_dout[95:64];
  assign in3 = input_fifo_dout[127:96];
  assign in4 = input_fifo_dout[159:128];
  assign in5 = input_fifo_dout[191:160];
  assign in6 = input_fifo_dout[223:192];
  assign in7 = input_fifo_dout[255:224];
  assign in8 = input_fifo_dout[287:256];
  assign in9 = input_fifo_dout[319:288];
  assign in10 = input_fifo_dout[351:320];
  assign in11 = input_fifo_dout[383:352];
  assign in12 = input_fifo_dout[415:384];
  assign in13 = input_fifo_dout[447:416];
  assign in14 = input_fifo_dout[479:448];
  assign in15 = input_fifo_dout[511:480];

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

  streamMatrixTransposeTop # (
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
    .out15(out15)
  );

  wire output_fifo_we;

  reg [31:0] ctx_output_count;

  always@(posedge clk) begin
    if (reset) begin
      ctx_output_count <= 0;
    end else if (output_fifo_we) begin
      ctx_output_count <= ctx_output_count + 1'b1;
    end
  end

  assign output_fifo_we = (ctx_length == ctx_output_count) ? 1'b0 : start_next_stage & clk_en;

  reg [31:0] run_time_count;
  always @(posedge clk) begin : proc_run_time_count
    if(reset) begin
      run_time_count <= 0;
    end else if(clk_en && ctx_length != ctx_output_count) begin
      run_time_count <= run_time_count + 1'b1;
    end
  end

  // total_time_count
  reg [31:0] total_time_count;
  reg total_time_count_state;
  localparam IDLE = 1'b0;
  localparam RUN = 1'b1;
  always @(posedge clk) begin : proc_total_time_count
    if(reset) begin
      total_time_count <= 0;
      total_time_count_state <= IDLE;
    end else begin
      case (total_time_count_state)
        IDLE: begin
          total_time_count <= total_time_count + 1'b1;
          if (clk_en) begin
            total_time_count_state <= RUN;
          end
        end

        RUN: begin
          if (ctx_length != ctx_output_count) begin
            total_time_count <= total_time_count + 1'b1;
          end
        end
      endcase // total_time_count_state
    end
  end

  wire [511:0] uut_dout = {out15, out14, out13, out12, out11, out10, out9, out8, 
                            out7, out6, out5, out4, out3, out2, out1, out0
                            };

  assign output_fifo_din = (ctx_length - 1 == ctx_output_count) ? {448'b0, total_time_count, run_time_count} : uut_dout;

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
