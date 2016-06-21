module single_port_ram # (
	parameter DATA_WIDTH = 8,
	parameter ADDR_WIDTH = 6
) (
	input [DATA_WIDTH-1:0] data,
	input [ADDR_WIDTH-1:0] addr,
	input we, clk,
	output reg [DATA_WIDTH-1:0] q
);

	// Declare the RAM variable

	reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];
	
	always @ (posedge clk)
	begin
	// Write
		if (we) begin
			ram[addr] <= data;
		end
		
		q <= ram[addr];
		
	end
	
endmodule
