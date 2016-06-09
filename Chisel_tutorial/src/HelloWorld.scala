/**
  * Created by chizhang on 6/8/16.
  */

import Chisel._

class GCD extends Module {
  val io = new Bundle {
    val operand1 = UInt(INPUT, 16)
    val operand2 = UInt(INPUT, 16)
    val start = Bool(INPUT)
    val output = UInt(OUTPUT, 16)
    val valid = Bool(OUTPUT)
  }
  val x = Reg(UInt())
  val y = Reg(UInt())
  when(x > y) {
    x := x - y
  }
  unless(x > y) {
    y := y - x
  }
  when(io.start) {
    x := io.operand1
    y := io.operand2
  }
  io.output := x
  io.valid := y === UInt(0)
}


object HelloWorld {
  def main(args: Array[String]) {
    chiselMain(args, () => Module(new GCD()))
  }

}
