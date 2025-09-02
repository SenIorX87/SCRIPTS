@echo off
cls
color 0a
setlocal enabledelayedexpansion
:::    _       _       _    _____   ___  _   _    _       _       _    
::: /\| |/\ /\| |/\ /\| |/\/  __ \ / _ \| | | |/\| |/\ /\| |/\ /\| |/\ 
::: \ ` ' / \ ` ' / \ ` ' /| /  \// /_\ \ | | |\ ` ' / \ ` ' / \ ` ' / 
:::|_     _|_     _|_     _| |    |  _  | | | |_     _|_     _|_     _|
::: / , . \ / , . \ / , . \| \__/\| | | | |_| |/ , . \ / , . \ / , . \ 
::: \/|_|\/ \/|_|\/ \/|_|\/ \____/\_| |_/\___/ \/|_|\/ \/|_|\/ \/|_|\/ 
:::    ___ ___________ _____ ________  ___ ___________ _____  ___      
:::   / _ \_   _| ___ \  ___/  ___|  \/  ||  ___|  _  \_   _|/ _ \     
:::  / /_\ \| | | |_/ / |__ \ `--.| .  . || |__ | | | | | | / /_\ \    
:::  |  _  || | |    /|  __| `--. \ |\/| ||  __|| | | | | | |  _  |    
::: _| | | || | | |\ \| |___/\__/ / |  | || |___| |/ / _| |_| | | |_   
:::(_)_| |_/\_/ \_| \_\____/\____/\_|  |_/\____/|___/  \___/\_| |_(_)  
                                                                    
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo %%A
chcp 65001
rem **********************************************************************************************
echo Edición 2.3
rem **********************************************************************************************
rem Histórico de cambios:
rem *** Edición 1.x ***
rem ·Borrado de carpetas temporales de usuario, Windows, WSUS, Papelera, Java, Teams, Outlook, Edge y borra la caché del resolutor de DNS.
rem *** Edición 2.0 ***
rem Mediante la introducción de una variable "USUARIOA3M" se pide el usuario para que todos los borrados a nivel de usuario se puedan enfocar sin esfuerzo sobre él.
rem ·Búsqueda de carpetas de "usuario.NOMBREDOMINIO" para saber si se ha regenerado el perfil de usuario y notificación de la misma.
rem ·Borrados más efectivos y precisos que en los programas de la 1.0 gracias a un enfoque más directo en carpetas concretas.
rem ·Corregido el fallo que no limpiaba todo el navegador.
rem ·Se fuerza el cierre de procesos de los programas para evitar borrados a medias.
rem *** Edición 2.1 ***
rem ·Se mata proceso y se borra cola de impresión para prevenir acumulación de documentos en impresoras no operativas.
rem ·Se añade la carpeta de temporales del CCM a la lista de elementos a borrar.
rem ·Se aplica una actualización de todas las políticas de grupo.
rem *** Edición 2.2 ***09/07/24
rem ·Se añade una comprobación para asegurarse de que se está ejecutando en modo administrador. Gracias a J. M. Lobo.
rem ·Se añade la etiqueta ":fin" para que cuando no se ejecute en modo Administrador, no se proporcione un usuario o este no exista finalice dirigiéndose al final del script.
rem ·Se modifica la asignación de variable "path" por "TEAMSDIR"
rem ·Se añade el proceso ms-teams.exe a los procesos que terminar antes de la limpieza ya que algunos ordenadores lo presentan en vez de teams.exe (¿probable new-Teams?)
rem ·Se renombran carpetas de políticas de grupo antes del gpupdate para asegurarse la actualización de estas. Gracias a J. M. Lobo.
rem ·Se añade un reinicio al finalizar el script para completar el proceso de limpieza satisfactoriamente.
rem *** Edición 2.3 ***
rem ·Se detienen servicios relacionados con actualizaciones de windows antes de la limpieza
rem ·Se añade catroot2 a la lista de carpetas que limpiar
rem ·Cambiado el formato de limpieza de temporales de Edge de un usuario concreto a todos los que existan
rem ·Añadidos más procesos relacionados con el navegador Edge para conseguir mejores resultados en la limpieza
rem ·Añadido Google Chrome a la lista de limpieza para todos los usuarios
rem ·Añadido Mozilla Firefox a la lista de limpieza para todos los usuarios
rem ·Se detiene y se reinicia el servicio de cola de impresión durante la limpieza para aumentar efectividad y descartar más errores
rem ·Las carpetas de temp locales y Windows vacías no se estaban borrando. Corregido.
rem ·Añadido directorio HubAppFileCache a la lista de directorios a vaciar en el bloque de limpieza de outlook



echo **********************************************************************************************
echo ****ASEGÚRATE QUE LA CUENTA DEL USUARIO EN EDGE ESTÁ SINCRONIZADA ANTES PARA QUE NO PIERDA****
echo *SUS FAVORITOS, SI NO ES ASÍ, PULSA AHORA Ctrl+C PARA INTERRUMPIR LA EJECUCIÓN DE ESTE SCRIPT*
echo **********************************************************************************************


:: ================================================================================================
:: BLOQUE COMPROBACION ADMIN
:: ================================================================================================
rem ejecuta net session y redirige los errores a nul
net session >nul 2>&1
rem comprueba el codigo de error, si es 0 es admin, si es cualquier otro valor, no lo es.
if %errorlevel%==0 (
    echo Estás en modo Administrador. TODO OK.
) else (
    color 04
    cls
    echo NO ESTÁS EN MODO ADMINISTRADOR, FINALIZANDO.
    goto :fin
)


:: ================================================================================================
:: BLOQUE COMPROBACION USUARIO
:: ================================================================================================
rem Pregunta el nombre del usuario sobre el que se realiza la limpieza y le asigna la variable USUARIOA3M
set /p USUARIOA3M=Introduce el nombre de usuario sobre el que vas a hacer limpieza: 
    if "%USUARIOA3M%"=="" (
        echo No has introducido ningún valor, finalizando.
            goto :fin
            ) else (
rem Verifica si existe la carpeta en C:\Users\
        if exist "C:\Users\%USUARIOA3M%" (
            echo La carpeta de usuario "%USUARIOA3M%" existe.
rem Verifica si existe el usuario "%USUARIOA3M%.NOMBREDOMINIO" ya que si hubo problemas de corrupción de datos del perfil se genera sola con los datos antiguos (conviene borrar tras rescatar)
    if exist "C:\Users\%USUARIOA3M%.*" (
        echo EXISTE UN USUARIO "%USUARIOA3M%.*" si quieres que la limpieza se ejecute sobre este perfil interrumpe el script con Ctrl+C y reintroduce el usuario así: "%USUARIOA3M%.NOMBREDOMINIO"
        pause
            ) else (
        echo El usuario existe, todo OK.
        )
            ) else (
        echo La carpeta de usuario "%USUARIOA3M%" no existe, finalizando.
            goto :fin
            )
            )



rem **********************************************************************************************
rem *****************************EN PROCESO DE CONVERTIRLO EN REMOTO******************************
rem **********************************************************************************************
rem if "%1"=="" goto :sintaxis
rem set MAQUINA=%1
rem robocopy /s /copy:dt /mt /w:1 /r:1 c:\Datos\TMPREM.BAT "\\NOMBREDELEQUIPO\C$\DATOS"
rem psexec -h -u NOMBREDOMINIO\USERRESIDENTE \\%1\DATOS\TMPREM.BAT 



:: ================================================================================================
:: BLOQUE LIMPIEZA TEMPORALES Y WINDOWS UPDATE
:: ================================================================================================
REM Detener servicios para limpieza más profunda y sin interferencias
net stop wuauserv
net stop BITS
net stop cryptSvc
net stop msiserver
net stop WSService


rem Limpieza de la carpeta Temp para cada usuario en C:\Users
echo Limpiando archivos temporales de cada usuario.
    for /D %%u in ("C:\Users\*") do (
        del "%%u\AppData\Local\Temp\*.*" /S /Q >nul 2>&1
)

rem Eliminación de carpetas vacías dentro de Temp
echo Eliminando carpetas vacías en las carpetas Temp.
    for /D %%u in ("C:\Users\*") do (
        for /D %%t in ("%%u\AppData\Local\Temp\*") do (
            rmdir "%%t" /S /Q >nul 2>&1
            if exist "%%t" echo No se pudo eliminar la carpeta: %%t
    )
)



rem Borrar archivos temporales de la carpeta global Temp
echo Eliminando archivos temporales en C:\Windows\Temp.
    del /s /q "C:\Windows\Temp\*.*" >nul 2>&1

rem Eliminación de carpetas vacías dentro de C:\Windows\Temp
echo Eliminando carpetas vacías en C:\Windows\Temp.
    for /D %%t in ("C:\Windows\Temp\*") do (
        rmdir "%%t" /S /Q >nul 2>&1
        if exist "%%t" echo No se pudo eliminar la carpeta: %%t
)


REM Esperar 10 segundos antes de renombrar y borrar carpetas
echo Esperando 1 segundo antes de renombrar y borrar carpetas asociadas a Windows Update...
timeout /t 1 /nobreak

REM Renombrar y borrar carpetas asociadas a Actualizaciones de windows
echo Renombrando y borrando carpetas asociadas a Windows Update...
if exist C:\Windows\SoftwareDistribution (
    rename C:\Windows\SoftwareDistribution SoftwareDistribution.oldFolder
    rd /s /q C:\Windows\SoftwareDistribution.oldFolder
)
if exist C:\Windows\System32\catroot2 (
    rename C:\Windows\System32\catroot2 catroot2.oldFolder
    rd /s /q C:\Windows\System32\catroot2.oldFolder
)

REM Iniciar servicios
net start wuauserv
net start BITS
net start cryptSvc
net start msiserver
net start WSService

rem Borrar archivos de la Papelera de Reciclaje
    echo Borrando archivos de la Papelera de Reciclaje.
        rd /s /q C:\$recycle.bin
rem Borrar archivos temporales de Java
    echo Eliminando archivos temporales de Java.
        del /s /q "C:\Users\%USUARIOA3M%\AppData\LocalLow\sun\java\deployment\cache\*.*"
rem Borrar cache de CCM o "centro de software"
    echo Borrando caché de CCM.
        del /s /q "C:\Windows\CCM\Temp\*.*"

rem Borrar cache de TEAMS
    echo Comprobando que tenga cerrado Microsoft Teams y cerrándolo...
        taskkill /f /im teams.exe
        taskkill /f /im ms-teams.exe
            timeout /t 2 /nobreak
echo Borrando la caché de Teams.
    set TEAMSDIR=C:\Users\%USUARIOA3M%\AppData\Roaming\Microsoft\Teams
        del /s /q %TEAMSDIR%\blob_storage\*
            for /f %%a in ('dir /B %TEAMSDIR%\blob_storage') do RD /s /q "%TEAMSDIR%\blob_storage\%%a"
        del /s /q %TEAMSDIR%\Cache\*
            for /f %%a in ('dir /B %TEAMSDIR%\Cache') do RD /s /q "%TEAMSDIR%\Cache\%%a"
        del /s /q %TEAMSDIR%\databases\*
            for /f %%a in ('dir /B %TEAMSDIR%\databases') do RD /s /q "%TEAMSDIR%\databases\%%a"
        del /s /q %TEAMSDIR%\GPUCache\*
            for /f %%a in ('dir /B %TEAMSDIR%\GPUCache') do RD /s /q "%TEAMSDIR%\GPUCache\%%a"
        del /s /q %TEAMSDIR%\IndexedDB\*
            for /f %%a in ('dir /B %TEAMSDIR%\IndexedDB') do RD /s /q "%TEAMSDIR%\IndexedDB\%%a"
        del /s /q %TEAMSDIR%\tmp\*
            for /f %%a in ('dir /B %TEAMSDIR%\tmp') do RD /s /q "%TEAMSDIR%\tmp\%%a"
        del /s /q "%TEAMSDIR%\Code Cache\*"
            for /f %%a in ('dir /B "%TEAMSDIR%\Code Cache"') do RD /s /q "%TEAMSDIR%\Code Cache\%%a"
        del /s /q "%TEAMSDIR%\Local Storage\*"
            for /f %%a in ('dir /B "%TEAMSDIR%\Local Storage"') do RD /s /q "%TEAMSDIR%\Local Storage\%%a"

rem Borrar caché y temporales de Microsoft Edge
    echo Comprobando que tenga cerrado Microsoft Edge y procesos relacionados.
        taskkill /f /im msedge.exe
        taskkill /f /im msedgewebview2.exe
        taskkill /f /im msedgeupdate.exe
        taskkill /f /im runtimebroker.exe
        taskkill /f /im smartscreen.exe

            timeout /t 2 /nobreak
echo Borrando caché y temporales de Microsoft Edge.
    for /D %%d in ("C:\Users\*") do del "%%d\AppData\Local\Microsoft\Edge\User Data\Default\*.*" /S /Q
    for /D %%d in ("C:\Users\*") do del "%%d"\"AppData\Local\Microsoft\Windows\Temporary Internet Files"\*.* /S /Q /F
    for /D %%a in ("C:\Users\*") do for /D %%b in ("%%a"\"AppData\Local\Microsoft\Windows\Temporary Internet Files"\*) do rmdir "%%b" /S /Q

rem Borrar caché y temporales de Chrome
    echo comprobando que tenga cerrado Google Chrome y procesos relacionados.
        taskkill /f /im chrome.exe
        taskkill /f /im GoogleCrashHandler.exe
        taskkill /f /im GoogleCrashHandler64.exe
        taskkill /f /im GoogleUpdate.exe
            timeout /t 2 /nobreak
echo Borrando caché y temporales de Chrome
    for /D %%d in ("C:\Users\*") do del "%%d"\"AppData\Local\Google\Chrome\User Data\Default\Cache"\*.* /S /Q /F
    for /D %%a in ("C:\Users\*") do for /D %%b in ("%%a"\"AppData\Local\Google\Chrome\User Data\Default\Cache"\*) do rmdir "%%b" /S /Q
    for /D %%d in ("C:\Users\*") do del "%%d"\"AppData\Local\Google\Chrome\User Data\Default\Media Cache"\*.* /S /Q /F
    for /D %%a in ("C:\Users\*") do for /D %%b in ("%%a"\"AppData\Local\Google\Chrome\User Data\Default\Media Cache"\*) do rmdir "%%b" /S /Q

rem Borrar caché y temporales de Firefox
    echo Comprobando que tenga cerrado Firefox y procesos relacionados
        taskkill /f /im firefox.exe
        taskkill /f /im plugin-container.exe
        taskkill /f /im updater.exe
        taskkill /f /im crashreporter.exe
        taskkill /f /im firefoxCP.exe
            timeout /t 2 /nobreak
echo Borrando caché y temporales de Firefox
    for /D %%d in ("C:\Users\*") do del "%%d"\"AppData\Local\Mozilla\Firefox\Profiles"\*.* /S /Q /F
    for /D %%a in ("C:\Users\*") do for /D %%b in ("%%a"\"AppData\Local\Mozilla\Firefox\Profiles"\*) do rmdir "%%b" /S /Q


rem Cierra Outlook si esta abierto
    echo Comprobando que tenga cerrado Outlook.
        taskkill /f /im outlook.exe
            timeout /t 2 /nobreak
rem Elimina los archivos de caché de Outlook.
    del /f /q "C:\Users\%USUARIOA3M%\AppData\Local\Microsoft\Outlook\*.ost"
rem Elimina los archivos de caché de búsqueda de Outlook.
    del /f /q "C:\Users\%USUARIOA3M%\AppData\Local\Microsoft\Outlook\*.oab"
rem Borrar archivos temporales de la carpeta HubAppFileCache
    echo Eliminando archivos temporales en HubAppFileCache
        del /s /q "%USUARIOA3M%\AppData\Local\Microsoft\Outlook\HubAppFileCache\*.*"
rem Eliminación de carpetas vacías dentro de HubAppFileCache
    echo Eliminando carpetas vacías en HubAppFileCache
        for /D %%t in ("%USUARIOA3M%\AppData\Local\Microsoft\Outlook\HubAppFileCache\*") do (
            rmdir "%%t" /S /Q >nul
            if exist "%%t" echo No se pudo eliminar la carpeta: %%t
        )

rem Detener el servicio de Cola de Impresión
    sc stop Spooler
        timeout /t 2 /nobreak
rem Matar proceso asociado a cola de impresión.
    taskkill -im printisolationhost.exe -f
        timeout /t 2 /nobreak
rem Eliminar archivos de la carpeta de cola de impresión
    echo Eliminando archivos de la carpeta de cola de impresión para evitar duplicados y saturación de la misma.
        del /q /f /s "%systemroot%\System32\spool\PRINTERS\*.*"
rem Iniciar el servicio de Cola de Impresión
    sc start Spooler
        echo Servicio de Cola de Impresión reiniciado correctamente.


rem borra la cache del resolutor de DNS
    echo Borrando caché DNS.
        ipconfig /flushdns
echo DNS LIMPIADAS.




REM Cambiar al directorio donde están las carpetas
cd /d C:\Windows\System32\GroupPolicy
REM Verificar si el cambio de directorio tuvo éxito
if errorlevel 1 (
    echo No se pudo acceder al directorio C:\Windows\System32\GroupPolicy
    pause
    exit /b 1
)
for /d %%f in (*) do (
  if "!%%f:~-4!"==".old" (
    rd "%%f" /Q
  )
)
echo Se han eliminado todas las carpetas que terminan en ".old" en este directorio.
REM Renombrar cada carpeta añadiendo .old al final
for /d %%f in (*) do (
    ren "%%f" "%%f.old"
)
REM Verificar si el comando de renombrado tuvo éxito
if %errorlevel%==0 (
    echo Todas las carpetas se han renombrado correctamente.
) else (
    echo Hubo un error al renombrar las carpetas.
)
rem actualizacion de todas las politicas de grupo
    echo Actualizando políticas de grupo.
        gpupdate /force



echo **********************************************************************************************
echo *************RECUERDA VOLVER A LOGAR AL USUARIO EN EDGE Y SINCRONIZAR SU CUENTA***************
echo **********************************************************************************************
echo Herramienta creada por Raúl Gómez Vázquez Para Residentes del grupo UNICAJA Y el CAU de ATRESMEDIA
echo Especial agradecimiento a J. M. Lobo por su gran ayuda aportando ideas y consejos constantemente.
echo Mención honorífica a Santiago M. L. Por darme la idea para mejorar este script.
echo COMÉNTAME POR TEAMS DÓNDE NECESITA MEJORAR O QUÉ LE FALTA, ESTOY ABIERTO A CRÍTICAS.
echo Mejor hacer algo imperfecto que no hacer nada sin fallo alguno. Robert Schuller.
pause




rem Usamos el comando choice para dar a escoger cuando reiniciar. Dado que debería tener todo cerrado para la limpieza el reinicio no se demora. He dejado una opción de espera de 3 minutos para excepciones.
choice /c 123 /n /t 20 /d 1 /m "Pulse un número: 1 Reiniciar ya, 2 Reiniciar en 3 minutos, No seleccionar una opción reiniciará el equipo en 20 segundos"
  if "%errorlevel%"=="1" goto :op1
  if "%errorlevel%"=="2" goto :op2
  if "%errorlevel%"=="3" goto :fin
  
:op1
  echo opcion uno
    endlocal
        shutdown /r /f /t 0

:op2
  echo opcion dos
    endlocal
        shutdown /r /f /t 180
            goto :fin




:fin
endlocal