from util import *
import random

"""
Predict GoogLeNet Inception Module delay
"""


def googLeNetDelay(fft_size):
    def inception_module(name, imageSize, one_dimension, three_reduce, three_dimension,
                         five_reduce, five_dimension, pool_proj):
        N, _, D1 = imageSize
        one_dimension_delay = predict_convLayer_harp(N, 1, D1, one_dimension, 0, 1, fft_size)
        three_reduce_delay = predict_convLayer_harp(N, 1, D1, three_reduce, 0, 1, fft_size)
        three_dimension_delay = predict_convLayer_harp(N, 3, three_reduce, three_dimension, 1, 1, fft_size)
        five_reduce_delay = predict_convLayer_harp(N, 1, D1, five_reduce, 0, 1, fft_size)
        five_dimension_delay = predict_convLayer_harp(N, 5, five_reduce, five_dimension, 2, 1, fft_size)
        pool_proj_delay = predict_convLayer_harp(N, 1, D1, pool_proj, 0, 1, fft_size)
        total_delay = one_dimension_delay + three_reduce_delay + three_dimension_delay + five_reduce_delay \
                      + five_dimension_delay + pool_proj_delay
        print "inception", name, "total delay:", total_delay, "ms"
        return total_delay

    total_delay = 0
    print "GoogLeNet in 2014"
    delay = predict_convLayer_harp(224, 7, 3, 64, 3, 2, fft_size)
    total_delay += delay
    print "layer 1", "total delay:", delay, "ms"
    delay = predict_convLayer_harp(56, 1, 64, 64, 0, 1, fft_size)
    total_delay += delay
    print "layer 2", "total delay:", delay, "ms"
    delay = predict_convLayer_harp(56, 3, 64, 192, 1, 1, fft_size)
    total_delay += delay
    print "layer 3", "total delay:", delay, "ms"

    # inception_3, 28x28x192
    delay = inception_module("3a", (28, 28, 192), 64, 96, 128, 16, 32, 32)
    total_delay += delay
    delay = inception_module("3b", (28, 28, 256), 128, 128, 192, 32, 96, 64)
    total_delay += delay
    # inception_4 14x14x480
    delay = inception_module("4a", (14, 14, 480), 192, 96, 208, 16, 48, 64)
    total_delay += delay
    delay = inception_module("4b", (14, 14, 512), 160, 112, 224, 24, 64, 64)
    total_delay += delay
    delay = inception_module("4c", (14, 14, 512), 128, 128, 256, 24, 64, 64)
    total_delay += delay
    delay = inception_module("4d", (14, 14, 512), 112, 144, 288, 32, 64, 64)
    total_delay += delay
    delay = inception_module("4e", (14, 14, 512), 256, 160, 320, 32, 128, 128)
    total_delay += delay
    # inception 4 7x7x832
    delay = inception_module("5a", (7, 7, 832), 256, 160, 320, 32, 128, 128)
    total_delay += delay
    delay = inception_module("5b", (7, 7, 832), 384, 192, 384, 48, 128, 128)
    total_delay += delay
    print "total delay:", total_delay, "ms"


def VGG16_delay_winograd():
    """
    predict delay using winograd algorithm for VGG16
    """
    scale_percentage = 0.2
    total_num_dsp = 128
    # CONV1
    conv1_delay = predict_convLayer_harp_winograd(224, 3, 3, 64, 1, 1, total_num_dsp)
    conv1_delay += predict_convLayer_harp_winograd(224, 3, 64, 64, 1, 1, total_num_dsp)
    conv1_delay *= (1 + random.random() * scale_percentage)
    print 'conv1 delay: %.2f' % conv1_delay

    # CONV2
    conv2_delay = predict_convLayer_harp_winograd(112, 3, 64, 128, 1, 1, total_num_dsp)
    conv2_delay += predict_convLayer_harp_winograd(112, 3, 128, 128, 1, 1, total_num_dsp)
    conv2_delay *= (1 + random.random() * scale_percentage)
    print 'conv2 delay: %.2f' % conv2_delay

    # CONV3
    conv3_delay = predict_convLayer_harp_winograd(56, 3, 128, 256, 1, 1, total_num_dsp)
    conv3_delay += predict_convLayer_harp_winograd(56, 3, 256, 256, 1, 1, total_num_dsp) * 2
    conv3_delay *= (1 + random.random() * scale_percentage)
    print 'conv3 delay: %.2f' % conv3_delay

    # CONV4
    conv4_delay = predict_convLayer_harp_winograd(28, 3, 256, 512, 1, 1, total_num_dsp)
    conv4_delay += predict_convLayer_harp_winograd(28, 3, 512, 512, 1, 1, total_num_dsp) * 2
    conv4_delay *= (1 + random.random() * scale_percentage)
    print 'conv4 delay: %.2f' % conv4_delay

    # CONV5
    conv5_delay = predict_convLayer_harp_winograd(14, 3, 512, 512, 1, 1, total_num_dsp) * 3
    conv5_delay *= (1 + random.random() * scale_percentage)
    print 'conv5 delay: %.2f' % conv5_delay

    total_delay = conv1_delay + conv2_delay + conv3_delay + conv4_delay + conv5_delay
    print 'total delay: %.2f' % total_delay

if __name__ == '__main__':
    VGG16_delay_winograd()