module multfixWrapper(input clk, input reset,
    input [15:0] io_a,
    input [15:0] io_b,
    output[15:0] io_q_sc,
    output[15:0] io_q_unsc
);

  wire[15:0] multfix_q_sc;
  wire[15:0] multfix_q_unsc;


  assign io_q_unsc = multfix_q_unsc;
  assign io_q_sc = multfix_q_sc;
  multfix # (
    .WIDTH(16),
    .CYCLES(2)
  ) multfix(.clk(clk), .rst(reset),
       .a( io_a ),
       .b( io_b ),
       .q_sc( multfix_q_sc ),
       .q_unsc( multfix_q_unsc )
  );
endmodule

