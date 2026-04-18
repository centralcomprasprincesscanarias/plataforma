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
    xcopy /Y /Q "%USERPROFILE%\Downloads\hub.html" "D:\PLATAFORMA PRINCESS\"
    echo OK: hub.html copiado
    set ACTUALIZADO=1
) else (
    echo --: hub.html no encontrado en Downloads
)

:: dosier.html
if exist "%USERPROFILE%\Downloads\dosier.html" (
    xcopy /Y /Q "%USERPROFILE%\Downloads\dosier.html" "D:\PLATAFORMA PRINCESS\"
    echo OK: dosier.html copiado
    set ACTUALIZADO=1
) else (
    echo --: dosier.html no encontrado en Downloads
)

:: fichas.html
if exist "%USERPROFILE%\Downloads\fichas.html" (
    xcopy /Y /Q "%USERPROFILE%\Downloads\fichas.html" "D:\PLATAFORMA PRINCESS\"
    echo OK: fichas.html copiado
    set ACTUALIZADO=1
) else (
    echo --: fichas.html no encontrado en Downloads
)

:: incidencias.html
if exist "%USERPROFILE%\Downloads\incidencias.html" (
    xcopy /Y /Q "%USERPROFILE%\Downloads\incidencias.html" "D:\PLATAFORMA PRINCESS\"
    echo OK: incidencias.html copiado
    set ACTUALIZADO=1
) else (
    echo --: incidencias.html no encontrado en Downloads
)

:: admin.html
if exist "%USERPROFILE%\Downloads\admin.html" (
    xcopy /Y /Q "%USERPROFILE%\Downloads\admin.html" "D:\PLATAFORMA PRINCESS\"
    echo OK: admin.html copiado
    set ACTUALIZADO=1
) else (
    echo --: admin.html no encontrado en Downloads
)

:: asignaciones.html
if exist "%USERPROFILE%\Downloads\asignaciones.html" (
    xcopy /Y /Q "%USERPROFILE%\Downloads\asignaciones.html" "D:\PLATAFORMA PRINCESS\"
    echo OK: asignaciones.html copiado
    set ACTUALIZADO=1
) else (
    echo --: asignaciones.html no encontrado en Downloads
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
echo ============================================
echo   OK - PLATAFORMA ACTUALIZADA EN GITHUB
echo   Disponible en 1-2 minutos en:
echo   centralcomprasprincesscanarias.github.io
echo ============================================

echo.
pause
