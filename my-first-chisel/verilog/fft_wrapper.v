module fft_wrapper(input clk, input reset,
    input  io_next,
    output io_next_out,
    input [31:0] io_input_15,
    input [31:0] io_input_14,
    input [31:0] io_input_13,
    input [31:0] io_input_12,
    input [31:0] io_input_11,
    input [31:0] io_input_10,
    input [31:0] io_input_9,
    input [31:0] io_input_8,
    input [31:0] io_input_7,
    input [31:0] io_input_6,
    input [31:0] io_input_5,
    input [31:0] io_input_4,
    input [31:0] io_input_3,
    input [31:0] io_input_2,
    input [31:0] io_input_1,
    input [31:0] io_input_0,
    output[31:0] io_output_15,
    output[31:0] io_output_14,
    output[31:0] io_output_13,
    output[31:0] io_output_12,
    output[31:0] io_output_11,
    output[31:0] io_output_10,
    output[31:0] io_output_9,
    output[31:0] io_output_8,
    output[31:0] io_output_7,
    output[31:0] io_output_6,
    output[31:0] io_output_5,
    output[31:0] io_output_4,
    output[31:0] io_output_3,
    output[31:0] io_output_2,
    output[31:0] io_output_1,
    output[31:0] io_output_0
);

  wire fft_next_out;
  wire[31:0] fft_Y15;
  wire[31:0] fft_Y14;
  wire[31:0] fft_Y13;
  wire[31:0] fft_Y12;
  wire[31:0] fft_Y11;
  wire[31:0] fft_Y10;
  wire[31:0] fft_Y9;
  wire[31:0] fft_Y8;
  wire[31:0] fft_Y7;
  wire[31:0] fft_Y6;
  wire[31:0] fft_Y5;
  wire[31:0] fft_Y4;
  wire[31:0] fft_Y3;
  wire[31:0] fft_Y2;
  wire[31:0] fft_Y1;
  wire[31:0] fft_Y0;


  assign io_output_0 = fft_Y0;
  assign io_output_1 = fft_Y1;
  assign io_output_2 = fft_Y2;
  assign io_output_3 = fft_Y3;
  assign io_output_4 = fft_Y4;
  assign io_output_5 = fft_Y5;
  assign io_output_6 = fft_Y6;
  assign io_output_7 = fft_Y7;
  assign io_output_8 = fft_Y8;
  assign io_output_9 = fft_Y9;
  assign io_output_10 = fft_Y10;
  assign io_output_11 = fft_Y11;
  assign io_output_12 = fft_Y12;
  assign io_output_13 = fft_Y13;
  assign io_output_14 = fft_Y14;
  assign io_output_15 = fft_Y15;
  assign io_next_out = fft_next_out;
  fft8_8 fft(.clk(clk), .reset(reset),
       .next( io_next ),
       .next_out( fft_next_out ),
       .X15( io_input_15 ),
       .X14( io_input_14 ),
       .X13( io_input_13 ),
       .X12( io_input_12 ),
       .X11( io_input_11 ),
       .X10( io_input_10 ),
       .X9( io_input_9 ),
       .X8( io_input_8 ),
       .X7( io_input_7 ),
       .X6( io_input_6 ),
       .X5( io_input_5 ),
       .X4( io_input_4 ),
       .X3( io_input_3 ),
       .X2( io_input_2 ),
       .X1( io_input_1 ),
       .X0( io_input_0 ),
       .Y15( fft_Y15 ),
       .Y14( fft_Y14 ),
       .Y13( fft_Y13 ),
       .Y12( fft_Y12 ),
       .Y11( fft_Y11 ),
       .Y10( fft_Y10 ),
       .Y9( fft_Y9 ),
       .Y8( fft_Y8 ),
       .Y7( fft_Y7 ),
       .Y6( fft_Y6 ),
       .Y5( fft_Y5 ),
       .Y4( fft_Y4 ),
       .Y3( fft_Y3 ),
       .Y2( fft_Y2 ),
       .Y1( fft_Y1 ),
       .Y0( fft_Y0 )
  );
endmodule

