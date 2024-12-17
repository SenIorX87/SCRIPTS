@echo off
cls
color 0a
setlocal enabledelayedexpansion
echo Version 1.0
rem a continuacion este borra los archivos temporales del usuario local
echo eliminando archivos temporales del usuario
del /s /q "C:\Users\%USERNAME%\AppData\Local\Temp\*.*"
rem este borra temporales de la carpeta comun de windows
echo eliminando archivos temporales de la carpeta comun
del /s /q "C:\Windows\Temp\*.*"
rem este borra los archivos remanentes que han quedado tras las instalaciones de windows update
echo eliminando temporales de windows update
del /s /q "C:\Windows\SoftwareDistribution\Download\*.*"
rem este vacia la papelera de reciclaje
echo vaciando la papelera de reciclaje
rd /s /q C:\$Recycle.Bin
rem este borra la caché y applets instalados de java
echo limpiando java
del /s /q "C:\Users\%USERNAME%\AppData\LocalLow\sun\java\deployment\cache\*.*"
endlocal
rem y aqui meto un pause por si quereis leer detenidamente lo que ha hecho el script al finalizar
pause
