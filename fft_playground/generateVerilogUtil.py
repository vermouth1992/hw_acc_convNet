"""
This file defines a set of class and function to help generate Verilog files
"""
import unittest

generatedVerilogFolder = "../verilog/generated/"

class ModuleIO:
    def __init__(self, length, name, type):
        assert type == "input" or type == "output" or "output reg"
        self.type = type
        self.length = str(length)
        self.name = name

    def getLength(self):
        return self.length

    def getName(self):
        return self.name

    def getType(self):
        return self.type


class ModuleParam:
    def __init__(self, name, defaultValue):
        self.name = name
        self.defaultValue = defaultValue

    def getName(self):
        return self.name

    def getDefaultValue(self):
        return self.defaultValue


def generateVerilogLine(numSpace, text, isNewLine):
    result = " " * numSpace + text
    if isNewLine:
        result += "\n"
    return result


def generateVerilogNewLine(numSpace, text):
    return generateVerilogLine(numSpace, text, True)


def generateParam(param, isLastParam=False):
    assert isinstance(param, ModuleParam)
    result = generateVerilogLine(2, "parameter " + param.getName() + " = " + str(param.getDefaultValue()), False)
    if not isLastParam:
        result += ","
    result += "\n"
    return result


def generateIO(io, isLastIO=False):
    assert isinstance(io, ModuleIO)
    result = ""
    if io.getLength() == "1":
        result += generateVerilogLine(2, io.getType() + " " + io.getName(), False)
    else:
        result += generateVerilogLine(2, io.getType() + " [" + str(io.getLength()) + "-1:0] " + io.getName(), False)
    if not isLastIO:
        result += ","
    result += "\n"
    return result


class VerilogModule:
    def __init__(self, name):
        self.name = name
        self.params = []
        self.io = []

    def addParam(self, parameter):
        assert isinstance(parameter, ModuleParam)
        self.params.append(parameter)

    def addIO(self, io):
        assert isinstance(io, ModuleIO)
        self.io.append(io)

    def __str__(self):
        result = ""
        # module
        result += generateVerilogLine(numSpace=0, text="module " + self.name, isNewLine=False)
        if len(self.params) != 0:
            result += " # (" + "\n"
            # parameter
            for i in range(len(self.params)):
                if i == len(self.params) - 1:
                    result += generateParam(self.params[i], isLastParam=True)
                else:
                    result += generateParam(self.params[i])

            result += ")"
        result += " (" + "\n"
        for i in range(len(self.io)):
            if i == len(self.io) - 1:
                result += generateIO(self.io[i], isLastIO=True)
            else:
                result += generateIO(self.io[i])
        result += ");" + "\n"
        return result


class GenVerilogTest(unittest.TestCase):

    # the test name must start with test
    @unittest.skip("")
    def testModuleGen(self):
        singleRam = VerilogModule("single_port_ram")
        singleRam.addParam(ModuleParam("DATA_WIDTH", 6))
        singleRam.addParam(ModuleParam("ADDR_WIDTH", 8))
        singleRam.addIO(ModuleIO("DATA_WIDTH", "data", "input"))
        singleRam.addIO(ModuleIO("ADDR_WIDTH", "addr", "input"))
        singleRam.addIO(ModuleIO(1, "we", "input"))
        singleRam.addIO(ModuleIO(1, "clk", "input"))
        singleRam.addIO(ModuleIO("DATA_WIDTH", "q", "output reg"))
        print singleRam



if __name__ == "__main__":
    unittest.main()
