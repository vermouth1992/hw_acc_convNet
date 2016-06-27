module single_port_ram(input clk,
    input [7:0] io_data,
    input [5:0] io_addr,
    input  io_we,
    output[7:0] io_q
);

  reg [7:0] out;
  wire[7:0] T0;
  wire[7:0] T1;
  reg [7:0] myMem [63:0];
  wire[7:0] T2;

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

