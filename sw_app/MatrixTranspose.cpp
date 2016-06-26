// Copyright (c) 2007-2015, Intel Corporation
//
// Redistribution  and  use  in source  and  binary  forms,  with  or  without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of  source code  must retain the  above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name  of Intel Corporation  nor the names of its contributors
//   may be used to  endorse or promote  products derived  from this  software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,  THE
// IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED.  IN NO EVENT  SHALL THE COPYRIGHT OWNER  OR CONTRIBUTORS BE
// LIABLE  FOR  ANY  DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR
// CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT LIMITED  TO,  PROCUREMENT  OF
// SUBSTITUTE GOODS OR SERVICES;  LOSS OF USE,  DATA, OR PROFITS;  OR BUSINESS
// INTERRUPTION)  HOWEVER CAUSED  AND ON ANY THEORY  OF LIABILITY,  WHETHER IN
// CONTRACT,  STRICT LIABILITY,  OR TORT  (INCLUDING NEGLIGENCE  OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,  EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//****************************************************************************
/// @file HelloSPLLB.cpp
/// @brief Basic SPL AFU interaction.
/// @ingroup HelloSPLLB
/// @verbatim
/// Intel(R) QuickAssist Technology Accelerator Abstraction Layer Sample Application
///
///    This application is for example purposes only.
///    It is not intended to represent a model for developing commercially-deployable applications.
///    It is designed to show working examples of the AAL programming model and APIs.
///
/// AUTHORS: Joseph Grecco, Intel Corporation.
///
/// This Sample demonstrates the following:
///    - The basic structure of an AAL program using the AAL Runtime APIs.
///    - The ISPLAFU and ISPLClient interfaces of the SPLAFU Service.
///    - System initialization and shutdown.
///    - Use of interface IDs (iids).
///    - Accessing object interfaces through the Interface functions.
///
/// This sample is designed to be used with the SPLAFU Service.
///
/// HISTORY:
/// WHEN:          WHO:     WHAT:
/// 06/15/2015     JG       Initial version started based on older sample code.@endverbatim
//****************************************************************************
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

//****************************************************************************
// UN-COMMENT appropriate #define in order to enable either Hardware or ASE.
//    DEFAULT is to use Software Simulation.
//****************************************************************************
// #define  HWAFU
#define  ASEAFU

using namespace AAL;

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

// if not define 32 bit world length, then the word length is 16 bits
// #define bt32BitsWordLength

#define M 16
#define numMatrixWorkSpace 20

#ifdef bt32BitsWordLength
#define oneMatrixSizeBytes M * M * 4
#else
#define oneMatrixSizeBytes M * M * 2
#endif

#define workspaceSizeBytes oneMatrixSizeBytes * numMatrixWorkSpace

// define the matrix struct
struct Matrix {
#ifdef bt32BitsWordLength
    btUnsigned32bitInt dw[M * M];
#else
    btUnsigned16bitInt dw[M * M];
#endif
};

int posToIndex(int x, int y) {
    return M * x + y;
}

void matrixTranspose(Matrix* m) {
    for (int y = 0; y < M - 1; y++) {   // the range of y is [0, M-2]
        for (int x = y + 1; x < M; x++) {  // the range of x is [y+1, M-1]
            int upperIndex = posToIndex(x, y);
            int lowerIndex = posToIndex(y, x);
            std::swap(m->dw[upperIndex], m->dw[lowerIndex]);  // swap two elements
        }
    }
}

/// @brief   Define our Runtime client class so that we can receive the runtime started/stopped notifications.
///
/// We implement a Service client within, to handle AAL Service allocation/free.
/// We also implement a Semaphore for synchronization with the AAL runtime.
class RuntimeClient : public CAASBase, public IRuntimeClient
{
public:
    RuntimeClient();
    ~RuntimeClient();

    void end();

    IRuntime* getRuntime();

    btBool isOK();

    // <begin IRuntimeClient interface>
    void runtimeStarted(IRuntime            *pRuntime,
                        const NamedValueSet &rConfigParms);

    void runtimeStopped(IRuntime *pRuntime);

    void runtimeStartFailed(const IEvent &rEvent);

    void runtimeAllocateServiceFailed( IEvent const &rEvent);

    void runtimeAllocateServiceSucceeded(IBase               *pClient,
                                         TransactionID const &rTranID);

    void runtimeEvent(const IEvent &rEvent);
    // <end IRuntimeClient interface>

protected:
    IRuntime        *m_pRuntime;  ///< Pointer to AAL runtime instance.
    Runtime          m_Runtime;   ///< AAL Runtime
    btBool           m_isOK;      ///< Status
    CSemaphore       m_Sem;       ///< For synchronizing with the AAL runtime.
};

///////////////////////////////////////////////////////////////////////////////
///
///  MyRuntimeClient Implementation
///
///////////////////////////////////////////////////////////////////////////////
RuntimeClient::RuntimeClient() :
    m_Runtime(),        // Instantiate the AAL Runtime
    m_pRuntime(NULL),
    m_isOK(false)
{
    NamedValueSet configArgs;
    NamedValueSet configRecord;

    // Publish our interface
    SetSubClassInterface(iidRuntimeClient, dynamic_cast<IRuntimeClient *>(this));

    m_Sem.Create(0, 1);

    // Using Hardware Services requires the Remote Resource Manager Broker Service
    //  Note that this could also be accomplished by setting the environment variable
    //   XLRUNTIME_CONFIG_BROKER_SERVICE to librrmbroker
#if defined( HWAFU )
    configRecord.Add(XLRUNTIME_CONFIG_BROKER_SERVICE, "librrmbroker");
    configArgs.Add(XLRUNTIME_CONFIG_RECORD, configRecord);
#endif

    if (!m_Runtime.start(this, configArgs)) {
        m_isOK = false;
        return;
    }
    m_Sem.Wait();
}

RuntimeClient::~RuntimeClient()
{
    m_Sem.Destroy();
}

btBool RuntimeClient::isOK()
{
    return m_isOK;
}

void RuntimeClient::runtimeStarted(IRuntime *pRuntime,
                                   const NamedValueSet &rConfigParms)
{
    // Save a copy of our runtime interface instance.
    m_pRuntime = pRuntime;
    m_isOK = true;
    m_Sem.Post(1);
}

void RuntimeClient::end()
{
    m_Runtime.stop();
    m_Sem.Wait();
}

void RuntimeClient::runtimeStopped(IRuntime *pRuntime)
{
    MSG("Runtime stopped");
    m_isOK = false;
    m_Sem.Post(1);
}

void RuntimeClient::runtimeStartFailed(const IEvent &rEvent)
{
    IExceptionTransactionEvent * pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("Runtime start failed");
    ERR(pExEvent->Description());
}

void RuntimeClient::runtimeAllocateServiceFailed( IEvent const &rEvent)
{
    IExceptionTransactionEvent * pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("Runtime AllocateService failed");
    ERR(pExEvent->Description());
}

void RuntimeClient::runtimeAllocateServiceSucceeded(IBase *pClient,
        TransactionID const &rTranID)
{
    MSG("Runtime Allocate Service Succeeded");
}

void RuntimeClient::runtimeEvent(const IEvent &rEvent)
{
    MSG("Generic message handler (runtime)");
}

IRuntime * RuntimeClient::getRuntime()
{
    return m_pRuntime;
}


/// @brief   Define our Service client class so that we can receive Service-related notifications from the AAL Runtime.
///          The Service Client contains the application logic.
///
/// When we request an AFU (Service) from AAL, the request will be fulfilled by calling into this interface.
class HelloSPLLBApp: public CAASBase, public IServiceClient, public ISPLClient
{
public:

    HelloSPLLBApp(RuntimeClient * rtc);
    ~HelloSPLLBApp();

    btInt run();
    void Show2CLs(void *pCLExpected,
                  void *pCLFound,
                  ostringstream &oss);
    void _DumpCL(void *pCL,
                 ostringstream &oss);


    // <ISPLClient>
    virtual void OnTransactionStarted(TransactionID const &TranID,
                                      btVirtAddr AFUDSM,
                                      btWSSize AFUDSMSize);
    virtual void OnContextWorkspaceSet(TransactionID const &TranID);

    virtual void OnTransactionFailed(const IEvent &Event);

    virtual void OnTransactionComplete(TransactionID const &TranID);

    virtual void OnTransactionStopped(TransactionID const &TranID);
    virtual void OnWorkspaceAllocated(TransactionID const &TranID,
                                      btVirtAddr WkspcVirt,
                                      btPhysAddr WkspcPhys,
                                      btWSSize WkspcSize);

    virtual void OnWorkspaceAllocateFailed(const IEvent &Event);

    virtual void OnWorkspaceFreed(TransactionID const &TranID);

    virtual void OnWorkspaceFreeFailed(const IEvent &Event);
    // </ISPLClient>

    // <begin IServiceClient interface>
    virtual void serviceAllocated(IBase *pServiceBase,
                                  TransactionID const &rTranID);

    virtual void serviceAllocateFailed(const IEvent &rEvent);

    virtual void serviceFreed(TransactionID const &rTranID);

    virtual void serviceEvent(const IEvent &rEvent);
    // <end IServiceClient interface>

protected:
    IBase         *m_pAALService;    // The generic AAL Service interface for the AFU.
    RuntimeClient *m_runtimClient;
    ISPLAFU       *m_SPLService;
    CSemaphore     m_Sem;            // For synchronizing with the AAL runtime.
    btInt          m_Result;

    // Workspace info
    btVirtAddr     m_pWkspcVirt;     ///< Workspace virtual address.
    btWSSize       m_WkspcSize;      ///< DSM workspace size in bytes.

    btVirtAddr     m_AFUDSMVirt;     ///< Points to DSM
    btWSSize       m_AFUDSMSize;     ///< Length in bytes of DSM
};

///////////////////////////////////////////////////////////////////////////////
///
///  Implementation
///
///////////////////////////////////////////////////////////////////////////////
HelloSPLLBApp::HelloSPLLBApp(RuntimeClient *rtc) :
    m_pAALService(NULL),
    m_runtimClient(rtc),
    m_SPLService(NULL),
    m_Result(0),
    m_pWkspcVirt(NULL),
    m_WkspcSize(0),
    m_AFUDSMVirt(NULL),
    m_AFUDSMSize(0)
{
    SetSubClassInterface(iidServiceClient, dynamic_cast<IServiceClient *>(this));
    SetInterface(iidSPLClient, dynamic_cast<ISPLClient *>(this));
    SetInterface(iidCCIClient, dynamic_cast<ICCIClient *>(this));
    m_Sem.Create(0, 1);
}

HelloSPLLBApp::~HelloSPLLBApp()
{
    m_Sem.Destroy();
}

btInt HelloSPLLBApp::run()
{
    cout << "===========================================" << endl;
    cout << "= Hello Streaming Matrix Transpose Sample =" << endl;
    cout << "===========================================" << endl;

    // Request our AFU.

    // NOTE: This example is bypassing the Resource Manager's configuration record lookup
    //  mechanism.  This code is work around code and subject to change.
    NamedValueSet Manifest;
    NamedValueSet ConfigRecord;


#if defined( HWAFU )                /* Use FPGA hardware */
    ConfigRecord.Add(AAL_FACTORY_CREATE_CONFIGRECORD_FULL_SERVICE_NAME, "libHWSPLAFU");
    ConfigRecord.Add(keyRegAFU_ID, "00000000-0000-0000-0000-000011100181");
    ConfigRecord.Add(AAL_FACTORY_CREATE_CONFIGRECORD_FULL_AIA_NAME, "libAASUAIA");

#elif defined ( ASEAFU )
    ConfigRecord.Add(AAL_FACTORY_CREATE_CONFIGRECORD_FULL_SERVICE_NAME, "libASESPLAFU");
    ConfigRecord.Add(AAL_FACTORY_CREATE_SOFTWARE_SERVICE, true);

#else

    ConfigRecord.Add(AAL_FACTORY_CREATE_CONFIGRECORD_FULL_SERVICE_NAME, "libSWSimSPLAFU");
    ConfigRecord.Add(AAL_FACTORY_CREATE_SOFTWARE_SERVICE, true);
#endif

    Manifest.Add(AAL_FACTORY_CREATE_CONFIGRECORD_INCLUDED, ConfigRecord);

    Manifest.Add(AAL_FACTORY_CREATE_SERVICENAME, "Hello SPL LB");

    MSG("Allocating Service");

    // Allocate the Service and allocate the required workspace.
    //   This happens in the background via callbacks (simple state machine).
    //   When everything is set we do the real work here in the main thread.
    m_runtimClient->getRuntime()->allocService(dynamic_cast<IBase *>(this), Manifest);

    m_Sem.Wait();

    // If all went well run test.
    //   NOTE: If not successful we simply bail.
    //         A better design would do all appropriate clean-up.
    if (0 == m_Result) {


        //=============================
        // Now we have the NLB Service
        //   now we can use it
        //=============================
        MSG("Running Test");

        btVirtAddr         pWSUsrVirt = m_pWkspcVirt; // Address of Workspace
        const btWSSize     WSLen      = m_WkspcSize; // Length of workspace

        MSG("Allocated " << WSLen << "-byte Workspace at virtual address "
            << std::hex << (void *)pWSUsrVirt);

        // Number of bytes in each of the source and destination buffers (4 MiB in this case)
        btUnsigned32bitInt a_num_bytes = (btUnsigned32bitInt) ((WSLen - sizeof(VAFU2_CNTXT)) / 2);
        btUnsigned32bitInt a_num_cl   = a_num_bytes / CL(1);  // number of cache lines in buffer

        // VAFU Context is at the beginning of the buffer
        VAFU2_CNTXT       *pVAFU2_cntxt = reinterpret_cast<VAFU2_CNTXT *>(pWSUsrVirt);

        // The source buffer is right after the VAFU Context
        btVirtAddr         pSource = pWSUsrVirt + sizeof(VAFU2_CNTXT);  // the same as char*

        // The destination buffer is right after the source buffer
        btVirtAddr         pDest   = pSource + a_num_bytes;

        struct OneCL {                      // Make a cache-line sized structure
            btUnsigned32bitInt dw[16];       //    for array arithmetic
        };
        struct OneCL      *pSourceCL = reinterpret_cast<struct OneCL *>(pSource);
        struct OneCL      *pDestCL   = reinterpret_cast<struct OneCL *>(pDest);

        // Note: the usage of the VAFU2_CNTXT structure here is specific to the underlying bitstream
        // implementation. The bitstream targeted for use with this sample application must implement
        // the Validation AFU 2 interface and abide by the contract that a VAFU2_CNTXT structure will
        // appear at byte offset 0 within the supplied AFU Context workspace.

        // Initialize the command buffer
        ::memset(pVAFU2_cntxt, 0, sizeof(VAFU2_CNTXT));
        pVAFU2_cntxt->num_cl  = a_num_cl;
        pVAFU2_cntxt->pSource = pSource;
        pVAFU2_cntxt->pDest   = pDest;

        MSG("VAFU2 Context=" << std::hex << (void *)pVAFU2_cntxt <<
            " Src="          << std::hex << (void *)pVAFU2_cntxt->pSource <<
            " Dest="         << std::hex << (void *)pVAFU2_cntxt->pDest << std::dec);
        MSG("Cache lines in each buffer="  << std::dec << pVAFU2_cntxt->num_cl <<
            " (bytes="       << std::dec << pVAFU2_cntxt->num_cl * CL(1) <<
            " 0x"            << std::hex << pVAFU2_cntxt->num_cl * CL(1) << std::dec << ")");



        /* TODO: 1. reinterpret the workspace as matrix given M (matrix width)
         *       2. Calculate the expected results
         *       3. start the transaction and compare the results
         *       4. The wordLength is 512 / k / M
         */
        // we must make sure that the number of matrix is integer
        Matrix* pSourceMatrix = reinterpret_cast<Matrix *>(pSource);
        int oneMatrixSize = oneMatrixSizeBytes;
        if (a_num_bytes % oneMatrixSize == 0) {

            int numMatrix = a_num_bytes / oneMatrixSize;
            MSG("The number of matrix in source buffer is " << numMatrix);

            // Init the src/dest buffers, based on the desired sequence (either fixed or random).
            MSG("Initializing source matrix. (random)");

            std::srand((uint) std::time(0));
            for (int i = 0; i < a_num_bytes; i++) {  // 1 byte a time
                char random = (char) (std::rand() % 256);
                ::memset(pSource + i, random, 1);
            }

            MSG("Initializing the destination buffer as 0xBE");
            ::memset(pDest, 0xBE, a_num_bytes);

            // Buffers have been initialized
            ////////////////////////////////////////////////////////////////////////////

            ////////////////////////////////////////////////////////////////////////////
            // Get the AFU and start talking to it

            // Acquire the AFU. Once acquired in a TransactionContext, can issue CSR Writes and access DSM.
            // Provide a workspace and so also start the task.
            // The VAFU2 Context is assumed to be at the start of the workspace.
            MSG("Starting SPL Transaction with Workspace");
            m_SPLService->StartTransactionContext(TransactionID(), pWSUsrVirt, 100);
            m_Sem.Wait();

            // The AFU is running
            ////////////////////////////////////////////////////////////////////////////

            ////////////////////////////////////////////////////////////////////////////
            // Wait for the AFU to be done. This is AFU-specific, we have chosen to poll ...

            // Set timeout increment based on hardware, software, or simulation
            bt32bitInt count(500);  // 5 seconds with 10 millisecond sleep
            bt32bitInt delay(10);   // 10 milliseconds is the default

            // Wait for SPL VAFU to finish code
            volatile bt32bitInt done = pVAFU2_cntxt->Status & VAFU2_CNTXT_STATUS_DONE;
            while (!done && --count) {
                SleepMilli(delay);
                done = pVAFU2_cntxt->Status & VAFU2_CNTXT_STATUS_DONE;
            }
            if (!done) {
                // must have dropped out of loop due to count -- never saw update
                ERR("AFU never signaled it was done. Timing out anyway. Results may be strange.\n");
            }
            ////////////////////////////////////////////////////////////////////////////
            // Stop the AFU

            // Issue Stop Transaction and wait for OnTransactionStopped
            MSG("Stopping SPL Transaction");
            m_SPLService->StopTransactionContext(TransactionID());
            m_Sem.Wait();
            MSG("SPL Transaction complete");

            // transpose the source buffer
            for (int i = 0; i < numMatrix; i++) {
                matrixTranspose(pSourceMatrix + i);
            }

            ////////////////////////////////////////////////////////////////////////////
            // Check the buffers to make sure they copied okay

            btUnsignedInt cl;               // Loop counter. Cache-Line number.
            int tres;              // If many errors in buffer, only dump a limited number
            ostringstream oss("");          // Place to stash fancy strings

            MSG("Verifying buffers in workspace");

            // verifying whether the source buffer is the same as destination buffer

            tres = 0;                                          // dump only 4 CL's at a time
            for (cl = 0; cl < a_num_cl && tres < 4; ++cl) { // check for error in destination buffer
                if (::memcmp(&pSourceCL[cl], &pDestCL[cl], CL(1))) {
                    Show2CLs(&pSourceCL[cl], &pDestCL[cl], oss);
                    ERR("Destination cache line " << cl << " @" << (void *) &pDestCL[cl] <<
                        " is not what was expected.\n" << oss.str());
                    oss.str(std::string(""));
                    ++tres;
                }
            }

            if (tres == 0) MSG("The source and destination buffer is exactly the same!");
        } else {
            ERR("The number of matrix in source buffer is not an integer, abort.");
        }
    }

    ////////////////////////////////////////////////////////////////////////////
    // Clean up and exit
    MSG("Workspace verification complete, freeing workspace.");
    m_SPLService->WorkspaceFree(m_pWkspcVirt, TransactionID());
    m_Sem.Wait();

    m_runtimClient->end();
    return m_Result;
}

// We must implement the IServiceClient interface (IServiceClient.h):

// <begin IServiceClient interface>
void HelloSPLLBApp::serviceAllocated(IBase *pServiceBase,
                                     TransactionID const &rTranID)
{
    m_pAALService = pServiceBase;
    ASSERT(NULL != m_pAALService);

    // Documentation says SPLAFU Service publishes ISPLAFU as subclass interface
    m_SPLService = subclass_ptr<ISPLAFU>(pServiceBase);

    ASSERT(NULL != m_SPLService);
    if ( NULL == m_SPLService ) {
        return;
    }

    MSG("Service Allocated");

    // Allocate Workspaces needed. ASE runs more slowly and we want to watch the transfers,
    //   so have fewer of them.
#if defined ( ASEAFU )
#define LB_BUFFER_SIZE workspaceSizeBytes
#else
#define LB_BUFFER_SIZE MB(4)
#endif

    m_SPLService->WorkspaceAllocate(sizeof(VAFU2_CNTXT) + LB_BUFFER_SIZE + LB_BUFFER_SIZE,
                                    TransactionID());

}

void HelloSPLLBApp::serviceAllocateFailed(const IEvent &rEvent)
{
    IExceptionTransactionEvent * pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("Failed to allocate a Service");
    ERR(pExEvent->Description());
    ++m_Result;
    m_Sem.Post(1);
}

void HelloSPLLBApp::serviceFreed(TransactionID const &rTranID)
{
    MSG("Service Freed");
    // Unblock Main()
    m_Sem.Post(1);
}

// <ISPLClient>
void HelloSPLLBApp::OnWorkspaceAllocated(TransactionID const &TranID,
        btVirtAddr           WkspcVirt,
        btPhysAddr           WkspcPhys,
        btWSSize             WkspcSize)
{
    AutoLock(this);

    m_pWkspcVirt = WkspcVirt;
    m_WkspcSize = WkspcSize;

    MSG("Got Workspace");         // Got workspace so unblock the Run() thread
    m_Sem.Post(1);
}

void HelloSPLLBApp::OnWorkspaceAllocateFailed(const IEvent &rEvent)
{
    IExceptionTransactionEvent * pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("OnWorkspaceAllocateFailed");
    ERR(pExEvent->Description());
    ++m_Result;
    m_Sem.Post(1);
}

void HelloSPLLBApp::OnWorkspaceFreed(TransactionID const &TranID)
{
    MSG("OnWorkspaceFreed");
    // Freed so now Release() the Service through the Services IAALService::Release() method
    (dynamic_ptr<IAALService>(iidService, m_pAALService))->Release(TransactionID());
}

void HelloSPLLBApp::OnWorkspaceFreeFailed(const IEvent &rEvent)
{
    IExceptionTransactionEvent * pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("OnWorkspaceAllocateFailed");
    ERR(pExEvent->Description());
    ++m_Result;
    m_Sem.Post(1);
}

/// CMyApp Client implementation of ISPLClient::OnTransactionStarted
void HelloSPLLBApp::OnTransactionStarted( TransactionID const &TranID,
        btVirtAddr           AFUDSMVirt,
        btWSSize             AFUDSMSize)
{
    MSG("Transaction Started");
    m_AFUDSMVirt = AFUDSMVirt;
    m_AFUDSMSize =  AFUDSMSize;
    m_Sem.Post(1);
}
/// CMyApp Client implementation of ISPLClient::OnContextWorkspaceSet
void HelloSPLLBApp::OnContextWorkspaceSet( TransactionID const &TranID)
{
    MSG("Context Set");
    m_Sem.Post(1);
}
/// CMyApp Client implementation of ISPLClient::OnTransactionFailed
void HelloSPLLBApp::OnTransactionFailed( const IEvent &rEvent)
{
    IExceptionTransactionEvent * pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("Runtime AllocateService failed");
    ERR(pExEvent->Description());
    m_bIsOK = false;
    ++m_Result;
    m_AFUDSMVirt = NULL;
    m_AFUDSMSize =  0;
    ERR("Transaction Failed");
    m_Sem.Post(1);
}
/// CMyApp Client implementation of ISPLClient::OnTransactionComplete
void HelloSPLLBApp::OnTransactionComplete( TransactionID const &TranID)
{
    m_AFUDSMVirt = NULL;
    m_AFUDSMSize =  0;
    MSG("Transaction Complete");
    m_Sem.Post(1);
}
/// CMyApp Client implementation of ISPLClient::OnTransactionStopped
void HelloSPLLBApp::OnTransactionStopped( TransactionID const &TranID)
{
    m_AFUDSMVirt = NULL;
    m_AFUDSMSize =  0;
    MSG("Transaction Stopped");
    m_Sem.Post(1);
}
void HelloSPLLBApp::serviceEvent(const IEvent &rEvent)
{
    ERR("unexpected event 0x" << hex << rEvent.SubClassID());
}
// <end IServiceClient interface>

void HelloSPLLBApp::Show2CLs(void          *pCLExpected, // pointer to cache-line expected
                             void          *pCLFound,    // pointer to found cache line
                             ostringstream &oss)         // add it to this ostringstream
{
    oss << "Expected: ";
    _DumpCL(pCLExpected, oss);
    oss << "\n";
    oss << "Found:    ";
    _DumpCL(pCLFound, oss);
}  // _DumpCL

void HelloSPLLBApp::_DumpCL( void         *pCL,  // pointer to cache-line to print
                             ostringstream &oss)  // add it to this ostringstream
{
    oss << std::hex << std::setfill('0') << std::uppercase;
    btUnsigned32bitInt *pu32 = reinterpret_cast<btUnsigned32bitInt*>(pCL);
    for ( int i = 0; i < ( CL(1) / sizeof(btUnsigned32bitInt)); ++i ) {
        oss << "0x" << std::setw(8) << *pu32 << " ";
        ++pu32;
    }
    oss << std::nouppercase;
}  // _DumpCL

/// @} group HelloSPLLB


//=============================================================================
// Name: main
// Description: Entry point to the application
// Inputs: none
// Outputs: none
// Comments: Main initializes the system. The rest of the example is implemented
//           in the objects.
//=============================================================================
int main(int argc, char *argv[])
{
    RuntimeClient  runtimeClient;
    HelloSPLLBApp theApp(&runtimeClient);

    if (!runtimeClient.isOK()) {
        ERR("Runtime Failed to Start");
        exit(1);
    }
    btInt Result = theApp.run();

    MSG("Done");
    return Result;
}

