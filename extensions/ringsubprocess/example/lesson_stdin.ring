# ======================================================
# Lesson: Using setStdin with Ring
# Author: Ring Team
# ======================================================

load "../subprocess.ring"


# Example 1: Ring REPL
? nl + "Example 1: Ring REPL"
? "------------------"

? "Testing setStdin with Ring REPL"
? "=========================="

write("repl.ring", '
while true
    see nl + "code:> "
    give cCode
    if cCode = "exit"
        exit
    ok
    try
        eval(cCode)
    catch
        see cCatchError
    done
end
')

proc = new ProcessManager()
? "Starting Ring REPL..."
proc.runCommand("ring repl.ring")

? nl + "Sending code to execute..."
proc.setStdin('see "Testing..." + nl' + nl + "exit" + nl)

proc.waitForComplete()
? nl + "Output:"
see proc.readOutput()

proc.kill()
remove("repl.ring")

# Example 2: Ring REPL with Multiple Commands
? nl + "Example 2: Ring REPL with Multiple Commands"
? "-----------------------------------------"

# Example: Ring REPL
? "Ring REPL Example"
? "================"

write("repl.ring", '
while true
    see nl + "code:> "
    give cCode
    if cCode = "exit"
        see "Goodbye!" + nl
        exit
    ok
    try
        eval(cCode)
    catch
        see cCatchError
    done
end
')

proc = new ProcessManager()
? "Starting Ring REPL..."
proc.runCommand("ring repl.ring")

? nl + "Sending commands..."
proc.setStdin("x = 10" + nl + 
              "see 'x = ' + x + nl" + nl +
              "for i = 1 to 3 see i + nl next" + nl +
              "exit" + nl)

proc.waitForComplete()
? nl + "Output:"
see proc.readOutput()

proc.kill()
remove("repl.ring")
