
`ifndef COMMON_VH
`define COMMON_VH

typedef struct packed {
  logic [31:0] r;
  logic [31:0] i;
} complex_t;

interface intf_fft4 (
  input clk,
  input reset
  );
  complex_t in [0:4-1];   // in[0]+j*in[1], in[2]+j*in[3]
  complex_t out [0:4-1];  // out[0]+j*out[1], out[2]+j*out[3]
  logic next, next_out;
endinterface

interface intf_fft8 (
  input clk,
  input reset
  );
  complex_t in [0:8-1];   // in[0]+j*in[1], in[2]+j*in[3]
  complex_t out [0:8-1];  // out[0]+j*out[1], out[2]+j*out[3]
  logic next, next_out;
endinterface

interface intf_fft16 (
  input clk,
  input reset
  );
  complex_t in [0:16-1];   // in[0]+j*in[1], in[2]+j*in[3]
  complex_t out [0:16-1];  // out[0]+j*out[1], out[2]+j*out[3]
  logic next, next_out;
endinterface

interface intf_fft4_2d (
  input clk,
  input reset
  );
  complex_t in [0:3][0:3];
  complex_t out [0:3][0:3];
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
  )
  logic we;
  logic [12:0] read_address;
  logic [12:0] write_address;
  complex_t in [0:3][0:3];
  complex_t out [0:3][0:3];

`endif
