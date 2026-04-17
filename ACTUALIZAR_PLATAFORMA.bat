@echo off
title ACTUALIZAR PLATAFORMA PRINCESS
color 0A
echo.
echo ============================================
echo   PLATAFORMA PRINCESS - Central de Compras
echo ============================================
echo.

cd /d "D:\PLATAFORMA PRINCESS"

set ACTUALIZADO=0

:: hub.html
if exist "%USERPROFILE%\Downloads\hub.html" (
    copy "%USERPROFILE%\Downloads\hub.html" "hub.html" /Y
    echo OK: hub.html copiado
    set ACTUALIZADO=1
) else (
    echo --: hub.html no encontrado en Downloads
)

:: dosier.html
if exist "%USERPROFILE%\Downloads\dosier.html" (
    copy "%USERPROFILE%\Downloads\dosier.html" "dosier.html" /Y
    echo OK: dosier.html copiado
    set ACTUALIZADO=1
) else (
    echo --: dosier.html no encontrado en Downloads
)

:: fichas.html
if exist "%USERPROFILE%\Downloads\fichas.html" (
    copy "%USERPROFILE%\Downloads\fichas.html" "fichas.html" /Y
    echo OK: fichas.html copiado
    set ACTUALIZADO=1
) else (
    echo --: fichas.html no encontrado en Downloads
)

:: incidencias.html
if exist "%USERPROFILE%\Downloads\incidencias.html" (
    copy "%USERPROFILE%\Downloads\incidencias.html" "incidencias.html" /Y
    echo OK: incidencias.html copiado
    set ACTUALIZADO=1
) else (
    echo --: incidencias.html no encontrado en Downloads
)

:: admin.html
if exist "%USERPROFILE%\Downloads\admin.html" (
    copy "%USERPROFILE%\Downloads\admin.html" "admin.html" /Y
    echo OK: admin.html copiado
    set ACTUALIZADO=1
) else (
    echo --: admin.html no encontrado en Downloads
)

echo.

if %ACTUALIZADO%==0 (
    echo ERROR: No se encontro ningun fichero en Downloads
    echo Descarga primero los ficheros desde Claude
    echo.
    pause
    exit
)

:: Subir a GitHub
git add .
git commit -m "Actualizacion plataforma"
git push

echo.
if %ERRORLEVEL% == 0 (
    echo ============================================
    echo   OK - PLATAFORMA ACTUALIZADA EN GITHUB
    echo   Disponible en 1-2 minutos en:
    echo   centralcomprasprincesscanarias.github.io
    echo ============================================
) else (
    echo ERROR: No se pudo subir a GitHub
    echo Comprueba la conexion e intentalo de nuevo
)

echo.
pause
