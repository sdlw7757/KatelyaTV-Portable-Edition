@echo off
REM KatelyaTV Smart Stop Script
REM This script will stop the KatelyaTV application

TITLE KatelyaTV Smart Stopper

echo ================================
echo   KatelyaTV Application Stop
echo ================================
echo.

echo Stopping KatelyaTV application...
echo.

REM Kill Node.js processes with more detailed output
echo Terminating Node.js processes...
taskkill /F /IM node.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo Node.js processes terminated successfully.
) else (
    echo No Node.js processes were found.
)

echo.
echo Cleaning up...
del server.log >nul 2>&1
echo Done.
echo.

echo KatelyaTV application has been stopped.
echo.

pause