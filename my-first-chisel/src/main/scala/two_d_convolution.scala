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
  val fftArrayFirst = Vec.fill(k) { Module(new fft(DATA_WIDTH, M, M)).io }
  for (i <- 0 until k) {
    fftArrayFirst(i).next := io.start
    for (j <- 0 until M) {
      fftArrayFirst(i).input(2 * j) := io.in(i * M + j)
      fftArrayFirst(i).input(2 * j + 1) := UInt(0)
    }
  }

  // define the first matrixTranspose
  val matrixTransposeFirst = Module(new streamMatrixTransposeTop(2 * DATA_WIDTH, k, M)).io
  matrixTransposeFirst.start := fftArrayFirst(0).next_out

  for (i <- 0 until k) {
    for (j <- 0 until M) {
      matrixTransposeFirst.in(i * M + j) := Cat(fftArrayFirst(i).input(2 * j + 1), fftArrayFirst(i).input(2 * j))
    }
  }

  //

}
