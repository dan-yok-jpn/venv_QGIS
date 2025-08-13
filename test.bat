@echo off
setlocal

if exist "%Programfiles%"\QGIS* (
    for /d %%i in ("%Programfiles%"\QGIS*) do (
        set OSGEO4W_ROOT=%%i
        goto :hasQGIS
    )
) else if exist C:\OSGeo4W (
    set OSGEO4W_ROOT=C:\OSGeo4W
    goto :hasQGIS
)
echo.
echo QGIS is not installed.
echo.
goto :eof

:hasQGIS
for /d %%i in ("%OSGEO4W_ROOT%"\apps\Python3*) do (
    set PYTHONHOME=%%i
    goto :hasPython
)
echo.
echo Your installed QGIS is too old. Let update QGIS.
echo.
goto :eof

:hasPython
set PATH=%OSGEO4W_ROOT%\bin;%WINDIR%\system32;%WINDIR%;%WINDIR%\system32\WBem

echo.
python test.py %*
