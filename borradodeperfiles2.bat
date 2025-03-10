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
endlocal
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

rem Intentar cerrar sesión del usuario si está conectado
echo Cerrando sesión del usuario si está conectado...
set "sessionID="
for /f "tokens=3" %%i in ('query user %PERFIL1A% 2^>nul') do (
    set "sessionID=%%i"
)
if defined sessionID (
    logoff %sessionID% >nul 2>&1
    echo Sesión cerrada para el usuario %PERFIL1A%.
) else (
    echo No se encontró sesión activa para el usuario %PERFIL1A% o error al obtener ID.
)

rem Eliminar carpeta de perfil
echo Eliminando carpeta del perfil...
rd /s /q "C:\Users\%PERFIL1A%"
if errorlevel 1 (
    echo Error al borrar la carpeta.
) else (
    echo Carpeta borrada correctamente.
)

rem Obtener el SID del usuario
set "SID="
for /f "tokens=2 delims==" %%a in ('wmic path win32_userprofile where "localpath='C:\\Users\\%PERFIL1A%'" get sid /value 2^>nul') do (
    set "SID=%%a"
)

rem Si no se pudo obtener el SID, mostrar error y saltar
if not defined SID (
    echo No se pudo obtener el SID del usuario %PERFIL1A%. Verifica manualmente en el registro.
    goto :SKIP
)

echo SID obtenido: %SID%
echo Eliminando claves de registro asociadas al perfil...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\%SID%" /f >nul 2>&1
if errorlevel 1 (
    echo Error al eliminar la clave de registro. Verifica manualmente.
) else (
    echo Clave de registro eliminada correctamente.
)

echo Perfil %PERFIL1A% eliminado satisfactoriamente.
:SKIP
echo.
goto :eof
