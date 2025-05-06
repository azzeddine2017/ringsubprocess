load "subprocess.ring"

? "=== Advanced Example of Using ProcessManager ==="

# Create new instance of ProcessManager
proc = new ProcessManager()

? "1. Creating and Executing Multiple Commands"
? "----------------------------------------"

# Create new test folder
if isWindows()
	proc.runCommand(getCommand("if not exist test_folder mkdir test_folder"))
else
	proc.runCommand(getCommand("rm -rf test_folder"))
	proc.runCommand(getCommand("mkdir -p test_folder"))
ok
proc.waitForComplete()

# Create some text files
if isWindows()
	proc.runCommand(getCommand('echo Welcome to Ring Language > test_folder\file1.txt'))
	proc.runCommand(getCommand('echo Ring is an amazing programming language > test_folder\file2.txt'))
else
	proc.runCommand(getCommand('echo "Welcome to Ring Language" > test_folder/file1.txt'))
	proc.runCommand(getCommand('echo "Ring is an amazing programming language" > test_folder/file2.txt'))
ok
proc.waitForComplete()

? "2. Reading Directory Contents"
? "----------------------------------------"
if isWindows()
	proc.runCommand(getCommand("dir test_folder"))
else
	proc.runCommand(getCommand("ls -l test_folder"))
ok
proc.waitForComplete()
? "Directory Contents:"
? proc.readOutput()

? "3. Merging Files"
? "----------------------------------------"
if isWindows()
	proc.runCommand(getCommand('copy /b test_folder\file1.txt + test_folder\file2.txt test_folder\combined.txt'))
	proc.waitForComplete()
	proc.runCommand(getCommand('type test_folder\combined.txt'))
else
	proc.runCommand(getCommand('cat test_folder/file1.txt test_folder/file2.txt > test_folder/combined.txt'))
	proc.waitForComplete()
	proc.runCommand(getCommand('cat test_folder/combined.txt'))
ok
proc.waitForComplete()
? "Combined File Content:"
? proc.readOutput()

? "4. Searching in Files"
? "----------------------------------------"
if isWindows()
	proc.runCommand(getCommand('findstr Ring test_folder\*.txt'))
else
	proc.runCommand(getCommand('grep Ring test_folder/*.txt'))
ok
proc.waitForComplete()
? "Search Results for 'Ring':"
? proc.readOutput()

? "5. Cleanup"
? "----------------------------------------"
if isWindows()
	proc.runCommand(getCommand("rd /s /q test_folder"))
else
	proc.runCommand(getCommand("rm -rf test_folder"))
ok
proc.waitForComplete()
proc.kill()
? "Process Status: " + proc.isActive()
? "All operations completed successfully!"

func getCommand(cmd)
	if isWindows()
		return "cmd.exe /c " + cmd
	else
		return `sh -c '` + cmd + `'`
	ok