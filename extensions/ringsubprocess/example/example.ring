load "subprocess.ring"

? "ProcessManager Example with Streams"
? "================================"

proc = new ProcessManager()

cmdPrefix = NULL

if iswindows()
    cmdPrefix = "cmd.exe /c"
ok
# 1. Synchronous Output Reading (after waitForComplete)
? nl + "1. Reading Output Synchronously:"
if proc.runCommandAsync(cmdPrefix + "echo Hello World") {
    proc.waitForComplete()  # Read all output and store in output
    ? proc.readOutput()     # Read from stored output
}

# 2. Asynchronous Output Reading (before waitForComplete)
? nl + "2. Reading Output Asynchronously:"
if proc.runCommandAsync(cmdPrefix + "echo Line 1 && echo Line 2 && echo Line 3") {
    ? "Reading output line by line:"
    while true {
        output = proc.readOutputAsync()
        if len(output) = 0 { exit }
        ? "> " + output
    }
    proc.waitForComplete()
}
