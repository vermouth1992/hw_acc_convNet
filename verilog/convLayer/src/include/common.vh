
`ifndef COMMON_VH
`define COMMON_VH

typedef struct packed {
  logic [31:0] r;
  logic [31:0] i;
} complex_t;


/* note that the width must be set in interface instantiation, not module ports */
interface intf_fft # (
  parameter WIDTH = 4
) (
  input clk,
  input reset
  );
  complex_t in [0:WIDTH-1];   // in[0]+j*in[1], in[2]+j*in[3]
  complex_t out [0:WIDTH-1];  // out[0]+j*out[1], out[2]+j*out[3]
  logic next, next_out;
endinterface


interface intf_fft_2d #(
  parameter WIDTH = 4
) (
  input clk,
  input reset
  );
  complex_t in [0:WIDTH-1][0:WIDTH-1];
  complex_t out [0:WIDTH-1][0:WIDTH-1];
  logic next, next_out;
endinterface

interface intf_block_mem # (
  parameter DATA_WIDTH = 64,
  parameter ADDR_WIDTH = 13
) (
  input clk
  );
  logic we; // Write Enable
  logic [DATA_WIDTH-1:0] data_in;
  logic [ADDR_WIDTH-1:0] write_address;
  logic [ADDR_WIDTH-1:0] read_address;
  logic [DATA_WIDTH-1:0] data_out;

endinterface

interface intf_block_mem_image (
  input clk
  );
  logic we;
  logic [12:0] read_address;
  logic [12:0] write_address;
  complex_t in [0:3][0:3];
  complex_t out [0:3][0:3];

endinterface

interface intf_block_mem_kernel (
  input clk
  );
  logic we;
  logic [8:0] read_address;  // always 16 complex number
  logic [8:0] write_address; // always 8 complex number a time to write
  logic select;              // used to select which sub mem block
  complex_t in [0:1][0:3];   // 4 * 2 complex number
  complex_t out [0:3][0:3];

endinterface

`endif
