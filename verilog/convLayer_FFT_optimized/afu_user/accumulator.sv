
`include "common.vh"

module accumulator (
  input clk,    // Clock
  input reset,  // Asynchronous reset active low
  // data
  input complex_fxp_t in,
  output complex_fxp_t out,
  // control, the valid data is when in_valid high, when in_valid is low, the output is valid
  input in_valid,
  output reg output_valid // indicate the output is valid on the next cycle
);
  
  complex_fxp_t wire_value;
  complex_fxp_t reg_value;

  assign wire_value.r = in.r + reg_value.r;
  assign wire_value.i = in.i + reg_value.i;

  enum {IDLE, RUN} state;

  always@(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      output_valid <= 0;
    end else begin
      case (state)
        IDLE: begin
          if(in_valid) begin
            state <= RUN;
            reg_value <= wire_value;
          end else begin
            state <= IDLE;
          end
          output_valid <= 0;
        end

        RUN: begin
          if(in_valid) begin
            state <= RUN;
            output_valid <= 0;
          end else begin
            state <= IDLE;
            output_valid <= 1;
          end
          reg_value <= wire_value;
        end

        default : begin end;
      endcase
    end
  end

  always@(posedge clk) begin
    out <= reg_value_delay;
  end

endmodule