@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM borramos letras conflictivas asignando las letras y las lineque no vayamos a usar las borramos :
net use Z: /delete
net use Y: /delete
net use X: /delete
net use W: /delete
net use V: /delete
REM net use Z: /delete


net use y: /user A3TV_MAD\jmolinagonzaold@atresmediacine.com "\\tifon\dptos$\Noticias y Entretenimiento\Area de Programas y Documentacion\Cine Español\" set /p PASSWORD="Contraseña: "

net use z: /user A3TV_MAD\jmolinagonzaold@atresmediacine.com "\\tifon\aptos$\Comunes\397- Financiero_A3films\" set /p PASSWORD="Contraseña: "

ENDLOCAL
pause