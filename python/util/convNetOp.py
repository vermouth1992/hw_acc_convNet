from convNets.util import *
import sys


def CaffeNetGOp():
    print "CaffeNet in 2012"
    # 227x227x3
    first_layer_space, first_layer_ooa = space_ooa_layer_difference((227, 227, 3), (11, 11, 3), 96, 0, 4, 64)
    print "Layer 1", "space:", first_layer_space, "ooa:", first_layer_ooa
    # 27x27x96
    second_layer_space, second_layer_ooa = space_ooa_layer_difference((27, 27, 96), (5, 5, 96), 256, 2, 1, 64)
    print "Layer 2", "space:", second_layer_space, "ooa:", second_layer_ooa
    # 13x13x256
    third_layer_space, third_layer_ooa = space_ooa_layer_difference((13, 13, 256), (3, 3, 256), 384, 1, 1, 8)
    print "Layer 3", "space:", third_layer_space, "ooa:", third_layer_ooa
    # 13x13x384
    fourth_layer_space, fourth_layer_ooa = space_ooa_layer_difference((13, 13, 384), (3, 3, 384), 384, 1, 1, 8)
    print "Layer 4", "space:", fourth_layer_space, "ooa:", fourth_layer_ooa
    # 13x13x384
    fifth_layer_space, fifth_layer_ooa = space_ooa_layer_difference((13, 13, 384), (3, 3, 384), 256, 1, 1, 8)
    print "Layer 5", "space:", fifth_layer_space, "ooa:", fifth_layer_ooa

    total_space_op = first_layer_space + second_layer_space + third_layer_space + fourth_layer_space + \
                     fifth_layer_space
    total_ooa_op = first_layer_ooa + second_layer_ooa + third_layer_ooa + fourth_layer_ooa + fifth_layer_ooa
    reduced_ratio = (total_space_op - total_ooa_op) / total_space_op * 100

    print 'Total space: %.2f, total OaA: %.2f, reduced ratio: %.2f' % (total_space_op, total_ooa_op, reduced_ratio)


def VGG16Op():
    print "VGG16 in 2014"
    # first layer
    L = 30
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
    L = 6
    fifth_layer_space = convLayerSizeOriginal((14, 14, 512), (3, 3, 512), 512, 1) + \
                        convLayerSizeOriginal((14, 14, 512), (3, 3, 512), 512, 1) * 2
    fifth_layer_ooa = convLayerSizeFFT((14, 14, 512), (3, 3, 512), 512, 1, (L, L)) + \
                      convLayerSizeFFT((14, 14, 512), (3, 3, 512), 512, 1, (L, L)) * 2
    print "Layer 5", "space:", fifth_layer_space, "ooa:", fifth_layer_ooa

    total_space_op = first_layer_space + second_layer_space + third_layer_space + fourth_layer_space + \
                     fifth_layer_space
    total_ooa_op = first_layer_ooa + second_layer_ooa + third_layer_ooa + fourth_layer_ooa + fifth_layer_ooa
    reduced_ratio = (total_space_op - total_ooa_op) / total_space_op * 100

    print 'Total space: %.2f, total OaA: %.2f, reduced ratio: %.2f' % (total_space_op, total_ooa_op, reduced_ratio)


def googLeNetOp():
    def inception_module(name, imageSize, one_dimension, three_reduce, three_dimension,
                         five_reduce, five_dimension, pool_proj):
        space_total, ooa_total, optimized_total = 0, 0, 0
        conv_space, conv_ooa = space_ooa_layer_difference(imageSize, (1, 1, imageSize[2]), one_dimension,
                                                          padding=0, stride=1, fft_size=8)
        space_total += conv_space
        ooa_total += conv_ooa
        optimized_total += conv_space
        print "inception", name, "1x1", "space:", conv_space, "ooa:", conv_ooa

        conv_space, conv_ooa = space_ooa_layer_difference(imageSize, (1, 1, imageSize[2]), three_reduce,
                                                          padding=0, stride=1, fft_size=8)
        space_total += conv_space
        ooa_total += conv_ooa
        optimized_total += conv_space
        print "inception", name, "3x3 reduce", "space:", conv_space, "ooa:", conv_ooa

        if imageSize[0] == 28:
            fft_size = 32
        elif imageSize[0] == 14:
            fft_size = 4
        elif imageSize[0] == 7:
            fft_size = 8
        else:
            raise Exception("Unknown imageSize.")
        conv_space, conv_ooa = space_ooa_layer_difference((imageSize[0], imageSize[0], three_reduce),
                                                          (3, 3, three_reduce), three_dimension, padding=1,
                                                          stride=1, fft_size=fft_size)
        space_total += conv_space
        ooa_total += conv_ooa
        optimized_total += conv_ooa
        print "inception", name, "3x3", "space:", conv_space, "ooa:", conv_ooa

        conv_space, conv_ooa = space_ooa_layer_difference(imageSize, (1, 1, imageSize[2]), five_reduce, padding=0,
                                                          stride=1, fft_size=8)
        space_total += conv_space
        ooa_total += conv_ooa
        optimized_total += conv_space
        print "inception", name, "5x5 reduce", "space:", conv_space, "ooa:", conv_ooa

        if imageSize[0] == 28:
            fft_size = 32
        elif imageSize[0] == 14:
            fft_size = 16
        elif imageSize[0] == 7:
            fft_size = 16
        else:
            raise Exception("Unknown imageSize.")
        conv_space, conv_ooa = space_ooa_layer_difference((imageSize[0], imageSize[0], five_reduce),
                                                          (5, 5, five_reduce), five_dimension,
                                                          padding=2, stride=1, fft_size=fft_size)
        space_total += conv_space
        ooa_total += conv_ooa
        optimized_total += conv_ooa
        print "inception", name, "5x5", "space:", conv_space, "ooa:", conv_ooa

        conv_space, conv_ooa = space_ooa_layer_difference(imageSize, (1, 1, imageSize[2]), pool_proj, padding=1,
                                                          stride=1, fft_size=8)
        space_total += conv_space
        ooa_total += conv_ooa
        optimized_total += conv_space
        print "inception", name, "pool proj", "space:", conv_space, "ooa:", conv_ooa

        print "space conv total: %.2f, ooa conv total: %.2f, optimized total: %.2f" % \
              (space_total, ooa_total, optimized_total)
        print "output dimension", one_dimension + three_dimension + five_dimension + pool_proj

    print "GoogLeNet in 2014"
    conv_space, conv_ooa = space_ooa_layer_difference((224, 224, 3), (7, 7, 3), 64, 3, 2, 64)
    print "layer 1", "space:", conv_space, "ooa:", conv_ooa
    conv_space, conv_ooa = space_ooa_layer_difference((56, 56, 64), (1, 1, 64), 64, 0, 1, 4)
    print "layer 2 reduce", "space:", conv_space, "ooa:", conv_ooa
    conv_space, conv_ooa = space_ooa_layer_difference((56, 56, 64), (3, 3, 64), 192, 1, 1, 32)
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
    # inception 4 7x7x832
    inception_module("5a", (7, 7, 832), 256, 160, 320, 32, 128, 128)
    inception_module("5b", (7, 7, 832), 384, 192, 384, 48, 128, 128)


if __name__ == "__main__":
    args = None
    if len(sys.argv) > 1:
        args = sys.argv[1]
    else:
        print 'Please specify the CNN architecture.'
    if args == 'vgg':
        VGG16Op()
    elif args == 'alex':
        CaffeNetGOp()
    elif args == 'google':
        googLeNetOp()
    else:
        pass
