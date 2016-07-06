/**
  * Created by chizhang on 7/6/16.
  */

import Chisel._

class two_d_convolution(DATA_WIDTH: Int, k: Int, M: Int, addsubCycles: Int, multCycles: Int) extends Module {
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
  val fftArrayFirst = Vec.fill(k) { Module(new fft(DATA_WIDTH, M, M, true)).io }
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


  val delayFirst = Vec.fill(M * k) { Reg(UInt(width = DATA_WIDTH)) }

  when(Bool(true)) {
    delayFirst := matrixTransposeFirst.out
  }

  // instantiate second fft array
  val fftArraySecond = Vec.fill(k) { Module(new fft(DATA_WIDTH, M, M, true)).io }
  for (i <- 0 until k) {
    fftArraySecond(i).next := matrixTransposeFirst.start_next_stage
    for (j <- 0 until M) {
      fftArraySecond(i).input(2 * j) := delayFirst(i * M + j)(DATA_WIDTH - 1, 0)
      fftArraySecond(i).input(2 * j + 1) := delayFirst(i * M + j)(2 * DATA_WIDTH - 1, DATA_WIDTH)
    }
  }

  // complex multiplier array
  val complexMultArray = Vec.fill(k * M) { Module(new multComplex(DATA_WIDTH, addsubCycles, multCycles)).io }
  for (i <- 0 until k) {
    for (j <- 0 until M) {
      complexMultArray(i * M + j).real1 := fftArraySecond(i).output(2 * j)
      complexMultArray(i * M + j).img1 := fftArraySecond(i).output(2 * j + 1)
      complexMultArray(i * M + j).real2 := UInt(1)    // read from ROM
      complexMultArray(i * M + j).img2 := UInt(1)     // read from ROM
    }
  }

  // delay array for the next_out_signal
  val delayArrayNext = Vec.fill(addsubCycles + multCycles) { Reg(UInt()) }

  when(Bool(true)) {
    delayArrayNext(0) := fftArraySecond(0).next_out
    for (i <- 0 until addsubCycles + multCycles - 1) {
      delayArrayNext(i + 1) := delayArrayNext(i)
    }
  }

  // ifft first stage
  val ifftArrayFirst = Vec.fill(k) { Module(new fft(DATA_WIDTH, M, M, false)).io }

  val ifftArraySecond = Vec.fill(k) { Module(new fft(DATA_WIDTH, M, M, false)).io }

  val matrixTransposeSecond = Module(new streamMatrixTransposeTop(2 * DATA_WIDTH, k, M)).io

  matrixTransposeSecond.clk_en := Bool(true)   // never stall
  // connect first IFFT Array input
  for (i <- 0 until k) {
    ifftArrayFirst(i).next := delayArrayNext(addsubCycles + multCycles - 1)
    for (j <- 0 until M) {
      ifftArrayFirst(i).input(2 * j) := complexMultArray(i * M + j).realOut
      ifftArrayFirst(i).input(2 * j + 1) := complexMultArray(i * M + j).imgOut
    }
  }

  // delay the next_out of
  val startSecondMatrix = Reg(next = ifftArrayFirst(0).next_out)
  matrixTransposeSecond.start := startSecondMatrix

  // connect first IFFT array output to second streamMatrixTranspose
  for (i <- 0 until k) {
    for (j <- 0 until M) {
      matrixTransposeSecond.in(i * M + j) := Cat(ifftArrayFirst(i).output(2 * j + 1), ifftArrayFirst(i).output(2 * j))
    }
  }


  val delaySecond = Vec.fill(M * k) { Reg(UInt(width = DATA_WIDTH)) }

  when(Bool(true)) {
    delaySecond := matrixTransposeSecond.out
  }

  // connect second streamMatrixTranspose output to second IFFT array input
  for (i <- 0 until k) {
    ifftArraySecond(i).next := matrixTransposeSecond.start_next_stage
    for (j <- 0 until M) {
      ifftArraySecond(i).input(2 * j) := delaySecond(i * M + j)(DATA_WIDTH - 1, 0)
      ifftArraySecond(i).input(2 * j + 1) := delaySecond(i * M + j)(2 * DATA_WIDTH - 1, DATA_WIDTH)
    }
  }

  // connect the second IFFT array output to output
  for (i <- 0 until k) {
    for (j <- 0 until M) {
      io.out(i * M + j) := ifftArraySecond(i).output(2 * j)
    }
  }

  // delay output start_next_stage
  val delayStartNextStage = Reg(next = ifftArraySecond(0).next_out)

  io.start_next_stage := delayStartNextStage

}
