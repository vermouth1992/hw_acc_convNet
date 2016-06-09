#include "GCD.h"

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
