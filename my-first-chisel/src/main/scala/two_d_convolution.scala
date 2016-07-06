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

  // delay the input by one cycle
  val delayInput = Vec.fill(M * k) { Reg(UInt(width = DATA_WIDTH)) }

  when(Bool(true)) {
    delayInput := io.in
  }

  // instantiate fft module, all together k fft
  val fftArrayFirst = Vec.fill(k) { Module(new fft(DATA_WIDTH, M, M)).io }
  for (i <- 0 until k) {
    fftArrayFirst(i).next := io.start
    for (j <- 0 until M) {
      fftArrayFirst(i).input(2 * j) := delayInput(i * M + j)
      fftArrayFirst(i).input(2 * j + 1) := UInt(0)
    }
  }

  // define the first matrixTranspose
  val matrixTransposeFirst = Module(new streamMatrixTransposeTop(2 * DATA_WIDTH, k, M)).io
  matrixTransposeFirst.clk_en := Bool(true)

  val startFirstMatrix = Reg(next = fftArrayFirst(0).next_out)
  matrixTransposeFirst.start := startFirstMatrix

  for (i <- 0 until k) {
    for (j <- 0 until M) {
      matrixTransposeFirst.in(i * M + j) := Cat(fftArrayFirst(i).output(2 * j + 1), fftArrayFirst(i).output(2 * j))
    }
  }


  val delaySecond = Vec.fill(M * k) { Reg(UInt(width = DATA_WIDTH)) }

  when(Bool(true)) {
    delaySecond := matrixTransposeFirst.out
  }

  // instantiate second fft array
  val fftArraySecond = Vec.fill(k) { Module(new fft(DATA_WIDTH, M, M)).io }
  for (i <- 0 until k) {
    fftArraySecond(i).next := matrixTransposeFirst.start_next_stage
    for (j <- 0 until M) {
      fftArraySecond(i).input(2 * j) := delaySecond(i * M + j)(DATA_WIDTH - 1, 0)
      fftArraySecond(i).input(2 * j + 1) := delaySecond(i * M + j)(2 * DATA_WIDTH - 1, DATA_WIDTH)
    }
  }

  // complex multiplier array


}
