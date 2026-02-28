@echo off
cd /d "%~dp0"
if not exist "Optimize-NetworkAdvanced.ps1" (
    echo ERROR: Optimize-NetworkAdvanced.ps1 not found in this folder!
    echo.
    echo Please download both files to the same folder:
    echo - Run-NetworkOptimization.bat
    echo - Optimize-NetworkAdvanced.ps1
    echo.
    pause
    exit /b
)
powershell -ExecutionPolicy Bypass -File "%~dp0Optimize-NetworkAdvanced.ps1"
pause
