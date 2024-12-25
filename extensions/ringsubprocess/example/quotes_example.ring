load "subprocess.ring"

see "Random Programming Quotes Example"
see "=============================="

proc = new ProcessManager()

# Using quotes.rest API - no API key needed
command = 'powershell -command "Invoke-WebRequest -Uri https://api.quotable.io/random -UseBasicParsing | Select-Object -ExpandProperty Content"'

see nl + "Fetching a random quote..."

if proc.runCommand(command) {
    proc.waitForComplete()
    output = proc.readOutput()
    
    if len(output) > 0 {
        see nl + "Quote received:"
        see "------------"
        see output
        see "------------"
    else
        see "Failed to fetch quote"
    }
}

# Try fetching multiple quotes
see nl + "Fetching multiple quotes..."

for i = 1 to 3 {
    see nl + "Quote #" + i
    
    if proc.runCommandAsync(command) {
        while true {
            output = proc.readOutputAsync()
            if len(output) = 0 { exit }
            see "> " + output
        }
        proc.waitForComplete()
    }
    see "Status code: " + proc.getExitCode()
}

proc.kill()
