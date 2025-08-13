@echo off
setlocal enabledelayedexpansion

if not exist .venv (
    call set_venv.bat 1
    if %errorlevel% neq 0 (
        echo.
        echo fail to set virtual environment
        goto :eof
    )
    set set_now=1
) else (
    for /f "tokens=3,3 delims= " %%i in (.venv\pyvenv.cfg) do (
        if not exist %%i (
            rem reset virtual environment
            rmdir /s /q .venv
            rmdir /s /q .vscode
            call set_venv.bat 1
            set set_now=1
        )
        goto :skip
    )
)
:skip
call .venv\Scripts\activate.bat
if "%set_now%"=="1" (
    if exist requirements.txt (
        @REM python -m pip install --upgrade pip 1>&2
        python -m pip install -r requirements.txt 1> install.log 2>nul
    )
)

echo.
python test.py %*
echo.

call .venv\Scripts\deactivate.bat
