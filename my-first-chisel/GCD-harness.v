module test;
  reg[15:0] io_a = 0;
  reg[15:0] io_b = 0;
  reg[0:0] io_e = 0;
  wire[15:0] io_z;
  wire[0:0] io_v;
  reg clk = 0;
  integer clk_len;
  always #clk_len clk = ~clk;
  reg vcdon = 0;
  reg [1023:0] vcdfile = 0;
  reg [1023:0] vpdfile = 0;

  /*** DUT instantiation ***/
  GCD GCD(
    .clk(clk),
    .io_a(io_a),
    .io_b(io_b),
    .io_e(io_e),
    .io_z(io_z),
    .io_v(io_v));

  initial begin
    clk_len = `CLOCK_PERIOD;
    $init_clks(clk_len);
    $init_rsts();
    $init_ins(io_a, io_b, io_e);
    $init_outs(io_z, io_v);
    $init_sigs(GCD);
    /*** VCD & VPD dump ***/
    if ($value$plusargs("vcdfile=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, GCD);
      $dumpoff;
      vcdon = 0;
    end
    if ($value$plusargs("vpdfile=%s", vpdfile)) begin
      $vcdplusfile(vpdfile);
      $vcdpluson(0);
      $vcdplusautoflushon;
    end
    if ($test$plusargs("vpdmem")) begin
      $vcdplusmemon;
    end
  end

  always @(negedge clk) begin
    $tick();
  end

endmodule
