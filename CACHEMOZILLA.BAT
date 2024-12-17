echo on
 
for /D %%d in ("C:\Users\*") do del "%%d"\"AppData\Local\Mozilla\Firefox\Profiles"\*.* /S /Q /F
for /D %%a in ("C:\Users\*") do for /D %%b in ("%%a"\"AppData\Local\Mozilla\Firefox\Profiles"\*) do rmdir "%%b" /S /Q
pause