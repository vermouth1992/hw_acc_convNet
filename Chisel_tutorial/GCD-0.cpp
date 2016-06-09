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
