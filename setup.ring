load "ziplib.ring"
load "stdlib.ring"

func main
    see "=== Ring Subprocess Installer ===" + nl
    
    try {
        cDir = CurrentDir()
        
        # Extract library files
        ? "Extracting files: ringsubprocess.zip "
        
        chdir(exefolder() + "../extensions")
        if Fexists("ringsubprocess.zip")
            zip_extract_allfiles("ringsubprocess.zip","ringsubprocess")
            remove("ringsubprocess.zip")
            ? " Library files extracted successfully"
        ok
        
        chdir(cDir)
        ? nl + " Ring Subprocess package installed successfully!"
        ? "Starting the package..."
        system("ringpm run ringsubprocess")
        
    catch 
        ? nl + "! Error during installation:"
        ? cCatchError
	}
