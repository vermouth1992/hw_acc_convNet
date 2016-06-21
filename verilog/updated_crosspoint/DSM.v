//
//	LOGIC CORE:		MAX3000/MAX II Crosspoint Switch Matrix
//	MODULE NAME: 	DSM
//	FILE NAME:		DSM.v
//	COMPANY:		Copyright 2000 Altera Corporation.
//                    www.altera.com
//	REVISION HISTORY:
//	
//	Revision 1.2	10/14/2002	Description: Initial Release.
//
//  This module is used in the top level module for the MAX3000/MAX II Crosspoint Switch Matrix.
//


module DSM(CNFG, RES, LOAD, CS, di, In_add, out_add, do);

input	CNFG, RES, LOAD, CS;
input	[15:0] di;
input	[3:0] In_add, out_add;
output	[15:0] do;

wire	[15:0] dec_add;
wire	[3:0] sel0, sel1, sel2, sel3, sel4, sel5, sel6, sel7, sel8;
wire	[3:0] sel9, sel10, sel11, sel12, sel13, sel14, sel15;
wire 	conf_en, load_en, reset, reset_inv;

assign conf_en = (CNFG & CS);
assign load_en = (LOAD & CS);
assign reset = RES & CS;

decoder	b2v_inst(.in(out_add),.out(dec_add));

switch	b2v_inst0(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[0]),.in_add(In_add),.inadd(sel0),.reset(reset));

switch	b2v_inst1(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[1]),.in_add(In_add),.inadd(sel1),.reset(reset));

switch	b2v_inst2(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[2]),.in_add(In_add),.inadd(sel2),.reset(reset));

switch	b2v_inst3(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[3]),.in_add(In_add),.inadd(sel3),.reset(reset));

switch	b2v_inst4(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[4]),.in_add(In_add),.inadd(sel4),.reset(reset));

switch	b2v_inst5(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[5]),.in_add(In_add),.inadd(sel5),.reset(reset));

switch	b2v_inst6(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[6]),.in_add(In_add),.inadd(sel6),.reset(reset));

switch	b2v_inst7(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[7]),.in_add(In_add),.inadd(sel7),.reset(reset));

switch	b2v_inst8(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[8]),.in_add(In_add),.inadd(sel8),.reset(reset));

Switch_Matrix	b2v_matrix2(.in(di),.sel0(sel0),.sel1(sel1),.sel2(sel2),.sel3(sel3),.sel4(sel4),.sel5(sel5),.sel6(sel6),.sel7(sel7),.sel8(sel8),.sel9(sel9),.sel10(sel10),.sel11(sel11),.sel12(sel12),.sel13(sel13),.sel14(sel14),.sel15(sel15),.out(do));

switch	b2v_inst9(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[9]),.in_add(In_add),.inadd(sel9),.reset(reset));

switch	b2v_inst10(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[10]),.in_add(In_add),.inadd(sel10),.reset(reset));

switch	b2v_inst11(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[11]),.in_add(In_add),.inadd(sel11),.reset(reset));

switch	b2v_inst12(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[12]),.in_add(In_add),.inadd(sel12),.reset(reset));

switch	b2v_inst13(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[13]),.in_add(In_add),.inadd(sel13),.reset(reset));

switch	b2v_inst14(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[14]),.in_add(In_add),.inadd(sel14),.reset(reset));

switch	b2v_inst15(.conf_en(conf_en),.load_en(load_en),.out_sel(dec_add[15]),.in_add(In_add),.inadd(sel15),.reset(reset));

endmodule
