@echo off
echo [1/5] Stopping and Disabling Telemetry & Tracking Services...
net stop DiagTrack >nul 2>&1
net stop dmwappushservice >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
sc config diagnosticshub.standardcollector.service start= disabled >nul 2>&1

echo [2/5] Disabling Telemetry via Registry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d 1 /f >nul

echo [3/5] Removing Microsoft Bloatware Packages...
for /f "tokens=*" %%i in ('powershell -Command "Get-AppxPackage -AllUsers | Where-Object {$_.Name -like '*Bing*' -or $_.Name -like '*Xbox*' -or $_.Name -like '*Zune*' -or $_.Name -like '*YourPhone*' -or $_.Name -like '*GetHelp*' -or $_.Name -like '*GetStarted*' -or $_.Name -like '*Messaging*' -or $_.Name -like '*Office*' -or $_.Name -like '*Skype*' -or $_.Name -like '*Solitaire*' -or $_.Name -like '*Spotify*' -or $_.Name -like '*Disney*' -or $_.Name -like '*Facebook*' -or $_.Name -like '*Netflix*' -or $_.Name -like '*Twitter*' -or $_.Name -like '*Cortana*'} | Select-Object -ExpandProperty PackageFullName"') do echo Removing %%i & powershell -Command "Remove-AppxPackage -Package %%i -AllUsers" 2>nul

echo [4/5] Disabling Cortana and Web Search in Start Menu...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul

echo [5/5] Applying Performance Tweaks...
:: Set Network Profile to Private for lower discovery latency (change to Public for stricter security)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles" /v "Category" /t REG_DWORD /d 1 /f >nul

echo.
echo ** SYSTEM DEBLOAT COMPLETE. **
echo A reboot is required for all changes to take effect.
echo Some features (Widgets, Store, etc.) are now broken.
pause
