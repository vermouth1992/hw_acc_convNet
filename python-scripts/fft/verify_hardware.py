import sys

sys.path.append("../")

from util.ucb import main
import numpy as np
from arithmetics_test.floating_point import hex_to_num


def transformLine_input(line):
    assert len(line) == 16
    data = np.array(line[12:16]).reshape((2, 2))
    return data

def transformLine_output(line):
    assert len(line) == 16
    return np.array(line).reshape((4, 4))

def getExpectedOutputLine(input_array):
    input_array = np.lib.pad(input_array, ((0, 2), (0, 2)), 'constant', constant_values=0)
    return np.fft.fft2(input_array).imag.T


def verifyLine(input_line_data, output_line_data, line_index):
    """
    :param input_line_data: a list of 8 hex number
    :param output_line_data:
    :return:
    """
    input_data_raw = [hex_to_num(data) for data in input_line_data]
    output_data_raw = [hex_to_num(data) for data in output_line_data]
    # translate input raw data to numpy array
    input_array = transformLine_input(input_data_raw)
    output_array = transformLine_output(output_data_raw)
    # calculate expected result
    expected_array = getExpectedOutputLine(input_array)
    # calculate error
    err = np.absolute(expected_array - output_array)
    err_msg = "line: " + str(line_index) + "\n" + "expected: " + str(expected_array) + "\n" + \
              "actual:" + str(output_array) + "\n"
    np.testing.assert_almost_equal(err, np.zeros(err.shape), err_msg=err_msg, decimal=6, verbose=True)


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
