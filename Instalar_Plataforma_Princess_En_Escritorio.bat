@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0Instalar_Plataforma_Princess_En_Escritorio.ps1"
if errorlevel 1 (
    echo.
    echo No se pudo crear el acceso directo.
    pause
    exit /b 1
)
echo.
echo OK. Se ha creado "Plataforma Princess" en el escritorio.
pause
