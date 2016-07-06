/**
  * Created by chizhang on 6/28/16.
  */
import Chisel._

class fft(DATA_WIDTH: Int, numPoints: Int, streamWidth: Int) extends BlackBox {
  val io = new Bundle {
    val next = Bool(INPUT)
    val next_out = Bool(OUTPUT)
    val input = Vec.fill(streamWidth * 2) { UInt(INPUT, width = DATA_WIDTH) }
    val output = Vec.fill(streamWidth * 2) { UInt(OUTPUT, width = DATA_WIDTH) }
  }

  io.next.setName("next")
  io.next_out.setName("next_out")
  for (i <- 0 until streamWidth * 2) {
    io.input(i).setName("X" + i)
    io.output(i).setName("Y" + i)
  }

  moduleName = "fft" + numPoints + "_" + streamWidth

  addClock(Driver.implicitClock)
  addResetPin(Driver.implicitReset)
}

class fft_wrapper(DATA_WIDTH: Int, numPoints: Int, streamWidth: Int) extends Module {
  val io = new Bundle {
    val next = Bool(INPUT)
    val next_out = Bool(OUTPUT)
    val input = Vec.fill(streamWidth * 2) { UInt(INPUT, width = DATA_WIDTH) }
    val output = Vec.fill(streamWidth * 2) { UInt(OUTPUT, width = DATA_WIDTH) }
  }

  val fftInst = Module(new fft(DATA_WIDTH, numPoints, streamWidth)).io

  fftInst.next := io.next
  io.next_out := fftInst.next_out
  fftInst.input := io.input
  io.output := fftInst.output
}

object fft_wrapperObj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--targetDir", "./verilog/", "--v")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMain(margs, () => Module(new fft_wrapper(32, 8, 8)))
  }
}