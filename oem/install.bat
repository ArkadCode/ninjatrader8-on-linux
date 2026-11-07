@echo off
echo ===================================================
echo   NT8 Provisioning Script
echo ===================================================

:: 1. Esperar a que el sistema este listo
echo Esperando 15 segundos para que Windows se estabilice...
timeout /t 15 /nobreak

:: 1.5. Ajustar resolucion a 1920x1080 automaticamente (para el visor web)
echo Ajustando resolucion de pantalla a 1920x1080...
powershell -ExecutionPolicy Bypass -File "C:\OEM\setres.ps1"

:: 2. Instalar NinjaTrader 8 desde el archivo MSI local (ruta real dentro de Windows)
echo Instalando NinjaTrader 8 desde MSI local...
msiexec /i "C:\OEM\NinjaTrader.Install.Previous.msi" /quiet /norestart /log "C:\NT8_install.log"

:: 3. Esperar a que termine la instalacion
echo Esperando a que finalice la instalacion...
timeout /t 120 /nobreak

:: 4. Verificar si se instalo correctamente
if exist "C:\Program Files\NinjaTrader 8\bin\NinjaTrader.exe" (
    echo NinjaTrader 8 instalado correctamente!
    
    :: 5. Configurar inicio automatico de NT8 al arrancar Windows
    echo Configurando Autostart...
    powershell -Command "$wsh = New-Object -ComObject WScript.Shell; $s = $wsh.CreateShortcut('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\NinjaTrader.lnk'); $s.TargetPath = 'C:\Program Files\NinjaTrader 8\bin\NinjaTrader.exe'; $s.Save()"
) else (
    echo ERROR: NinjaTrader 8 no se encontro despues de la instalacion.
    echo Revisa el log en C:\NT8_install.log
    pause
)

echo ===================================================
echo   Proceso completado!
echo ===================================================
pause
