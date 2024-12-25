load "../subprocess.ring"

? "Testing ProcessManager"

# Create new instance
proc = new ProcessManager()

? "Executing dir command"
proc.runCommand("cmd.exe /c dir")
proc.waitForComplete()
? "Output:"
? proc.readOutput()

? "Executing echo command"
proc.runCommandAsync("cmd.exe /c echo Hello World")
proc.waitForComplete()
? "Output:"
? proc.readOutput()

? "Terminating process"
proc.kill()

? "Is process active: " + proc.isActive()
