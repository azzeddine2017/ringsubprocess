#ifndef ring_subprocess_h
#define ring_subprocess_h

#include "ring.h"
#include <windows.h>

// هياكل البيانات
typedef struct SubProcess {
    FILE *pipeHandle;      // للقراءة من stdout
    FILE *stdinHandle;     // للكتابة إلى stdin
    HANDLE hProcess;
    DWORD processId;
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
