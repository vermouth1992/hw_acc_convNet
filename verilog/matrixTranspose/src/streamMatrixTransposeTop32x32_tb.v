`timescale 1ns/1ns

module streamMatrixTransposeTop32x32_tb;

  parameter CLOCK_PERIOD = 10;
  parameter DATA_WIDTH = 16;
  parameter NUM_DATA = 512 / DATA_WIDTH;
  
  

  always #(CLOCK_PERIOD / 2) clk = ~clk;

  

  

endmodule