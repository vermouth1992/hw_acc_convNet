/**
  * Created by chizhang on 6/27/16.
  */

import Chisel._

class memArray(DATA_WIDTH: Int, k: Int, M: Int) extends Module {
  val io = new Bundle {
    val clk_en = Bool(INPUT)
    val start = Bool(INPUT)
    val start_next_stage = Bool(OUTPUT)
    val in = Vec.fill(M * k) { UInt(INPUT, DATA_WIDTH) }
    val out = Vec.fill(M * k) { UInt(OUTPUT, DATA_WIDTH) }
  }

  moduleName = "memArray"

  // address
  val address = Vec.fill(M) {Reg(init = UInt(0, width=log2Up(M / k)))}

  // start next stage
  val start_next_stage_reg = Reg(init = Bool(false))
  io.start_next_stage := start_next_stage_reg

  // counter
  val counter = Reg(init = UInt(0, width=log2Up(M / k)))


  // finite state machine
  val sIDLE :: p1 :: p2 :: Nil = Enum(UInt(), 3)
  val state = Reg(init = sIDLE)

  when (io.clk_en && io.start) {
    when (state === sIDLE) {
      state := p1
      counter := counter + UInt(1)
      for (i <- 0 until M) {
        address(i) := address(i) + UInt(1)
      }
    }
    when (state === p1) {
      counter := counter + UInt(1)
      when (counter === UInt(M / k - 1)) {
        state := p2
        for (i <- 0 until M) {
          address(i) := UInt(i % (M / k))
        }

      } .otherwise {
        for (i <- 0 until M) {
          address(i) := address(i) + UInt(1)
        }
      }
    }

    when (state === p2) {
      counter := counter + UInt(1)
      start_next_stage_reg := Bool(true)
      when (counter === UInt(M / k - 1)) {
        state := p1
        for (i <- 0 until M) {
          address(i) := UInt(0)
        }
      } .otherwise {
        for (i <- 0 until M) {
          address(i) := address(i) - UInt(1)
        }
      }
    }
  }

  val memBlock = Vec.fill(M * k) { Module(new single_port_ram(DATA_WIDTH, M / k)).io }

  for (i <- 0 until M * k) {
    memBlock(i).data := io.in(i)
    memBlock(i).addr := address(i / k)
    memBlock(i).we := io.start & io.clk_en
    io.out(i) := memBlock(i).q
  }
}


object memArrayObj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--targetDir", "./verilog/", "--v")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMain(margs, () => Module(new memArray(32, 2, 8)))
  }
}