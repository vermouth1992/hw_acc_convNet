//
// Created by chizhang on 7/6/16.
//

#ifndef APP_COMMON_H
#define APP_COMMON_H

#include <aalsdk/AAL.h>
#include <aalsdk/xlRuntime.h>
#include <aalsdk/AALLoggerExtern.h> // Logger


#include <aalsdk/service/ISPLAFU.h>       // Service Interface
#include <aalsdk/service/ISPLClient.h>    // Service Client Interface
#include <aalsdk/kernel/vafu2defs.h>      // AFU structure definitions (brings in spl2defs.h)

#include <string.h>
#include <ctime>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

// Convenience macros for printing messages and errors.
#ifdef MSG
# undef MSG
#endif // MSG
#define MSG(x) std::cout << __AAL_SHORT_FILE__ << ':' << __LINE__ << ':' << __AAL_FUNC__ << "() : " << x << std::endl
#ifdef ERR
# undef ERR
#endif // ERR
#define ERR(x) std::cerr << __AAL_SHORT_FILE__ << ':' << __LINE__ << ':' << __AAL_FUNC__ << "() **Error : " << x << std::endl

// Print/don't print the event ID's entered in the event handlers.
#if 1
# define EVENT_CASE(x) case x : MSG(#x);
#else
# define EVENT_CASE(x) case x :
#endif

#ifndef CL
# define CL(x)                     ((x) * 64)  // 64 bytes = 512 bits
#endif // CL
#ifndef LOG2_CL
# define LOG2_CL                   6
#endif // LOG2_CL
#ifndef MB
# define MB(x)                     ((x) * 1024 * 1024)
#endif // MB
#define LPBK1_BUFFER_SIZE        CL(1)

#define LPBK1_DSM_SIZE           MB(4);
/// @addtogroup HelloSPLLB

struct OneCL {                      // Make a cache-line sized structure
    AAL::btUnsigned32bitInt dw[16];       //    for array arithmetic
};


#endif //APP_COMMON_H
