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

#define bt32BitsWordLength
#define M 16

#define numMatrixWorkSpace 20

#ifdef bt32BitsWordLength
#define oneMatrixSizeBytes M * M * 4
#else
#define oneMatrixSizeBytes M * M * 2
#endif

#endif //SW_APP_CONFIG_H
