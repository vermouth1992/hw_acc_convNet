#include "GCD.h"

mod_t* GCD_t::clone() {
  mod_t* cloned = new GCD_t(*this);
  return cloned;
}
