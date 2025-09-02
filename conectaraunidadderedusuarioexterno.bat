@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM borramos letras conflictivas asignando las letras y las lineque no vayamos a usar las borramos :
net use Z: /delete
net use Y: /delete
net use X: /delete
net use W: /delete
net use V: /delete
REM net use Z: /delete


net use y: /user A3TV_MAD\ejemplo@correo.com "\\tifon\dptos$\" set /p PASSWORD="Contraseña: "

net use z: /user A3TV_MAD\ejemplo@correo.com "\\tifon\aptos$\" set /p PASSWORD="Contraseña: "

ENDLOCAL
pause