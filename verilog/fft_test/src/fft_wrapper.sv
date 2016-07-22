/* 
 * This file is a fft wrapper using system verilog interface
 */

interface intf_fft(
  input clk,
  input reset
  );
  logic [31:0] in [0:15];   // in[0]+j*in[1], in[2]+j*in[3]
  logic [31:0] out [0:15];  // out[0]+j*out[1], out[2]+j*out[3]
  logic next, next_out;
endinterface

module fft_wrapper (
  intf_fft fft_io
);

  dft_top fft_inst (
    .clk(fft_io.clk),
    .reset(fft_io.reset),
    .next(fft_io.next),
    .next_out(fft_io.next_out),
    .X0(fft_io.in[0]),
    .X1(fft_io.in[1]),
    .X2(fft_io.in[2]),
    .X3(fft_io.in[3]),
    .X4(fft_io.in[4]),
    .X5(fft_io.in[5]),
    .X6(fft_io.in[6]),
    .X7(fft_io.in[7]),
    .X8(fft_io.in[8]),
    .X9(fft_io.in[9]),
    .X10(fft_io.in[10]),
    .X11(fft_io.in[11]),
    .X12(fft_io.in[12]),
    .X13(fft_io.in[13]),
    .X14(fft_io.in[14]),
    .X15(fft_io.in[15]),
    .Y0(fft_io.out[0]),
    .Y1(fft_io.out[1]),
    .Y2(fft_io.out[2]),
    .Y3(fft_io.out[3]),
    .Y4(fft_io.out[4]),
    .Y5(fft_io.out[5]),
    .Y6(fft_io.out[6]),
    .Y7(fft_io.out[7]),
    .Y8(fft_io.out[8]),
    .Y9(fft_io.out[9]),
    .Y10(fft_io.out[10]),
    .Y11(fft_io.out[11]),
    .Y12(fft_io.out[12]),
    .Y13(fft_io.out[13]),
    .Y14(fft_io.out[14]),
    .Y15(fft_io.out[15])
    );

endmodule


module fft_wrapper_tb (
  intf_fft fft_io
);

  integer i;

  initial begin
    // wait for global reset
    wait(fft_io.reset);
    @(posedge fft_io.clk);
    // insert next
    fft_io.next <= 1;
    @(posedge fft_io.clk);
    // insert input
    $display("--- begin input ---");
    for (i=0; i<16; i=i+1) begin
      fft_io.in[i] <= $random;
    end
    @(posedge fft_io.clk);
    for (i=0; i<16; i=i+1) begin
      $display("%h", fft_io.in[i]);
    end
    fft_io.next <= 0;
    // wait for next out to be asserted
    @(posedge fft_io.next_out);
    @(posedge fft_io.clk); #1;
    $display("--- begin output ---");
    for (i=0; i<16;i=i+1) begin
      $display("%h", fft_io.out[i]);
    end
  end
endmodule

module fft_wrapper_tb_top;
  reg clk;
  reg reset;
  initial begin
    clk = 0;
    reset = 1;
    #15;
    reset = 0;
  end

  always # 10 clk = ~clk;
  
  intf_fft io(clk, reset);

  fft_wrapper fft_inst(io);
  fft_wrapper_tb fft_inst_tb(io);

endmodule


