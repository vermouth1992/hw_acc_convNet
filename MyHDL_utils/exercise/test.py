from myhdl import *
from random import randrange


def dff(clk, d, q):
    @always(clk.posedge)
    def logic():
        q.next = d

    return logic


def test_dff():
    q, d, clk = [Signal(bool(0)) for _ in range(3)]

    dff_inst = dff(clk, d, q)

    @always(delay(10))
    def clkgen():
        clk.next = not clk

    @always(clk.posedge)
    def stimulus():
        d.next = randrange(2)

    return dff_inst, clkgen, stimulus


def simulate(timesteps):
    tb = traceSignals(test_dff)
    sim = Simulation(tb)
    sim.run(timesteps)

def convert():
    q, d, clk = [Signal(bool(0)) for i in range(3)]
    toVerilog(dff, q, d, clk)

convert()