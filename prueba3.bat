rem Pregunta al usuario si desea realizar la limpieza del Prefetch
@echo off
echo ¿Deseas realizar una limpieza en la carpeta Prefetch? Si no respondes en 10 minutos, se realizará para archivos más antiguos de 120 días.
echo Responde con "S" para limpiar, "N" para omitir, o un número para indicar los días de antigüedad (por ejemplo, 90).
echo Tiempo límite: 10 minutos.

rem Establece el tiempo límite (600 segundos = 10 minutos)
set /p LIMPIAR_PREFETCH=Introduce tu respuesta (S/N/días): | timeout /t 600 /nobreak >nul && set LIMPIAR_PREFETCH=120

rem Validación de entrada
if /i "%LIMPIAR_PREFETCH%"=="N" (
    echo Limpieza de Prefetch cancelada por el usuario.
    goto :SKIP_PREFETCH
) else if /i "%LIMPIAR_PREFETCH%"=="S" (
    set DIAS=120
) else (
    set /a DIAS=%LIMPIAR_PREFETCH%
    if %DIAS% lss 1 (
        echo Entrada no válida. Usando valor por defecto: 120 días.
        set DIAS=120
    )
)

rem Limpieza de Prefetch según la antigüedad indicada
echo Limpiando archivos antiguos de Prefetch (más antiguos de %DIAS% días)...
forfiles /p "C:\Windows\Prefetch" /m *.pf /d -%DIAS% /c "cmd /c del @path >nul 2>&1"

if %errorlevel% equ 0 (
    echo Limpieza de Prefetch completada. Archivos más antiguos de %DIAS% días han sido eliminados.
) else (
    echo No se encontraron archivos antiguos o hubo un error en la limpieza.
)

:SKIP_PREFETCH
rem Continuar con el resto del script
echo Continuando con la limpieza general...
