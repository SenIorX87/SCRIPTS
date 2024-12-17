echo on
 
for /D %%d in ("C:\Users\*") do del "%%d"\"AppData\Local\Microsoft\Windows\Temporary Internet Files"\*.* /S /Q /F
for /D %%a in ("C:\Users\*") do for /D %%b in ("%%a"\"AppData\Local\Microsoft\Windows\Temporary Internet Files"\*) do rmdir "%%b" /S /Q
 
 
pause