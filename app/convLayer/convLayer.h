//
// Created by chizhang on 7/29/16.
//

#ifndef APP_CONVLAYER_H
#define APP_CONVLAYER_H

#include "../common.h"

using namespace AAL;

class convLayerConfig {
private:
    btUnsigned32bitInt imageSize;   // N
    btUnsigned32bitInt filterSize;  // n
    btUnsigned32bitInt numInputFeatureMap;  // D1
    btUnsigned32bitInt numOutputFeatureMap;  // D2
    btUnsigned32bitInt zeroPadding;
    btUnsigned32bitInt convStride;
    btUnsigned32bitInt fftSize;
    btUnsigned32bitInt tileSize;

public:
    convLayerConfig(btUnsigned32bitInt i, btUnsigned32bitInt f, btUnsigned32bitInt d1, btUnsigned32bitInt d2,
                    btUnsigned32bitInt z, btUnsigned32bitInt s, btUnsigned32bitInt p);

    // calculate configurations functions
    btUnsigned32bitInt getImageSizeInBytes();
    btUnsigned32bitInt getFilterSizeInBytes();
    btUnsigned32bitInt getOutputBufferSizeInBytes();

    // get private value interface
    btUnsigned32bitInt getImageSize() {
        return imageSize;
    }

    btUnsigned32bitInt getFilterSize() {
        return filterSize;
    }

    btUnsigned32bitInt getNumInputFeatureMap() {
        return numInputFeatureMap;
    }

    btUnsigned32bitInt getNumOutputFeatureMap() {
        return numOutputFeatureMap;
    }
};

convLayerConfig::convLayerConfig(btUnsigned32bitInt i, btUnsigned32bitInt f, btUnsigned32bitInt d1,
                                 btUnsigned32bitInt d2, btUnsigned32bitInt z, btUnsigned32bitInt s,
                                 btUnsigned32bitInt p) :
        imageSize(i),
        filterSize(f),
        numInputFeatureMap(d1),
        numOutputFeatureMap(d2),
        zeroPadding(z),
        convStride(s),
        fftSize(p) {
    tileSize = fftSize + 1 - filterSize;
}

btUnsigned32bitInt convLayerConfig::getImageSizeInBytes() {
    btUnsigned32bitInt numTile = (btUnsigned32bitInt) ceil(float(imageSize + 2 * zeroPadding) / float(tileSize));
    // zero padding is done on FPGA
    btUnsigned32bitInt originalSize = numTile * fftSize;
    btUnsigned32bitInt numPoint = originalSize * originalSize * numInputFeatureMap;
    return numPoint * 4;
}

btUnsigned32bitInt convLayerConfig::getFilterSizeInBytes() {
    btUnsigned32bitInt numPoint = fftSize * fftSize * numInputFeatureMap * numOutputFeatureMap;
    return numPoint * 8;   // complex floating point
}

// The output buffer is the raw size without overlap
btUnsigned32bitInt convLayerConfig::getOutputBufferSizeInBytes() {
    btUnsigned32bitInt numTile = (btUnsigned32bitInt) ceil(float(imageSize + 2 * zeroPadding) / float(tileSize));
    btUnsigned32bitInt remappingSize = numTile * fftSize;
    btUnsigned32bitInt numPoint = remappingSize * remappingSize * numOutputFeatureMap;
    return numPoint * 4;
}

#endif //APP_CONVLAYER_H
