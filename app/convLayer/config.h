//
// Created by chizhang on 6/27/16.
//

#ifndef SW_APP_CONFIG_H
#define SW_APP_CONFIG_H

#include "convLayer.h"
//****************************************************************************
// UN-COMMENT appropriate #define in order to enable either Hardware or ASE.
//    DEFAULT is to use Software Simulation.
//****************************************************************************
#define  HWAFU
//#define  ASEAFU

// convLayer configuration
#ifdef HWAFU
#define N 14   // image size N*N*D1
#define n 3     // filter size  n*n*D1*D2
#define D1 512   // input feature maps
#define D2 512   // output feature maps
#define padding 1  // zero padding
#define stride 1   // stride
#endif

// ASE tests using small image size and kernel
#ifdef ASEAFU
#define N 6   // image size N*N*D1
#define n 3     // filter size  n*n*D1*D2
#define D1 32   // input feature maps
#define D2 8   // output feature maps
#define padding 1  // zero padding
#define stride 1   // stride
#endif

bool isPooling = false;
bool isOverlap = false;
bool isFullyConnected = true;


#define numPointFFT 4  // fft size

struct OneConvLayerTile {
    float data[numPointFFT * numPointFFT];
};

convLayerConfig testLayer = convLayerConfig(N, n, D1, D2, padding, stride, numPointFFT);

#endif //SW_APP_CONFIG_H
