@echo off
cls
color 0a
setlocal enabledelayedexpansion
echo ==================================================
echo        BORRADO INTERACTIVO DE PERFILES DE USUARIO
echo ==================================================
echo.
echo ** Nota: Este script requiere permisos de administrador. **
echo Buscando perfiles de usuario en C:\Users...
echo.

rem Recorre todas las carpetas de perfiles en C:\Users
for /d %%P in (C:\Users\*) do (
    set "PERFIL1A=%%~nxP"
    call :PROCESS_PERFIL1A
)

echo.
echo ==================================================
echo   PROCESO COMPLETADO. SE HA TERMINADO LA LIMPIEZA.
echo ==================================================
pause
exit /b

:PROCESS_PERFIL1A
rem Excluir perfiles protegidos (Administrador, Default, etc.)
if /i "%PERFIL1A%"=="Administrador" goto :SKIP
if /i "%PERFIL1A%"=="Default" goto :SKIP
if /i "%PERFIL1A%"=="Default User" goto :SKIP
if /i "%PERFIL1A%"=="Public" goto :SKIP
if /i "%PERFIL1A%"=="All Users" goto :SKIP
if /i "%PERFIL1A%"=="nx" goto :SKIP
if /i "%PERFIL1A%"=="presentacion" goto :SKIP



rem Preguntar al usuario si desea borrar el perfil
echo ===============================================
echo Perfil encontrado: %PERFIL1A%
choice /c SN /n /m "¿Deseas borrar este perfil? (S/N): "
if errorlevel 2 (
    echo Saltando el perfil %PERFIL1A%.
    goto :SKIP
)

rem Forzar cierre de sesión del usuario si está conectado
echo Cerrando sesión del usuario si está conectado...
logoff %PERFIL1A% >nul 2>&1

rem Eliminar carpeta de perfil
echo Eliminando carpeta del perfil...
rd /s /q "C:\Users\%PERFIL1A%"
if errorlevel 1 (
    echo Carpeta borrada
)

rem Eliminar entrada del registro para el perfil
echo Eliminando claves de registro asociadas al perfil...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /f /v "%PERFIL1A%" >nul 2>&1
if errorlevel 1 (
    echo Error al eliminar la clave de registro. Verifica manualmente.
) else (
    echo Clave de registro eliminada correctamente.
)

echo Perfil %PERFIL1A% eliminado satisfactoriamente.
goto :SKIP

:SKIP
echo.
endlocal
