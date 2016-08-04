import sys
from util.ucb import main
import numpy as np
from arithmetics_test.floating_point import hex_to_num


def transformLine(line):
    assert len(line) == 16
    data = np.array(line)
    output = []
    for i in range(8):
        output.append(data[2 * i] + data[2 * i + 1] * 1j)
    return np.array(output)

def getExpectedOutputLine(input_array):
    assert len(input_array) == 8
    output = np.zeros(8, dtype=np.complex_)
    for i in range(7):
        output[i] = input_array[i] * input_array[i+1]
    output[7] = input_array[0] * input_array[7]
    return output


def verifyLine(input_line_data, output_line_data, line_index):
    """
    :param input_line_data: a list of 8 hex number
    :param output_line_data:
    :return:
    """
    input_data_raw = [hex_to_num(data) for data in input_line_data]
    output_data_raw = [hex_to_num(data) for data in output_line_data]
    # translate input raw data to numpy array
    input_array = transformLine(input_data_raw)
    output_array = transformLine(output_data_raw)
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
