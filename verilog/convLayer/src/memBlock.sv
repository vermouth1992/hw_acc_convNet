

/*
 * Each memory block is 16 complex width * 512 * 16
 */
`include "common.vh"

module memBlockImage (
  intf_block_mem_image block_mem_io
);

  // memory
  reg [1023:0] mem [0:8192-1];

  // used to reformat input and output
  wire [1023:0] in;
  reg [1023:0] out_reg;

  genvar i, j;
  generate
    for (i=0; i<4; i=i+1) begin: reformat_in
      for (j=0; j<4; j=j+1) begin: reformat_in_inner
        assign in[256 * i + 64 * j + 31 : 256 * i + 64 * j] = block_mem_io.in[i][j].r;
        assign in[256 * i + 64 * j + 63 : 256 * i + 64 * j + 32] = block_mem_io.in[i][j].i;
        assign block_mem_io.out[i][j].r = out_reg[256 * i + 64 * j + 31 : 256 * i + 64 * j];
        assign block_mem_io.out[i][j].i = out_reg[256 * i + 64 * j + 63 : 256 * i + 64 * j + 32];
      end
    end
  endgenerate

  always@(posedge block_mem_io.clk) begin
    if (block_mem_io.wr) begin
      mem[block_mem_io.waddr] <= in;
    end
    if (block_mem_io.re) begin
      out_reg <= mem[block_mem_io.raddr];
    end
  end

endmodule