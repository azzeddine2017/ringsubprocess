#include "ring_subprocess.h"
#include <stdio.h>
#include <windows.h>

RING_API void ringlib_init(RingState *pRingState)
{
    ring_vm_funcregister("subprocess_init", ring_vm_subprocess_init);
    ring_vm_funcregister("subprocess_create", ring_vm_subprocess_create);
    ring_vm_funcregister("subprocess_execute", ring_vm_subprocess_execute);
    ring_vm_funcregister("subprocess_wait", ring_vm_subprocess_wait);
    ring_vm_funcregister("subprocess_getoutput", ring_vm_subprocess_getoutput);
    ring_vm_funcregister("subprocess_terminate", ring_vm_subprocess_terminate);
    ring_vm_funcregister("subprocess_setstdin", ring_vm_subprocess_setstdin);
    ring_vm_funcregister("subprocess_geterror", ring_vm_subprocess_geterror);
    ring_vm_funcregister("subprocess_getexitcode", ring_vm_subprocess_getexitcode);
    ring_vm_funcregister("subprocess_getpid", ring_vm_subprocess_getpid);
    ring_vm_funcregister("subprocess_readasync", ring_vm_subprocess_readasync);
}

RING_API void ring_vm_subprocess_init(void *pPointer)
{
    SubProcess *pSubProcess = (SubProcess *)malloc(sizeof(SubProcess));
    if (pSubProcess == NULL) {
        RING_API_ERROR(RING_OOM);
        return;
    }
    pSubProcess->hProcess = NULL;
    pSubProcess->pipeHandle = NULL;
    pSubProcess->stdinHandle = NULL;
    pSubProcess->output = NULL;
    pSubProcess->processId = 0;
    RING_API_RETCPOINTER(pSubProcess, "SubProcess");
}

RING_API void ring_vm_subprocess_create(void *pPointer)
{
    if (RING_API_PARACOUNT != 2) {
        RING_API_ERROR(RING_API_MISS2PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1) || !RING_API_ISSTRING(2)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    const char *command = RING_API_GETSTRING(2);

    SECURITY_ATTRIBUTES saAttr;
    HANDLE hReadPipe = NULL;
    HANDLE hWritePipe = NULL;
    HANDLE hStdinRead = NULL;
    HANDLE hStdinWrite = NULL;
    
    saAttr.nLength = sizeof(SECURITY_ATTRIBUTES);
    saAttr.bInheritHandle = TRUE;
    saAttr.lpSecurityDescriptor = NULL;

    // إنشاء أنبوب للقراءة (stdout)
    if (!CreatePipe(&hReadPipe, &hWritePipe, &saAttr, 0)) {
        RING_API_ERROR("Failed to create stdout pipe");
        return;
    }

    // إنشاء أنبوب للكتابة (stdin)
    if (!CreatePipe(&hStdinRead, &hStdinWrite, &saAttr, 0)) {
        CloseHandle(hReadPipe);
        CloseHandle(hWritePipe);
        RING_API_ERROR("Failed to create stdin pipe");
        return;
    }

    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    si.hStdError = hWritePipe;
    si.hStdOutput = hWritePipe;
    si.hStdInput = hStdinRead;  // تعيين stdin
    si.dwFlags |= STARTF_USESTDHANDLES;
    
    ZeroMemory(&pi, sizeof(pi));

    if (!CreateProcess(NULL, (LPSTR)command, NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi)) {
        CloseHandle(hReadPipe);
        CloseHandle(hWritePipe);
        CloseHandle(hStdinRead);
        CloseHandle(hStdinWrite);
        RING_API_ERROR("Failed to create process");
        return;
    }

    pSubProcess->hProcess = pi.hProcess;
    pSubProcess->processId = pi.dwProcessId;
    pSubProcess->pipeHandle = _fdopen(_open_osfhandle((intptr_t)hReadPipe, _O_RDONLY), "r");
    pSubProcess->stdinHandle = _fdopen(_open_osfhandle((intptr_t)hStdinWrite, _O_WRONLY), "w");
    
    CloseHandle(pi.hThread);
    CloseHandle(hWritePipe);
    CloseHandle(hStdinRead);

    RING_API_RETNUMBER(1);
}

RING_API void ring_vm_subprocess_execute(void *pPointer)
{
    if (RING_API_PARACOUNT != 2) {
        RING_API_ERROR(RING_API_MISS2PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1) || !RING_API_ISSTRING(2)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    const char *command = RING_API_GETSTRING(2);

    SECURITY_ATTRIBUTES saAttr;
    HANDLE hReadPipe = NULL;
    HANDLE hWritePipe = NULL;
    HANDLE hStdinRead = NULL;
    HANDLE hStdinWrite = NULL;
    
    saAttr.nLength = sizeof(SECURITY_ATTRIBUTES);
    saAttr.bInheritHandle = TRUE;
    saAttr.lpSecurityDescriptor = NULL;

    // إنشاء أنبوب للقراءة (stdout)
    if (!CreatePipe(&hReadPipe, &hWritePipe, &saAttr, 0)) {
        RING_API_ERROR("Failed to create stdout pipe");
        return;
    }

    // إنشاء أنبوب للكتابة (stdin)
    if (!CreatePipe(&hStdinRead, &hStdinWrite, &saAttr, 0)) {
        CloseHandle(hReadPipe);
        CloseHandle(hWritePipe);
        RING_API_ERROR("Failed to create stdin pipe");
        return;
    }

    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    si.hStdError = hWritePipe;
    si.hStdOutput = hWritePipe;
    si.hStdInput = hStdinRead;  // تعيين stdin
    si.dwFlags |= STARTF_USESTDHANDLES;
    
    ZeroMemory(&pi, sizeof(pi));

    if (!CreateProcess(NULL, (LPSTR)command, NULL, NULL, TRUE, CREATE_NO_WINDOW, NULL, NULL, &si, &pi)) {
        CloseHandle(hReadPipe);
        CloseHandle(hWritePipe);
        CloseHandle(hStdinRead);
        CloseHandle(hStdinWrite);
        RING_API_ERROR("Failed to execute process");
        return;
    }

    pSubProcess->hProcess = pi.hProcess;
    pSubProcess->processId = pi.dwProcessId;
    pSubProcess->pipeHandle = _fdopen(_open_osfhandle((intptr_t)hReadPipe, _O_RDONLY), "r");
    pSubProcess->stdinHandle = _fdopen(_open_osfhandle((intptr_t)hStdinWrite, _O_WRONLY), "w");
    
    CloseHandle(pi.hThread);
    CloseHandle(hWritePipe);
    CloseHandle(hStdinRead);

    RING_API_RETNUMBER(1);
}

RING_API void ring_vm_subprocess_wait(void *pPointer)
{
    if (RING_API_PARACOUNT != 1) {
        RING_API_ERROR(RING_API_MISS1PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    if (pSubProcess->hProcess != NULL) {
        WaitForSingleObject(pSubProcess->hProcess, INFINITE);
        
        char buffer[4096];
        String *pString = ring_string_new("");

        while (fgets(buffer, sizeof(buffer)-1, pSubProcess->pipeHandle) != NULL) {
            ring_string_add(pString, buffer);
        }

        if (pSubProcess->output != NULL) {
            ring_string_delete(pSubProcess->output);
        }
        pSubProcess->output = pString;
        
        RING_API_RETNUMBER(1);
    }
    RING_API_RETNUMBER(0);
}

RING_API void ring_vm_subprocess_getoutput(void *pPointer)
{
    if (RING_API_PARACOUNT != 1) {
        RING_API_ERROR(RING_API_MISS1PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    if (pSubProcess->output != NULL) {
        RING_API_RETSTRING2(ring_string_get(pSubProcess->output), ring_string_size(pSubProcess->output));
    } else {
        RING_API_RETSTRING("");
    }
}

RING_API void ring_vm_subprocess_terminate(void *pPointer)
{
    if (RING_API_PARACOUNT != 1) {
        RING_API_ERROR(RING_API_MISS1PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    if (pSubProcess->pipeHandle != NULL) {
        _pclose(pSubProcess->pipeHandle);
    }
    if (pSubProcess->stdinHandle != NULL) {
        _pclose(pSubProcess->stdinHandle);
    }
    if (pSubProcess->output != NULL) {
        ring_string_delete(pSubProcess->output);
    }
    free(pSubProcess);
    RING_API_RETNUMBER(1);
}

RING_API void ring_vm_subprocess_setstdin(void *pPointer)
{
    if (RING_API_PARACOUNT != 2) {
        RING_API_ERROR(RING_API_MISS2PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1) || !RING_API_ISSTRING(2)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    const char *input = RING_API_GETSTRING(2);

    if (pSubProcess->stdinHandle != NULL) {
        fputs(input, pSubProcess->stdinHandle);
        fflush(pSubProcess->stdinHandle);
        RING_API_RETNUMBER(1);
    }
    RING_API_RETNUMBER(0);
}

RING_API void ring_vm_subprocess_geterror(void *pPointer)
{
    if (RING_API_PARACOUNT != 1) {
        RING_API_ERROR(RING_API_MISS1PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    if (pSubProcess->pipeHandle != NULL && ferror(pSubProcess->pipeHandle)) {
        RING_API_RETSTRING("Process Error Occurred");
    }
    RING_API_RETSTRING("");
}

RING_API void ring_vm_subprocess_getexitcode(void *pPointer)
{
    if (RING_API_PARACOUNT != 1) {
        RING_API_ERROR(RING_API_MISS1PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    DWORD exitCode = 0;

    if (pSubProcess->hProcess != NULL) {
        GetExitCodeProcess(pSubProcess->hProcess, &exitCode);
    }
    RING_API_RETNUMBER(exitCode);
}

RING_API void ring_vm_subprocess_getpid(void *pPointer)
{
    if (RING_API_PARACOUNT != 1) {
        RING_API_ERROR(RING_API_MISS1PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    RING_API_RETNUMBER(pSubProcess->processId);
}

RING_API void ring_vm_subprocess_readasync(void *pPointer)
{
    if (RING_API_PARACOUNT != 1) {
        RING_API_ERROR(RING_API_MISS1PARA);
        return;
    }
    if (!RING_API_ISPOINTER(1)) {
        RING_API_ERROR(RING_API_BADPARATYPE);
        return;
    }

    SubProcess *pSubProcess = (SubProcess *)RING_API_GETCPOINTER(1, "SubProcess");
    if (pSubProcess->pipeHandle != NULL) {
        char buffer[1024];
        if (fgets(buffer, sizeof(buffer)-1, pSubProcess->pipeHandle) != NULL) {
            RING_API_RETSTRING(buffer);
            return;
        }
    }
    RING_API_RETSTRING("");
}
