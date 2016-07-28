//
// Created by chizhang on 6/27/16.
//

#ifndef SW_APP_CONFIG_H
#define SW_APP_CONFIG_H

//****************************************************************************
// UN-COMMENT appropriate #define in order to enable either Hardware or ASE.
//    DEFAULT is to use Software Simulation.
//****************************************************************************
// #define  HWAFU
#define  ASEAFU

// convLayer configuration
#ifdef HWAFU
#define N 224   // image size N*N*D1
#define n 3     // filter size  n*n*D1*D2
#define D1 64   // input feature maps
#define D2 64   // output feature maps
#endif

// ASE tests using small image size and kernel
#ifdef ASEAFU
#define N 14   // image size N*N*D1
#define n 3     // filter size  n*n*D1*D2
#define D1 3   // input feature maps
#define D2 3   // output feature maps
#endif


#endif //SW_APP_CONFIG_H
