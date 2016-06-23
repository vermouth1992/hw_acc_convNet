module memArray (
  input clk,    // Clock
  input we,
  input in0,
  ...
  input addr0_3,
  output out0
);

  single_port_ram # (
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
    ) mem0 (
    .data(in0),
    .addr(addr0_3),
    .we(we)
    .clk(clk),
    .q(out0)
    );



endmodule