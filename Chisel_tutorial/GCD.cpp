#include "GCD.h"

void GCD_t::init ( val_t rand_init ) {
  this->__srand(rand_init);
  GCD__x.randomize(&__rand_seed);
  GCD__y.randomize(&__rand_seed);
}
int GCD_t::clock ( dat_t<1> reset ) {
  uint32_t min = ((uint32_t)1<<31)-1;
  if (clk_cnt < min) min = clk_cnt;
  clk_cnt-=min;
  if (clk_cnt == 0) clock_hi( reset );
  if (clk_cnt == 0) clock_lo( reset );
  if (clk_cnt == 0) clk_cnt = clk;
  return min;
}
mod_t* GCD_t::clone() {
  mod_t* cloned = new GCD_t(*this);
  return cloned;
}
bool GCD_t::set_circuit_from ( mod_t* src ) {
  GCD_t* mod_typed = dynamic_cast<GCD_t*>(src);
  assert(mod_typed);
  GCD__io_output = mod_typed->GCD__io_output;
  GCD__io_operand1 = mod_typed->GCD__io_operand1;
  GCD__io_start = mod_typed->GCD__io_start;
  T3 = mod_typed->T3;
  GCD__x = mod_typed->GCD__x;
  GCD__io_operand2 = mod_typed->GCD__io_operand2;
  T8 = mod_typed->T8;
  GCD__y = mod_typed->GCD__y;
  GCD__io_valid = mod_typed->GCD__io_valid;
  clk = mod_typed->clk;
  clk_cnt = mod_typed->clk_cnt;
  return true;
}
void GCD_t::print ( FILE* f ) {
}
void GCD_t::print ( std::ostream& s ) {
}
void GCD_t::dump_init ( FILE* f ) {
}
void GCD_t::dump ( FILE* f, int t ) {
}
void GCD_t::clock_lo ( dat_t<1> reset ) {
  { GCD__io_output.values[0] = GCD__x.values[0];}
  val_t T0;
  { T0 = GCD__x.values[0]-GCD__y.values[0];}
  T0 = T0 & 0xffffL;
  val_t T1;
  T1 = GCD__y.values[0]<GCD__x.values[0];
  val_t T2;
  { T2 = TERNARY_1(T1, T0, GCD__x.values[0]);}
  { T3.values[0] = TERNARY_1(GCD__io_start.values[0], GCD__io_operand1.values[0], T2);}
  val_t T4;
  { T4 = GCD__y.values[0]-GCD__x.values[0];}
  T4 = T4 & 0xffffL;
  val_t T5;
  T5 = GCD__y.values[0]<GCD__x.values[0];
  val_t T6;
  { T6 = T5 ^ 0x1L;}
  val_t T7;
  { T7 = TERNARY_1(T6, T4, GCD__y.values[0]);}
  { T8.values[0] = TERNARY_1(GCD__io_start.values[0], GCD__io_operand2.values[0], T7);}
  val_t T9;
  T9 = GCD__y.values[0] == 0x0L;
  { GCD__io_valid.values[0] = T9;}
}
void GCD_t::clock_hi ( dat_t<1> reset ) {
  dat_t<16> GCD__x__shadow = T3;
  dat_t<16> GCD__y__shadow = T8;
  GCD__x = T3;
  GCD__y = T8;
}
void GCD_api_t::init_mapping_table (  ) {
  dat_table.clear();
  mem_table.clear();
  GCD_t* mod_typed = dynamic_cast<GCD_t*>(module);
  assert(mod_typed);
  dat_table["GCD.io_output"] = new dat_api<16>(&mod_typed->GCD__io_output, "GCD.io_output", "");
  dat_table["GCD.io_operand1"] = new dat_api<16>(&mod_typed->GCD__io_operand1, "GCD.io_operand1", "");
  dat_table["GCD.io_start"] = new dat_api<1>(&mod_typed->GCD__io_start, "GCD.io_start", "");
  dat_table["GCD.x"] = new dat_api<16>(&mod_typed->GCD__x, "GCD.x", "");
  dat_table["GCD.io_operand2"] = new dat_api<16>(&mod_typed->GCD__io_operand2, "GCD.io_operand2", "");
  dat_table["GCD.y"] = new dat_api<16>(&mod_typed->GCD__y, "GCD.y", "");
  dat_table["GCD.io_valid"] = new dat_api<1>(&mod_typed->GCD__io_valid, "GCD.io_valid", "");
}
