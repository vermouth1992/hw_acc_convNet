/**
  * Created by chizhang on 6/27/16.
  */

import Chisel._

class streamMatrixTransposeTop(DATA_WIDTH: Int, k: Int, M: Int) extends Module {
  val io = new Bundle {
    val clk_en = Bool(INPUT)
    val start = Bool(INPUT)
    val start_next_stage = Bool(OUTPUT)
    val in = Vec.fill(M * k) { UInt(INPUT, DATA_WIDTH) }
    val out = Vec.fill(M * k) { UInt(OUTPUT, DATA_WIDTH) }
  }

  val crossbarInst = Module(new crossbar(DATA_WIDTH, k, M)).io

  crossbarInst.clk_en := io.clk_en
  crossbarInst.start := io.start
  crossbarInst.in := io.in

  val crossbarShiftDownInst = Module(new crossbarShift(DATA_WIDTH, k, M, true)).io

  crossbarShiftDownInst.clk_en := io.clk_en
  crossbarShiftDownInst.start := crossbarInst.start_next_stage
  crossbarShiftDownInst.in := crossbarInst.out

  val memArrayInst = Module(new memArray(DATA_WIDTH, k, M)).io

  memArrayInst.clk_en := io.clk_en
  memArrayInst.start := crossbarShiftDownInst.start_next_stage
  memArrayInst.in := crossbarShiftDownInst.out

  val crossbarShiftUpInst = Module(new crossbarShift(DATA_WIDTH, k, M, false)).io

  crossbarShiftUpInst.clk_en := io.clk_en
  crossbarShiftUpInst.start := memArrayInst.start_next_stage
  crossbarShiftUpInst.in := memArrayInst.out

  io.start_next_stage := crossbarShiftUpInst.start_next_stage
  io.out := crossbarShiftUpInst.out
}

class streamMatrixTransposeTopTest(c: streamMatrixTransposeTop) extends Tester(c) {

}

object streamMatrixTransposeTopObj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--targetDir", "./verilog/", "--v")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMainTest(margs, () => Module(new streamMatrixTransposeTop(32, 2, 8))){ c => new streamMatrixTransposeTopTest(c)}
  }
}