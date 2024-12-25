load "stdlib.ring"

func main
	? "Removing Folder : ring/extensions/subprocess"
	cDir = CurrentDir()
	chdir(exefolder()+"../extensions")
	OSDeleteFolder("subprocess")
	chdir(cDir)

	? "Removing dll : ring_subprocess.dll"
	chdir(exefolder()+"../bin")
	remove("ring_subprocess.dll")
	chdir(cDir)
	
	? "Removing  : load subprocess.ring"
	chdir(exefolder()+"../bin/load")
	remove("subprocess.ring")
	chdir(cDir)

