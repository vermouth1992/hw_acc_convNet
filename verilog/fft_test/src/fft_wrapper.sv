/* 
 * This file is a fft wrapper using system verilog interface
 */

`include "common.vh"

module fft4_wrapper (
  intf_fft4 fft_io
);

  dft4_top fft_inst (
    .clk(fft_io.clk),
    .reset(fft_io.reset),
    .next(fft_io.next),
    .next_out(fft_io.next_out),
    .X0(fft_io.in[0].r),
    .X1(fft_io.in[0].i),
    .X2(fft_io.in[1].r),
    .X3(fft_io.in[1].i),
    .X4(fft_io.in[2].r),
    .X5(fft_io.in[2].i),
    .X6(fft_io.in[3].r),
    .X7(fft_io.in[3].i),
    .Y0(fft_io.out[0].r),
    .Y1(fft_io.out[0].i),
    .Y2(fft_io.out[1].r),
    .Y3(fft_io.out[1].i),
    .Y4(fft_io.out[2].r),
    .Y5(fft_io.out[2].i),
    .Y6(fft_io.out[3].r),
    .Y7(fft_io.out[3].i)
    );

endmodule


module ifft4_wrapper (
  intf_fft4 fft_io
);

  idft4_top fft_inst (
    .clk(fft_io.clk),
    .reset(fft_io.reset),
    .next(fft_io.next),
    .next_out(fft_io.next_out),
    .X0(fft_io.in[0].r),
    .X1(fft_io.in[0].i),
    .X2(fft_io.in[1].r),
    .X3(fft_io.in[1].i),
    .X4(fft_io.in[2].r),
    .X5(fft_io.in[2].i),
    .X6(fft_io.in[3].r),
    .X7(fft_io.in[3].i),
    .Y0(fft_io.out[0].r),
    .Y1(fft_io.out[0].i),
    .Y2(fft_io.out[1].r),
    .Y3(fft_io.out[1].i),
    .Y4(fft_io.out[2].r),
    .Y5(fft_io.out[2].i),
    .Y6(fft_io.out[3].r),
    .Y7(fft_io.out[3].i)
    );

endmodule


module fft8_wrapper (
  intf_fft8 fft_io
);

  dft8_top fft_inst (
    .clk(fft_io.clk),
    .reset(fft_io.reset),
    .next(fft_io.next),
    .next_out(fft_io.next_out),
    .X0(fft_io.in[0].r),
    .X1(fft_io.in[0].i),
    .X2(fft_io.in[1].r),
    .X3(fft_io.in[1].i),
    .X4(fft_io.in[2].r),
    .X5(fft_io.in[2].i),
    .X6(fft_io.in[3].r),
    .X7(fft_io.in[3].i),
    .X8(fft_io.in[4].r),
    .X9(fft_io.in[4].i),
    .X10(fft_io.in[5].r),
    .X11(fft_io.in[5].i),
    .X12(fft_io.in[6].r),
    .X13(fft_io.in[6].i),
    .X14(fft_io.in[7].r),
    .X15(fft_io.in[7].i),
    .Y0(fft_io.out[0].r),
    .Y1(fft_io.out[0].i),
    .Y2(fft_io.out[1].r),
    .Y3(fft_io.out[1].i),
    .Y4(fft_io.out[2].r),
    .Y5(fft_io.out[2].i),
    .Y6(fft_io.out[3].r),
    .Y7(fft_io.out[3].i),
    .Y8(fft_io.out[4].r),
    .Y9(fft_io.out[4].i),
    .Y10(fft_io.out[5].r),
    .Y11(fft_io.out[5].i),
    .Y12(fft_io.out[6].r),
    .Y13(fft_io.out[6].i),
    .Y14(fft_io.out[7].r),
    .Y15(fft_io.out[7].i)
    );

endmodule

module ifft8_wrapper (
  intf_fft8 fft_io
);

  idft8_top fft_inst (
    .clk(fft_io.clk),
    .reset(fft_io.reset),
    .next(fft_io.next),
    .next_out(fft_io.next_out),
    .X0(fft_io.in[0].r),
    .X1(fft_io.in[0].i),
    .X2(fft_io.in[1].r),
    .X3(fft_io.in[1].i),
    .X4(fft_io.in[2].r),
    .X5(fft_io.in[2].i),
    .X6(fft_io.in[3].r),
    .X7(fft_io.in[3].i),
    .X8(fft_io.in[4].r),
    .X9(fft_io.in[4].i),
    .X10(fft_io.in[5].r),
    .X11(fft_io.in[5].i),
    .X12(fft_io.in[6].r),
    .X13(fft_io.in[6].i),
    .X14(fft_io.in[7].r),
    .X15(fft_io.in[7].i),
    .Y0(fft_io.out[0].r),
    .Y1(fft_io.out[0].i),
    .Y2(fft_io.out[1].r),
    .Y3(fft_io.out[1].i),
    .Y4(fft_io.out[2].r),
    .Y5(fft_io.out[2].i),
    .Y6(fft_io.out[3].r),
    .Y7(fft_io.out[3].i),
    .Y8(fft_io.out[4].r),
    .Y9(fft_io.out[4].i),
    .Y10(fft_io.out[5].r),
    .Y11(fft_io.out[5].i),
    .Y12(fft_io.out[6].r),
    .Y13(fft_io.out[6].i),
    .Y14(fft_io.out[7].r),
    .Y15(fft_io.out[7].i)
    );

endmodule




// testbench for SystemVerilog fft wrapper

module fft8_wrapper_tb (
  intf_fft8 fft_io
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
    for (i=0; i<8; i=i+1) begin
      fft_io.in[i].r <= $random;
      fft_io.in[i].i <= $random;
    end
    @(posedge fft_io.clk);
    for (i=0; i<8; i=i+1) begin
      $display("%h + j%h", fft_io.in[i].r, fft_io.in[i].i);
    end
    fft_io.next <= 0;
    // wait for next out to be asserted
    @(posedge fft_io.next_out);
    @(posedge fft_io.clk); #1;
    $display("--- begin output ---");
    for (i=0; i<8; i=i+1) begin
      $display("%h + j%h", fft_io.out[i].r, fft_io.out[i].i);
    end
  end
endmodule

module fft8_wrapper_tb_top;
  reg clk;
  reg reset;
  initial begin
    clk = 0;
    reset = 1;
    #15;
    reset = 0;
  end

  always # 10 clk = ~clk;
  
  intf_fft8 io(clk, reset);

  fft8_wrapper fft_inst(io);
  fft8_wrapper_tb fft_inst_tb(io);

endmodule


