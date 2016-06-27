module single_port_ram(input clk, input reset,
    input [7:0] io_data,
    input [5:0] io_addr,
    input  io_we,
    output[7:0] io_q
);

  reg [7:0] out;
  wire[7:0] T5;
  wire[7:0] T0;
  wire[7:0] T1;
  wire[7:0] T2;
  reg [7:0] myMem [63:0];
  wire[7:0] T3;
  wire T4;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    out = {1{$random}};
    for (initvar = 0; initvar < 64; initvar = initvar+1)
      myMem[initvar] = {1{$random}};
  end
// synthesis translate_on
`endif

  assign io_q = out;
  assign T5 = reset ? 8'h0 : T0;
  assign T0 = T4 ? out : T1;
  assign T1 = io_we ? T2 : out;
  assign T2 = myMem[io_addr];
  assign T4 = io_we ^ 1'h1;

  always @(posedge clk) begin
    if(reset) begin
      out <= 8'h0;
    end else if(T4) begin
      out <= out;
    end else if(io_we) begin
      out <= T2;
    end
    if (io_we)
      myMem[io_addr] <= io_data;
  end
endmodule

