#include "GCD.h"

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
