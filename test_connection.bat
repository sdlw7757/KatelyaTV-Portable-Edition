@echo off
REM KatelyaTV Connection Test Script
REM This script will test if the KatelyaTV application is running correctly

TITLE KatelyaTV Connection Test

echo ================================
echo   KatelyaTV Connection Test
echo ================================
echo.

echo 1. Testing if port 3000 is open...
netstat -ano | findstr :3000 >nul
if %errorlevel% == 0 (
    echo Port 3000 is open and listening
) else (
    echo Port 3000 is not open
)

echo.
echo 2. Testing server response...
powershell -Command "$response = try { curl -UseBasicParsing -Uri http://localhost:3000 -TimeoutSec 10; Write-Output 'SUCCESS' } catch { Write-Output 'FAILED' }; if ($response -eq 'SUCCESS') { echo Server is responding correctly } else { echo Server is not responding }"

echo.
echo 3. Opening browser to http://localhost:3000
start http://localhost:3000

echo.
echo If the page does not load:
echo 1. Try refreshing the browser (Ctrl+F5)
echo 2. Try opening in an incognito/private window
echo 3. Try accessing http://127.0.0.1:3000 instead
echo 4. Check if any browser extensions are blocking the content
echo.
pause