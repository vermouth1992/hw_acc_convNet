/**
  * Created by chizhang on 6/27/16.
  */

import Chisel._

class syn_read_fifo(val FIFO_DEPTH_BITS: Int = 5) extends BlackBox {

  setVerilogParameters(
    "#(.FIFO_WIDTH(512)," +
      ".FIFO_DEPTH_BITS(" + FIFO_DEPTH_BITS + ")," +
      ".FIFO_ALMOSTFULL_THRESHOLD(" + (math.pow(2, FIFO_DEPTH_BITS) - 4).toInt + ")," +
      ".FIFO_ALMOSTEMPTY_THRESHOLD(2)" + ")\n ")

  moduleName = "syn_read_fifo"

  val io = new Bundle {
    // input
    //val clk = Bool(INPUT)
    // val reset = Bool(INPUT)
    val din = UInt(INPUT, 512)
    val we = Bool(INPUT)
    val re = Bool(INPUT)
    // output
    val dout = UInt(OUTPUT, 512)
    val empty = Bool(OUTPUT)
    val almostempty = Bool(OUTPUT)
    val full = Bool(OUTPUT)
    val count = Bool(OUTPUT)
    val almostfull = Bool(OUTPUT)
  }

  //io.clk.setName("clk")
  // io.reset.setName("reset")
  io.din.setName("din")
  io.we.setName("we")
  io.re.setName("re")

  io.dout.setName("dout")
  io.empty.setName("empty")
  io.almostempty.setName("almostempty")
  io.full.setName("full")
  io.count.setName("count")
  io.almostfull.setName("almostfull")

  addClock(Driver.implicitClock)
  addResetPin(Driver.implicitReset)
}
