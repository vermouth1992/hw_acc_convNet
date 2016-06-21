//
//	LOGIC CORE:		I/O cell
//	MODULE NAME: 	IO_cell
//	FILE NAME:		IO_cell.v
//	COMPANY:		Copyright 2000 Altera Corporation.
//                    www.altera.com
//	REVISION HISTORY:
//	
//	Revision 1.0	10/14/2002	Description: Initial Release.
//
//  This module is used in the sub-level module for the Switch_Matrix.
//


module IO_cell (in, sel, oe, out);

input [15:0] in;
input [3:0] sel;
input oe;
output out;

reg mux_out;

always @(in or sel)
begin
	case (sel)
	4'b0000: mux_out = in[0];
	4'b0001: mux_out = in[1];
	4'b0011: mux_out = in[2];
	4'b0010: mux_out = in[3];
	4'b0110: mux_out = in[4];
	4'b0111: mux_out = in[5];
	4'b0101: mux_out = in[6];
	4'b0100: mux_out = in[7];
	4'b1100: mux_out = in[8];
	4'b1101: mux_out = in[9];
	4'b1111: mux_out = in[10];
	4'b1110: mux_out = in[11];
	4'b1010: mux_out = in[12];
	4'b1011: mux_out = in[13];
	4'b1001: mux_out = in[14];
	4'b1000: mux_out = in[15];
	default: mux_out = 1'bx;
	endcase
end
										
assign out = oe ? mux_out : 1'bz;
	
endmodule