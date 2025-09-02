@echo off
setlocal enabledelayedexpansion

if not exist .venv (
    call set_venv.bat 1
    if %errorlevel% neq 0 (
        echo.
        echo fail to set virtual environment
        goto :eof
    )
    set set_now=TRUE
) else (
    for /f "tokens=3,3 delims= " %%i in (.venv\pyvenv.cfg) do (
        if not exist %%i (
            rem reset virtual environment
            rmdir /s /q .venv
            call set_venv.bat 1
            set set_now=TRUE
        )
        goto :skip
    )
)
:skip
call .venv\Scripts\activate.bat
if defined set_now (
    if exist requirements.txt (
        python -m pip install -r requirements.txt 1> install.log 2>nul
    )
)

echo.
python test.py %*
echo.

call .venv\Scripts\deactivate.bat
