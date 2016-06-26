import numpy as np
import random

def numToHex(num, length):
    """

    :param num:
    :param length: the binary length
    :return:
    >>> numToHex(20, 32)
    '00000014'
    """
    hexStr = hex(int(num))[2:]
    return (length // 4 - len(hexStr)) * "0" + hexStr


def vectorToInputVector(vector, hexLength):
    """
    >>> vectorToInputVector(np.array([[1, 2, 3], [4, 6, 5]])[0, :], 16)
    '000100020003'
    """
    result = ""
    for x in vector:
        result += numToHex(x, hexLength)
    return result


def matrixToInputVector(k, M, matrix):
    """
    a = np.random.randint(20, size=(8, 8)); print matrixToInputVector(4, 8, a)
    """
    assert M % k == 0
    result = ""
    tempResult = ""
    wordLength = 512 / k / M
    matrix = np.fliplr(matrix)
    currentLine = 0
    while currentLine < M:
        tempResult = vectorToInputVector(matrix[currentLine, :], wordLength) + tempResult
        if (currentLine + 1) % k == 0:
            result += tempResult + "\r\n"
            tempResult = ""
        currentLine += 1
    return result


def generateInputVector(k, M, inputFileName, expectedFileName, testStall=False):
    inputFile = open(inputFileName, "w")
    # write test number
    testNum = random.randint(10, 20)
    inputFile.write(str(numToHex(testNum * M / k, 32)) + "\r\n")
    # generate matrix
    wordLength = 512 / k / M
    maxNum = 2 ** wordLength - 1
    inputMatrix = []
    for _ in range(testNum):
        testMatrix = np.random.randint(0, maxNum, (M, M))
        inputMatrix.append(testMatrix)
        inputFile.write(matrixToInputVector(k, M, testMatrix))
    inputFile.close()
    # expected result
    outputFile = open(expectedFileName, "w")
    for m in inputMatrix:
        outputFile.write(matrixToInputVector(k, M, np.transpose(m)))
    outputFile.close()

if __name__ == "__main__":
    generateTestVector = True
    testVectorFolder = "../verilog/matrixTranspose/out/"
    if generateTestVector:
        inputFileName = testVectorFolder + "input_trace.txt"
        outputFileName = testVectorFolder + "expected_trace.txt"
        generateInputVector(k, M, inputFileName, outputFileName)
