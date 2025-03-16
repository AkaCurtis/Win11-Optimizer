@echo off
title Windows 11 Optimization Script
color 0A
echo ========================================
echo  Running Optimizations for Windows 11...
echo ========================================
timeout /t 2 >nul

for /f %%A in ('powershell -command "& {Get-PhysicalDisk | Where-Object MediaType -eq 'SSD'}"') do set SSD=%%A

if defined SSD (
    echo SSD detected. Applying SSD optimizations...
    set SSD=true
) else (
    echo HDD detected. Keeping prefetch services enabled...
    set SSD=false
)
timeout /t 2 >nul

echo Enabling Ultimate Performance Power Plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg /S e9a42b02-d5df-448d-aa00-03f14749eb61
timeout /t 2 >nul

:Disable_Services
echo Do you want to disable Superfetch (SysMain) and Windows Search? (Y/N)
set /p disable_services=
if /i "%disable_services%"=="y" goto Disable_Services_Yes
if /i "%disable_services%"=="n" goto Disable_Services_No
echo Invalid input. Please enter Y or N.
goto Disable_Services

:Disable_Services_Yes
if "%SSD%"=="true" (
    echo Disabling SysMain (Superfetch) for SSD...
    sc config SysMain start=disabled
    net stop SysMain
) else (
    echo Keeping SysMain enabled (HDD detected)...
)
echo Disabling Windows Search...
sc config WSearch start=disabled
net stop WSearch
goto Continue

:Disable_Services_No
echo Keeping Windows Search and Superfetch enabled.
goto Continue

:Continue
timeout /t 2 >nul

:Disable_Xbox
echo Disable Xbox services? (Only if you don't game) (Y/N)
set /p disable_xbox=
if /i "%disable_xbox%"=="y" goto Disable_Xbox_Yes
if /i "%disable_xbox%"=="n" goto Disable_Xbox_No
echo Invalid input. Please enter Y or N.
goto Disable_Xbox

:Disable_Xbox_Yes
echo Disabling Xbox services...
sc config XblAuthManager start=disabled
sc config XblGameSave start=disabled
sc config XboxNetApiSvc start=disabled
net stop XblAuthManager
net stop XblGameSave
net stop XboxNetApiSvc
goto Continue2

:Disable_Xbox_No
echo Keeping Xbox services enabled.
goto Continue2

:Continue2
timeout /t 2 >nul

echo Clearing RAM & Restarting Explorer...
taskkill /F /IM explorer.exe
start explorer.exe
timeout /t 2 >nul

:: SSD Optimizations
if "%SSD%"=="true" (
    echo Enabling SSD TRIM...
    fsutil behavior set DisableDeleteNotify 0
    timeout /t 2 >nul
)

echo Running Disk Cleanup...
cleanmgr /sagerun:1
timeout /t 2 >nul

echo Flushing DNS cache...
ipconfig /flushdns
netsh interface tcp set global autotuninglevel=normal
timeout /t 2 >nul

echo Checking Disk Health...
powershell -command "& {Get-PhysicalDisk | Select Model, MediaType, HealthStatus, OperationalStatus}"
timeout /t 2 >nul

echo ========================================
echo  Optimization Complete! Restart for best performance.
echo ========================================
pause
exit
