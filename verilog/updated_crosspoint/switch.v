//
//	LOGIC CORE:		Configuration Circuit Control
//	MODULE NAME: 	switch
//	FILE NAME:		switch.v
//	COMPANY:		Copyright 2000 Altera Corporation.
//                    www.altera.com
//	REVISION HISTORY:
//	
//	Revision 1.2	10/14/2002	Description: Initial Release.
//
//  This module is used in the sub-level module for the MAX3000/MAX II Crosspoint Switch Matrix.
//

module switch (conf_en, load_en, in_add, inadd, out_sel, reset);

input [3:0] in_add;
input conf_en, load_en, out_sel, reset;
output [3:0] inadd;

reg [3:0] load_inadd_reg;
reg [3:0] inadd;

wire conf_en, load_enable;

assign load_enable = load_en & out_sel;

always @(posedge load_enable or posedge reset)
begin
	if (reset)
		load_inadd_reg = 4'b0;
	else
		load_inadd_reg = in_add;
end

always @(posedge conf_en or posedge reset)
begin
	if (reset)
		inadd = 4'b0;
	else
		inadd = load_inadd_reg;
end

endmodule
