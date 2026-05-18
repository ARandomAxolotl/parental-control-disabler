if %Debuglevel% gtr 0 echo [DEBUG] Checking the environment...
set "winpe=True"
tasklist /FI "imagename eq explorer.exe" | find "explorer.exe" >nul
IF !errorlevel! == 0 (
    echo Because u are running script in the normal Windows session so I'm now checking for update
    echo Checking internet connection...
    ping -n 1 www.github.com | find "TTL=" >nul
    if %errorlevel%==0 (
         echo You are online!
         echo Getting newest version info...
         for /f "usebackq delims=" %%b in (`curl -sL "https://raw.githubusercontent.com/ARandomAxolotl/parental-control-disabler/refs/heads/main/ver.txt"`) do (
             set "newVersion=%%b"
             call :CheckUpdate
         )
    ) else (
         echo You are offline.
         echo Stopping
    )
    exit /b 1
    set "winpe=False"
)
exit /b 0

:CheckUpdate
if /i %newVersion% gtr %CurrentVersion% (
cd ..
curl -sL https://codeload.github.com/ARandomAxolotl/parental-control-disabler/zip/refs/heads/main
powershell -command "Expand-Archive -Path 'parental-control-disabler-main.zip' -DestinationPath '.' -Force"
)