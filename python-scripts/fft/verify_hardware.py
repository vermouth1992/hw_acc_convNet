import sys
from util.ucb import main
import numpy as np
from arithmetics_test.floating_point import hex_to_num


def lineToComplex(line):
    assert len(line) == 16
    data = list()
    i = 0
    while i < 16:
        c = line[i] + 1j * line[i + 1]
        data.append(c)
        i += 2
    return data


def verifyLine(input_line_data, output_line_data, line_index):
    """
    :param input_line_data: a list of 8 hex number
    :param output_line_data:
    :return:
    """
    input_data_raw = [hex_to_num(data) for data in input_line_data]
    output_data_raw = [hex_to_num(data) for data in output_line_data]
    # translate input raw data to complex number
    input_array = np.array(lineToComplex(input_data_raw))
    output_array = np.array(lineToComplex(output_data_raw))
    actual_fft_array = np.fft.fft(input_array)
    err = np.absolute(actual_fft_array / output_array)
    err_msg = "line: " + str(line_index) + "\n" + "input: " + str(actual_fft_array) + "\n" + \
              "output:" + str(output_array) + "\n"
    np.testing.assert_almost_equal(err, np.ones(err.shape), err_msg=err_msg, decimal=6, verbose=True)


def verify(input_data, output_data):
    assert len(input_data) == len(output_data)
    num_line = len(input_data) / 16
    for i in range(num_line):
        input_line_data = input_data[i * 16 : (i + 1) * 16]
        output_line_data = output_data[i * 16 : (i + 1) * 16]
        verifyLine(input_line_data, output_line_data, i)

# the sys.argv will pass into the main function
@main
def test(*argv):
    assert argv[0] == "-i" and argv[2] == "-o"
    input_file = open(argv[1])
    output_file = open(argv[3])
    input_data = input_file.read().split()
    output_data = output_file.read().split()
    input_file.close()
    output_file.close()
    verify(input_data, output_data)