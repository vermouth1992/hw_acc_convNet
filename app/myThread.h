//
// Created by chizhang on 7/6/16.
//

#ifndef APP_MYTHREAD_H
#define APP_MYTHREAD_H

#include <pthread.h>

struct OneCL {                      // Make a cache-line sized structure
    unsigned int dw[16];       //    for array arithmetic
};

void *modify_cacheline(void *arg) {
    ::memset(arg, 0x00, 64);
    return 0;
}


#endif //APP_MYTHREAD_H
