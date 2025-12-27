@echo off
:: Code from AI warn
choice /m "This is code from AI, it may get some issues, continue?
if errorlevel 2 goto :finish
:: INITIALIZATION
cls
SETLOCAL ENABLEDELAYEDEXPANSION
set "CONFIG_FILE=config.txt"

:: 1. ENVIRONMENT CHECK
:: Checks if the user is in a normal session or WinRE by looking for explorer.exe
tasklist /FI "imagename eq explorer.exe" | find "explorer.exe" >nul
IF !errorlevel! == 0 (
    echo It seems like you're in the normal windows session, restarting to winRE
    
    :: REPLACED: SET /P with CHOICE
    choice /C YN /M "Wanna restart to winre?"
    
    :: Errorlevel 2 = N, Errorlevel 1 = Y
    if errorlevel 2 (
        echo You have to do it manualy!
        goto finish
    )
    if errorlevel 1 (
        shutdown /r /o /t 00
    )
)

:: 2. CONFIGURATION LOADING
:loadconfig
if not exist "%CONFIG_FILE%" goto configurator

echo Loading configuration from "%CONFIG_FILE%"...
for /f "usebackq tokens=1,* delims==" %%a in ("%CONFIG_FILE%") do (
    if not "%%a" == "" if not "%%a" == "#" (
        set "var_name=%%a"
        set "var_value=%%b"
        set "!var_name!=!var_value!"
        echo Set variable: !var_name! = !var_value!
    )
)
echo.
echo Configuration loaded successfully.
goto parse_args

:: 3. ARGUMENT PARSING
:parse_args
:: Check for debug mode
set debug=nottrue
if "%2" == "--debugon" (
    @echo on
    set debug=true
)

:: Process flags for operation and target
if "%1" == "-d" set opt=1
if "%1" == "-e" set opt=2
if "%1" == "-r" set opt=3
if "%2" == "-m" set target=1
if "%2" == "-k" set target=2
if "%2" == "-b" set target=3

:: If no arguments, go to interactive menu
if "%1" == "" goto printhelp
goto execute

:: 4. INTERACTIVE MENUS
:printhelp
echo -------------------------------
echo Parental control disable script
echo -------------------------------
echo What do u want to do?
echo 1 - (disable)
echo 2 - (enable)
echo 3 - (remove)

:: REPLACED: SET /P with CHOICE
choice /C 123 /M "Select option"
set opt=%errorlevel%

goto helpstep2

:helpstep2
cls
echo Select target: 
echo 1 - (Kaspersky Safe Kids)
echo 2 - (Microsoft Family Safety)
echo 3 - (Both)

:: REPLACED: SET /P with CHOICE
choice /C 123 /M "Select target"
set target=%errorlevel%

goto execute

:: 5. EXECUTION LOGIC
:execute
if "%debug%" == "nottrue" cls
echo Executing task...

:: Removal Warning
if "%opt%"=="3" (
    echo WARNING: Removing parental control apps is NOT recommended.
    choice /m "Do you wish to proceed with REMOVAL?"
    if errorlevel 2 goto finish
)

:: Route to specific actions
if "%opt%"=="1" goto action_disable
if "%opt%"=="2" goto action_enable
if "%opt%"=="3" goto action_remove
goto finish

:action_disable
:: Disabling logic (Renaming files)
if "%target%"=="1" call :toggle_kaspersky disable
if "%target%"=="2" call :toggle_microsoft disable
if "%target%"=="3" (
    call :toggle_kaspersky disable
    call :toggle_microsoft disable
)
goto finish

:action_enable
:: Enabling logic (Renaming back)
if "%target%"=="1" call :toggle_kaspersky enable
if "%target%"=="2" call :toggle_microsoft enable
if "%target%"=="3" (
    call :toggle_kaspersky enable
    call :toggle_microsoft enable
)
goto finish

:action_remove
:: Removal logic (Deleting files)
if "%target%"=="1" call :delete_kaspersky
if "%target%"=="2" call :delete_microsoft
if "%target%"=="3" (
    call :delete_kaspersky
    call :delete_microsoft
)
goto finish

:: 6. SUBROUTINES
:toggle_kaspersky
set "k_path=%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0"
if "%1"=="disable" (
    if exist "%k_path%" rename "%k_path%" "Kaspersky Safe Kids 23.0 rename"
) else (
    if exist "%k_path% rename" rename "%k_path% rename" "Kaspersky Safe Kids 23.0"
)
exit /b

:toggle_microsoft
set "m_path=%windirtoo%:\Windows\System32\wpcmon.exe"
if "%1"=="disable" (
    if exist "%m_path%" rename "%m_path%" wpcmon1.exe
) else (
    if exist "%windirtoo%:\Windows\System32\wpcmon1.exe" rename "%windirtoo%:\Windows\System32\wpcmon1.exe" wpcmon.exe
)
exit /b

:delete_kaspersky
rmdir /s /q "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0"
exit /b

:delete_microsoft
echo Deleting Microsoft Family Safety is not recommended (it returns after updates).
del /p "%windirtoo%:\Windows\System32\wpcmon.exe"
exit /b

:configurator
echo ----------Configurator---------
echo Opening notepad to help you find your drive letter...
start notepad
set /p configdisk=Enter your Windows disk letter (e.g., C, D): 
echo windirtoo=%configdisk% > config.txt
goto loadconfig

:: 7. CLEANUP & EXIT
:finish
CD %WINDIR%
if "%debug%" == "nottrue" (
    @echo off
    cls
)
echo This is the end!
echo Bye Bye. Hope ur parents dont find me
endlocal
pause
goto :eof