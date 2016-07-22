// Latency: 54
// Gap: 1
// module_name_is:dft_top
module dft_top(clk, reset, next, next_out,
   X0, Y0,
   X1, Y1,
   X2, Y2,
   X3, Y3,
   X4, Y4,
   X5, Y5,
   X6, Y6,
   X7, Y7,
   X8, Y8,
   X9, Y9,
   X10, Y10,
   X11, Y11,
   X12, Y12,
   X13, Y13,
   X14, Y14,
   X15, Y15);

   output next_out;
   input clk, reset, next;

   input [31:0] X0,
      X1,
      X2,
      X3,
      X4,
      X5,
      X6,
      X7,
      X8,
      X9,
      X10,
      X11,
      X12,
      X13,
      X14,
      X15;

   output [31:0] Y0,
      Y1,
      Y2,
      Y3,
      Y4,
      Y5,
      Y6,
      Y7,
      Y8,
      Y9,
      Y10,
      Y11,
      Y12,
      Y13,
      Y14,
      Y15;

   wire [31:0] t0_0;
   wire [31:0] t0_1;
   wire [31:0] t0_2;
   wire [31:0] t0_3;
   wire [31:0] t0_4;
   wire [31:0] t0_5;
   wire [31:0] t0_6;
   wire [31:0] t0_7;
   wire [31:0] t0_8;
   wire [31:0] t0_9;
   wire [31:0] t0_10;
   wire [31:0] t0_11;
   wire [31:0] t0_12;
   wire [31:0] t0_13;
   wire [31:0] t0_14;
   wire [31:0] t0_15;
   wire next_0;
   wire [31:0] t1_0;
   wire [31:0] t1_1;
   wire [31:0] t1_2;
   wire [31:0] t1_3;
   wire [31:0] t1_4;
   wire [31:0] t1_5;
   wire [31:0] t1_6;
   wire [31:0] t1_7;
   wire [31:0] t1_8;
   wire [31:0] t1_9;
   wire [31:0] t1_10;
   wire [31:0] t1_11;
   wire [31:0] t1_12;
   wire [31:0] t1_13;
   wire [31:0] t1_14;
   wire [31:0] t1_15;
   wire next_1;
   wire [31:0] t2_0;
   wire [31:0] t2_1;
   wire [31:0] t2_2;
   wire [31:0] t2_3;
   wire [31:0] t2_4;
   wire [31:0] t2_5;
   wire [31:0] t2_6;
   wire [31:0] t2_7;
   wire [31:0] t2_8;
   wire [31:0] t2_9;
   wire [31:0] t2_10;
   wire [31:0] t2_11;
   wire [31:0] t2_12;
   wire [31:0] t2_13;
   wire [31:0] t2_14;
   wire [31:0] t2_15;
   wire next_2;
   assign t0_0 = X0;
   assign Y0 = t2_0;
   assign t0_1 = X1;
   assign Y1 = t2_1;
   assign t0_2 = X2;
   assign Y2 = t2_2;
   assign t0_3 = X3;
   assign Y3 = t2_3;
   assign t0_4 = X4;
   assign Y4 = t2_4;
   assign t0_5 = X5;
   assign Y5 = t2_5;
   assign t0_6 = X6;
   assign Y6 = t2_6;
   assign t0_7 = X7;
   assign Y7 = t2_7;
   assign t0_8 = X8;
   assign Y8 = t2_8;
   assign t0_9 = X9;
   assign Y9 = t2_9;
   assign t0_10 = X10;
   assign Y10 = t2_10;
   assign t0_11 = X11;
   assign Y11 = t2_11;
   assign t0_12 = X12;
   assign Y12 = t2_12;
   assign t0_13 = X13;
   assign Y13 = t2_13;
   assign t0_14 = X14;
   assign Y14 = t2_14;
   assign t0_15 = X15;
   assign Y15 = t2_15;
   assign next_0 = next;
   assign next_out = next_2;

// latency=31, gap=1
   codeBlock70968 stage0(.clk(clk), .reset(reset), .next_in(next_0), .next_out(next_1),
       .X0_in(t0_0), .Y0(t1_0),
       .X1_in(t0_1), .Y1(t1_1),
       .X2_in(t0_2), .Y2(t1_2),
       .X3_in(t0_3), .Y3(t1_3),
       .X4_in(t0_4), .Y4(t1_4),
       .X5_in(t0_5), .Y5(t1_5),
       .X6_in(t0_6), .Y6(t1_6),
       .X7_in(t0_7), .Y7(t1_7),
       .X8_in(t0_8), .Y8(t1_8),
       .X9_in(t0_9), .Y9(t1_9),
       .X10_in(t0_10), .Y10(t1_10),
       .X11_in(t0_11), .Y11(t1_11),
       .X12_in(t0_12), .Y12(t1_12),
       .X13_in(t0_13), .Y13(t1_13),
       .X14_in(t0_14), .Y14(t1_14),
       .X15_in(t0_15), .Y15(t1_15));


// latency=23, gap=1
   codeBlock71332 stage1(.clk(clk), .reset(reset), .next_in(next_1), .next_out(next_2),
       .X0_in(t1_0), .Y0(t2_0),
       .X1_in(t1_1), .Y1(t2_1),
       .X2_in(t1_2), .Y2(t2_2),
       .X3_in(t1_3), .Y3(t2_3),
       .X4_in(t1_4), .Y4(t2_4),
       .X5_in(t1_5), .Y5(t2_5),
       .X6_in(t1_6), .Y6(t2_6),
       .X7_in(t1_7), .Y7(t2_7),
       .X8_in(t1_8), .Y8(t2_8),
       .X9_in(t1_9), .Y9(t2_9),
       .X10_in(t1_10), .Y10(t2_10),
       .X11_in(t1_11), .Y11(t2_11),
       .X12_in(t1_12), .Y12(t2_12),
       .X13_in(t1_13), .Y13(t2_13),
       .X14_in(t1_14), .Y14(t2_14),
       .X15_in(t1_15), .Y15(t2_15));


endmodule