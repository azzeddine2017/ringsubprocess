load "subprocess.ring"

? "Testing ProcessManager"

# Create new instance
proc = new ProcessManager()

if isWindows()
	? "Executing dir command"
	proc.runCommand("cmd.exe \c dir")
else
	? "Executing ls command"
	proc.runCommand("ls")
ok

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
