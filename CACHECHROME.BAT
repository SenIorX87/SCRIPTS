@echo off

REM Lo de arriba desactiva eco para mantener el script limpio
REM este habilita el uso de variables
setlocal enabledelayedexpansion

REM Variables para mejorar la legibilidad
set "chromeCachePath=AppData\Local\Google\Chrome\User Data\Default\Cache"
set "mediaCachePath=AppData\Local\Google\Chrome\User Data\Default\Media Cache"
echo Limpiando la caché de Google Chrome...

REM Recorrer todos los usuarios en la carpeta C:\Users
for /D %%d in ("C:\Users\*") do (

REM Verificar si las carpetas de caché existen antes de intentar eliminarlas
    if exist "%%d\%chromeCachePath%" (
echo Eliminando archivos de caché en: %%d\%chromeCachePath%
        del /S /Q /F "%%d\%chromeCachePath%\*.*"
        for /D %%b in ("%%d\%chromeCachePath%\*") do (
            rmdir /S /Q "%%b"
        )
    )
    if exist "%%d\%mediaCachePath%" (
echo Eliminando archivos de Media Cache en: %%d\%mediaCachePath%
        del /S /Q /F "%%d\%mediaCachePath%\*.*"
        for /D %%b in ("%%d\%mediaCachePath%\*") do (
            rmdir /S /Q "%%b"
        )
    )
)

echo Proceso completado.
endlocal
pause
