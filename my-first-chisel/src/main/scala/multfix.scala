/**
  * Created by chizhang on 7/6/16.
  */
import Chisel._

class multfixParam(dataWidth: Int, cycles: Int) extends VerilogParameters {
  val WIDTH = dataWidth
  val CYCLES = cycles
}

class multfix(DATA_WIDTH: Int, CYCLES: Int) extends BlackBox {
  val io = new Bundle {
    val a = UInt(INPUT, width = DATA_WIDTH)
    val b = UInt(INPUT, width = DATA_WIDTH)
    val q_sc = UInt(OUTPUT, width = DATA_WIDTH)
    val q_unsc = UInt(OUTPUT, width = DATA_WIDTH)
  }

  io.a.setName("a")
  io.b.setName("b")
  io.q_sc.setName("q_sc")
  io.q_unsc.setName("q_unsc")

  moduleName = "multfix"

  setVerilogParameters(new multfixParam(DATA_WIDTH, CYCLES))

  addClock(Driver.implicitClock)
  renameReset("rst")

}


class multfixWrapper(DATA_WIDTH: Int, CYCLES: Int) extends Module {
  val io = new Bundle {
    val a = UInt(INPUT, width = DATA_WIDTH)
    val b = UInt(INPUT, width = DATA_WIDTH)
    val q_sc = UInt(OUTPUT, width = DATA_WIDTH)
    val q_unsc = UInt(OUTPUT, width = DATA_WIDTH)
  }

  val multifixInst = Module(new multfix(DATA_WIDTH, CYCLES)).io

  multifixInst.a := io.a
  multifixInst.b := io.b
  io.q_sc := multifixInst.q_sc
  io.q_unsc := multifixInst.q_unsc

}

object multifixWrapperObj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--targetDir", "./verilog/", "--v")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMain(margs, () => Module(new multfixWrapper(16, 2)))
  }
}
