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

#define bt32BitsWordLength
#define M 8

#define numMatrixWorkSpace 2000

#ifdef bt32BitsWordLength
#define oneMatrixSizeBytes M * M * 4
#else
#define oneMatrixSizeBytes M * M * 2
#endif

// 0 for 1st real, 1 for 1st imag, etc
#define mode 1

#endif //SW_APP_CONFIG_H
