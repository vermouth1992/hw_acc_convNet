#include "GCD.h"

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
