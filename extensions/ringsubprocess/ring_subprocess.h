#ifndef ring_subprocess_h
#define ring_subprocess_h

#include "ring.h"
#include <stdio.h>
#include <fcntl.h>

#ifdef _WIN32
#include <windows.h>
#include <io.h>
#else
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <signal.h>

typedef pid_t HANDLE;
typedef int DWORD;
#endif

// هياكل البيانات
typedef struct SubProcess
{
    FILE *pipeHandle;
    FILE *stdinHandle;

#ifdef _WIN32
    HANDLE hProcess;
    DWORD processId;
#else
    pid_t hProcess;
    pid_t processId;
#endif

    String *output;
} SubProcess;

// التعريفات الأساسية
RING_API void ringlib_init(RingState *pRingState);

// دوال الواجهة
RING_API void ring_vm_subprocess_init(void *pPointer);
RING_API void ring_vm_subprocess_create(void *pPointer);
RING_API void ring_vm_subprocess_execute(void *pPointer);
RING_API void ring_vm_subprocess_wait(void *pPointer);
RING_API void ring_vm_subprocess_getoutput(void *pPointer);
RING_API void ring_vm_subprocess_terminate(void *pPointer);
RING_API void ring_vm_subprocess_setstdin(void *pPointer);
RING_API void ring_vm_subprocess_geterror(void *pPointer);
RING_API void ring_vm_subprocess_getexitcode(void *pPointer);
RING_API void ring_vm_subprocess_getpid(void *pPointer);
RING_API void ring_vm_subprocess_readasync(void *pPointer);

#endif
