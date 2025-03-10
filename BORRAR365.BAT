@echo off
cls
echo Eliminando archivos y carpetas de Office 365...
echo.

:: Detener procesos relacionados con Office
taskkill /f /im winword.exe
taskkill /f /im excel.exe
taskkill /f /im powerpnt.exe
taskkill /f /im outlook.exe
taskkill /f /im onenote.exe
taskkill /f /im lync.exe
taskkill /f /im teams.exe
taskkill /f /im msoia.exe
taskkill /f /im msosync.exe
taskkill /f /im officeclicktorun.exe

:: Esperar unos segundos para asegurarse de que los procesos se cierran
timeout /t 5 /nobreak

:: Eliminar carpetas de instalación de Office
rd /s /q "C:\Program Files\Microsoft Office"
rd /s /q "C:\Program Files (x86)\Microsoft Office"
rd /s /q "C:\ProgramData\Microsoft\Office"

:: Eliminar carpetas del usuario relacionadas con Office
rd /s /q "%APPDATA%\Microsoft\Office"
rd /s /q "%LOCALAPPDATA%\Microsoft\Office"
rd /s /q "%LOCALAPPDATA%\Microsoft\OneDrive"
rd /s /q "%LOCALAPPDATA%\Microsoft\Teams"
rd /s /q "%LOCALAPPDATA%\Microsoft\Outlook"
rd /s /q "%USERPROFILE%\Documents\Archivos de Outlook"
rd /s /q "%USERPROFILE%\Documents\OneNote Notebooks"

:: Eliminar claves del Registro relacionadas con Office
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Office" /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Office" /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\OneDrive" /f
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Teams" /f

echo.
echo Eliminación completada. Es recomendable reiniciar el equipo.
pause
exit
