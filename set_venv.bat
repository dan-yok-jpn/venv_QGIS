@echo off
setlocal

if exist .venv (
    echo.
    echo Virtual environment was set already.
    goto :eof
)

set option=/b
if not "%1"=="" (set option=)

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
exit %option% 1

:hasQGIS
for /d %%i in ("%OSGEO4W_ROOT%"\apps\Python3*) do (
    set PYTHONHOME=%%i
    goto :hasPython
)
echo.
echo Your installed QGIS is too old. Let update QGIS.
echo.
exit %option% 1

:hasPython

> tmp.bat (
    echo.@echo off
    echo."%PYTHONHOME%\python" -m venv --system-site-packages ^^
    echo.--symlinks --without-pip --clear .venv
) 
powershell Start-Process tmp.bat -Verb runas -Wait

mkdir .vscode
> .vscode\settings.json (
    echo.{
    echo."python.defaultInterpreterPath": ".venv\\Scripts\\python.exe",
    echo."python.terminal.activateEnvironment": true
    echo.}
)

if "%1"=="" (
    if exist requirements.txt (
        call .venv\Scripts\activate.bat
        python -m pip install -r requirements.txt 2>nul
        call .venv\Scripts\deactivate.bat
    )
)

del tmp.bat