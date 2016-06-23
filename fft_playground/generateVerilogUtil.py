"""
This file defines a set of class and function to help generate Verilog files
"""
import unittest

generatedVerilogFolder = "../verilog/generated/"


def numToVerilogBit(num, length):
    """
    >>> numToVerilogBit(0, 3)
    "3'b000"
    >>> numToVerilogBit(1, 3)
    "3'b001"
    """
    binStr = bin(num)[2:]
    binStr = (length - len(binStr)) * "0" + binStr
    return str(length) + "'b" + binStr


class ModuleIO:
    def __init__(self, length, name, type, defaultValue=None):
        assert type == "input" or type == "output" or "output reg"
        self.type = type
        self.length = str(length)
        self.name = name
        self.defaultValue = defaultValue  # used for instantiation

    def getLength(self):
        return self.length

    def getName(self):
        return self.name

    def getType(self):
        return self.type

    def getDefaultValue(self):
        return self.defaultValue


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


"""
Used to generate verilog module
"""

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

"""
Use to generate instance
"""

def generateParamInstance(param, isLastParam=False):
    assert isinstance(param, ModuleParam)
    assert type(param.getDefaultValue()) == str, "For module instantiation, the parameter's default value must be a string."
    result = "." + param.getName() + "(" + param.getDefaultValue() + ")"
    if not isLastParam:
        result += ","
    return result


def generateIOInstance(io, isLastIO=False):
    assert isinstance(io, ModuleIO)
    assert io.defaultValue is not None
    result = "." + io.getName() + "(" + io.getDefaultValue() + ")"
    if not isLastIO:
        result += ","
    return result

class VerilogModule:
    def __init__(self, name, baseIndent=0):
        self.name = name
        self.params = []
        self.io = []
        self.baseIndent = baseIndent

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


class InstantiateModule(VerilogModule):
    def __init__(self, name, instanceName, baseIndent=0):
        VerilogModule.__init__(self, name, baseIndent)
        self.instanceName = instanceName

    def __str__(self):
        result = ""
        # module name
        result += generateVerilogLine(self.baseIndent, self.name, isNewLine=False)
        if len(self.params) != 0:
            result += " # (" + "\n"
            # parameter
            for i in range(len(self.params)):
                if i == len(self.params) - 1:
                    result += generateVerilogNewLine(self.baseIndent + 2,
                                                     generateParamInstance(self.params[i], isLastParam=True))
                else:
                    result += generateVerilogNewLine(self.baseIndent + 2,
                                                     generateParamInstance(self.params[i]))
            # instance name line
            result += generateVerilogLine(self.baseIndent + 2, ") ", isNewLine=False)
        result += self.instanceName + " (" + "\n"
        for i in range(len(self.io)):
            if i == len(self.io) - 1:
                result += generateVerilogNewLine(self.baseIndent + 2,
                                                 generateIOInstance(self.io[i], isLastIO=True))
            else:
                result += generateVerilogNewLine(self.baseIndent + 2,
                                                 generateIOInstance(self.io[i]))
        result += generateVerilogNewLine(self.baseIndent, ");")
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

    def testInstanceGen(self):
        singleRam = InstantiateModule("single_port_ram", "mem0", 2)
        singleRam.addParam(ModuleParam("DATA_WIDTH", "DATA_WIDTH"))
        singleRam.addParam(ModuleParam("ADDR_WIDTH", "1"))
        singleRam.addIO(ModuleIO("DATA_WIDTH", "data", "input", numToVerilogBit(0, 32)))
        singleRam.addIO(ModuleIO("ADDR_WIDTH", "addr", "input", "addr0_3"))
        singleRam.addIO(ModuleIO(1, "we", "input", defaultValue="we"))
        singleRam.addIO(ModuleIO(1, "clk", "input", defaultValue="clk"))
        singleRam.addIO(ModuleIO("DATA_WIDTH", "q", "output reg", defaultValue="out0"))
        print singleRam


if __name__ == "__main__":
    unittest.main()
