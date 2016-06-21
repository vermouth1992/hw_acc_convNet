//
//	LOGIC CORE:		Address Decoder
//	MODULE NAME: 	decoder
//	FILE NAME:		decoder.v
//	COMPANY:		Copyright 2000 Altera Corporation.
//                    www.altera.com
//	REVISION HISTORY:
//	
//	Revision 1.2	10/14/2002	Description: Initial Release.
//
//  This module is used in the sub-level module for the MAX3000/MAX II Crosspoint Switch Matrix.
//


module decoder (in, out);

input [3:0] in;
output [15:0] out;

reg [15:0] out;

always @(in)
case (in)
	4'b0000 : out = 16'd1;
	4'b0001 : out = 16'd2;
	4'b0011 : out = 16'd4;
	4'b0010 : out = 16'd8;
	4'b0110 : out = 16'd16;
	4'b0111 : out = 16'd32;
	4'b0101 : out = 16'd64;
	4'b0100 : out = 16'd128;
	4'b1100 : out = 16'd256;
	4'b1101 : out = 16'd512;
	4'b1111 : out = 16'd1024;
	4'b1110 : out = 16'd2048;
	4'b1010 : out = 16'd4096;
	4'b1011 : out = 16'd8192;
	4'b1001 : out = 16'd16384;
	4'b1000 : out = 16'd32768;
	default : out = 16'd0;

endcase

endmodule



