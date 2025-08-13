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

call :genBat > tmp.bat
powershell Start-Process tmp.bat -Verb runas -Wait
del tmp.bat

mkdir .vscode
call :genJson > .vscode\settings.json

if "%1"=="" (
    if exist requirements.txt (
        call .venv\Scripts\activate.bat
        @REM python -m pip install --upgrade pip
        python -m pip install -r requirements.txt 2>nul
        call .venv\Scripts\deactivate.bat
    )
)
goto :eof

:genBat
    echo @echo off
    echo cd "%~dp0"
    echo echo.
    echo echo #############################################################
    echo echo ## Now Create a Virtual Environment. Please Wait a Minute. ##
    echo echo #############################################################
    echo "%PYTHONHOME%\python" -m venv --system-site-packages --symlinks --without-pip --clear .venv
    @REM echo "%PYTHONHOME%\python" -m venv --system-site-packages --symlinks --clear .venv
    exit /b

:genJson
    echo {"python.defaultInterpreterPath": "${workspaceFolder}\\.venv\\Scripts\\python.exe"}
    exit /b
