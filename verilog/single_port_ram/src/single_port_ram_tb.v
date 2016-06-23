`timescale 1ns/1ns

module single_port_ram_tb;
  parameter CLOCK_PERIOD = 10;
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 3;
  // input
  reg clk;
  reg [DATA_WIDTH-1:0] data;
  reg [ADDR_WIDTH-1:0] addr;
  reg we;

  // output
  wire [DATA_WIDTH-1:0] q;

  single_port_ram #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
      .data(data),
      .addr(addr),
      .we(we),
      .clk(clk),
      .q(q)
    );

  always #(CLOCK_PERIOD / 2) clk = ~clk;

  integer file;

  initial begin
    file = $fopen("out/ram.txt", "w");
    clk = 0;
    we = 0;
    addr = 0;
    data = $random;
  end

  initial begin
    $monitor("@%0d, addr = %h, we = %h, input data = %h, output data = %h", $time, addr, we, data, q);
  end

  always@(negedge clk) begin
    $fdisplay(file, "$0:%h,$1:%h,$2:%h,$3:%h,$4:%h,$5:%h,$6:%h,$7:%h", uut.ram[0], uut.ram[1], uut.ram[2], uut.ram[3], uut.ram[4], uut.ram[5], uut.ram[6], uut.ram[7]);
  end

  initial begin
    we = 1;
    repeat(20)@(posedge clk) begin
      data = $random;
      addr = addr + 1'b1;
    end
    $stop;
    $fclose(file);
  end

endmodule
