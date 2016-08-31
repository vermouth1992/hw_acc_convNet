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
    numOpPerResult = 2 * F * F * D1 + 1  # 1 is the bias
    return W2 * H2 * D2 * numOpPerResult / 10e9


def isPowerofTwo(num):
    """
    >>> isPowerofTwo(2 ** 10)
    True
    >>> isPowerofTwo(2 ** 10 - 1)
    False
    """
    return ((num & (num - 1)) == 0) and num > 0


def convLayerSizeFFT(imageSize, filterSize, numKernel, padding, unitSize, stride=1, inGFLOP=True, addFilter=True):
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
    logFFTUnitSize = int(math.log(fftUnitSize, 2))
    numTilt = int(math.ceil((W1 + 2 * padding) / float(fftUnitSize))) ** 2
    numMultImageFFT = 6 * fftUnitSize ** 2 * logFFTUnitSize * numTilt * D1
    numMultImageFilter = fftUnitSize ** 2 * D1 * D2 * numTilt
    numMultIFFT = 6 * fftUnitSize ** 2 * logFFTUnitSize * numTilt * D2
    numAddImageFFT = fftUnitSize * logFFTUnitSize * fftUnitSize * 2 * 2 * numTilt * D1  # one complex add is two add
    numAddInDepth = fftUnitSize ** 2 * D1 * D2 * numTilt
    numAddOverlap = (F - 1) * fftUnitSize * 2 * numTilt * D2
    numMult = numMultImageFFT + numMultImageFilter + numMultIFFT
    numAdd = numAddImageFFT + numAddInDepth + numAddOverlap

    # filter FFT
    numFilterMult = 6 * fftUnitSize ** 2 * logFFTUnitSize * D1 * D2
    numFilterAdd = fftUnitSize * logFFTUnitSize * fftUnitSize * 2 * 2 * D1 * D2

    numOps = numMult + numAdd
    if addFilter:
        numOps += numFilterAdd + numFilterMult

    if inGFLOP:
        return numOps / 1e9
    else:
        return numOps


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


def predict_convLayer_harp(N, n, D1, D2, padding, stride, fft_size):
    assert fft_size > n, "fft size must be greater than n"
    tile_size = fft_size + 1 - n
    total_image_tile = int(math.ceil(float(N + padding * 2) / float(tile_size)))
    return total_image_tile * total_image_tile * D1 * D2 * 5e-6


def AlexNetGOp():
    # first layer
    result = 0
    result += convLayerSizeOriginal((227, 227, 3), (11, 11, 3), 96, 0, stride=4)
    result += convLayerSizeOriginal((27, 27, 96), (5, 5, 96), 256, 2)
    result += convLayerSizeOriginal((13, 13, 256), (3, 3, 256), 384, 1) * 2
    result += convLayerSizeOriginal((13, 13, 256), (3, 3, 256), 256, 1)
    result += (4096 * (512 * 7 * 7 * 2) + 4096 * (4096 * 2) + 4096 * 2 * 1000) / 1e9
    return result


def test():
    imageSize = (112, 112, 64)
    filterSize = (5, 5, 64)
    numKernel = 128
    padding = 3
    print convLayerSizeOriginal(imageSize, filterSize, numKernel, padding, stride=1)
    unitSize = findUnitSize(filterSize)
    print convLayerSizeFFT(imageSize, filterSize, numKernel, padding, unitSize, 3, True, True)
    print "AlexNet GOps:", AlexNetGOp()


if __name__ == "__main__":
    test()
