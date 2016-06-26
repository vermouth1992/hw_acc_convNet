"""
This file is to generate p*p crossbar given k and M
M is the matrix size, k is p/M, # of lines processed in one cycle
"""

from generateVerilogUtil import *
import math


def getInputIndexMatrixTranspose(outputIndex, k, M):
    assert M % k == 0, "k must be a divisor of M."
    groupIndex = outputIndex // M  # from [0, k)
    groupOffset = outputIndex % M  # from [0, M)
    subGroupIndex = groupOffset // k  # from [0, M/k)
    subGroupOffset = groupOffset % k  # from [0, k)
    j = groupIndex + 1 + subGroupIndex * k
    i = subGroupOffset + 1
    return (i - 1) * M + j - 1, i, j


def getInputIndexShiftCrossbar(outputIndex, k, M, shiftNum):
    assert M % k == 0, "k must be a divisor of M."
    assert shiftNum % k == 0, "k must be a divisor of shiftNum"
    return (outputIndex - shiftNum) % (k * M)


def getShiftCrossbarPair(k, M, shiftNum):
    result = []
    for i in range(k * M):
        outputStr = "out" + str(i)
        inputStr = "in" + str(getInputIndexShiftCrossbar(i, k, M, shiftNum))
        result.append((inputStr, outputStr))
    return result


def generateCrossbarVerilog(k, M, inputWidth, fileName):
    f = open(fileName, "w")
    # generate the top comment
    f.write(generateVerilogNewLine(0, "/* " + fileName))
    f.write(generateVerilogNewLine(1, "* This file is automatically generated by Chi Zhang"))
    f.write(generateVerilogNewLine(1, "* k = " + str(k) + ", M = " + str(M)))
    f.write(generateVerilogNewLine(1, "*/"))
    crossbarSize = k * M
    crossbar = VerilogModule("crossbar" + str(crossbarSize) + "x" + str(crossbarSize))
    crossbar.addIO(ModuleIO(1, "clk", "input"))
    crossbar.addIO(ModuleIO(1, "clk_en", "input"))
    crossbar.addIO(ModuleIO(1, "reset", "input"))
    crossbar.addIO(ModuleIO(1, "start", "input"))
    crossbar.addParam(ModuleParam("DATA_WIDTH", inputWidth))
    inputWidth = "DATA_WIDTH"
    for i in range(k * M):
        crossbar.addIO(ModuleIO(inputWidth, "in" + str(i), "input"))

    startNextStageIO = ModuleIO(1, "start_next_stage", "output reg")
    crossbar.addIO(startNextStageIO)

    for i in range(k * M):
        crossbar.addIO(ModuleIO(inputWidth, "out" + str(i), "output reg"))

    f.write(crossbar.__str__())
    f.write("\n")

    # generate control block
    f.write(generateVerilogNewLine(2, "always@(posedge clk) begin"))
    f.write(generateVerilogNewLine(4, "if (reset) begin"))
    f.write(generateVerilogNewLine(6, generateAssignment(startNextStageIO, 0, "non-blocking")))
    f.write(generateVerilogNewLine(4, "end else if (clk_en & start) begin"))
    f.write(generateVerilogNewLine(6, generateAssignment(startNextStageIO, "start", "non-blocking")))
    f.write(generateVerilogNewLine(4, "end"))
    f.write(generateVerilogNewLine(2, "end"))
    f.write("\n")

    # generate always block
    f.write(generateVerilogNewLine(2, "always@(posedge clk) begin"))
    f.write(generateVerilogNewLine(4, "if (clk_en & start) begin"))
    for outIndex in range(k * M):
        inputIndex, _, _ = getInputIndexMatrixTranspose(int(outIndex), k, M)
        f.write(generateVerilogNewLine(6, "out" + str(outIndex) + " <= " + "in" + str(inputIndex) + ";"))
    f.write(generateVerilogNewLine(4, "end"))
    f.write(generateVerilogNewLine(2, "end"))
    f.write("\n")
    f.write(generateVerilogNewLine(0, "endmodule"))
    f.close()


def generateShiftCrossbarVerilog(k, M, defaultInputWidth, fileName, direction="Down"):
    f = open(fileName, "w")
    # generate the top comment
    f.write(generateVerilogNewLine(0, "/* " + fileName))
    f.write(generateVerilogNewLine(1, "* This file is automatically generated by Chi Zhang"))
    f.write(generateVerilogNewLine(1, "* k = " + str(k) + ", M = " + str(M)))
    f.write(generateVerilogNewLine(1, "*/"))
    crossbarSize = k * M
    timestamp = M / k
    timestampLength = int(math.log(timestamp, 2))
    # generate module io
    crossbarShift = VerilogModule("crossbarShift" + direction + str(crossbarSize) + "x" + str(crossbarSize))
    crossbarShift.addIO(ModuleIO(1, "clk", "input"))
    crossbarShift.addIO(ModuleIO(1, "clk_en", "input"))
    crossbarShift.addIO(ModuleIO(1, "start", "input"))
    crossbarShift.addIO(ModuleIO(1, "reset", "input"))
    crossbarShift.addParam(ModuleParam("DATA_WIDTH", defaultInputWidth))
    inputWidth = "DATA_WIDTH"
    for i in range(k * M):
        crossbarShift.addIO(ModuleIO(inputWidth, "in" + str(i), "input"))
    startNextStageModule = ModuleIO(1, "start_next_stage", "output reg")
    crossbarShift.addIO(startNextStageModule)
    for i in range(k * M):
        crossbarShift.addIO(ModuleIO(inputWidth, "out" + str(i), "output reg"))

    f.write(crossbarShift.__str__())
    f.write("\n")

    # generate control block
    t = ModuleReg(timestampLength, "timestamp")
    f.write(generateVerilogNewLine(2, t.__str__()))
    f.write("\n")
    f.write(generateVerilogNewLine(2, "always@(posedge clk) begin"))
    f.write(generateVerilogNewLine(4, "if (reset) begin"))
    f.write(generateVerilogNewLine(6, generateAssignment(startNextStageModule, 0, "non-blocking")))
    f.write(generateVerilogNewLine(6, generateAssignment(t, 0, "non-blocking")))
    f.write(generateVerilogNewLine(4, "end else if (clk_en & start) begin"))
    f.write(generateVerilogNewLine(6, generateAssignment(startNextStageModule, "start", "non-blocking")))
    f.write(generateVerilogNewLine(6, generateAssignment(t, "timestamp + 1", "non-blocking")))
    f.write(generateVerilogNewLine(4, "end"))
    f.write(generateVerilogNewLine(2, "end"))
    f.write("\n")

    # generate the always block
    f.write(generateVerilogNewLine(2, "always@(posedge clk) begin"))
    f.write(generateVerilogNewLine(4, "if (clk_en & start) begin"))
    f.write(generateVerilogNewLine(6, "case (timestamp)"))
    for i in range(timestamp):
        f.write(generateVerilogNewLine(8, numToVerilogBit(i, timestampLength) + ": begin"))
        if direction == "Down":
            shiftNum = i * k
        elif direction == "Up":
            shiftNum = - i * k
        else:
            raise NotImplementedError("Unknown direction")
        inOutPair = getShiftCrossbarPair(k, M, shiftNum)
        for inPort, outPort in inOutPair:
            f.write(generateVerilogNewLine(10, outPort + " <= " + inPort + ";"))
        f.write(generateVerilogNewLine(8, "end"))
    f.write(generateVerilogNewLine(6, "endcase"))
    f.write(generateVerilogNewLine(4, "end"))
    f.write(generateVerilogNewLine(2, "end"))
    f.write("\n")
    f.write(generateVerilogNewLine(0, "endmodule"))
    f.close()


"""
helper function to generate a single_port_ram for memArray
"""


def genSinglePortRam(k, M, index, baseIndent):
    result = ""
    result += generateVerilogNewLine(baseIndent, "single_port_ram # (")
    result += generateVerilogNewLine(baseIndent + 2, "")


def genMemArrayVerilog(k, M, defaultInputWidth, fileName):
    f = open(fileName, "w")
    # generate the top comment
    f.write(generateVerilogNewLine(0, "/* " + fileName))
    f.write(generateVerilogNewLine(1, "* This file is automatically generated by Chi Zhang"))
    f.write(generateVerilogNewLine(1, "* k = " + str(k) + ", M = " + str(M)))
    f.write(generateVerilogNewLine(1, "*/"))
    # generate module io
    memArray = VerilogModule("memArray" + str(M / k) + "x" + str(M * k))
    memArray.addIO(ModuleIO(1, "clk", "input"))
    memArray.addIO(ModuleIO(1, "clk_en", "input"))
    memArray.addIO(ModuleIO(1, "reset", "input"))
    memArray.addIO(ModuleIO(1, "start", "input"))
    memArray.addParam(ModuleParam("DATA_WIDTH", defaultInputWidth))
    inputWidth = "DATA_WIDTH"
    for i in range(k * M):
        memArray.addIO(ModuleIO(inputWidth, "in" + str(i), "input"))
    for i in range(k * M):
        memArray.addIO(ModuleIO(inputWidth, "out" + str(i), "output"))

    startNextStageReg = ModuleIO(1, "start_next_stage", "output reg")
    memArray.addIO(startNextStageReg)
    f.write(memArray.__str__())
    f.write("\n")

    # generate control block
    addressWidth = int(math.log(M / k, 2))
    addressRegList = []
    for i in range(M):
        startIndex = i * k
        endIndex = startIndex + k - 1
        addressReg = ModuleReg(addressWidth, "addr" + str(startIndex) + "_" + str(endIndex))
        f.write(generateVerilogNewLine(2, addressReg.__str__()))
        addressRegList.append(addressReg)

    f.write("\n")

    # add localparams
    f.write(generateVerilogNewLine(2, "localparam IDLE = 2'b00;"))
    f.write(generateVerilogNewLine(2, "localparam P1 = 2'b01;"))
    f.write(generateVerilogNewLine(2, "localparam P2 = 2'b10;"))
    f.write("\n")

    stateReg = ModuleReg(2, "state")
    f.write(generateVerilogNewLine(2, stateReg.__str__()))

    counterReg = ModuleReg(addressWidth, "counter")
    f.write(generateVerilogNewLine(2, counterReg.__str__()))
    f.write("\n")

    # create the FSM
    f.write(generateVerilogNewLine(2, "always@(posedge clk) begin"))
    f.write(generateVerilogNewLine(4, "if (reset) begin"))
    f.write(generateVerilogNewLine(6, generateAssignment(stateReg, "IDLE", "non-blocking")))
    f.write(generateVerilogNewLine(6, generateAssignment(counterReg, 0, "non-blocking")))
    f.write(generateVerilogNewLine(6, generateAssignment(startNextStageReg, 0, "non-blocking")))
    for addr in addressRegList:
        f.write(generateVerilogNewLine(6, generateAssignment(addr, 0, "non-blocking")))
    f.write(generateVerilogNewLine(4, "end else if (clk_en & start) begin"))
    f.write(generateVerilogNewLine(6, "case(state)"))
    # IDLE
    f.write(generateVerilogNewLine(8, "IDLE: begin"))
    f.write(generateVerilogNewLine(10, generateAssignment(stateReg, "P1")))
    f.write(generateVerilogNewLine(10, generateAssignment(counterReg, counterReg.getName() +
                                                          " + " + numToVerilogBit(1, counterReg.getLength()))))
    for addr in addressRegList:
        f.write(generateVerilogNewLine(10, generateAssignment(addr, addr.getName() +
                                                              " + " + numToVerilogBit(1, addr.getLength()))))
    f.write(generateVerilogNewLine(8, "end"))
    # P1
    f.write(generateVerilogNewLine(8, "P1: begin"))
    f.write(generateVerilogNewLine(10, generateAssignment(counterReg, counterReg.getName() +
                                                          " + " + numToVerilogBit(1, counterReg.getLength()))))
    f.write(generateVerilogNewLine(10, "if (counter == " + numToVerilogBit(M / k - 1, counterReg.getLength())
                                   + ") begin"))
    f.write(generateVerilogNewLine(12, generateAssignment(stateReg, "P2")))
    for i in range(len(addressRegList)):
        f.write(generateVerilogNewLine(12, generateAssignment(addressRegList[i], i % (M / k))))
    f.write(generateVerilogNewLine(10, "end else begin"))
    f.write(generateVerilogNewLine(12, generateAssignment(stateReg, "P1")))
    for addr in addressRegList:
        f.write(generateVerilogNewLine(12, generateAssignment(addr, addr.getName() +
                                                              " + " + numToVerilogBit(1, addr.getLength()))))
    f.write(generateVerilogNewLine(10, "end"))
    f.write(generateVerilogNewLine(8, "end"))
    # P2
    f.write(generateVerilogNewLine(8, "P2: begin"))
    f.write(generateVerilogNewLine(10, generateAssignment(counterReg, counterReg.getName() +
                                                          " + " + numToVerilogBit(1, counterReg.getLength()))))
    f.write(generateVerilogNewLine(10, generateAssignment(startNextStageReg, 1, "non-blocking")))
    f.write(generateVerilogNewLine(10, "if (counter == " + numToVerilogBit(M / k - 1, counterReg.getLength())
                                   + ") begin"))
    f.write(generateVerilogNewLine(12, generateAssignment(stateReg, "P1")))
    for i in range(len(addressRegList)):
        f.write(generateVerilogNewLine(12, generateAssignment(addressRegList[i], 0)))

    f.write(generateVerilogNewLine(10, "end else begin"))
    f.write(generateVerilogNewLine(12, generateAssignment(stateReg, "P2")))
    for addr in addressRegList:
        f.write(generateVerilogNewLine(12, generateAssignment(addr, addr.getName() +
                                                              " - " + numToVerilogBit(1, addr.getLength()))))
    f.write(generateVerilogNewLine(10, "end"))
    f.write(generateVerilogNewLine(8, "end"))
    f.write(generateVerilogNewLine(8, "default: begin end"))
    f.write(generateVerilogNewLine(6, "endcase"))
    f.write(generateVerilogNewLine(4, "end"))
    f.write(generateVerilogNewLine(2, "end"))

    f.write("\n")

    # generate the mem instantiation
    for i in range(M * k):
        mem = InstantiateModule("single_port_ram", "mem" + str(i), 2)
        mem.addParam(ModuleParam("DATA_WIDTH", "DATA_WIDTH"))
        mem.addParam(ModuleParam("ADDR_WIDTH", str(addressWidth)))
        mem.addIO(ModuleIO(None, "data", "input", "in" + str(i)))
        startIndex = int(i // k) * k
        endIndex = startIndex + k - 1
        mem.addIO(ModuleIO(None, "addr", "input", "addr" + str(startIndex) + "_" + str(endIndex)))
        mem.addIO(ModuleIO(None, "we", "input", "start & clk_en"))
        mem.addIO(ModuleIO(None, "clk", "input", "clk"))
        mem.addIO(ModuleIO(None, "q", "out", "out" + str(i)))
        f.write(mem.__str__())
        f.write("\n")

    f.write(generateVerilogNewLine(0, "endmodule"))
    f.close()


def generateStreamTransposeTop(k, M, defaultInputWidth, crossbarShiftDownName, crossbarName,
                               memArrayName, crossbarShiftUpName, fileName):
    f = open(fileName, "w")
    # generate the top comment
    f.write(generateVerilogNewLine(0, "/* " + fileName))
    f.write(generateVerilogNewLine(1, "* This file is automatically generated by Chi Zhang"))
    f.write(generateVerilogNewLine(1, "* k = " + str(k) + ", M = " + str(M)))
    f.write(generateVerilogNewLine(1, "*/"))
    # generate module io
    memArray = VerilogModule("streamMatrixTransposeTop" + str(crossbarSize) + "x" + str(crossbarSize))
    memArray.addIO(ModuleIO(1, "clk", "input"))
    memArray.addIO(ModuleIO(1, "clk_en", "input"))
    memArray.addIO(ModuleIO(1, "reset", "input"))
    memArray.addIO(ModuleIO(1, "start", "input"))
    memArray.addParam(ModuleParam("DATA_WIDTH", defaultInputWidth))
    inputWidth = "DATA_WIDTH"
    for i in range(k * M):
        memArray.addIO(ModuleIO(inputWidth, "in" + str(i), "input"))
    for i in range(k * M):
        memArray.addIO(ModuleIO(inputWidth, "out" + str(i), "output"))

    startNextStageReg = ModuleIO(1, "start_next_stage", "output")
    memArray.addIO(startNextStageReg)
    f.write(memArray.__str__())
    f.write("\n")

    # stage 0
    # instantiate crossbarShiftDown
    shiftDownOutList = []
    for i in range(k * M):
        shiftDownOutList.append(ModuleWire("DATA_WIDTH", "shiftDownOut" + str(i)))

    for shiftDownOutWire in shiftDownOutList:
        f.write(generateVerilogNewLine(2, shiftDownOutWire.__str__()))

    startNextStageWireShiftDown = ModuleWire(1, "start_next_stage_shiftDown")
    f.write(generateVerilogNewLine(2, startNextStageWireShiftDown.__str__()))
    f.write("\n")

    # construct the instance
    crossbarShiftDownInstance = InstantiateModule(crossbarName, "stage0", 2)
    crossbarShiftDownInstance.addParam(ModuleParam("DATA_WIDTH", "DATA_WIDTH"))
    crossbarShiftDownInstance.addIO(ModuleIO(1, "clk", "input", "clk"))
    crossbarShiftDownInstance.addIO(ModuleIO(1, "clk_en", "input", "clk_en"))
    crossbarShiftDownInstance.addIO(ModuleIO(1, "start", "input", "start"))
    crossbarShiftDownInstance.addIO(ModuleIO(1, "reset", "input", "reset"))
    for i in range(M * k):
        crossbarShiftDownInstance.addIO(ModuleIO("DATA_WIDTH", "in" + str(i), "input", "in" + str(i)))
    crossbarShiftDownInstance.addIO(ModuleIO(1, "start_next_stage", "output", startNextStageWireShiftDown.getName()))
    for i in range(M * k):
        crossbarShiftDownInstance.addIO(ModuleIO("DATA_WIDTH", "out" + str(i), "output", shiftDownOutList[i].getName()))

    f.write(crossbarShiftDownInstance.__str__())
    f.write("\n")

    # stage 1
    crossbarOutList = []
    for i in range(k * M):
        crossbarOutList.append(ModuleWire("DATA_WIDTH", "crossbarOut" + str(i)))

    for wire in crossbarOutList:
        f.write(generateVerilogNewLine(2, wire.__str__()))

    startNextStageWireCrossbar = ModuleWire(1, "start_next_stage_crossbar")
    f.write(generateVerilogNewLine(2, startNextStageWireCrossbar.__str__()))
    f.write("\n")

    # construct the instance
    crossbarInstance = InstantiateModule(crossbarShiftDownName, "stage1", 2)
    crossbarInstance.addParam(ModuleParam("DATA_WIDTH", "DATA_WIDTH"))
    crossbarInstance.addIO(ModuleIO(1, "clk", "input", "clk"))
    crossbarInstance.addIO(ModuleIO(1, "clk_en", "input", "clk_en"))
    crossbarInstance.addIO(ModuleIO(1, "reset", "input", "reset"))
    crossbarInstance.addIO(ModuleIO(1, "start", "input", startNextStageWireShiftDown.getName()))
    for i in range(M * k):
        crossbarInstance.addIO(ModuleIO("DATA_WIDTH", "in" + str(i), "input", shiftDownOutList[i].getName()))
    crossbarInstance.addIO(ModuleIO(1, "start_next_stage", "output", startNextStageWireCrossbar.getName()))
    for i in range(M * k):
        crossbarInstance.addIO(ModuleIO("DATA_WIDTH", "out" + str(i), "output", crossbarOutList[i].getName()))

    f.write(crossbarInstance.__str__())
    f.write("\n")

    # stage 2
    memArrayOutList = []
    for i in range(k * M):
        memArrayOutList.append(ModuleWire("DATA_WIDTH", "memArrayOut" + str(i)))

    for wire in memArrayOutList:
        f.write(generateVerilogNewLine(2, wire.__str__()))

    startNextStageWireMemArray = ModuleWire(1, "start_next_stage_memArray")
    f.write(generateVerilogNewLine(2, startNextStageWireMemArray.__str__()))
    f.write("\n")

    # construct the instance
    memArrayInstance = InstantiateModule(memArrayName, "stage2", 2)
    memArrayInstance.addParam(ModuleParam("DATA_WIDTH", "DATA_WIDTH"))
    memArrayInstance.addIO(ModuleIO(1, "clk", "input", "clk"))
    memArrayInstance.addIO(ModuleIO(1, "clk_en", "input", "clk_en"))
    memArrayInstance.addIO(ModuleIO(1, "reset", "input", "reset"))
    memArrayInstance.addIO(ModuleIO(1, "start", "input", startNextStageWireCrossbar.getName()))
    for i in range(M * k):
        memArrayInstance.addIO(ModuleIO("DATA_WIDTH", "in" + str(i), "input", crossbarOutList[i].getName()))
    memArrayInstance.addIO(ModuleIO(1, "start_next_stage", "output", startNextStageWireMemArray.getName()))
    for i in range(M * k):
        memArrayInstance.addIO(ModuleIO("DATA_WIDTH", "out" + str(i), "output", memArrayOutList[i].getName()))

    f.write(memArrayInstance.__str__())
    f.write("\n")

    # stage 3
    # construct the instance
    memArrayInstance = InstantiateModule(crossbarShiftUpName, "stage3", 2)
    memArrayInstance.addParam(ModuleParam("DATA_WIDTH", "DATA_WIDTH"))
    memArrayInstance.addIO(ModuleIO(1, "clk", "input", "clk"))
    memArrayInstance.addIO(ModuleIO(1, "clk_en", "input", "clk_en"))
    memArrayInstance.addIO(ModuleIO(1, "reset", "input", "reset"))
    memArrayInstance.addIO(ModuleIO(1, "start", "input", startNextStageWireMemArray.getName()))
    for i in range(M * k):
        memArrayInstance.addIO(ModuleIO("DATA_WIDTH", "in" + str(i), "input", memArrayOutList[i].getName()))
    memArrayInstance.addIO(ModuleIO(1, "start_next_stage", "output", "start_next_stage"))
    for i in range(M * k):
        memArrayInstance.addIO(ModuleIO("DATA_WIDTH", "out" + str(i), "output", "out" + str(i)))

    f.write(memArrayInstance.__str__())
    f.write("\n")
    f.write(generateVerilogNewLine(0, "endmodule"))
    f.close()


def generateTopInstance(k, M, topName):
    """
    just return a string, not write into file
    """
    # construct the instance
    topInstance = InstantiateModule(topName, "uut", 2)
    topInstance.addParam(ModuleParam("DATA_WIDTH", "DATA_WIDTH"))
    topInstance.addIO(ModuleIO(1, "clk", "input", "clk"))
    topInstance.addIO(ModuleIO(1, "clk_en", "input", "clk_en"))
    topInstance.addIO(ModuleIO(1, "start", "input", "start"))
    topInstance.addIO(ModuleIO(1, "reset", "input", "reset"))
    for i in range(M * k):
        topInstance.addIO(ModuleIO("DATA_WIDTH", "in" + str(i), "input", "in" + str(i)))
    topInstance.addIO(ModuleIO(1, "start_next_stage", "output", "start_next_stage"))
    for i in range(M * k):
        topInstance.addIO(ModuleIO("DATA_WIDTH", "out" + str(i), "output", "out" + str(i)))

    return topInstance.__str__()


def generateSeparateInput(inputName, outputName, k, M):
    result = ""
    inputWireList = []
    outputWireList = []
    for i in range(k * M):
        inputWireList.append(ModuleWire("DATA_WIDTH", "in" + str(i)))
        outputWireList.append(ModuleWire("DATA_WIDTH", "out" + str(i)))

    for wire in inputWireList:
        result += generateVerilogNewLine(2, wire.__str__())
    result += "\n"
    for wire in outputWireList:
        result += generateVerilogNewLine(2, wire.__str__())
    result += "\n"

    for i, wire in enumerate(inputWireList):
        defaultLength = 512 / k / M
        start = i * defaultLength
        end = start + defaultLength - 1
        r = "[" + str(end) + ":" + str(start) + "]"
        result += generateVerilogNewLine(2, generateAssignment(wire, inputName + r, "blocking"))
    result += "\n"

    concatenateOut = "{"
    for i in range(k * M):
        concatenateOut += "out" + str(k * M - i - 1)
        if i != k * M - 1:
            concatenateOut += ", "
        if (k * M - i - 1) % M == 0:
            concatenateOut += "\n" + 28 * " "
    concatenateOut += "}"

    result += generateVerilogNewLine(2, generateAssignment(ModuleWire(512, outputName), concatenateOut, "blocking"))

    return result


def generateAfuUserVerilog(k, M, topModuleName, fileName):
    f = open(fileName, "w")
    before = \
        """module afu_user # (
          parameter DATA_WIDTH = 16,
          parameter BUFF_DEPTH_BITS = 3
        ) (
          input clk,    // Clock
          input reset,  // Asynchronous reset active low
          // input fifo
          input [511:0] input_fifo_din,
          input input_fifo_we,
          output input_fifo_full,
          output input_fifo_almost_full,
          output [BUFF_DEPTH_BITS-1:0] input_fifo_count,
          // output fifo
          output [511:0] output_fifo_dout,
          input output_fifo_re,
          output output_fifo_empty,
          output output_fifo_almost_empty,
          // other information
          input [31:0] ctx_length
        );
          // input fifo
          wire [511:0] input_fifo_dout;
          wire input_fifo_re;
          wire input_fifo_empty;
          // output fifo
          wire [511:0] output_fifo_din;
          // uut
          reg start;
          wire clk_en;
          wire start_next_stage;

          syn_read_fifo #(.FIFO_WIDTH(512),
                          .FIFO_DEPTH_BITS(BUFF_DEPTH_BITS),       // transfer size 1 -> 32 entries
                          .FIFO_ALMOSTFULL_THRESHOLD(2**(BUFF_DEPTH_BITS)-4),
                          .FIFO_ALMOSTEMPTY_THRESHOLD(2)
                         ) input_fifo (
                        .clk                (clk),
                        .reset              (reset),
                        .din                (input_fifo_din),
                        .we                 (input_fifo_we),
                        .re                 (input_fifo_re),
                        .dout               (input_fifo_dout),
                        .empty              (input_fifo_empty),
                        .almostempty        (),
                        .full               (input_fifo_full),
                        .count              (input_fifo_count),
                        .almostfull         (input_fifo_almost_full)
                    );

        """
    middle = \
        """
          assign input_fifo_re = (reset == 1'b1) ? 1'b0 : ~input_fifo_empty;

          always @(posedge clk) begin
            if (reset) begin
              start <= 1'b0;
            end else if (input_fifo_re == 1'b1) begin
              start <= 1'b1;
            end else begin
              start <= 1'b0;
            end
          end

          reg [31:0] ctx_input_count;

          always@(posedge clk) begin
            if (reset) begin
              ctx_input_count <= 0;
            end else if (input_fifo_re) begin
              ctx_input_count <= ctx_input_count + 1'b1;
            end
          end

          assign clk_en = (ctx_input_count == ctx_length) ? 1'b1 : start;

        """
    after = \
        """
          wire output_fifo_we;

          assign output_fifo_we = start_next_stage & clk_en;

          syn_read_fifo #(.FIFO_WIDTH(512),
                          .FIFO_DEPTH_BITS(BUFF_DEPTH_BITS),       // transfer size 1 -> 32 entries
                          .FIFO_ALMOSTFULL_THRESHOLD(2**(BUFF_DEPTH_BITS)-4),
                          .FIFO_ALMOSTEMPTY_THRESHOLD(2)
                         ) output_fifo (
                        .clk                (clk),
                        .reset              (reset),
                        .din                (output_fifo_din),
                        .we                 (output_fifo_we),
                        .re                 (output_fifo_re),
                        .dout               (output_fifo_dout),
                        .empty              (output_fifo_empty),
                        .almostempty        (output_fifo_almost_empty),
                        .full               (),
                        .count              (),
                        .almostfull         ()
                    );

        endmodule
        """
    separateInput = generateSeparateInput("input_fifo_dout", "output_fifo_din", k, M)
    uutInstance = generateTopInstance(k, M, topModuleName)
    f.write(before + separateInput + middle + uutInstance + after)
    f.close()


if __name__ == "__main__":
    k, M = 4, 8
    crossbarSize = k * M
    generateCrossbar = True
    generateCrossbarShiftDown = True
    generateCrossbarShiftUp = True
    generateMemArray = True
    generateStreamMatrixTop = True
    generateAfuUser = True

    # ultimate generate file
    generateVerilogFile = True

    crossbarName = "crossbar"
    crossbarShiftDownName = "crossbarShiftDown"
    crossbarShiftUpName = "crossbarShiftUp"
    memArrayName = "memArray"
    streamTransposeTopName = "streamMatrixTransposeTop"

    generatedMatrixTranspose = "../verilog/matrixTranspose/src/"

    if generateVerilogFile:
        if generateCrossbar:
            fileName = generatedMatrixTranspose + crossbarName + ".v"
            generateCrossbarVerilog(k, M, inputWidth=32, fileName=fileName)

        if generateCrossbarShiftDown:
            fileName = generatedMatrixTranspose + crossbarShiftDownName + ".v"
            generateShiftCrossbarVerilog(k, M, defaultInputWidth=32, fileName=fileName, direction="Down")

        if generateCrossbarShiftUp:
            fileName = generatedMatrixTranspose + crossbarShiftUpName + ".v"
            generateShiftCrossbarVerilog(k, M, defaultInputWidth=32, fileName=fileName, direction="Up")

        if generateMemArray:
            fileName = generatedMatrixTranspose + memArrayName + ".v"
            genMemArrayVerilog(k, M, defaultInputWidth=32, fileName=fileName)

        if generateStreamMatrixTop:
            fileName = generatedMatrixTranspose + streamTransposeTopName + ".v"
            generateStreamTransposeTop(k, M, 32, crossbarShiftDownName, crossbarName,
                                       memArrayName, crossbarShiftUpName, fileName)

        if generateAfuUser:
            fileName = generatedMatrixTranspose + "afu_user" + ".v"
            generateAfuUserVerilog(k, M, streamTransposeTopName, fileName)
