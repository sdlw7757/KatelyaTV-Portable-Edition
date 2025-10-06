@echo off
TITLE KatelyaTV Setup

echo ================================
echo   KatelyaTV Installation
echo ================================
echo.
echo Checking system requirements...

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo Error: Node.js is not installed.
    echo.
    echo Please download and install Node.js from:
    echo https://nodejs.org/
    echo.
    echo After installing Node.js, run this setup again.
    echo.
    pause
    exit /b 1
)

REM Check if pnpm is installed
echo Checking for pnpm...
pnpm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing pnpm...
    npm install -g pnpm
    if %errorlevel% neq 0 (
        echo.
        echo Error: Failed to install pnpm.
        echo.
        pause
        exit /b 1
    )
)

REM Install dependencies
echo Installing application dependencies...
cd /d "%~dp0"
pnpm install
if %errorlevel% neq 0 (
    echo.
    echo Error: Failed to install dependencies.
    echo.
    pause
    exit /b 1
)

echo.
echo Installation completed successfully
echo.
echo To start KatelyaTV:
echo   1. Double-click start.bat
echo   2. Or open a terminal and run: npx next dev
echo.
echo The application will be available at http://localhost:3000
echo.
echo For more information, see README_LOCAL.md
echo.
pause
