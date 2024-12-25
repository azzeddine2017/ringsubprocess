load "../subprocess.ring"

? "=== Advanced Example of Using ProcessManager ==="

# Create new instance of ProcessManager
proc = new ProcessManager()

? "1. Creating and Executing Multiple Commands"
? "----------------------------------------"

# Create new test folder
proc.runCommand("cmd.exe /c if not exist test_folder mkdir test_folder")
proc.waitForComplete()

# Create some text files with proper escaping
proc.runCommand("cmd.exe /c echo Welcome to Ring Language > test_folder\file1.txt")
proc.waitForComplete()
proc.runCommand("cmd.exe /c echo Ring is an amazing programming language > test_folder\file2.txt")
proc.waitForComplete()

? "2. Reading Directory Contents"
? "----------------------------------------"
proc.runCommand("cmd.exe /c dir test_folder")
proc.waitForComplete()
? "Directory Contents:"
? proc.readOutput()

? "3. Merging Files"
? "----------------------------------------"
proc.runCommand("cmd.exe /c copy /b test_folder\file1.txt + test_folder\file2.txt test_folder\combined.txt")
proc.waitForComplete()
proc.runCommand("cmd.exe /c type test_folder\combined.txt")
proc.waitForComplete()
? "Combined File Content:"
? proc.readOutput()

? "4. Searching in Files"
? "----------------------------------------"
proc.runCommand("cmd.exe /c findstr Ring test_folder\*.txt")
proc.waitForComplete()
? "Search Results for 'Ring':"
? proc.readOutput()

? "5. Cleanup"
? "----------------------------------------"
proc.runCommand("cmd.exe /c rd /s /q test_folder")
proc.waitForComplete()
proc.kill()
? "Process Status: " + proc.isActive()
? "All operations completed successfully!"
