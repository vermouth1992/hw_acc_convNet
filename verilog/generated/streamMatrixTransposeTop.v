module streamMatrixTransposeTop # (
  parameter DATA_WIDTH = 32
) (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input reset,
  input start
  input in0
  ...
  output out0
  ...
  output start_next_stage
);

  wire shiftDownOut0;
  wire shiftDownOut1;
  ...
  wire start_next_stage_shift_down;

  crossbarShiftDown 


  wire crossbarOut0;
  ...
  wire start_next_stage_crossbar;

  crossbar

  
  wire memArrayOut0;
  ...
  wire start_next_stage_memArray;

  memArray


  crossbarShiftUp


endmodule