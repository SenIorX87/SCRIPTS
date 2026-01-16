@echo off
:: =========================================
:: Control de Windows Update (ON / OFF)
:: Ejecutar como ADMINISTRADOR
:: =========================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Este script debe ejecutarse como ADMINISTRADOR.
    pause
    exit /b
)

:MENU
cls
echo =========================================
echo   CONTROL DE WINDOWS UPDATE
echo =========================================
echo.
echo 1 - DESACTIVAR Windows Update
echo 2 - RESTAURAR Windows Update
echo 0 - SALIR
echo.
set /p opcion=Seleccione una opcion:

if "%opcion%"=="1" goto DESACTIVAR
if "%opcion%"=="2" goto RESTAURAR
if "%opcion%"=="0" exit
goto MENU

:DESACTIVAR
echo.
echo Desactivando servicios...
sc stop wuauserv >nul 2>&1
sc stop bits >nul 2>&1
sc stop usosvc >nul 2>&1
sc stop dosvc >nul 2>&1

sc config wuauserv start= disabled >nul
sc config bits start= disabled >nul
sc config usosvc start= disabled >nul
sc config dosvc start= disabled >nul

echo Aplicando politicas de grupo (registro)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul

gpupdate /force >nul 2>&1

echo.
echo Windows Update DESACTIVADO.
pause
goto MENU

:RESTAURAR
echo.
echo Restaurando servicios...
sc config wuauserv start= auto >nul
sc config bits start= delayed-auto >nul
sc config usosvc start= auto >nul
sc config dosvc start= auto >nul

sc start wuauserv >nul 2>&1
sc start bits >nul 2>&1

echo Eliminando politicas...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f >nul 2>&1

gpupdate /force >nul 2>&1

echo.
echo Windows Update RESTAURADO.
pause
goto MENU
