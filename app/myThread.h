//
// Created by chizhang on 7/6/16.
//

#ifndef APP_MYTHREAD_H
#define APP_MYTHREAD_H

#include <pthread.h>

#include "common.h"

void *modify_cacheline(void *arg) {
    MSG("Start to modify the first cacheline.");
    ::memset(arg, 0x00, 64);
    MSG("The first cacheline should be all zero now.");
    return 0;
}


#endif //APP_MYTHREAD_H
