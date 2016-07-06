"""
This file includes the utility function to convNet related computation
"""
import math

"""
Compute a convLayer size
"""


def convLayerSizeOriginal(imageSize, filterSize, numKernel, padding, stride=1, inGFLOP=True):
    """
    :param imageSize: (W1, H1, D1), represented as a tuple
    :param filterSize: (F, F, D1)
    :param numKernel:
    :param padding:
    :param stride:
    :return: The number of operations: accumulation + multiplication
    """
    W1, H1, D1 = imageSize
    assert D1 == filterSize[2], "image size and filter size must have the same depth."
    F = filterSize[0]
    W2, H2, D2 = (W1 - F + 2 * padding) // stride + 1, (H1 - F + 2 * padding) // stride, numKernel
    # number of operations to get one result
    numOpPerResult = 2 * F * F * D1
    return W2 * H2 * D2 * numOpPerResult / 10e9


def isPowerofTwo(num):
    """
    >>> isPowerofTwo(2 ** 10)
    True
    >>> isPowerofTwo(2 ** 10 - 1)
    False
    """
    return ((num & (num - 1)) == 0) and num > 0


def convLayerSizeFFT(imageSize, filterSize, numKernel, padding, unitSize, stride=1, inGFLOP=True):
    """
    :param unitSize: L * L, the basic FFT imageSize, L + F - 1 must be some power of 2
    :return: The number of operations in FFT: accumulation + multiplication
    """
    W1, H1, D1 = imageSize
    assert D1 == filterSize[2], "image size and filter size must have the same depth."
    F = filterSize[0]
    W2, H2, D2 = (W1 - F + 2 * padding) // stride + 1, (H1 - F + 2 * padding) // stride, numKernel
    L = unitSize[0]
    fftUnitSize = L + F - 1
    assert isPowerofTwo(fftUnitSize), "The FFT unit size must be a power of 2"
    # number of operations
    numMultiplicationPerFFT = fftUnitSize // 2 * int(math.log(fftUnitSize, 2))
    numAddPerFFT = fftUnitSize * int(math.log(fftUnitSize, 2))
    FFTMultiplicationOp = numMultiplicationPerFFT * fftUnitSize * 2 * 2 * 3 + fftUnitSize * fftUnitSize
    FFTAddOp = numAddPerFFT * fftUnitSize * 2 * 2 * 3
    # number of add to overlap
    overlapAddOp = (F - 1) * fftUnitSize * 2
    numUnitSize = int(math.ceil(float(W1 + 2 * padding) / fftUnitSize))
    onePlaneOp = (FFTMultiplicationOp + FFTAddOp + overlapAddOp) * (numUnitSize ** 2)
    return (onePlaneOp + W2 * H2) * D1 * D2 / 10e9


def findUnitSize(filterSize):
    """
    >>> findUnitSize((3, 3, 128))
    6
    >>> findUnitSize((7, 7, 128))
    10
    """
    F, _, _ = filterSize
    start = int(math.ceil(math.log(F, 2)))
    unitSize = 2 ** start
    while True:
        total = 2 ** start
        unitSize = total + 1 - F
        if unitSize >= F:
            break
        start += 1
    return unitSize, unitSize

def test():
    imageSize = (224, 224, 128)
    filterSize = (3, 3, 128)
    numKernel = 128
    padding = 1
    print convLayerSizeOriginal(imageSize, filterSize, numKernel, padding)
    unitSize = findUnitSize(filterSize)
    print convLayerSizeFFT(imageSize, filterSize, numKernel, padding, unitSize)


if __name__ == "__main__":
    test()
