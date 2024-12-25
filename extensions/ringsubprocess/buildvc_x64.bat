cls
setlocal enableextensions enabledelayedexpansion
call ../../language/build/locatevc.bat x64
cl /c /DEBUG ring_subprocess.c -I"..\..\language\include"
link /DEBUG ring_subprocess.obj  ..\..\lib\ring.lib Shell32.lib /DLL /OUT:..\..\bin\ring_subprocess.dll
del ring_subprocess.obj
endlocal
