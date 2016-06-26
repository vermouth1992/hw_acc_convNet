/* ../verilog/matrixTranspose/src/memArray2x32.v
 * This file is automatically generated by Chi Zhang
 * k = 4, M = 8
 */
module memArray2x32 # (
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
  output [DATA_WIDTH-1:0] out0,
  output [DATA_WIDTH-1:0] out1,
  output [DATA_WIDTH-1:0] out2,
  output [DATA_WIDTH-1:0] out3,
  output [DATA_WIDTH-1:0] out4,
  output [DATA_WIDTH-1:0] out5,
  output [DATA_WIDTH-1:0] out6,
  output [DATA_WIDTH-1:0] out7,
  output [DATA_WIDTH-1:0] out8,
  output [DATA_WIDTH-1:0] out9,
  output [DATA_WIDTH-1:0] out10,
  output [DATA_WIDTH-1:0] out11,
  output [DATA_WIDTH-1:0] out12,
  output [DATA_WIDTH-1:0] out13,
  output [DATA_WIDTH-1:0] out14,
  output [DATA_WIDTH-1:0] out15,
  output [DATA_WIDTH-1:0] out16,
  output [DATA_WIDTH-1:0] out17,
  output [DATA_WIDTH-1:0] out18,
  output [DATA_WIDTH-1:0] out19,
  output [DATA_WIDTH-1:0] out20,
  output [DATA_WIDTH-1:0] out21,
  output [DATA_WIDTH-1:0] out22,
  output [DATA_WIDTH-1:0] out23,
  output [DATA_WIDTH-1:0] out24,
  output [DATA_WIDTH-1:0] out25,
  output [DATA_WIDTH-1:0] out26,
  output [DATA_WIDTH-1:0] out27,
  output [DATA_WIDTH-1:0] out28,
  output [DATA_WIDTH-1:0] out29,
  output [DATA_WIDTH-1:0] out30,
  output [DATA_WIDTH-1:0] out31,
  output reg [1-1:0] start_next_stage
);

  reg [1-1:0] addr0_3;
  reg [1-1:0] addr4_7;
  reg [1-1:0] addr8_11;
  reg [1-1:0] addr12_15;
  reg [1-1:0] addr16_19;
  reg [1-1:0] addr20_23;
  reg [1-1:0] addr24_27;
  reg [1-1:0] addr28_31;

  localparam IDLE = 2'b00;
  localparam P1 = 2'b01;
  localparam P2 = 2'b10;

  reg [2-1:0] state;
  reg [1-1:0] counter;

  always@(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counter <= 1'b0;
      start_next_stage <= 1'b0;
      addr0_3 <= 1'b0;
      addr4_7 <= 1'b0;
      addr8_11 <= 1'b0;
      addr12_15 <= 1'b0;
      addr16_19 <= 1'b0;
      addr20_23 <= 1'b0;
      addr24_27 <= 1'b0;
      addr28_31 <= 1'b0;
    end else if (clk_en & start) begin
      case(state)
        IDLE: begin
          state <= P1;
          counter <= counter + 1'b1;
          addr0_3 <= addr0_3 + 1'b1;
          addr4_7 <= addr4_7 + 1'b1;
          addr8_11 <= addr8_11 + 1'b1;
          addr12_15 <= addr12_15 + 1'b1;
          addr16_19 <= addr16_19 + 1'b1;
          addr20_23 <= addr20_23 + 1'b1;
          addr24_27 <= addr24_27 + 1'b1;
          addr28_31 <= addr28_31 + 1'b1;
        end
        P1: begin
          counter <= counter + 1'b1;
          if (counter == 1'b1) begin
            state <= P2;
            addr0_3 <= 1'b0;
            addr4_7 <= 1'b1;
            addr8_11 <= 1'b0;
            addr12_15 <= 1'b1;
            addr16_19 <= 1'b0;
            addr20_23 <= 1'b1;
            addr24_27 <= 1'b0;
            addr28_31 <= 1'b1;
          end else begin
            state <= P1;
            addr0_3 <= addr0_3 + 1'b1;
            addr4_7 <= addr4_7 + 1'b1;
            addr8_11 <= addr8_11 + 1'b1;
            addr12_15 <= addr12_15 + 1'b1;
            addr16_19 <= addr16_19 + 1'b1;
            addr20_23 <= addr20_23 + 1'b1;
            addr24_27 <= addr24_27 + 1'b1;
            addr28_31 <= addr28_31 + 1'b1;
          end
        end
        P2: begin
          counter <= counter + 1'b1;
          start_next_stage <= 1'b1;
          if (counter == 1'b1) begin
            state <= P1;
            addr0_3 <= 1'b0;
            addr4_7 <= 1'b0;
            addr8_11 <= 1'b0;
            addr12_15 <= 1'b0;
            addr16_19 <= 1'b0;
            addr20_23 <= 1'b0;
            addr24_27 <= 1'b0;
            addr28_31 <= 1'b0;
          end else begin
            state <= P2;
            addr0_3 <= addr0_3 - 1'b1;
            addr4_7 <= addr4_7 - 1'b1;
            addr8_11 <= addr8_11 - 1'b1;
            addr12_15 <= addr12_15 - 1'b1;
            addr16_19 <= addr16_19 - 1'b1;
            addr20_23 <= addr20_23 - 1'b1;
            addr24_27 <= addr24_27 - 1'b1;
            addr28_31 <= addr28_31 - 1'b1;
          end
        end
        default: begin end
      endcase
    end
  end

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem0 (
    .data(in0),
    .addr(addr0_3),
    .we(start & clk_en),
    .clk(clk),
    .q(out0)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem1 (
    .data(in1),
    .addr(addr0_3),
    .we(start & clk_en),
    .clk(clk),
    .q(out1)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem2 (
    .data(in2),
    .addr(addr0_3),
    .we(start & clk_en),
    .clk(clk),
    .q(out2)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem3 (
    .data(in3),
    .addr(addr0_3),
    .we(start & clk_en),
    .clk(clk),
    .q(out3)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem4 (
    .data(in4),
    .addr(addr4_7),
    .we(start & clk_en),
    .clk(clk),
    .q(out4)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem5 (
    .data(in5),
    .addr(addr4_7),
    .we(start & clk_en),
    .clk(clk),
    .q(out5)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem6 (
    .data(in6),
    .addr(addr4_7),
    .we(start & clk_en),
    .clk(clk),
    .q(out6)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem7 (
    .data(in7),
    .addr(addr4_7),
    .we(start & clk_en),
    .clk(clk),
    .q(out7)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem8 (
    .data(in8),
    .addr(addr8_11),
    .we(start & clk_en),
    .clk(clk),
    .q(out8)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem9 (
    .data(in9),
    .addr(addr8_11),
    .we(start & clk_en),
    .clk(clk),
    .q(out9)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem10 (
    .data(in10),
    .addr(addr8_11),
    .we(start & clk_en),
    .clk(clk),
    .q(out10)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem11 (
    .data(in11),
    .addr(addr8_11),
    .we(start & clk_en),
    .clk(clk),
    .q(out11)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem12 (
    .data(in12),
    .addr(addr12_15),
    .we(start & clk_en),
    .clk(clk),
    .q(out12)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem13 (
    .data(in13),
    .addr(addr12_15),
    .we(start & clk_en),
    .clk(clk),
    .q(out13)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem14 (
    .data(in14),
    .addr(addr12_15),
    .we(start & clk_en),
    .clk(clk),
    .q(out14)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem15 (
    .data(in15),
    .addr(addr12_15),
    .we(start & clk_en),
    .clk(clk),
    .q(out15)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem16 (
    .data(in16),
    .addr(addr16_19),
    .we(start & clk_en),
    .clk(clk),
    .q(out16)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem17 (
    .data(in17),
    .addr(addr16_19),
    .we(start & clk_en),
    .clk(clk),
    .q(out17)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem18 (
    .data(in18),
    .addr(addr16_19),
    .we(start & clk_en),
    .clk(clk),
    .q(out18)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem19 (
    .data(in19),
    .addr(addr16_19),
    .we(start & clk_en),
    .clk(clk),
    .q(out19)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem20 (
    .data(in20),
    .addr(addr20_23),
    .we(start & clk_en),
    .clk(clk),
    .q(out20)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem21 (
    .data(in21),
    .addr(addr20_23),
    .we(start & clk_en),
    .clk(clk),
    .q(out21)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem22 (
    .data(in22),
    .addr(addr20_23),
    .we(start & clk_en),
    .clk(clk),
    .q(out22)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem23 (
    .data(in23),
    .addr(addr20_23),
    .we(start & clk_en),
    .clk(clk),
    .q(out23)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem24 (
    .data(in24),
    .addr(addr24_27),
    .we(start & clk_en),
    .clk(clk),
    .q(out24)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem25 (
    .data(in25),
    .addr(addr24_27),
    .we(start & clk_en),
    .clk(clk),
    .q(out25)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem26 (
    .data(in26),
    .addr(addr24_27),
    .we(start & clk_en),
    .clk(clk),
    .q(out26)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem27 (
    .data(in27),
    .addr(addr24_27),
    .we(start & clk_en),
    .clk(clk),
    .q(out27)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem28 (
    .data(in28),
    .addr(addr28_31),
    .we(start & clk_en),
    .clk(clk),
    .q(out28)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem29 (
    .data(in29),
    .addr(addr28_31),
    .we(start & clk_en),
    .clk(clk),
    .q(out29)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem30 (
    .data(in30),
    .addr(addr28_31),
    .we(start & clk_en),
    .clk(clk),
    .q(out30)
  );

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(1)
    ) mem31 (
    .data(in31),
    .addr(addr28_31),
    .we(start & clk_en),
    .clk(clk),
    .q(out31)
  );

endmodule
