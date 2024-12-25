# Ring Subprocess Extension

A powerful subprocess management extension for the Ring programming language that provides a simple interface for creating and managing system processes.

## Features

- Execute commands synchronously and asynchronously
- Read command output in both synchronous and asynchronous modes
- Send input to processes
- Get process information (PID, exit code)
- Handle process errors and stderr
- Stream output in real-time
- Create and manage system processes
- Capture process output
- Wait for process completion
- Terminate running processes
- Simple and intuitive API

## Installation

- `ringpm install ringsubprocess from Azzeddine2017`

### Build Steps

- Build the extension using the provided `buildvc_x64.bat` script:
```batch
buildvc_x64.bat
```

## Usage

### Basic Example

```ring
load "subprocess.ring"

proc = new ProcessManager()
proc.runCommand("cmd.exe /c dir")
proc.waitForComplete()
? proc.readOutput()
proc.kill()
```
### Advanced Example

```ring
load "subprocess.ring"

# Create a new process manager
proc = new ProcessManager()

# Execute a command synchronously
proc.runCommand("command")
proc.waitForComplete()
output = proc.readOutput()

# Execute a command asynchronously with real-time output
proc.runCommandAsync("command")
while true {
    output = proc.readOutputAsync()
    if len(output) = 0 { exit }
    ? output
}

# Get process information
pid = proc.getPid()
exitCode = proc.getExitCode()
error = proc.getStderr()

# Clean up
proc.kill()
```


#### runCommand(command)
Creates and executes a new process with the specified command.
```ring
proc.runCommand("cmd.exe /c echo Hello World")
```

#### runCommandAsync(command)
Runs a command asynchronously.
```ring
proc.runCommandAsync("command")
```

#### waitForComplete()
Waits for the process to complete and captures its output.
```ring
proc.waitForComplete()
```

#### readOutput()
Returns the captured output from the process.
```ring
output = proc.readOutput()
```

#### readOutputAsync()
Reads output line by line asynchronously.
```ring
output = proc.readOutputAsync()
```

#### setStdin(data)
Sends input to the process.
```ring
proc.setStdin("input data")
```

#### getStderr()
Gets error output from the process.
```ring
error = proc.getStderr()
```

#### getExitCode()
Gets the process exit code.
```ring
exitCode = proc.getExitCode()
```

#### getPid()
Gets the process ID.
```ring
pid = proc.getPid()
```

#### kill()
Terminates the running process.
```ring
proc.kill()
```

#### isActive()
Checks if the process is still running.
```ring
if proc.isActive()
    ? "Process is still running"
ok
```


## Implementation Details

The extension uses `_popen` for process creation and management, which provides several advantages:
- Simple and reliable process creation
- Built-in output capture functionality
- Avoids conflicts with Ring's existing system functions


## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Here are some ways you can contribute:
1. Reporting bugs
2. Suggesting enhancements
3. Adding new features
4. Improving documentation

## Future Enhancements

Planned features for future releases:
- Exit code retrieval
- Asynchronous execution support
- Standard input (stdin) redirection
- Enhanced error handling
- Cross-platform support improvements
