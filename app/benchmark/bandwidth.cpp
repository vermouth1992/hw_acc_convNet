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
/// @file LlApp.cpp
/// @brief Linked List traversal using SPL (code and device use same address space for memory)
/// @ingroup LinkedList
/// @verbatim
/// Intel(R) QuickAssist Technology Accelerator Abstraction Layer Sample Application
///
///    This application is for example purposes only.
///    It is not intended to represent a model for developing commercially-deployable applications.
///    It is designed to show working examples of the AAL programming model and APIs.
///
/// AUTHORS: David Sheffield, Intel Corporation.
///
/// This Sample demonstrates the following:
///    - Using SPL to allow linked list traversal by a device
///
/// This sample is designed to be used with the SPLAFU Service.
///
/// HISTORY:
/// WHEN:          WHO:     WHAT:
/// 06/29/2015     HM       Initial integration into Samples.@endverbatim
//****************************************************************************
#include "../common.h"
#include "config.h"

using namespace AAL;

/// @addtogroup LinkedListSample
/// @{



/// @brief   Define our Runtime client class so that we can receive the runtime started/stopped notifications.
///
/// We implement a Service client within, to handle AAL Service allocation/free.
/// We also implement a Semaphore for synchronization with the AAL runtime.
class RuntimeClient : public CAASBase,
                      public IRuntimeClient {
public:
    RuntimeClient();

    ~RuntimeClient();

    void end();

    IRuntime *getRuntime();

    btBool isOK();

    // <begin IRuntimeClient interface>
    void runtimeStarted(IRuntime *pRuntime,
                        const NamedValueSet &rConfigParms);

    void runtimeStopped(IRuntime *pRuntime);

    void runtimeStartFailed(const IEvent &rEvent);

    void runtimeAllocateServiceFailed(IEvent const &rEvent);

    void runtimeAllocateServiceSucceeded(IBase *pClient,
                                         TransactionID const &rTranID);

    void runtimeEvent(const IEvent &rEvent);
    // <end IRuntimeClient interface>


protected:
    IRuntime *m_pRuntime;  // Pointer to AAL runtime instance.
    Runtime m_Runtime;   // AAL Runtime
    btBool m_isOK;      // Status
    CSemaphore m_Sem;       // For synchronizing with the AAL runtime.
};

///////////////////////////////////////////////////////////////////////////////
///
///  MyRuntimeClient Implementation
///
///////////////////////////////////////////////////////////////////////////////
RuntimeClient::RuntimeClient() :
        m_Runtime(),        // Instantiate the AAL Runtime
        m_pRuntime(NULL),
        m_isOK(false) {
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

RuntimeClient::~RuntimeClient() {
    m_Sem.Destroy();
}

btBool RuntimeClient::isOK() {
    return m_isOK;
}

void RuntimeClient::runtimeStarted(IRuntime *pRuntime,
                                   const NamedValueSet &rConfigParms) {
    // Save a copy of our runtime interface instance.
    m_pRuntime = pRuntime;
    m_isOK = true;
    m_Sem.Post(1);
}

void RuntimeClient::end() {
    m_Runtime.stop();
    m_Sem.Wait();
}

void RuntimeClient::runtimeStopped(IRuntime *pRuntime) {
    MSG("Runtime stopped");
    m_isOK = false;
    m_Sem.Post(1);
}

void RuntimeClient::runtimeStartFailed(const IEvent &rEvent) {
    IExceptionTransactionEvent *pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("Runtime start failed");
    ERR(pExEvent->Description());
}

void RuntimeClient::runtimeAllocateServiceFailed(IEvent const &rEvent) {
    IExceptionTransactionEvent *pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("Runtime AllocateService failed");
    ERR(pExEvent->Description());
}

void RuntimeClient::runtimeAllocateServiceSucceeded(IBase *pClient,
                                                    TransactionID const &rTranID) {
    MSG("Runtime Allocate Service Succeeded");
}

void RuntimeClient::runtimeEvent(const IEvent &rEvent) {
    MSG("Generic message handler (runtime)");
}

IRuntime *RuntimeClient::getRuntime() {
    return m_pRuntime;
}


/// @brief   Define our Service client class so that we can receive Service-related notifications from the AAL Runtime.
///          The Service Client contains the application logic.
///
/// When we request an AFU (Service) from AAL, the request will be fulfilled by calling into this interface.
class ConvLayer : public CAASBase, public IServiceClient, public ISPLClient {
public:

    ConvLayer(RuntimeClient *rtc);

    ~ConvLayer();

    btInt run();

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
    IBase *m_pAALService; // The generic AAL Service interface for the AFU.
    RuntimeClient *m_runtimClient;
    ISPLAFU *m_SPLService;
    CSemaphore m_Sem;         // For synchronizing with the AAL runtime.
    btInt m_Result;      ///< zero if no errors

    // Workspace MSG
    btVirtAddr m_pWkspcVirt;  ///< Workspace virtual address.
    btWSSize m_WkspcSize;   ///< DSM workspace size in bytes.

    btVirtAddr m_AFUDSMVirt;  ///< Points to DSM
    btWSSize m_AFUDSMSize;  ///< Length in bytes of DSM
};

///////////////////////////////////////////////////////////////////////////////
///
///  Implementation
///
///////////////////////////////////////////////////////////////////////////////
ConvLayer::ConvLayer(RuntimeClient *rtc) :
        m_pAALService(NULL),
        m_runtimClient(rtc),
        m_SPLService(NULL),
        m_Result(0),
        m_pWkspcVirt(NULL),
        m_WkspcSize(0),
        m_AFUDSMVirt(NULL),
        m_AFUDSMSize(0) {
    SetSubClassInterface(iidServiceClient, dynamic_cast<IServiceClient *>(this));
    SetInterface(iidSPLClient, dynamic_cast<ISPLClient *>(this));
    SetInterface(iidCCIClient, dynamic_cast<ICCIClient *>(this));
    m_Sem.Create(0, 1);
}

ConvLayer::~ConvLayer() {
    m_Sem.Destroy();
}

/* DBS: list data-structure.
 * use __packed__ attribute to ensure data
 * structure has the desired layout */

typedef struct list {
    struct list *next;
    uint64_t value;
} __attribute__((__packed__)) list_t;


int ConvLayer::run() {
    cout << "=======================" << endl;
    cout << "= Bandwidth Benchmark =" << endl;
    cout << "=======================" << endl;

    // Request our AFU.

    // NOTE: This example is bypassing the Resource Manager's configuration record lookup
    //  mechanism.  This code is work around code and subject to change.
    NamedValueSet Manifest;
    NamedValueSet ConfigRecord;


#if defined( HWAFU )                /* Use FPGA hardware */
    ConfigRecord.Add(AAL_FACTORY_CREATE_CONFIGRECORD_FULL_SERVICE_NAME, "libHWSPLAFU");
    ConfigRecord.Add(keyRegAFU_ID, "7D2FAE3B-B549-43E1-B575-7C6D947307FE");
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

        btVirtAddr pWSUsrVirt = m_pWkspcVirt; // Address of Workspace
        const btWSSize WSLen = m_WkspcSize; // Length of workspace

        MSG("Allocated " << WSLen << "-byte Workspace at virtual address "
                         << std::hex << (void *) pWSUsrVirt);

        // Number of bytes in each of the source and destination buffers (4 MiB in this case)
        btUnsigned32bitInt a_num_bytes = (btUnsigned32bitInt) ((WSLen - sizeof(VAFU2_CNTXT)) / 2);
        btUnsigned32bitInt a_num_cl = a_num_bytes / CL(1);  // number of cache lines in each buffer

        // VAFU Context is at the beginning of the buffer
        VAFU2_CNTXT *pVAFU2_cntxt = reinterpret_cast<VAFU2_CNTXT *>(pWSUsrVirt);

        // The source buffer is right after the VAFU Context
        btVirtAddr pSource = pWSUsrVirt + sizeof(VAFU2_CNTXT);  // the same as char*

        // The destination buffer is right after the source buffer
        btVirtAddr pDest = pSource + a_num_bytes;

        // Note: the usage of the VAFU2_CNTXT structure here is specific to the underlying bitstream
        // implementation. The bitstream targeted for use with this sample application must implement
        // the Validation AFU 2 interface and abide by the contract that a VAFU2_CNTXT structure will
        // appear at byte offset 0 within the supplied AFU Context workspace.

        // Initialize the command buffer
        ::memset(pVAFU2_cntxt, 0, sizeof(VAFU2_CNTXT));
        pVAFU2_cntxt->num_cl = a_num_cl;   // note that it is number of cache line in total
        pVAFU2_cntxt->pSource = pSource;
        pVAFU2_cntxt->pDest = pDest;
        pVAFU2_cntxt->qword0[4] = 2;    // 0 is illegal 1 for read, 2 for write, 3 for read/write

        MSG("VAFU2 Context=" << std::hex << (void *) pVAFU2_cntxt <<
                             " Src=" << std::hex << (void *) pVAFU2_cntxt->pSource <<
                             " Dest=" << std::hex << (void *) pVAFU2_cntxt->pDest << std::dec);
        MSG("Cache lines in each buffer=" << std::dec << pVAFU2_cntxt->num_cl <<
                                          " (bytes=" << std::dec << pVAFU2_cntxt->num_cl * CL(1) <<
                                          " 0x" << std::hex << pVAFU2_cntxt->num_cl * CL(1) << std::dec << ")");

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

        // set the timer
        timespec start;
        timespec end;

        // start the timer
        clock_gettime(CLOCK_REALTIME, &start);
        // The AFU is running
        ////////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////////
        // Wait for the AFU to be done. This is AFU-specific, we have chosen to poll ...

        // Set timeout increment based on hardware, software, or simulation
        bt32bitInt count(500);  // 5 seconds with 10 millisecond sleep
        bt32bitInt delay(1000);   // 10 milliseconds is the default

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
        // set the end time
        clock_gettime(CLOCK_REALTIME, &end);

        string precision = "ms";
        MSG("The processing time is " << calculate_time_interval(end, start, precision) << precision);

        // Issue Stop Transaction and wait for OnTransactionStopped
        MSG("Stopping SPL Transaction");
        m_SPLService->StopTransactionContext(TransactionID());
        m_Sem.Wait();
        MSG("SPL Transaction complete");
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
void ConvLayer::serviceAllocated(IBase *pServiceBase,
                                 TransactionID const &rTranID) {
    m_pAALService = pServiceBase;
    ASSERT(NULL != m_pAALService);

    // Documentation says SPLAFU Service publishes ISPLAFU as subclass interface
    m_SPLService = subclass_ptr<ISPLAFU>(pServiceBase);

    ASSERT(NULL != m_SPLService);
    if (NULL == m_SPLService) {
        return;
    }

    MSG("Service Allocated");

    // Allocate Workspaces needed.
    m_SPLService->WorkspaceAllocate(sizeof(VAFU2_CNTXT) + bufferSize + bufferSize,
                                    TransactionID());

}

void ConvLayer::serviceAllocateFailed(const IEvent &rEvent) {
    IExceptionTransactionEvent *pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("Failed to allocate a Service");
    ERR(pExEvent->Description());
    ++m_Result;
    m_Sem.Post(1);
}

void ConvLayer::serviceFreed(TransactionID const &rTranID) {
    MSG("Service Freed");
    // Unblock Main()
    m_Sem.Post(1);
}

// <ISPLClient>
void ConvLayer::OnWorkspaceAllocated(TransactionID const &TranID,
                                     btVirtAddr WkspcVirt,
                                     btPhysAddr WkspcPhys,
                                     btWSSize WkspcSize) {
    AutoLock(this);

    m_pWkspcVirt = WkspcVirt;
    m_WkspcSize = WkspcSize;

    MSG("Got Workspace");         // Got workspace so unblock the Run() thread
    m_Sem.Post(1);
}

void ConvLayer::OnWorkspaceAllocateFailed(const IEvent &rEvent) {
    IExceptionTransactionEvent *pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("OnWorkspaceAllocateFailed");
    ERR(pExEvent->Description());
    ++m_Result;
    m_Sem.Post(1);
}

void ConvLayer::OnWorkspaceFreed(TransactionID const &TranID) {
    ERR("OnWorkspaceFreed");
    // Freed so now Release() the Service through the Services IAALService::Release() method
    (dynamic_ptr<IAALService>(iidService, m_pAALService))->Release(TransactionID());
}

void ConvLayer::OnWorkspaceFreeFailed(const IEvent &rEvent) {
    IExceptionTransactionEvent *pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    ERR("OnWorkspaceAllocateFailed");
    ERR(pExEvent->Description());
    ++m_Result;
    m_Sem.Post(1);
}

/// CMyApp Client implementation of ISPLClient::OnTransactionStarted
void ConvLayer::OnTransactionStarted(TransactionID const &TranID,
                                     btVirtAddr AFUDSMVirt,
                                     btWSSize AFUDSMSize) {
    MSG("Transaction Started");
    m_AFUDSMVirt = AFUDSMVirt;
    m_AFUDSMSize = AFUDSMSize;
    m_Sem.Post(1);
}

/// CMyApp Client implementation of ISPLClient::OnContextWorkspaceSet
void ConvLayer::OnContextWorkspaceSet(TransactionID const &TranID) {
    MSG("Context Set");
    m_Sem.Post(1);
}

/// CMyApp Client implementation of ISPLClient::OnTransactionFailed
void ConvLayer::OnTransactionFailed(const IEvent &rEvent) {
    IExceptionTransactionEvent *pExEvent = dynamic_ptr<IExceptionTransactionEvent>(iidExTranEvent, rEvent);
    MSG("Runtime AllocateService failed");
    MSG(pExEvent->Description());
    m_bIsOK = false;
    ++m_Result;
    m_AFUDSMVirt = NULL;
    m_AFUDSMSize = 0;
    ERR("Transaction Failed");
    m_Sem.Post(1);
}

/// CMyApp Client implementation of ISPLClient::OnTransactionComplete
void ConvLayer::OnTransactionComplete(TransactionID const &TranID) {
    m_AFUDSMVirt = NULL;
    m_AFUDSMSize = 0;
    MSG("Transaction Complete");
    m_Sem.Post(1);
}

/// CMyApp Client implementation of ISPLClient::OnTransactionStopped
void ConvLayer::OnTransactionStopped(TransactionID const &TranID) {
    m_AFUDSMVirt = NULL;
    m_AFUDSMSize = 0;
    MSG("Transaction Stopped");
    m_Sem.Post(1);
}

void ConvLayer::serviceEvent(const IEvent &rEvent) {
    ERR("unexpected event 0x" << hex << rEvent.SubClassID());
}
// <end IServiceClient interface>

/// @} group LinkedListSample


//=============================================================================
// Name: main
// Description: Entry point to the application
// Inputs: none
// Outputs: none
// Comments: Main initializes the system. The rest of the example is implemented
//           in the objects.
//=============================================================================
int main(int argc, char *argv[]) {
    RuntimeClient runtimeClient;
    ConvLayer theApp(&runtimeClient);

    if (!runtimeClient.isOK()) {
        ERR("Runtime Failed to Start");
        exit(1);
    }
    btInt Result = theApp.run();

    MSG("Done");
    return Result;
}

