module streamMatrixTransposeFSM_handwritten (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input reset,  // Synchronous reset active high
  input shift_down_enable,
  input shift_up_enable,
  output timestamp_down,
  output timestamp_up,
  output reg addr0_3,
  output reg addr4_7,
  output reg addr8_11,
  output reg addr12_15,
  output reg addr16_19,
  output reg addr20_23,
  output reg addr24_27,
  output reg addr28_31
);

  reg timestamp_down_reg;
  // the first shift down
  always@(posedge clk) begin
    if (reset) begin
      timestamp_down_reg <= 1'b0;
    end else if (clk_en && shift_down_enable) begin
      timestamp_down_reg <= timestamp_down_reg + 1'b1;
    end
  end

  assign timestamp_down = timestamp_down_reg;

  reg timestamp_up_reg;
  // the third shift up
  always@(posedge clk) begin
    if (reset) begin
      timestamp_up_reg <= 1'b0;
    end else if (clk_en && shift_up_enable) begin
      timestamp_up_reg <= timestamp_up_reg + 1'b1;
    end
  end

  assign timestamp_up = timestamp_up_reg;

  // the address pattern
  localparam IDLE = 2'b00;
  localparam P1 = 2'b01;
  localparam P2 = 2'b10;

  reg [1:0] state;
  reg []

  always@(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      addr0_3 <= 1'b0;
      ...
    end else if 


endmodule