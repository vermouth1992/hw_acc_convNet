
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

// we need a better interface for memory read/write


// 2 memory block as bank
module image_buffer_bank # (
  parameter DATA_WIDTH = 32 * 16,
  parameter ADDR_WIDTH = 11
) (
  input clk,
  input we,
  input complex_fxp_t data_in [0:1][0:15],
  // address will be the same for all sub memory
  input [ADDR_WIDTH-1:0] write_address,
  input [ADDR_WIDTH-1:0] read_address,
  output complex_fxp_t data_out [0:1][0:15]
);

  wire [DATA_WIDTH-1:0] data_in_mem [0:1];
  wire [DATA_WIDTH-1:0] data_out_mem [0:1];

  genvar i, j;
  generate
    for (i = 0; i < 2; i=i+1) begin: outer
      for (j = 0; j < 16; j=j+1) begin: inner
        assign data_in_mem[i][32*j+15:32*j] = data_in[i][j].r;
        assign data_in_mem[i][32*j+31:32*j+16] = data_in[i][j].i;
        assign data_out[i][j].r = data_out_mem[i][32*j+15:32*j];
        assign data_out[i][j].i = data_out_mem[i][32*j+31:32*j+16];
      end
    end
  endgenerate
  
  generate
    for (i = 0; i < 2； i=i+1) begin: memory_array
      dual_port_ram # (DATA_WIDTH, ADDR_WIDTH) dual_port_ram_inst (
        .clk          (clk),
        .we           (we),
        .data_in      (data_in_mem[i]),
        .write_address(write_address),
        .read_address (read_address),
        .data_out     (data_out_mem[i])
        );
    end
  endgenerate
  
endmodule


