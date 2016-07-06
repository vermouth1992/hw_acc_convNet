/**
  * Created by chizhang on 7/6/16.
  */

import Chisel._

class two_d_convolution(DATA_WIDTH: Int, k: Int, M: Int) extends Module {
  val io = new Bundle {
    val clk_en = Bool(INPUT)
    val start = Bool(INPUT)
    val start_next_stage = Bool(OUTPUT)
    val in = Vec.fill(M * k) { UInt(INPUT, DATA_WIDTH) }
    val out = Vec.fill(M * k) { UInt(OUTPUT, DATA_WIDTH) }
  }

  // instantiate fft module, all together k fft
}
