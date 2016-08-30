
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
module memBlockImage # (
  parameter IMAGE_MEM_DEPTH_BITS = 13
) (
  intf_block_mem_image block_mem_image_io
);
  
  genvar i, j;

  intf_block_mem block_mem_io [15:0] (block_mem_image_io.clk);

  generate
    for (i=0; i<16; i=i+1) begin: dual_port_ram_loop
      dual_port_ram #(64, IMAGE_MEM_DEPTH_BITS) dual_port_ram_inst (
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

module memBlockKernel # (
  parameter KERNEL_MEM_DEPTH_BITS = 9
) (
  intf_block_mem_kernel block_mem_kernel_io
);

  genvar i, j;

  // when assign the interface port, remember to split to two parts
  intf_block_mem #(64, KERNEL_MEM_DEPTH_BITS) block_mem_io_0 [7:0] (block_mem_kernel_io.clk);
  intf_block_mem #(64, KERNEL_MEM_DEPTH_BITS) block_mem_io_1 [7:0] (block_mem_kernel_io.clk);

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
    for (i=0; i<2; i=i+1) begin: input_port_connection_data_outer_0
      for (j=0; j<4; j=j+1) begin: input_port_connection_data_inner_0
        assign block_mem_io_0[4*i+j].data_in[63:32] = block_mem_kernel_io.in[i][j].r;
        assign block_mem_io_0[4*i+j].data_in[31:0] = block_mem_kernel_io.in[i][j].i;
        assign block_mem_kernel_io.out[i][j].r = block_mem_io_0[4*i+j].data_out[63:32];
        assign block_mem_kernel_io.out[i][j].i = block_mem_io_0[4*i+j].data_out[31:0];
      end
    end
    for (i=0; i<2; i=i+1) begin: input_port_connection_data_outer_1
      for (j=0; j<4; j=j+1) begin: input_port_connection_data_inner_1
        assign block_mem_io_1[4*i+j].data_in[63:32] = block_mem_kernel_io.in[i][j].r;
        assign block_mem_io_1[4*i+j].data_in[31:0] = block_mem_kernel_io.in[i][j].i;
        assign block_mem_kernel_io.out[i+2][j].r = block_mem_io_1[4*i+j].data_out[63:32];
        assign block_mem_kernel_io.out[i+2][j].i = block_mem_io_1[4*i+j].data_out[31:0];
      end
    end
  endgenerate

  // instantiate
  generate
    for (i=0; i<8; i=i+1) begin: dual_port_ram_loop
      dual_port_ram #(64, KERNEL_MEM_DEPTH_BITS) dual_port_ram_inst_0 (
        .clk           (block_mem_io_0[i].clk),
        .we            (block_mem_io_0[i].we),
        .data_in       (block_mem_io_0[i].data_in),
        .write_address (block_mem_io_0[i].write_address),
        .read_address (block_mem_io_0[i].read_address),
        .data_out     (block_mem_io_0[i].data_out)
        );
      
      assign block_mem_io_0[i].read_address = block_mem_kernel_io.read_address;
      assign block_mem_io_0[i].write_address = block_mem_kernel_io.write_address;
      
      dual_port_ram #(64, KERNEL_MEM_DEPTH_BITS) dual_port_ram_inst_1 (
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


/* The top module of memBlockImage, which contains two sets of memory block */

module memBlockImage_top # (
  parameter IMAGE_MEM_DEPTH_BITS = 13
) (
  input clk,
  input logic [IMAGE_MEM_DEPTH_BITS-1:0] read_address,
  input logic [IMAGE_MEM_DEPTH_BITS-1:0] write_address,
  input we,
  input select_block_we,
  input select_block_rd,
  input complex_t in [0:3][0:3],
  output complex_t out [0:3][0:3]
  );

  intf_block_mem_image #(IMAGE_MEM_DEPTH_BITS) block_mem_image_io [0:1] (clk);

  genvar i;
  generate
    for (i=0; i<2; i=i+1) begin: image_block_array
      memBlockImage #(IMAGE_MEM_DEPTH_BITS) memBlockImage_inst(block_mem_image_io[i]);
      assign block_mem_image_io[i].in = in;     // connect the output of 2dfft to mem block
      assign block_mem_image_io[i].we = (select_block_we == i) ? we : 1'b0;
      assign block_mem_image_io[i].read_address = read_address;
      assign block_mem_image_io[i].write_address = write_address;
    end
  endgenerate

  assign out = (select_block_rd == 1'b0) ? block_mem_image_io[0].out : block_mem_image_io[1].out;

endmodule

/* The top module of 2 memBlockKernel,  */

module memBlockKernel_top # (
  parameter KERNEL_MEM_DEPTH_BITS = 9
) (
  input clk,
  input logic we,
  input [KERNEL_MEM_DEPTH_BITS-1:0] read_address,
  input [KERNEL_MEM_DEPTH_BITS-1:0] write_address,
  input select_block_rd,
  input select_block_we,
  input select_sub_block_we,
  input complex_t in [0:1][0:3],   // one cacheline
  output complex_t out [0:3][0:3]  // 16 kernel complex number
  );

  intf_block_mem_kernel block_mem_kernel_io [0:1] (clk);

  genvar i;
  generate
    for(i=0; i<2; i=i+1) begin: kernel_block_array
      memBlockKernel #(KERNEL_MEM_DEPTH_BITS) memBlockKernel_inst(block_mem_kernel_io[i]);
      assign block_mem_kernel_io[i].we = (select_block_we == i) ? we : 1'b0;
      assign block_mem_kernel_io[i].read_address = read_address;
      assign block_mem_kernel_io[i].write_address = write_address;
      assign block_mem_kernel_io[i].select = select_sub_block_we;
      assign block_mem_kernel_io[i].in = in;
    end
  endgenerate

  // select read block
  assign out = (select_block_rd == 1'b0) ? block_mem_kernel_io[0].out : block_mem_kernel_io[1].out;

endmodule

