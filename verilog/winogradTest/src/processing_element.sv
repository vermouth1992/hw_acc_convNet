module processing_element (
  input clk,    // Clock
  input reset,  // Synchronous reset active high
  // data
  input [31:0] data_in [0:3][0:3],
  input [31:0] filter_in [0:3][0:3],
  output [31:0] data_out [0:1][0:1],
  // control
  input next,
  input next_out
);

  genvar i, j;

  // preprocessing, delay = 11
  wire [31:0] preprocessing_result [0:3][0:3];
  // d0 - d2
  generate
    for (i=0; i<4; i=i+1) begin: d0_minus_d2
      subfp32 subfp32_d0_d2_inst (
        .clk   (clk),
        .enable(1'b1),
        .rst   (reset),
        .a     (data_in[0][i]),
        .b     (data_in[2][i]),
        .out   (preprocessing_result[0][i])
        );
    end
  endgenerate

  // d1 + d2
  generate
    for (i=0; i<4; i=i+1) begin: d1_add_d2
      addfp32 addfp32_d1_d2_inst (
        .clk   (clk),
        .enable(1'b1),
        .rst   (reset),
        .a     (data_in[1][i]),
        .b     (data_in[2][i]),
        .out   (preprocessing_result[1][i])
        );
    end
  endgenerate

  // d2 - d1
  generate
    for (i=0; i<4; i=i+1) begin: d2_minus_d1
      subfp32 subfp32_d2_d1_inst (
        .clk   (clk),
        .enable(1'b1),
        .rst   (reset),
        .a     (data_in[2][i]),
        .b     (data_in[1][i]),
        .out   (preprocessing_result[2][i])
        );
    end
  endgenerate

  // d1 - d3
  generate
    for (i=0; i<4; i=i+1) begin: d1_minus_d3
      subfp32 subfp32_d1_d3_inst (
        .clk   (clk),
        .enable(1'b1),
        .rst   (reset),
        .a     (data_in[1][i]),
        .b     (data_in[3][i]),
        .out   (preprocessing_result[3][i])
        );
    end
  endgenerate

  // delay filter_in by 11 cycles
  wire [31:0] filter_in_FIFO_out [0:3][0:3];
  generate
    for (i=0; i<4; i=i+1) begin: filter_in_inst_outer
      for (j=0; j<4; j=j+1) begin: filter_in_inst_inner
        shiftRegFIFO #(11, 32) shiftRegFIFO_filter_inst(
          .clk(clk),
          .X  (filter_in[i][j]),
          .Y  (filter_in_FIFO_out[i][j])
          );
      end
    end
  endgenerate

  wire [31:0] F_2x3_out [0:3][0:1];
  // instantiate 4 F_2x3, delay = 41
  generate
    for (i=0; i<4; i=i+1) begin: F_2x3_inst
      F_2x3 F_2x3_inst (
        .clk      (clk),
        .reset    (reset),
        .data_in  (preprocessing_result[i]),
        .filter_in(filter_in_FIFO_out[i]),
        .data_out (F_2x3_out[i])
        );
    end
  endgenerate

  // post processing, delay = 11 + 11 = 22
  // m00 + m20
  wire [31:0] m00_add_m20;
  addfp32 m00_m20 (
    .clk   (clk),
    .enable(1'b1),
    .rst   (reset),
    .a     (F_2x3_out[0][0]),
    .b     (F_2x3_out[2][0]),
    .out   (m00_add_m20)
    );

  // m01 + m21
  wire [31:0] m01_add_m21;
  addfp32 m01_m21 (
    .clk   (clk),
    .enable(1'b1),
    .rst   (reset),
    .a     (F_2x3_out[0][1]),
    .b     (F_2x3_out[2][1]),
    .out   (m01_add_m21)
    );

  // m20 + m30
  wire [31:0] m20_add_m30;
  addfp32 m20_m30 (
    .clk   (clk),
    .enable(1'b1),
    .rst   (reset),
    .a     (F_2x3_out[2][0]),
    .b     (F_2x3_out[3][0]),
    .out   (m20_add_m30)
    );

  // m21 + m31
  wire [31:0] m21_add_m31;
  addfp32 m21_m31 (
    .clk   (clk),
    .enable(1'b1),
    .rst   (reset),
    .a     (F_2x3_out[2][1]),
    .b     (F_2x3_out[3][1]),
    .out   (m21_add_m31)
    );

  // delay m10, m11
  wire [31:0] delay_m10, delay_m11;
  shiftRegFIFO #(11, 32) shiftRegFIFO_inst_m10 (.clk(clk), .X  (F_2x3_out[0][1]), .Y  (delay_m10));
  shiftRegFIFO #(11, 32) shiftRegFIFO_inst_m11 (.clk(clk), .X  (F_2x3_out[1][1]), .Y  (delay_m11));

  // final stage
  addfp32 addfp32_out00 (
    .clk   (clk),
    .enable(1'b1),
    .rst   (reset),
    .a     (m00_add_m20),
    .b     (delay_m10),
    .out   (data_out[0][0])
    );

  addfp32 addfp32_out01 (
    .clk   (clk),
    .enable(1'b1),
    .rst   (reset),
    .a     (m01_add_m21),
    .b     (delay_m11),
    .out   (data_out[0][1])
    );

  subfp32 subfp32_out10 (
    .clk   (clk),
    .enable(1'b1),
    .rst   (reset),
    .a     (delay_m10),
    .b     (m20_add_m30),
    .out   (data_out[1][0])
    );

  subfp32 subfp32_out11 (
    .clk   (clk),
    .enable(1'b1),
    .rst   (reset),
    .a     (delay_m11),
    .b     (m21_add_m31),
    .out   (data_out[1][1])
    );

  // control, delay = 11 + 41 + 22 = 74
  shiftRegFIFO #(74, 1) shiftRegFIFO_inst_next (.clk(clk), .X  (next), .Y  (next_out));

endmodule


module F_2x3 (
  input clk,    // Clock
  input reset,  // Synchronous reset active low
  // data
  input [31:0] data_in [0:3],
  input [31:0] filter_in [0:3],
  output [31:0] data_out [0:1]
  // // control
  // input next,
  // output next_out
);

  genvar i;
  
  // delay is 11
  wire [31:0] data_preprocessing [0:3];
  // d0_minus_d2
  subfp32 d0_d2(.clk(clk), .enable(1'b1), .rst(reset), .a(data_in[0]), .b(data_in[2]), .out(data_preprocessing[0]));
  // d1_add_d2
  addfp32 d1_d2(.clk(clk), .enable(1'b1), .rst(reset), .a(data_in[1]), .b(data_in[2]), .out(data_preprocessing[1]));
  // d2_minus_d1
  subfp32 d2_d1(.clk(clk), .enable(1'b1), .rst(reset), .a(data_in[2]), .b(data_in[1]), .out(data_preprocessing[2]));
  // d1_minus_d3
  subfp32 d1_d3(.clk(clk), .enable(1'b1), .rst(reset), .a(data_in[1]), .b(data_in[3]), .out(data_preprocessing[3]));

  // instantiate 4 shiftFIFO for filter_in, the delay is 11
  wire [31:0] filter_in_FIFO_out [0:3];
  generate
    for (i=0; i<4; i=i+1) begin: filter_in_FIFO
      shiftRegFIFO #(11, 32) shiftRegFIFO_inst (.clk(clk), .X  (filter_in[i]), .Y  (filter_in_FIFO_out[i]));
    end
  endgenerate

  // instantiate 4 multiplier
  wire [31:0] multiplier_out [0:3];
  generate
    for (i=0; i<4; i=i+1) begin: multiplier_array
      multfp32fp32 multfp32fp32_inst (
        .clk   (clk),
        .enable(1'b1),
        .rst   (reset),
        .a     (data_preprocessing[i]),
        .b     (filter_in_FIFO_out[i]),
        .out   (multiplier_out[i])
        );
    end
  endgenerate

  // first adder pipeline
  wire [31:0] m0_add_m2;
  addfp32 m0_m2(.clk(clk), .enable(1'b1), .rst(reset), .a(multiplier_out[0]), .b(multiplier_out[2]), .out(m0_add_m2));
  wire [31:0] m2_add_m3;
  addfp32 m2_m3(.clk(clk), .enable(1'b1), .rst(reset), .a(multiplier_out[2]), .b(multiplier_out[3]), .out(m2_add_m3));

  wire [31:0] shiftFIFO_m1;
  shiftRegFIFO #(11, 32) shiftRegFIFO_inst_m1 (.clk(clk), .X  (multiplier_out[1]), .Y  (shiftFIFO_m1));

  // second adder pipeline
  addfp32 m0_m1_m2(.clk(clk), .enable(1'b1), .rst(reset), .a(m0_add_m2), .b(shiftFIFO_m1), .out(data_out[0]));
  subfp32 m1_m2_m3(.clk(clk), .enable(1'b1), .rst(reset), .a(shiftFIFO_m1), .b(m2_add_m3), .out(data_out[1]));

  // // the total latency is 11+8+11+11=41
  // shiftRegFIFO #(41, 1) shiftRegFIFO_inst_next (.clk(clk), .X  (next), .Y  (next_out));

endmodule

