"""
This file test
1-D and 2-D
    1. numpy built-in conv algorithm
    2. self write fft-base conv algorithm (without using complex number directly)
    3. Overlap-and-add algorithm base conv
"""

import numpy as np
import cmath
import math


def zero_padding(x, output_length):
    """

    :param x: the input list
    :param output_length:
    :return:
    >>> x = [1, 2, 5, 6, 7]
    >>> zero_padding(x, 8)
    [1, 2, 5, 6, 7, 0, 0, 0]
    """
    x_temp = list(x)
    if output_length > len(x_temp):
        x_temp += (output_length - len(x_temp)) * [0]
    return x_temp


def find_ceil_power_of_two(n):
    """
    >>> find_ceil_power_of_two(25)
    32
    >>> find_ceil_power_of_two(32)
    32
    """
    return 2 ** int(np.ceil(np.log2(n)))


def flip_binary(x, bin_length):
    """

    :param input:
    :return:
    >>> flip_binary(0, 3)
    0
    >>> flip_binary(1, 3)
    4
    >>> flip_binary(2, 3)
    2
    >>> flip_binary(3, 3)
    6
    >>> flip_binary(4, 3)
    1
    """
    # reshuffle
    bin_x = bin(x)[2:]
    bin_x = bin_x[::-1]
    if len(bin_x) < bin_length:
        bin_x += (bin_length - len(bin_x)) * '0'
    return int(bin_x, 2)


def get_w(num_point, exponent):
    return math.cos(2 * math.pi * exponent / num_point) - 1j * math.sin(2 * math.pi * exponent / num_point)


"""
Test for 8 point FFT
"""


def eightPointFFTHelper(x, type):
    if len(x) > 8:
        raise Exception("input length can't be greater than 8")
    elif len(x) < 8:
        x = zero_padding(x, 8)
    shuffle_input = []
    for i in range(8):
        shuffle_input.append(x[flip_binary(i, 3)])

    for i in range(4):
        shuffle_input[2 * i + 1] *= get_w(8, 0)

    for i in range(4):
        shuffle_input[2 * i], shuffle_input[2 * i + 1] = \
            shuffle_input[2 * i] + shuffle_input[2 * i + 1], shuffle_input[2 * i] - shuffle_input[2 * i + 1]

    for i in range(2):
        if type == "fft":
            exponent = 2
        elif type == "ifft":
            exponent = -2
        shuffle_input[4 * i + 2] *= get_w(8, 0)
        shuffle_input[4 * i + 3] *= get_w(8, exponent)

    for i in range(2):
        shuffle_input[4 * i], shuffle_input[4 * i + 1], shuffle_input[4 * i + 2], shuffle_input[4 * i + 3] = \
            shuffle_input[4 * i] + shuffle_input[4 * i + 2], shuffle_input[4 * i + 1] + shuffle_input[4 * i + 3], \
            shuffle_input[4 * i] - shuffle_input[4 * i + 2], shuffle_input[4 * i + 1] - shuffle_input[4 * i + 3]

    for i in range(4):
        if type == "fft":
            exponent = i
        elif type == "ifft":
            exponent = -i
        shuffle_input[4 + i] *= get_w(8, exponent)

    output = []
    for i in range(4):
        output.append(shuffle_input[i] + shuffle_input[4 + i])

    for i in range(4):
        output.append(shuffle_input[i] - shuffle_input[4 + i])

    if type == "ifft":
        for i in range(len(output)):
            output[i] /= 8

    return output


def eight_point_fft(x):
    return eightPointFFTHelper(x, "fft")

def eight_point_ifft(x):
    return eightPointFFTHelper(x, "ifft")


def dotProduct(x, y):
    assert len(x) == len(y), "x and y must have the same length"
    result = []
    for i in range(len(x)):
        result.append(x[i] * y[i])
    return result

"""
1D convolution using overlap-and-add, only limited to 8 point, use python built-in list, not numpy
"""
def convolutionOverlapAndAdd(x, h):
    # overhead
    assert len(h) < 8
    H = eight_point_fft(h)
    M = len(h)       # length of the filter
    L = 8 + 1 - M    # length of each fragment
    ptr = 0
    result = [0] * (len(x) + M - 1)
    while ptr + L <= len(x):
        xk = x[ptr:ptr + L]
        Xk = eight_point_fft(xk)
        Yk = dotProduct(Xk, H)
        yk = eight_point_ifft(Yk)
        for i in range(ptr, ptr + 8):
            result[i] += yk[i - ptr]
        ptr += L
    if ptr < len(x):
        xk = x[ptr:]
        Xk = eight_point_fft(xk)
        Yk = dotProduct(Xk, H)
        yk = eight_point_ifft(Yk)
        for i in range(ptr, len(result)):
            result[i] += yk[i - ptr]
        ptr += L
    return result

if __name__ == "__main__":
    import doctest
    doctest.testmod()
