load "stdlib.ring"

func main
    see "=== Ring Subprocess Uninstaller ===" + nl
    
    try {
        cDir = CurrentDir()
        
        # Remove library folder
        ? "Removing folder: ring/extensions/subprocess"
		
        chdir(exefolder()+"../extensions")
        if Direxists("subprocess")
            OSDeleteFolder("subprocess")
            ? " Library folder removed successfully"
        else
            ? "! Library folder not found"
        ok
        
        # Remove DLL file
        ? nl + "Removing: ring_subprocess.dll"
        chdir("../bin")
        if Fexists("ring_subprocess.dll")
            remove("ring_subprocess.dll")
            ? " DLL file removed successfully"
        else
            ? "! DLL file not found"
        ok
        
        # Remove load file
        ? nl + "Removing: subprocess.ring"
        chdir("../bin/load")
        if Fexists("subprocess.ring")
            remove("subprocess.ring")
            ? " Load file removed successfully"
        else
            ? "! Load file not found"
        ok
        
        chdir(cDir)
        ? nl + " Ring Subprocess package uninstalled successfully!"
        
    catch 
        ? nl + "! Error during uninstallation:"
        ? cCatchError
    }
