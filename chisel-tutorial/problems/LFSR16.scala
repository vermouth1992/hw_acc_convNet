package TutorialProblems

import Chisel._

class LFSR16 extends Module {
  val io = new Bundle {
    val inc = Bool(INPUT)
    val out = UInt(OUTPUT, 16)
  }
  // COMPUTE LFSR16 HERE
  val reg = Reg(init = UInt(1, width = 16))
  when (io.inc === UInt(1)) {
    for (i <- 0 until 15) {
      reg(i) := reg(i+1)
    }
    reg(15) := reg(0) ^ reg(2) ^ reg(3) ^ reg(5)
  }

  io.out := reg
}

class LFSR16Tests(c: LFSR16) extends Tester(c) {
  var res = 1
  for (t <- 0 until 16) {
    val inc = rnd.nextInt(2)
    poke(c.io.inc, inc)
    step(1)
    if (inc == 1) {
      val bit = ((res >> 0) ^ (res >> 2) ^ (res >> 3) ^ (res >> 5) ) & 1;
      res = (res >> 1) | (bit << 15);
    }
    expect(c.io.out, res)
  }
}
