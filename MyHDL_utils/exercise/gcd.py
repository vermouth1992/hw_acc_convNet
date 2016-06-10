from myhdl import *
import os

"""
A sequential example
"""

def gcd(clk, inputA, inputB, start, output, ready):

    tempA = intbv(0)[5:]
    tempB = intbv(1)[5:]

    @always(clk.posedge)
    def gcdLogic():
        if start:
            tempA.next = inputA
            tempB.next = inputB
        elif tempA > tempB:
            tempA.next = tempA - tempB
        else:
            tempB.next = tempB - tempA

        output.next = tempA
        if tempB == 0:
            ready.next = 1
            tempB.next = 1

        if ready == 1:
            ready.next = 0

    return gcdLogic


# testbench
def gcdTestBench():
    clk = Signal(bool(0))
    start = Signal(bool(0))
    inputA = Signal(0)
    inputB = Signal(0)
    output = Signal(0)
    ready = Signal(bool(0))

    dut = gcd(clk, inputA, inputB, start, output, ready)

    @always(delay(1))
    def clkgen():
        clk.next = not clk

    @instance
    def stimulus():
        inputA.next = 12
        inputB.next = 8
        start.next = 1
        yield clk.posedge
        start.next = 0
        while ready != 1:
            yield clk.posedge
        raise StopSimulation

    @always(clk.posedge)
    def monitor():
        print inputA, inputB, start, output, ready

    return dut, clkgen, stimulus, monitor

def gcdSimulate(timesteps):
    filename = "gcdTestBench.vcd"
    os.system("rm -rf " + filename)
    tb = traceSignals(gcdTestBench)
    traceSignals.name = filename
    sim = Simulation(tb)
    sim.run(timesteps)

def gcdConvert():
    inputA = intbv(0)[5:]
    inputB = intbv(0)[5:]
    start = Signal(bool(0))
    output = Signal(bool(0))
    ready = Signal(bool(0))
    clk = Signal(bool(0))
    toVerilog(gcd, clk, inputA, inputB, start, output, ready)

gcdSimulate(100)
gcdConvert()


"""
A combination example, use always and assign
"""



"""
An example to instantiate another block inside the current block
"""


"""
An example to instantiate a mem, asyn FIFO and syn FIFO, for synthesis reason, we have to explicitly write
the pass-by logic
"""


"""
A FSM example
"""
ACTIVE_LOW = 0
FRAME_SIZE = 8
t_State = enum('SEARCH', 'CONFIRM', 'SYNC')

def FramerCtrl(SOF, state, syncFlag, clk, reset):
    index = Signal(0) # position in frame

    @always_seq(clk.posedge, reset=reset)
    def FSM():
        index.next = (index + 1) % FRAME_SIZE
        SOF.next = 0

        if state == t_State.SEARCH:
            index.next = 1
            if syncFlag:
                state.next = t_State.CONFIRM

        elif state == t_State.CONFIRM:
            if index == 0:
                if syncFlag:
                    state.next = t_State.SYNC
                else:
                    state.next = t_State.SEARCH

        elif state == t_State.SYNC:
            if index == 0:
                if not syncFlag:
                    state.next = t_State.SEARCH
            SOF.next = (index == FRAME_SIZE-1)

        else:
            raise ValueError("Undefined state")

    return FSM

"""
Two clock domain interacts, maybe needed
"""