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
    f.write(generateVerilogNewLine(12, generateAssignment(startNextStageReg, 1, "non-blocking")))
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

    startNextStageReg = ModuleIO(1, "start_next_stage", "output reg")
    memArray.addIO(startNextStageReg)
    f.write(memArray.__str__())
    f.write("\n")

    # instantiate crossbarShiftDown

if __name__ == "__main__":
    k, M = 4, 8
    crossbarSize = k * M
    generateCrossbar = True
    generateCrossbarShiftDown = True
    generateCrossbarShiftUp = True
    generateMemArray = True
    crossbarName = "crossbar" + str(crossbarSize) + "x" + str(crossbarSize)
    crossbarShiftDownName = "crossbarShiftDown" + str(crossbarSize) + "x" + str(crossbarSize)
    crossbarShiftUpName = "crossbarShiftUp" + str(crossbarSize) + "x" + str(crossbarSize)
    memArrayName = "memArray" + str(M / k) + "x" + str(M * k)
    streamTransposeTopName = "streamMatrixTransposeTop" + str(crossbarSize) + "x" + str(crossbarSize)

    if generateCrossbar:
        fileName = generatedVerilogFolder + crossbarName + ".v"
        generateCrossbarVerilog(k, M, inputWidth=32, fileName=fileName)

    if generateCrossbarShiftDown:
        fileName = generatedVerilogFolder + crossbarShiftDownName + ".v"
        generateShiftCrossbarVerilog(k, M, defaultInputWidth=32, fileName=fileName, direction="Down")

    if generateCrossbarShiftUp:
        fileName = generatedVerilogFolder + crossbarShiftUpName + ".v"
        generateShiftCrossbarVerilog(k, M, defaultInputWidth=32, fileName=fileName, direction="Up")

    if generateMemArray:
        fileName = generatedVerilogFolder + memArrayName + ".v"
        genMemArrayVerilog(k, M, defaultInputWidth=32, fileName=fileName)

