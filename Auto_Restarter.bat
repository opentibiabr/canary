@echo off
title Auto OTServ Restarter

:begin
tasklist /FI "IMAGENAME eq canary.exe" 2>NUL | find /I /N "canary.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Canary.exe is executing.
) else (
    echo Canary.exe is not executing. Restarting...
    start "" "C:\Users\SERVER\Documents\canary-main\canary.exe"
)

timeout /t 10 >nul
goto begin