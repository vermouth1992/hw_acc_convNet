"""
This file includes the utility function to convNet related computation
"""
import math

"""
Compute a convLayer size
"""

oneGiga = 1e9

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
    numOpPerResult = 2 * F * F * D1 + D1 + 1  # 1 is the bias
    return W2 * H2 * D2 * numOpPerResult / oneGiga


def isPowerofTwo(num):
    """
    >>> isPowerofTwo(2 ** 10)
    True
    >>> isPowerofTwo(2 ** 10 - 1)
    False
    """
    return ((num & (num - 1)) == 0) and num > 0


def convLayerSizeFFT(imageSize, filterSize, numKernel, padding, unitSize, stride=1, inGFLOP=True, addFilter=False):
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
    numMultImageFilter = fftUnitSize ** 2 * D1 * D2 * numTilt * 6
    numMultIFFT = 6 * fftUnitSize ** 2 * logFFTUnitSize * numTilt * D2
    numAddImageFFT = fftUnitSize * logFFTUnitSize * fftUnitSize * 2 * 2 * numTilt * D1  # one complex add is two add
    numAddInDepth = fftUnitSize ** 2 * D1 * D2 * numTilt
    numAddOverlap = (F - 1) * fftUnitSize * 4 * numTilt * D2
    numMult = numMultImageFFT + numMultImageFilter + numMultIFFT
    numAdd = numAddImageFFT + numAddInDepth + numAddOverlap

    # filter FFT
    numFilterMult = 6 * fftUnitSize ** 2 * logFFTUnitSize * D1 * D2
    numFilterAdd = fftUnitSize * logFFTUnitSize * fftUnitSize * 2 * 2 * D1 * D2

    numOps = numMult + numAdd
    if addFilter:
        numOps += numFilterAdd + numFilterMult

    if inGFLOP:
        return numOps / oneGiga
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


def estimated_cycles_execution_read_cycle(num_image_mem_bits, num_kernel_mem_bits, D1, fft_size):
    execution_cycles = 2 ** (num_image_mem_bits + num_kernel_mem_bits) / float(D1)
    fill_kernel_mem_cycles = 2 ** num_kernel_mem_bits * fft_size * fft_size * 8 / 32
    fill_image_mem_cycles = 2 ** num_image_mem_bits * fft_size * fft_size * 8 / 32
    memory_utilization = (2 ** num_kernel_mem_bits + 2 ** num_image_mem_bits) * fft_size * fft_size * 8 * 2 \
                         / 1024.0 / 1024.0
    print "execution cycles:", execution_cycles, "\nfill kernel:", fill_kernel_mem_cycles, \
        "\nfill image:", fill_image_mem_cycles, "\nmemory consumption(MB):", memory_utilization


def space_oaa_ratio(kernel_size, fft_size):
    assert fft_size >= kernel_size, "fft size must be greater than or equal to kernel size"
    num_multiplier = dict()
    num_multiplier[4] = 0
    num_multiplier[8] = 4
    num_multiplier[16] = 24
    num_multiplier[32] = 88
    space_product = kernel_size * kernel_size
    ooa_num_multiplier = fft_size * fft_size * 3 + num_multiplier[fft_size] * fft_size * 4
    L = fft_size - kernel_size + 1
    ooa_product = float(ooa_num_multiplier) / L / L
    ratio = float(space_product) / float(ooa_product)
    print "space:", space_product, "OaA:", ooa_product, "ratio:", ratio



def space_ooa_layer_difference(imageSize, kernelSize, numKernels, padding, stride, L):
    space_num_op = convLayerSizeOriginal(imageSize, kernelSize, numKernels, padding, stride)
    ooa_num_op = convLayerSizeFFT(imageSize, kernelSize, numKernels, padding, (L, L), stride)
    return space_num_op, ooa_num_op



def CaffeNetGOp():
    print "CaffeNet in 2012"
    # 227x227x3
    first_layer_space, first_layer_ooa = space_ooa_layer_difference((227, 227, 3), (11, 11, 3), 96, 0, 4, 6)
    print "Layer 1", "space:", first_layer_space, "ooa:", first_layer_ooa
    # 27x27x96
    second_layer_space, second_layer_ooa = space_ooa_layer_difference((27, 27, 96), (5, 5, 96), 256, 2, 1, 4)
    print "Layer 2", "space:", second_layer_space, "ooa:", second_layer_ooa
    # 13x13x256
    third_layer_space, third_layer_ooa = space_ooa_layer_difference((13, 13, 256), (3, 3, 256), 384, 1, 1, 2)
    print "Layer 3", "space:", third_layer_space, "ooa:", third_layer_ooa
    # 13x13x384
    fourth_layer_space, fourth_layer_ooa = space_ooa_layer_difference((13, 13, 384), (3, 3, 384), 384, 1, 1, 2)
    print "Layer 4", "space:", fourth_layer_space, "ooa:", fourth_layer_ooa
    # 13x13x384
    fifth_layer_space, fifth_layer_ooa = space_ooa_layer_difference((13, 13, 384), (3, 3, 384), 256, 1, 1, 2)
    print "Layer 5", "space:", fifth_layer_space, "ooa:", fifth_layer_ooa

def VGG16Op():
    print "VGG16 in 2014"
    L = 2
    # first layer
    first_layer_space = convLayerSizeOriginal((224, 224, 3), (3, 3, 3), 64, 1) + \
                        convLayerSizeOriginal((224, 224, 64), (3, 3, 64), 64, 1)
    first_layer_ooa = convLayerSizeFFT((224, 224, 3), (3, 3, 3), 64, padding=1, unitSize=(L, L)) + \
                      convLayerSizeFFT((224, 224, 64), (3, 3, 64), 64, padding=1, unitSize=(L, L))
    print "Layer 1", "space:", first_layer_space, "ooa:", first_layer_ooa
    # second layer
    second_layer_space = convLayerSizeOriginal((112, 112, 64), (3, 3, 64), 128, 1) + \
                         convLayerSizeOriginal((112, 112, 128), (3, 3, 128), 128, 1)
    second_layer_ooa = convLayerSizeFFT((112, 112, 64), (3, 3, 64), 128, 1, (L, L)) + \
                       convLayerSizeFFT((112, 112, 128), (3, 3, 128), 128, 1, (L, L))
    print "Layer 2", "space:", second_layer_space, "ooa:", second_layer_ooa
    # third layer
    third_layer_space = convLayerSizeOriginal((56, 56, 128), (3, 3, 128), 256, 1) + \
                         convLayerSizeOriginal((56, 56, 256), (3, 3, 256), 256, 1) * 2
    third_layer_ooa = convLayerSizeFFT((56, 56, 128), (3, 3, 128), 256, 1, (L, L)) + \
                       convLayerSizeFFT((56, 56, 256), (3, 3, 256), 256, 1, (L, L)) * 2
    print "Layer 3", "space:", third_layer_space, "ooa:", third_layer_ooa
    # fourth layer
    fourth_layer_space = convLayerSizeOriginal((28, 28, 256), (3, 3, 256), 512, 1) + \
                         convLayerSizeOriginal((28, 28, 512), (3, 3, 512), 512, 1) * 2
    fourth_layer_ooa = convLayerSizeFFT((28, 28, 256), (3, 3, 256), 512, 1, (L, L)) + \
                       convLayerSizeFFT((28, 28, 512), (3, 3, 512), 512, 1, (L, L)) * 2
    print "Layer 4", "space:", fourth_layer_space, "ooa:", fourth_layer_ooa
    # fourth layer
    fifth_layer_space = convLayerSizeOriginal((14, 14, 512), (3, 3, 512), 512, 1) + \
                         convLayerSizeOriginal((14, 14, 512), (3, 3, 512), 512, 1) * 2
    fifth_layer_ooa = convLayerSizeFFT((14, 14, 512), (3, 3, 512), 512, 1, (L, L)) + \
                       convLayerSizeFFT((14, 14, 512), (3, 3, 512), 512, 1, (L, L)) * 2
    print "Layer 5", "space:", fifth_layer_space, "ooa:", fifth_layer_ooa


def googLeNetOp():
    def inception_module(name, imageSize, one_dimension, three_reduce, three_dimension,
                         five_reduce, five_dimension, pool_proj):
        conv_space, conv_ooa = space_ooa_layer_difference(imageSize, (1, 1, imageSize[2]), one_dimension,
                                                          padding=0, stride=1, L=4)
        print "inception", name, "1x1", "space:", conv_space, "ooa:", conv_ooa
        conv_space, conv_ooa = space_ooa_layer_difference(imageSize, (1, 1, imageSize[2]), three_reduce,
                                                          padding=0, stride=1, L=4)
        print "inception", name, "3x3 reduce", "space:", conv_space, "ooa:", conv_ooa
        conv_space, conv_ooa = space_ooa_layer_difference((28, 28, three_reduce), (3, 3, three_reduce),
                                                          three_dimension, padding=1, stride=1, L=2)
        print "inception", name, "3x3", "space:", conv_space, "ooa:", conv_ooa
        conv_space, conv_ooa = space_ooa_layer_difference(imageSize, (1, 1, imageSize[2]), five_reduce, padding=0,
                                                          stride=1, L=4)
        print "inception", name, "5x5 reduce", "space:", conv_space, "ooa:", conv_ooa
        conv_space, conv_ooa = space_ooa_layer_difference((28, 28, five_reduce), (3, 3, five_reduce), five_dimension,
                                                          padding=1, stride=1, L=2)
        print "inception", name, "5x5", "space:", conv_space, "ooa:", conv_ooa
        conv_space, conv_ooa = space_ooa_layer_difference(imageSize, (3, 3, imageSize[2]), pool_proj, padding=1, stride=1, L=2)
        print "inception", name, "pool proj", "space:", conv_space, "ooa:", conv_ooa

        print "output dimension", one_dimension + three_dimension + five_dimension + pool_proj

    print "GoogLeNet in 2014"
    conv_space, conv_ooa = space_ooa_layer_difference((224, 224, 3), (7, 7, 3), 64, 3, 2, 2)
    print "layer 1", "space:", conv_space, "ooa:", conv_ooa
    conv_space, conv_ooa = space_ooa_layer_difference((56, 56, 64), (1, 1, 64), 64, 0, 1, 4)
    print "layer 2 reduce", "space:", conv_space, "ooa:", conv_ooa
    conv_space, conv_ooa = space_ooa_layer_difference((56, 56, 64), (3, 3, 64), 192, 1, 1, 2)
    print "layer 2", "space:", conv_space, "ooa:", conv_ooa

    # inception_3, 28x28x192
    inception_module("3a", (28, 28, 192), 64, 96, 128, 16, 32, 32)
    inception_module("3b", (28, 28, 256), 128, 128, 192, 32, 96, 64)
    # inception_4 14x14x480
    inception_module("4a", (14, 14, 480), 192, 96, 208, 16, 48, 64)
    inception_module("4b", (14, 14, 512), 160, 112, 224, 24, 64, 64)
    inception_module("4c", (14, 14, 512), 128, 128, 256, 24, 64, 64)
    inception_module("4d", (14, 14, 512), 112, 144, 288, 32, 64, 64)
    inception_module("4e", (14, 14, 512), 256, 160, 320, 32, 128, 128)
    #inception 4 7x7x832
    inception_module("5a", (7, 7, 832), 256, 160, 320, 32, 128, 128)
    inception_module("5b", (7, 7, 832), 384, 192, 384, 48, 128, 128)

def DM_ratio_test():
    kernels = [3, 5, 7, 9, 11]
    fft_sizes = [4, 8, 16, 32]
    for k in kernels:
        for f in fft_sizes:
            if f >= k:
                print "kernel:", k, "fft:", f
                space_oaa_ratio(k, f)


if __name__ == "__main__":
    # VGG16Op()
    # CaffeNetGOp()
    googLeNetOp()