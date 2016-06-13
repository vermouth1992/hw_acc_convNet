#include "Accumulator.h"

void Accumulator_t::init ( val_t rand_init ) {
  this->__srand(rand_init);
  clk.len = 1;
  clk.cnt = 0;
  clk.values[0] = 0;
}


int Accumulator_t::clock ( dat_t<1> reset ) {
  uint32_t min = ((uint32_t)1<<31)-1;
  if (clk.cnt < min) min = clk.cnt;
  clk.cnt-=min;
  if (clk.cnt == 0) clock_lo( reset );
  if (!reset.to_bool()) print( std::cerr );
  if (clk.cnt == 0) clock_hi( reset );
  if (clk.cnt == 0) clk.cnt = clk.len;
  return min;
}


void Accumulator_t::print ( FILE* f ) {
}
void Accumulator_t::print ( std::ostream& s ) {
}


void Accumulator_t::dump_init ( FILE* f ) {
}


void Accumulator_t::dump ( FILE* f, val_t t, dat_t<1> reset ) {
}




void Accumulator_t::clock_lo ( dat_t<1> reset, bool assert_fire ) {
  { Accumulator__io_out.values[0] = 0x0L;}
}


void Accumulator_t::clock_hi ( dat_t<1> reset ) {
}


void Accumulator_api_t::init_sim_data (  ) {
  sim_data.inputs.clear();
  sim_data.outputs.clear();
  sim_data.signals.clear();
  Accumulator_t* mod = dynamic_cast<Accumulator_t*>(module);
  assert(mod);
  sim_data.inputs.push_back(new dat_api<1>(&mod->Accumulator__io_in));
  sim_data.outputs.push_back(new dat_api<8>(&mod->Accumulator__io_out));
  sim_data.clk_map["clk"] = new clk_api(&mod->clk);
}
