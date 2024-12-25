load "../subprocess.ring"

? "System Information Example"
? "========================"

proc = new ProcessManager()

# Get System Information
see nl + "Getting System Information..."

commands = [
    'systeminfo | findstr /B /C:"OS Name" /C:"OS Version"',
    'wmic cpu get name',
    'wmic memorychip get capacity',
    'wmic diskdrive get size,model'
]

for command in commands {
    see nl + "Executing: " + command
    if proc.runCommandAsync(command) {
        while true {
            output = proc.readOutputAsync()
            if len(output) = 0 { exit }
            see "> " + output
        }
        proc.waitForComplete()
        
        if proc.getExitCode() != 0 {
            see "Error executing command!"
        }
    }
}

# Get running processes
see nl + "Getting top 5 processes by memory usage..."
command = 'powershell -command "Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 5 | Format-Table Name, WS"'

if proc.runCommand(command) {
    proc.waitForComplete()
    see proc.readOutput()
}

proc.kill()
