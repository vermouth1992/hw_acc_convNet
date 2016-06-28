
import Chisel._

class single_port_ram(WIDTH: Int, DEPTH: Int) extends Module {
  val io = new Bundle {
    val data = UInt(INPUT, WIDTH)
    val addr = UInt(INPUT, log2Up(DEPTH))
    val we = Bool(INPUT)
    val q = UInt(OUTPUT, WIDTH)
  }

  val myMem = Mem(UInt(width=WIDTH), DEPTH, seqRead = true)
  val out = Reg(UInt())

  when (io.we) {
    myMem(io.addr) := io.data
    out := myMem(io.addr)
  }

  io.q := out
}

class single_port_ram_Tests(c: single_port_ram) extends Tester(c) {

}

object single_port_ram_obj {
  def main(args: Array[String]): Unit = {
    val margs = Array("--backend", "v")
    //val margs = Array("--backend", "c", "--genHarness", "--compile", "--test")
    chiselMainTest(margs, () => Module(new single_port_ram(8, 64))){c => new single_port_ram_Tests(c)}
  }
}