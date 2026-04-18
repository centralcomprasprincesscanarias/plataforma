@echo off
cd /d %~dp0

echo ============================
echo ACTUALIZANDO ASIGNACIONES
echo ============================

REM Ruta donde tienes los archivos (cámbiala si hace falta)
set ORIGEN=C:\Users\%USERNAME%\Downloads

REM Copiar archivos correctos
echo Copiando archivos...
copy "%ORIGEN%\asignaciones.html" ".\asignaciones.html" /Y
copy "%ORIGEN%\asignaciones.json" ".\asignaciones.json" /Y

REM Git
echo.
echo Subiendo a GitHub...

git add asignaciones.html
git add asignaciones.json

git commit -m "update asignaciones"
git push origin main

echo.
echo ============================
echo ✔ SUBIDO CORRECTAMENTE
echo ============================

pause
