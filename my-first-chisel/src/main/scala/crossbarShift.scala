/**
  * Created by chizhang on 6/27/16.
  */
import Chisel._

class crossbarShift(DATA_WIDTH: Int, k: Int, M: Int, isShiftDown: Boolean) extends Module{

  def getInputIndexGivenOutputIndex(outputIndex: Int, shiftNum: Int) = {
    if (isShiftDown) {
      if (outputIndex - shiftNum < 0) outputIndex + M * k - shiftNum
      else outputIndex - shiftNum
    }
    else (outputIndex + shiftNum) % (k * M)
  }

  if (isShiftDown) moduleName = "crossbarShiftDown"
  else moduleName = "crossbarShiftUp"

  val io = new Bundle {
    val clk_en = Bool(INPUT)
    val start = Bool(INPUT)
    val start_next_stage = Bool(OUTPUT)
    val in = Vec.fill(M * k) { UInt(INPUT, DATA_WIDTH) }
    val out = Vec.fill(M * k) { UInt(OUTPUT, DATA_WIDTH) }
  }

  // start_next_stage
  val start_next_stage_reg = Reg(init = Bool(false))

  io.start_next_stage := start_next_stage_reg

  val timestamp = Reg(init = UInt(0, width = log2Up(M / k)))

  when (io.clk_en & io.start) {
    start_next_stage_reg := Bool(true)
    timestamp := timestamp + UInt(1)
  }

  // output register
  val out_reg = Vec.fill(k * M) {Reg(UInt(width=DATA_WIDTH))}


  when (io.start & io.clk_en) {
    for (i <- 0 until M / k) {  // timestamp
      when (timestamp === UInt(i)) {
        for (j <- 0 until M * k) {
          out_reg(j) := io.in(getInputIndexGivenOutputIndex(j, i * k))
        }
      }
    }
  }

  for (i <- 0 until M * k) {
    io.out(i) := out_reg(i)
  }

}


object crossbarShiftObj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--targetDir", "./verilog/", "--v", "-feature")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMain(margs, () => Module(new crossbarShift(32, 2, 8, false)))
  }
}