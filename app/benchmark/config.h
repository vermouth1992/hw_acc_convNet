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
#define num_cacheline 10000
#endif

// ASE tests using small image size and kernel
#ifdef ASEAFU
#define num_cacheline 16
#endif

#define bufferSize CL(1) * num_cacheline

#endif //SW_APP_CONFIG_H
