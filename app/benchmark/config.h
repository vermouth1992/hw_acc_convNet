//
// Created by chizhang on 6/27/16.
//

#ifndef SW_APP_CONFIG_H
#define SW_APP_CONFIG_H

//****************************************************************************
// UN-COMMENT appropriate #define in order to enable either Hardware or ASE.
//    DEFAULT is to use Software Simulation.
//****************************************************************************
#define  HWAFU
// #define  ASEAFU

#define read_only 1
#define write_only 2
#define read_write 3

// testing configuration, maximum num cacheline is 16777215
#ifdef HWAFU
#define num_cacheline 16777215
#endif

// ASE tests using small image size and kernel
#ifdef ASEAFU
#define num_cacheline 16
#endif

#define bufferSize CL(1) * num_cacheline
#define mode read_write

#endif //SW_APP_CONFIG_H
