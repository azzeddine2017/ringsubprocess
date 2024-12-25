load "ziplib.ring"

func main
	? "Extracting File : ringsubprocess.zip and ringsubprocessdll.zip"
	cDir = CurrentDir()
	chdir(exefolder() + "../extensions")
	zip_extract_allfiles("ringsubprocess.zip","ringsubprocess")
	remove("ringsubprocess.zip")
	chdir(cDir)

	chdir(exefolder() + "../bin")
	zip_extract_allfiles("ringsubprocessdll.zip","bin")
	remove("ringsubprocessdll.zip")
	chdir(cDir)

	? "Ring Subprocess Extension has been installed successfully!"
	system("ringpm run ringsubprocess")