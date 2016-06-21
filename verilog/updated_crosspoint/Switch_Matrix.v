//
//	LOGIC CORE:		16x16 crosspoint switch
//	MODULE NAME: 	Switch_Matrix
//	FILE NAME:		Switch_Matrix.v
//	COMPANY:		Copyright 2000 Altera Corporation.
//                    www.altera.com
//	REVISION HISTORY:
//	
//	Revision 1.0	10/14/2002	Description: Initial Release.
//
//  This module is used in the sub-level module for the MAX3000/MAX II Crosspoint Switch Matrix.
//

module Switch_Matrix (in, sel0, sel1, sel2, sel3, sel4, sel5, sel6, sel7
		, sel8, sel9, sel10, sel11, sel12, sel13, sel14, sel15, out);

input [15:0] in;
input [3:0] sel0, sel1, sel2, sel3, sel4, sel5, sel6, sel7;
input [3:0] sel8, sel9, sel10, sel11, sel12, sel13, sel14, sel15;
output [15:0] out;

wire vcc;

assign vcc = 1'b1;

IO_cell output_0 (.in(in), .sel(sel0), .oe(vcc), .out(out[0]));

IO_cell output_1 (.in(in), .sel(sel1), .oe(vcc), .out(out[1]));

IO_cell output_2 (.in(in), .sel(sel2), .oe(vcc), .out(out[2]));

IO_cell output_3 (.in(in), .sel(sel3), .oe(vcc), .out(out[3]));

IO_cell output_4 (.in(in), .sel(sel4), .oe(vcc), .out(out[4]));

IO_cell output_5 (.in(in), .sel(sel5), .oe(vcc), .out(out[5]));

IO_cell output_6 (.in(in), .sel(sel6), .oe(vcc), .out(out[6]));

IO_cell output_7 (.in(in), .sel(sel7), .oe(vcc), .out(out[7]));
	
IO_cell output_8 (.in(in), .sel(sel8), .oe(vcc), .out(out[8]));

IO_cell output_9 (.in(in), .sel(sel9), .oe(vcc), .out(out[9]));

IO_cell output_10 (.in(in), .sel(sel10), .oe(vcc), .out(out[10]));

IO_cell output_11 (.in(in), .sel(sel11), .oe(vcc), .out(out[11]));

IO_cell output_12 (.in(in), .sel(sel12), .oe(vcc), .out(out[12]));

IO_cell output_13 (.in(in), .sel(sel13), .oe(vcc), .out(out[13]));

IO_cell output_14 (.in(in), .sel(sel14), .oe(vcc), .out(out[14]));

IO_cell output_15 (.in(in), .sel(sel15), .oe(vcc), .out(out[15]));

endmodule



