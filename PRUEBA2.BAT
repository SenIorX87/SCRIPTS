echo Borrando la caché de Teams para todos los usuarios.

for /D %%u in ("C:\Users\*") do (
    set "TEAMSDIR=%%u\AppData\Roaming\Microsoft\Teams"
    if exist "!TEAMSDIR!" (
        echo Procesando usuario %%u...
        del /s /q "!TEAMSDIR!\blob_storage\*"
        for /f %%a in ('dir /B "!TEAMSDIR!\blob_storage" 2^>nul') do RD /s /q "!TEAMSDIR!\blob_storage\%%a"
        
        del /s /q "!TEAMSDIR!\Cache\*"
        for /f %%a in ('dir /B "!TEAMSDIR!\Cache" 2^>nul') do RD /s /q "!TEAMSDIR!\Cache\%%a"
        
        del /s /q "!TEAMSDIR!\databases\*"
        for /f %%a in ('dir /B "!TEAMSDIR!\databases" 2^>nul') do RD /s /q "!TEAMSDIR!\databases\%%a"
        
        del /s /q "!TEAMSDIR!\GPUCache\*"
        for /f %%a in ('dir /B "!TEAMSDIR!\GPUCache" 2^>nul') do RD /s /q "!TEAMSDIR!\GPUCache\%%a"
        
        del /s /q "!TEAMSDIR!\IndexedDB\*"
        for /f %%a in ('dir /B "!TEAMSDIR!\IndexedDB" 2^>nul') do RD /s /q "!TEAMSDIR!\IndexedDB\%%a"
        
        del /s /q "!TEAMSDIR!\tmp\*"
        for /f %%a in ('dir /B "!TEAMSDIR!\tmp" 2^>nul') do RD /s /q "!TEAMSDIR!\tmp\%%a"
        
        del /s /q "!TEAMSDIR!\Code Cache\*"
        for /f %%a in ('dir /B "!TEAMSDIR!\Code Cache" 2^>nul') do RD /s /q "!TEAMSDIR!\Code Cache\%%a"
        
        del /s /q "!TEAMSDIR!\Local Storage\*"
        for /f %%a in ('dir /B "!TEAMSDIR!\Local Storage" 2^>nul') do RD /s /q "!TEAMSDIR!\Local Storage\%%a"
    ) else (
        echo Carpeta de Teams no encontrada para usuario %%u.
    )
)
