
`include "common.vh"

/* a generic dual port ram */
module dual_port_ram # (
  parameter DATA_WIDTH = 64,
  parameter ADDR_WIDTH = 13
) (
  input clk,    // Clock
  input we, // Write Enable
  input [DATA_WIDTH-1:0] data_in,
  input [ADDR_WIDTH-1:0] write_address,
  input [ADDR_WIDTH-1:0] read_address,
  output reg [DATA_WIDTH-1:0] data_out
);

  reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];

  always@(posedge clk) begin
    if (we) begin
      ram[write_address] <= data_in;
    end

    data_out <= ram[read_address];
  end

endmodule

/*
 * Each memory block is 16 complex width * 512 * 16
 */
module memBlockImage (
  intf_block_mem_image block_mem_image_io
);
  
  genvar i, j;

  intf_block_mem block_mem_io [15:0] (block_mem_image_io.clk);

  generate
    for (i=0; i<16; i=i+1) begin: i
      dual_port_ram #(64, 13) dual_port_ram_inst (
        .clk           (block_mem_io.clk),
        .we            (block_mem_io[i].we),
        .data_in       (block_mem_io[i].data_in),
        .write_address (block_mem_io[i].write_address),
        .read_address (block_mem_io[i].read_address),
        .data_out     (block_mem_io[i].data_out),
        );
      assign block_mem_io[i].we = block_mem_image_io.we;
      assign block_mem_io[i].write_address = block_mem_image_io.write_address;
      assign block_mem_io[i].read_address = block_mem_image_io.read_address;
    end
  endgenerate

  generate
    for (i=0; i<4; i=i+1) begin:i
      for (j=0; j<4; j=j+1) begin: j
        assign block_mem_io[4*i+j].data_in = '{block_mem_image_io.in[i][j].r, block_mem_image_io.in[i][j].i};
        assign block_mem_image_io.out[i][j].r = block_mem_io[4*i+j].data_out[63:32];
        assign block_mem_image_io.out[i][j].i = block_mem_io[4*i+j].data_out[31:0];
      end
    end
  endgenerate

endmodule