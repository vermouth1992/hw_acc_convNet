
import Chisel._

class crossbar(DATA_WIDTH: Int, k: Int, M: Int) extends Module {

  def getInputIndexGivenOutputIndex(outputIndex: Int) = {
    val i = (outputIndex % M) % k + 1
    val j = (outputIndex / M) + 1 + ((outputIndex % M) / k) * k
    (i - 1) * M + j - 1
  }

  val io = new Bundle {
    val clk_en = Bool(INPUT)
    val start = Bool(INPUT)
    val start_next_stage = Bool(OUTPUT)
    val in = Vec.fill(k * M) {UInt(INPUT, width=DATA_WIDTH)}
    val out = Vec.fill(k * M) {UInt(OUTPUT, width=DATA_WIDTH)}
  }

  val out_reg = Vec.fill(k * M) {Reg(UInt(width=DATA_WIDTH))}

  val start_next_stage_reg = Reg(init = Bool(false))

  when (io.start & io.clk_en) {
    start_next_stage_reg := Bool(true)
  }

  io.start_next_stage := start_next_stage_reg

  when (io.clk_en && io.start) {
    for (i <- 0 until k * M) {
      out_reg(i) := io.in(getInputIndexGivenOutputIndex(i))
    }
  }

  for (i <- 0 until k * M) {
    io.out(i) := out_reg(i)
  }
}

class CrossBarTest(c: crossbar) extends Tester(c) {

}

object CrossBarObj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--targetDir", "./verilog/", "--v")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMainTest(margs, () => Module(new crossbar(32, 2, 8))){ c => new CrossBarTest(c)}
  }
}