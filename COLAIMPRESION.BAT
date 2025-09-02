@echo off
setlocal enabledelayedexpansion
rem Detener el servicio de Cola de Impresión
sc stop Spooler
timeout /t 2 /nobreak

rem Forzar el cierre del proceso printisolationhost.exe
taskkill -im printisolationhost.exe -f
timeout /t 2 /nobreak

rem Eliminar archivos de la carpeta de cola de impresión
echo Eliminando archivos de la carpeta de cola de impresión para evitar duplicados y saturación de la misma.
del /q /f /s "%systemroot%\System32\spool\PRINTERS\*.*"

timeout /t 2 /nobreak

rem Iniciar el servicio de Cola de Impresión
sc start Spooler
echo Servicio de Cola de Impresión reiniciado correctamente.
endlocal