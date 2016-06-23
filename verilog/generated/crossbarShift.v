module crossbarShift # (
  parameter DATA_WIDTH = 32
) (
  input clk,    // Clock
  input clk_en, // Clock Enable
  input [2:0] timestamp,    // it is used to determine the shift number, it is determined by M / k
  input [DATA_WIDTH-1:0] in0,
  ...
  output reg [DATA_WIDTH-1:0] out0
);

  always@(posedge clk) begin
    if (clk_en) begin
      case (timestamp)
        3'b000: begin
          out0 <= ...
        end 

        3'b001: begin

endmodule