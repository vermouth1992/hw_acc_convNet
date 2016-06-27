module CrossBar(input clk,
    input [7:0] io_input_4,
    input [7:0] io_input_3,
    input [7:0] io_input_2,
    input [7:0] io_input_1,
    input [7:0] io_input_0,
    output[7:0] io_output_4,
    output[7:0] io_output_3,
    output[7:0] io_output_2,
    output[7:0] io_output_1,
    output[7:0] io_output_0,
    input  io_clk_en
);

  reg [7:0] output_reg_0;
  wire[7:0] T0;
  reg [7:0] output_reg_1;
  wire[7:0] T1;
  reg [7:0] output_reg_2;
  wire[7:0] T2;
  reg [7:0] output_reg_3;
  wire[7:0] T3;
  reg [7:0] output_reg_4;
  wire[7:0] T4;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    output_reg_0 = {1{$random}};
    output_reg_1 = {1{$random}};
    output_reg_2 = {1{$random}};
    output_reg_3 = {1{$random}};
    output_reg_4 = {1{$random}};
  end
// synthesis translate_on
`endif

  assign io_output_0 = output_reg_0;
  assign T0 = io_clk_en ? io_input_0 : output_reg_0;
  assign io_output_1 = output_reg_1;
  assign T1 = io_clk_en ? io_input_1 : output_reg_1;
  assign io_output_2 = output_reg_2;
  assign T2 = io_clk_en ? io_input_2 : output_reg_2;
  assign io_output_3 = output_reg_3;
  assign T3 = io_clk_en ? io_input_3 : output_reg_3;
  assign io_output_4 = output_reg_4;
  assign T4 = io_clk_en ? io_input_4 : output_reg_4;

  always @(posedge clk) begin
    if(io_clk_en) begin
      output_reg_0 <= io_input_0;
    end
    if(io_clk_en) begin
      output_reg_1 <= io_input_1;
    end
    if(io_clk_en) begin
      output_reg_2 <= io_input_2;
    end
    if(io_clk_en) begin
      output_reg_3 <= io_input_3;
    end
    if(io_clk_en) begin
      output_reg_4 <= io_input_4;
    end
  end
endmodule

