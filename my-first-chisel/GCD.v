module GCD(input clk,
    input [15:0] io_a,
    input [15:0] io_b,
    input  io_e,
    output[15:0] io_z,
    output io_v
);

  wire T0;
  reg [15:0] y;
  wire[15:0] T1;
  wire[15:0] T2;
  wire[15:0] T3;
  reg [15:0] x;
  wire[15:0] T4;
  wire[15:0] T5;
  wire[15:0] T6;
  wire T7;
  wire T8;
  wire T9;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    y = {1{$random}};
    x = {1{$random}};
  end
// synthesis translate_on
`endif

  assign io_v = T0;
  assign T0 = y == 16'h0;
  assign T1 = io_e ? io_b : T2;
  assign T2 = T8 ? T3 : y;
  assign T3 = y - x;
  assign T4 = io_e ? io_a : T5;
  assign T5 = T7 ? T6 : x;
  assign T6 = x - y;
  assign T7 = y < x;
  assign T8 = T9 ^ 1'h1;
  assign T9 = y < x;
  assign io_z = x;

  always @(posedge clk) begin
    if(io_e) begin
      y <= io_b;
    end else if(T8) begin
      y <= T3;
    end
    if(io_e) begin
      x <= io_a;
    end else if(T7) begin
      x <= T6;
    end
  end
endmodule

