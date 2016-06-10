"""
This file test
1-D and 2-D
    1. numpy built-in conv algorithm
    2. self write fft-base conv algorithm (without using complex number directly)
    3. Overlap-and-add algorithm base conv
"""

import numpy as np


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
    while len(x_temp) < output_length:
        x_temp.append(0)

    return x_temp

def find_ceil_power_of_two(n):
    """
    >>> find_ceil_power_of_two(25)
    32
    >>> find_ceil_power_of_two(32)
    32
    """
    return 2 ** int(np.ceil(np.log2(n)))





if __name__ == "__main__":
    import doctest
    doctest.testmod()


