@echo off
REM KatelyaTV Smart Start Script
REM This script will automatically check and install dependencies if needed, then start the application

TITLE KatelyaTV Smart Launcher

echo ================================
echo   KatelyaTV Smart Launcher
echo ================================
echo.

cd /d "%~dp0"

echo Current directory: %CD%
echo.

REM Check if we're in the correct directory
if not exist "package.json" (
    echo Error: package.json not found!
    echo Please make sure you're running this script from the KatelyaTV directory.
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

REM Check if node_modules exists and install if needed
echo Checking for dependencies...
if not exist "node_modules" (
    echo Dependencies not found. Installing...
    echo.
    
    REM Check if pnpm is installed
    echo Checking for pnpm...
    pnpm --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo pnpm not found. Installing pnpm...
        npm install -g pnpm
        if %errorlevel% neq 0 (
            echo Error: Failed to install pnpm.
            echo Please install Node.js and pnpm manually from https://nodejs.org/
            echo.
            echo Press any key to exit...
            pause >nul
            exit /b 1
        )
        echo pnpm installed successfully.
        echo.
    ) else (
        echo pnpm is already installed.
        echo.
    )
    
    echo Installing application dependencies...
    echo This may take several minutes. Please be patient.
    echo.
    
    pnpm install
    if %errorlevel% neq 0 (
        echo.
        echo Error: Failed to install dependencies.
        echo Please check your internet connection and try again.
        echo.
        echo Press any key to exit...
        pause >nul
        exit /b 1
    )
    
    echo.
    echo Dependencies installed successfully!
    echo.
    
    REM Run post-install scripts to generate necessary files
    echo Running post-install scripts...
    node scripts/convert-config.js
    if %errorlevel% neq 0 (
        echo Warning: Failed to run convert-config.js, but continuing...
    )
    
    node scripts/generate-manifest.js
    if %errorlevel% neq 0 (
        echo Warning: Failed to run generate-manifest.js, but continuing...
    )
    echo Post-install scripts completed.
    echo.
) else (
    echo Dependencies found.
    echo.
)

REM Kill any existing Node.js processes
echo Stopping any existing Node.js processes...
taskkill /F /IM node.exe >nul 2>&1
del server.log >nul 2>&1
echo Done.
echo.

REM Start the application in background and open browser
echo Starting KatelyaTV application...
echo The application will be available at http://localhost:3000
echo.

REM Start server in background and log output
start "KatelyaTV Server" /D "%CD%" cmd /c "npx next dev > server.log 2>&1"

REM Give the server more time to start (increased from 15 to 25 seconds)
echo Waiting for server to start (this may take up to 25 seconds)...
timeout /t 25 /nobreak >nul

REM Check if server started successfully
set SERVER_STARTED=0
set CHECK_COUNT=0
:check_server
if exist "server.log" (
    findstr /C:"Ready in" server.log >nul
    if %errorlevel% equ 0 (
        echo Server started successfully!
        set SERVER_STARTED=1
    ) else (
        if %CHECK_COUNT% LSS 5 (
            echo Server is still starting, checking again in 5 seconds...
            set /a CHECK_COUNT+=1
            timeout /t 5 /nobreak >nul
            goto check_server
        ) else (
            echo Server may still be starting, proceeding anyway...
        )
    )
) else (
    echo Starting server process...
)

REM Open browser automatically - ONLY after server has started
echo Opening browser to http://localhost:3000
start http://localhost:3000

REM Additional check to ensure browser opens even if server takes longer to start
if %SERVER_STARTED% equ 0 (
    echo Server may still be starting. Opening browser now anyway...
    start http://localhost:3000
)

echo.
echo Server is running in the background.
echo Browser has been opened automatically.
echo To stop the server, run stop.bat
echo.

REM Keep this window open so user can see the messages
echo ================================================
echo   The application is now running!
echo   Browser should have opened automatically.
echo   Press any key to close this window.
echo   (The server will continue running in background)
echo ================================================
pause >nul
exit