/**
  * Created by chizhang on 7/6/16.
  */
import Chisel._

class multComplex(DATA_WIDTH: Int, multCycles: Int, addsubCycles: Int) extends Module {
  val io = new Bundle {
    val real1 = UInt(INPUT, width = DATA_WIDTH)
    val img1 = UInt(INPUT, width = DATA_WIDTH)
    val real2 = UInt(INPUT, width = DATA_WIDTH)
    val img2 = UInt(INPUT, width = DATA_WIDTH)
    val realOut = UInt(OUTPUT, width = DATA_WIDTH)
    val imgOut = UInt(OUTPUT, width = DATA_WIDTH)
  }

  // delay real1, real2, img1 by addsubCycles
  val delayArrayReal1 = Vec.fill(addsubCycles) { Reg(UInt()) }

  when(Bool(true)) {
    delayArrayReal1(0) := io.real1
    for (i <- 0 until addsubCycles - 1) {
      delayArrayReal1(i + 1) := delayArrayReal1(i)
    }
  }

  val delayArrayReal2 = Vec.fill(addsubCycles) { Reg(UInt()) }

  when(Bool(true)) {
    delayArrayReal2(0) := io.real2
    for (i <- 0 until addsubCycles - 1) {
      delayArrayReal2(i + 1) := delayArrayReal2(i)
    }
  }

  val delayArrayImg1 = Vec.fill(addsubCycles) {Reg(UInt()) }

  when(Bool(true)) {
    delayArrayImg1(0) := io.img1
    for (i <- 0 until addsubCycles - 1) {
      delayArrayImg1(i + 1) := delayArrayImg1(i)
    }
  }

  val subArray = Vec.fill(3) { Module(new addsubfxp(DATA_WIDTH, addsubCycles, false)).io }
  val addArray = Vec.fill(2) { Module(new addsubfxp(DATA_WIDTH, addsubCycles, true)).io }
  val multArray = Vec.fill(3) { Module(new multfix(DATA_WIDTH, multCycles)).io }

  // first pipeline
  subArray(0).a := io.real1
  subArray(0).b := io.img1

  subArray(1).a := io.real2
  subArray(1).b := io.img2

  addArray(0).a := io.real2
  addArray(0).b := io.img2

  // second pipeline
  multArray(0).a := subArray(0).q
  multArray(0).b := delayArrayReal2(addsubCycles - 1)

  multArray(1).a := delayArrayImg1(addsubCycles - 1)
  multArray(1).b := subArray(1).q

  multArray(2).a := addArray(0).q
  multArray(2).b := delayArrayReal1(addsubCycles - 1)

  // third pipeline
  addArray(1).a := multArray(0).q_sc
  addArray(1).b := multArray(1).q_sc

  subArray(2).a := multArray(0).q_sc
  subArray(2).b := multArray(2).q_sc

  io.realOut := addArray(1).q
  io.imgOut := subArray(2).q

}
