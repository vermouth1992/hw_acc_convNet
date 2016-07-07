/**
  * Created by chizhang on 7/6/16.
  */
import Chisel._

class addsubfxpParam(DATA_WIDTH: Int, CYCLES: Int) extends VerilogParameters {
  val width = DATA_WIDTH
  val cycles = CYCLES
}

class addsubfxp(DATA_WIDTH: Int, CYCLES: Int, isAdd: Boolean) extends BlackBox {
  val io = new Bundle {
    val a = UInt(INPUT, width = DATA_WIDTH)
    val b = UInt(INPUT, width = DATA_WIDTH)
    val q = UInt(OUTPUT, width = DATA_WIDTH)
  }

  if (isAdd) {
    moduleName = "addfxp"
  } else {
    moduleName = "subfxp"
  }

  io.a.setName("a")
  io.b.setName("b")
  io.q.setName("q")

  setVerilogParameters(new addsubfxpParam(DATA_WIDTH, CYCLES))

  addClock(Driver.implicitClock)

}
