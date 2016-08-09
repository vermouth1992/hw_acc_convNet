
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
 * Each memory block for image is 16 complex width * 512 * 16
 */
module memBlockImage (
  intf_block_mem_image block_mem_image_io
);
  
  genvar i, j;

  intf_block_mem block_mem_io [15:0] (block_mem_image_io.clk);

  generate
    for (i=0; i<16; i=i+1) begin: dual_port_ram_loop
      dual_port_ram #(64, 13) dual_port_ram_inst (
        .clk           (block_mem_io[i].clk),
        .we            (block_mem_io[i].we),
        .data_in       (block_mem_io[i].data_in),
        .write_address (block_mem_io[i].write_address),
        .read_address (block_mem_io[i].read_address),
        .data_out     (block_mem_io[i].data_out)
        );
      assign block_mem_io[i].we = block_mem_image_io.we;
      assign block_mem_io[i].write_address = block_mem_image_io.write_address;
      assign block_mem_io[i].read_address = block_mem_image_io.read_address;
    end
  endgenerate

  generate
    for (i=0; i<4; i=i+1) begin: block_mem_image_io_loop_outer
      for (j=0; j<4; j=j+1) begin: block_mem_image_io_loop_inner
        assign block_mem_io[4*i+j].data_in[63:32] = block_mem_image_io.in[i][j].r;
        assign block_mem_io[4*i+j].data_in[31:0] = block_mem_image_io.in[i][j].i;
        assign block_mem_image_io.out[i][j].r = block_mem_io[4*i+j].data_out[63:32];
        assign block_mem_image_io.out[i][j].i = block_mem_io[4*i+j].data_out[31:0];
      end
    end
  endgenerate

endmodule

/* each memory block for kernel is 16 complex width (one cacheline) and depth is 512 
 * internally, it is split into two memory blocks and can be activated separated
 */

module memBlockKernel (
  intf_block_mem_kernel block_mem_kernel_io
);

  genvar i, j;

  // when assign the interface port, remember to split to two parts
  intf_block_mem block_mem_io_0 [7:0] (block_mem_kernel_io.clk);
  intf_block_mem block_mem_io_1 [7:0] (block_mem_kernel_io.clk);

  wire we_0, we_1;

  assign we_0 = (block_mem_kernel_io.select == 1'b0) ? block_mem_kernel_io.we : 1'b0;
  assign we_1 = (block_mem_kernel_io.select == 1'b1) ? block_mem_kernel_io.we : 1'b0;

  // connect input control signal
  generate
    for (i=0; i<8; i=i+1) begin: input_port_connection_ctrl
      assign block_mem_io_0[i].we = we_0;
      assign block_mem_io_1[i].we = we_1;
    end
  endgenerate

  // connect data
  generate
    for (i=0; i<4; i=i+1) begin: input_port_connection_data_outer
      for (j=0; j<2; j=j+1) begin: input_port_connection_data_inner
        assign block_mem_io_0[2*i+j].data_in[63:32] = block_mem_image_io.in[i][j].r;
        assign block_mem_io_0[2*i+j].data_in[31:0] = block_mem_image_io.in[i][j].i;
        assign block_mem_image_io.out[i][j].r = block_mem_io_0[2*i+j].data_out[63:32];
        assign block_mem_image_io.out[i][j].i = block_mem_io_0[2*i+j].data_out[31:0];
      end
    end
    for (i=0; i<4; i=i+1) begin: input_port_connection_data_outer
      for (j=0; j<2; j=j+1) begin: input_port_connection_data_inner
        assign block_mem_io_1[2*i+j].data_in[63:32] = block_mem_image_io.in[i][j].r;
        assign block_mem_io_1[2*i+j].data_in[31:0] = block_mem_image_io.in[i][j].i;
        assign block_mem_image_io.out[i][j+2].r = block_mem_io_1[2*i+j].data_out[63:32];
        assign block_mem_image_io.out[i][j+2].i = block_mem_io_1[2*i+j].data_out[31:0];
      end
    end

  // instantiate
  generate
    for (i=0; i<8; i=i+1) begin: dual_port_ram_loop
      dual_port_ram #(64, 9) dual_port_ram_inst_0 (
        .clk           (block_mem_io_0[i].clk),
        .we            (block_mem_io_0[i].we),
        .data_in       (block_mem_io_0[i].data_in),
        .write_address (block_mem_io_0[i].write_address),
        .read_address (block_mem_io_0[i].read_address),
        .data_out     (block_mem_io_0[i].data_out)
        );
      
      assign block_mem_io_0[i].read_address = block_mem_kernel_io.read_address;
      assign block_mem_io_0[i].write_address = block_mem_kernel_io.write_address;
      
      dual_port_ram #(64, 9) dual_port_ram_inst_1 (
        .clk           (block_mem_io_1[i].clk),
        .we            (block_mem_io_1[i].we),
        .data_in       (block_mem_io_1[i].data_in),
        .write_address (block_mem_io_1[i].write_address),
        .read_address (block_mem_io_1[i].read_address),
        .data_out     (block_mem_io_1[i].data_out)
        );
      
      assign block_mem_io_1[i].read_address = block_mem_kernel_io.read_address;
      assign block_mem_io_1[i].write_address = block_mem_kernel_io.write_address;
    end
  endgenerate


endmodule // memBlockKernel
