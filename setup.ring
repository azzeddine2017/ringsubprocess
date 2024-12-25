load "ziplib.ring"
load "stdlib.ring"

func main
    see "=== Ring Subprocess Installer ===" + nl
    
    try {
        cDir = CurrentDir()
        
        # Check required files
        if not Fexists("ringsubprocess.zip") or not Fexists("ringsubprocessdll.zip")
            ? "! Error: Package files not found"
            return
        ok
        
        # Extract library files
        ? "Extracting files: ringsubprocess.zip and ringsubprocessdll.zip"
        
        chdir(exefolder() + "../extensions")
        if Fexists("ringsubprocess.zip")
            zip_extract_allfiles("ringsubprocess.zip","ringsubprocess")
            remove("ringsubprocess.zip")
            ? " Library files extracted successfully"
        ok

        # Extract DLL files
        chdir("../bin")
        if Fexists("ringsubprocessdll.zip")
            zip_extract_allfiles("ringsubprocessdll.zip",".")
            remove("ringsubprocessdll.zip")
            ? " DLL files extracted successfully"
        ok
        
        chdir(cDir)
        ? nl + " Ring Subprocess package installed successfully!"
        ? "Starting the package..."
        system("ringpm run ringsubprocess")
        
    catch 
        ? nl + "! Error during installation:"
        ? cCatchError
	}
