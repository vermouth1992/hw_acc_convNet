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
    """ Note that for 1x1 kernel, it is the same """
    assert fft_size > n, "fft size must be greater than n"
    tile_size = fft_size + 1 - n
    total_image_tile = int(math.ceil(float(N + padding * 2) / float(tile_size)))
    return total_image_tile * total_image_tile * D1 * D2 * 5e-6


def memory_consumption_estimation(t_k, t_i, P, D1, D2, f, B, kernel_buffer_depth, one_image_buffer=False):
    kernel_constraint = 8 * t_k * P * P * D1 * f * 1e6 / B / 1024 ** 3
    image_constraint = 8 * P * P * D1 * D2 * f * 1e6 * t_k / (D2 * B * 1024 ** 3 - 8 * t_i * P * P * f * 1e6 * t_k)
    x = max(kernel_constraint, image_constraint)
    print "x =", x
    x = 2 ** int(math.ceil(math.log(x, 2)))
    memory_consumption = x * P * P * t_i + kernel_buffer_depth * P * P * t_k * 2
    if one_image_buffer == False:
        memory_consumption += x * P * P * t_i
    # in MB
    return memory_consumption * 8 / 1024 / 1024


def estimated_cycles_execution_read_cycle(num_image_mem_bits, num_kernel_mem_bits, D1, fft_size):
    """ This function estimates the read cycle each process cycle """
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


def DM_ratio_test():
    kernels = [3, 5, 7, 9, 11]
    fft_sizes = [4, 8, 16, 32]
    for k in kernels:
        for f in fft_sizes:
            if f >= k:
                print "kernel:", k, "fft:", f
                space_oaa_ratio(k, f)



