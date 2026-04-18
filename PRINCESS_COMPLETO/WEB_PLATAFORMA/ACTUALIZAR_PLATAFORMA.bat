@echo off
title ACTUALIZAR PLATAFORMA PRINCESS
color 0A
echo.
echo ============================================
echo   PLATAFORMA PRINCESS - Central de Compras
echo ============================================
echo.
cd /d "D:\PLATAFORMA PRINCESS"
set ORIGEN=%USERPROFILE%\Downloads
set ACTUALIZADO=0
for %%f in (hub.html dosier.html fichas.html incidencias.html asignaciones.html asignaciones.json admin.html) do (
    if exist "%ORIGEN%\%%f" (
        xcopy /Y /Q "%ORIGEN%\%%f" "." & echo OK: %%f & set ACTUALIZADO=1
    ) else ( echo --: %%f no en Downloads )
)
if %ACTUALIZADO%==0 (
    echo ERROR: Sin ficheros en Downloads & pause & exit
)
git add . & git commit -m "Actualizacion plataforma %date%" & git push origin main
echo.
if %ERRORLEVEL%==0 (
    echo ============================================
    echo   OK - Disponible en 1-2 min en GitHub Pages
    echo ============================================
) else ( echo ERROR al subir a GitHub )
pause
