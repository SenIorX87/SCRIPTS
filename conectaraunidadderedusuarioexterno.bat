@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
net use y: /user A3TV_MAD\jmolinagonzaold@atresmediacine.com "\\tifon\dptos$\Noticias y Entretenimiento\Area de Programas y Documentacion\Cine Español\" set /p PASSWORD="Contraseña: "

net use z: /user A3TV_MAD\jmolinagonzaold@atresmediacine.com "\\tifon\aptos$\Comunes\397- Financiero_A3films\" set /p PASSWORD="Contraseña: "

ENDLOCAL
pause