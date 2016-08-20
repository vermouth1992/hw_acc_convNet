import struct
from util.ucb import main


def hex_to_num(hexadecimal):
    return struct.unpack('!f', hexadecimal.decode('hex'))[0]


def floating_to_hex(num):
    return ''.join(hex(ord(c)).replace('0x', '').rjust(2, '0') for c in struct.pack('!f', num))


class FloatingPoint():
    """
    ieee 754 standard 32-bit floating point
    """

    def __init__(self, sign, exponent, mantissa):
        """
        The input should follow verilog syntax input[31:0]
        Note: (-1)^sign * 2^exponent * (mantissa / 2^23 + 1),  mantissa is normalized to [1, 2)
        """
        assert len(sign) == 1
        assert len(exponent) == 8
        assert len(mantissa) == 23
        self.sign = sign
        self.exponent = exponent
        self.mantissa = mantissa

    @property
    def binary_repr(self):
        return self.sign + self.exponent + self.mantissa

    @property
    def hex_repr(self):
        binary = self.binary_repr
        return hex(int(binary, 2))[2:].rjust(8, '0')

    @property
    def decimal_repr(self):
        return struct.unpack('!f', self.hex_repr.decode('hex'))[0]

    # @property
    # def raw_decimal_repr(self):
    #     sign_dec = int(self.sign, 2)
    #     exponent_dec = int(self.exponent, 2)
    #     mantissa_dec = int(self.mantissa, 2)
    #     decimal = 2 ** (exponent_dec - 127) * float(mantissa_dec / 2 ** 23 + 1) * (-1) ** sign_dec
    #     return decimal

    @property
    def decimal_repr_separate(self):
        sign_dec = int(self.sign, 2)
        exponent_dec = int(self.exponent, 2)
        mantissa_dec = int(self.mantissa, 2)
        return str(sign_dec) + " " + str(exponent_dec) + " " + str(mantissa_dec)

    def __str__(self):
        return self.sign + " " + self.exponent + " " + self.mantissa


@main
def test():
    sign = "0"
    exponent = "00000000"
    mantissa = "0" * 19 + "0000"
    t = FloatingPoint(sign, exponent, mantissa)
    print t
    print t.binary_repr
    print t.hex_repr
    print "Standard decimal:", t.decimal_repr
    print t.decimal_repr_separate
    print floating_to_hex(0.1)
