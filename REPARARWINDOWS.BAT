sfc /scannow
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
ECHO ******************************************
ECHO TRAS PULSAR TECLA SE REINICIARÁ EL SISTEMA
ECHO ******************************************
PAUSE
SHUTDOWN /R /T 0