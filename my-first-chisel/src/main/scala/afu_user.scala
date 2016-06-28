/**
  * Created by chizhang on 6/27/16.
  */

import Chisel._

class afu_user(DATA_WIDTH: Int, k: Int, M: Int, FIFO_DEPTH_BITS: Int) extends Module {
  val io = new Bundle {
    // input fifo
    val input_fifo_din = UInt(INPUT, width = 512)
    val input_fifo_we = Bool(INPUT)
    val input_fifo_full = Bool(OUTPUT)
    val input_fifo_almost_full = Bool(OUTPUT)
    val input_fifo_count = UInt(OUTPUT, width = FIFO_DEPTH_BITS)
    // output fifo
    val output_fifo_dout = UInt(OUTPUT, width = 512)
    val output_fifo_re = Bool(INPUT)
    val output_fifo_empty = Bool(OUTPUT)
    val output_fifo_almost_empty = Bool(OUTPUT)
    val ctx_length = UInt(INPUT, 32)
  }

  // use the original name
  io.input_fifo_din.setName("input_fifo_din")
  io.input_fifo_we.setName("input_fifo_we")
  io.input_fifo_full.setName("input_fifo_full")
  io.input_fifo_almost_full.setName("input_fifo_almost_full")
  io.input_fifo_count.setName("input_fifo_count")
  io.output_fifo_dout.setName("output_fifo_dout")
  io.output_fifo_re.setName("output_fifo_re")
  io.output_fifo_empty.setName("output_fifo_empty")
  io.output_fifo_almost_empty.setName("output_fifo_almost_empty")
  io.ctx_length.setName("ctx_length")

  // input fifo
  val inputFIFOInst = Module(new syn_read_fifo(FIFO_DEPTH_BITS)).io

  inputFIFOInst.din := io.input_fifo_din
  inputFIFOInst.we := io.input_fifo_we

  io.input_fifo_full := inputFIFOInst.full
  io.input_fifo_almost_full := inputFIFOInst.almostfull
  io.input_fifo_count := inputFIFOInst.count

  when (reset) {
    inputFIFOInst.re := UInt(0)
  }.otherwise {
    inputFIFOInst.re := ~inputFIFOInst.empty
  }

  // start logic
  val start_reg = Reg(init = Bool(false))
  when (inputFIFOInst.re) {
    start_reg := Bool(true)
  }.otherwise {
    start_reg := Bool(false)
  }

  // input and output count logic
  val ctx_input_count = Reg(init = UInt(0, width = 32))
  val ctx_output_count = Reg(init = UInt(0, width = 32))

  when (inputFIFOInst.re) {
    ctx_input_count := ctx_input_count + UInt(1)
  }

  // define stream matrix transpose top
  val streamMatrixInst = Module(new streamMatrixTransposeTop(DATA_WIDTH, k, M)).io

  streamMatrixInst.start := start_reg
  when (io.ctx_length === ctx_input_count) {
    streamMatrixInst.clk_en := UInt(1)
  }.otherwise {
    streamMatrixInst.clk_en := start_reg
  }


  // slice the output of input fifo
  for (i <- 0 until M * k) {
    streamMatrixInst.in(i) := inputFIFOInst.dout((i + 1) * DATA_WIDTH - 1, i * DATA_WIDTH)
  }


  //output fifo
  val outputFIFOInst = Module(new syn_read_fifo(FIFO_DEPTH_BITS)).io

  // slice the output of stream matrix transpose top
  outputFIFOInst.din := streamMatrixInst.out.toBits()

  // output count
  when (outputFIFOInst.we) {
    ctx_output_count := ctx_output_count + UInt(1)
  }

  io.output_fifo_dout := outputFIFOInst.dout
  outputFIFOInst.re := io.output_fifo_re

  when (io.ctx_length === ctx_output_count) {
    outputFIFOInst.we := UInt(0)
  }.otherwise {
    outputFIFOInst.we := streamMatrixInst.start_next_stage & streamMatrixInst.clk_en
  }

  io.output_fifo_almost_empty := outputFIFOInst.almostempty
  io.output_fifo_empty := outputFIFOInst.empty
}


object afu_userObj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--targetDir", "./verilog/", "--v")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMain(margs, () => Module(new afu_user(32, 2, 8, 6)))
  }
}