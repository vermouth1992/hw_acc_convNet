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
    binStr = (int(length) - len(binStr)) * "0" + binStr
    return str(length) + "'b" + binStr


class ModuleIO:
    def __init__(self, length, name, type, defaultValue=None):
        assert type == "input" or type == "output" or "output reg" or "reg" or "wire"
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

    def __str__(self):
        result = self.getType() + " [" + str(self.getLength()) + "-1:0] " + self.getName()
        return result


class ModuleReg(ModuleIO):
    def __init__(self, length, name):
        ModuleIO.__init__(self, length, name, "reg")

    def __str__(self):
        return ModuleIO.__str__(self) + ";"

class ModuleWire(ModuleIO):
    def __init__(self, length, name):
        ModuleIO.__init__(self, length, name, "wire")

    def __str__(self):
        return ModuleIO.__str__(self) + ";"

class ModuleParam:
    def __init__(self, name, defaultValue):
        self.name = name
        self.defaultValue = defaultValue

    def getName(self):
        return self.name

    def getDefaultValue(self):
        return self.defaultValue


def generateAssignment(m, value, assignType="non-blocking"):
    assert assignType == "blocking" or assignType == "non-blocking"
    assert isinstance(m, ModuleIO)
    if assignType == "blocking":
        assign = " = "
    else:
        assign = " <= "
    if type(value) == int:
        result = m.getName() + assign + numToVerilogBit(value, int(m.getLength())) + ";"
    else:
        result = m.getName() + assign + value + ";"
    if assign == " = ":
        result = "assign " + result
    return result

def generateVerilogLine(numSpace, text, isNewLine, comment=""):
    result = " " * numSpace + text
    if comment != "":
        result += 5 * " " + comment
    if isNewLine:
        result += "\n"
    return result


def generateVerilogNewLine(numSpace, text, comment=""):
    return generateVerilogLine(numSpace, text, True, comment)


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
    result = generateVerilogLine(2, io.__str__(), False)
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


if __name__ == "__main__":
    pass
