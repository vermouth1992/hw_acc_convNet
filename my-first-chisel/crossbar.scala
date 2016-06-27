
import Chisel._

class crossbar(WIDTH: Int, numInput: Int) extends Module {
  val io = new Bundle {
    val input = Vec.fill(numInput) {UInt(INPUT, width=WIDTH)}
    val output = Vec.fill(numInput) {UInt(OUTPUT, width=WIDTH)}
    val clk_en = Bool(INPUT)
  }

  val output_reg = Vec.fill(numInput) {Reg(UInt(width=WIDTH))}

  when (io.clk_en) {
    for (i <- 0 until numInput) {
      output_reg(i) := io.input(i)
    }
  }

  for (i <- 0 until numInput) {
    io.output(i) := output_reg(i)
  }
}

class CrossBarTest(c: crossbar) extends Tester(c) {

}

object CrossBarObj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--v")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMainTest(margs, () => Module(new crossbar(8, 5))){ c => new CrossBarTest(c)}
  }
}