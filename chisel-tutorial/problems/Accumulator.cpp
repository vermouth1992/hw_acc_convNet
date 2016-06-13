#include "Accumulator.h"

void Accumulator_t::init ( val_t rand_init ) {
  this->__srand(rand_init);
  Accumulator__acc.randomize(&__rand_seed);
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
  val_t T0;
  { T0 = Accumulator__io_in.values[0] | 0x0L << 1;}
  val_t T1;
  { T1 = Accumulator__acc.values[0]+T0;}
  T1 = T1 & 0xffL;
  { T2.values[0] = TERNARY(reset.values[0], 0x0L, T1);}
  { Accumulator__io_out.values[0] = Accumulator__acc.values[0];}
}


void Accumulator_t::clock_hi ( dat_t<1> reset ) {
  dat_t<8> Accumulator__acc__shadow = T2;
  Accumulator__acc = T2;
}


void Accumulator_api_t::init_sim_data (  ) {
  sim_data.inputs.clear();
  sim_data.outputs.clear();
  sim_data.signals.clear();
  Accumulator_t* mod = dynamic_cast<Accumulator_t*>(module);
  assert(mod);
  sim_data.inputs.push_back(new dat_api<1>(&mod->Accumulator__io_in));
  sim_data.outputs.push_back(new dat_api<8>(&mod->Accumulator__io_out));
  sim_data.signals.push_back(new dat_api<8>(&mod->Accumulator__acc));
  sim_data.signal_map["Accumulator.acc"] = 0;
  sim_data.clk_map["clk"] = new clk_api(&mod->clk);
}
