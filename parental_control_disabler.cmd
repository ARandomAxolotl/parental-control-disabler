@echo off
:: Initialize environment and set code page to UTF-8
cls
SETLOCAL ENABLEDELAYEDEXPANSION
chcp 65001 >nul

:: Capture the Escape character for potential coloring or advanced formatting
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: -----------------------------------------------------------------
:: SECTION 1: ENVIRONMENT CHECK
:: -----------------------------------------------------------------
:: Checks if explorer.exe is running. If it is, we are likely in a normal session.
:: The script implies it works best in WinRE (Recovery Environment).
:: [cite: 1, 2]
:CheckEnvironment
tasklist /FI "imagename eq explorer.exe" | find "explorer.exe" >nul
IF !errorlevel! == 0 (
    echo It seems like you're in the normal windows session.
    echo This script is intended to run in WinRE.
    
    SET /P restartqueue="Wanna restart to winre? (Y/N) : "
    if /I "!restartqueue!" == "Y" (
        :: Restart to recovery options
        shutdown /r /o /t 00
    ) else (
        echo You have to do it manually!
        goto :Finish
    )
) ELSE (
    :: If explorer isn't running, proceed to config loading
    goto :LoadConfig
)

:: -----------------------------------------------------------------
:: SECTION 2: CONFIGURATION
:: -----------------------------------------------------------------
:LoadConfig
:: Define the path to your config file
set "CONFIG_FILE=config.txt"

:: Check if the config file exists
if not exist "%CONFIG_FILE%" (
    echo Config file not found. Calling the "configurator"...
    goto :Configurator
)

echo Loading configuration from "%CONFIG_FILE%"...
:: [cite: 7] Parse config file. Skips lines starting with "#".
for /f "usebackq tokens=1,* delims==" %%a in ("%CONFIG_FILE%") do (
    if not "%%a" == "" (
        if not "%%a" == "#" (
            set "var_name=%%a"
            set "var_value=%%b"
            set "!var_name!=!var_value!"
            echo Set variable: !var_name! = !var_value!
        )
    )
)
echo.
echo Configuration loaded successfully. [cite: 9]
echo.
goto :ArgumentParsing

:: -----------------------------------------------------------------
:: SECTION 3: ARGUMENT PARSING
:: -----------------------------------------------------------------
:ArgumentParsing
:: [cite: 3] Check for debug flag (-d)
:DebugCheck
if "%3" == "-d" (
    @echo on
    set debug=true
    echo [DEBUG MODE ENABLED]
) else (
    set debug=nottrue
)

:ParseOptions
:: Map arguments to variables
if "%1" == "-d" ( set opt=1 )
if "%1" == "-e" ( set opt=2 )
if "%1" == "-r" ( set opt=3 )

if "%2" == "-m" ( set target=1 )
if "%2" == "-k" ( set target=2 )
if "%2" == "-b" ( set target=3 )

:: If no arguments are provided, show the help menu
if "%1" == "" ( goto :PrintHelp )

:: If arguments exist, skip the menu and execute directly
goto :Execute

:: -----------------------------------------------------------------
:: SECTION 4: USER INTERFACE / MENUS
:: -----------------------------------------------------------------
:PrintHelp
echo ╭─────────────────────────────────╮
echo │ Parental control disable script │
echo ╰─────────────────────────────────╯
echo What do u want to do?
echo 1 - (Disable)
echo 2 - (Enable)
echo 3 - (Remove)
set /p opt=Enter option: 
goto :SelectTarget

:SelectTarget
if "%debug%" == "nottrue" (  
    @echo off
    cls
)
echo ╭─────────────────────────────────╮
echo │ Parental control disable script │
echo ╰─────────────────────────────────╯
echo Select target : 
echo 1 - (Kaspersky Safe Kids)
echo 2 - (Microsoft Family Safety)
echo 3 - (Both)
set /p target=Enter target: 
goto :Execute

:Configurator
echo ╭─────────────────────────────────╮
echo │ Parental control disable script │
echo ╰─────────────────────────────────╯
@echo off
setlocal enabledelayedexpansion

echo Searching for all Windows installations...
echo ──────────────────────────────────────────
set "count=0"

:: Iterate through all possible drive letters
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    if exist "%%i:\Windows\System32" (
        set /a count+=1
        set "drive[!count!]=%%i"
        
        :: Get the volume label to help identify which is which
        for /f "tokens=2 delims==" %%j in ('wmic volume where "DriveLetter='%%i:'" get Label /value 2^>nul') do set "label=%%j"
        
        echo [!count!] Drive %%i: [!label!]
    )
)

if %count%==0 (
    echo No Windows partitions found.
    goto Finish
)

echo ──────────────────────────────────────────
set /p choice="Enter the number of the drive you want to work with (1-%count%): "

:: Proceed with your commands using %target%
pause
goto :LoadConfig

:: -----------------------------------------------------------------
:: SECTION 5: EXECUTION LOGIC
:: -----------------------------------------------------------------
:Execute
if "%debug%" == "nottrue" ( 
    @echo off
    cls 
)
echo ╭─────────────────────────────────╮
echo │        Executing......          │
echo ╰─────────────────────────────────╯

:: Check for Removal Option (High Risk)
if "%opt%"=="3" (
    echo You are about to remove parental control apps.
    echo I DO NOT RECOMMEND THIS OPTION. I RECOMMEND DISABLING THEM.
    echo DO WITH CAUTION.
    
    choice /m "Do you wish to remove?"
    if errorlevel 2 goto :Finish
    if errorlevel 1 goto :RemovalWarning2
)

if "%opt%"=="1" ( goto :ActionDisable )
if "%opt%"=="2" ( goto :ActionEnable )

:RemovalWarning2
echo THIS IS THE LAST WARNING.
choice /m "Do you wish to remove?"
if errorlevel 2 goto :Finish
if errorlevel 1 goto :ActionRemove [cite: 11]

:: -----------------------------------------------------------------
:: SECTION 6: ACTIONS (REMOVE / DISABLE / ENABLE)
:: -----------------------------------------------------------------

:: --- REMOVE ---
:ActionRemove
echo REMOVING...
:: Kaspersky Removal
if "%target%"=="1" goto :RemoveKaspersky
if "%target%"=="3" goto :RemoveKaspersky
:ReturnFromRemoveKaspersky

:: MS Family Safety Removal
if "%target%"=="2" goto :RemoveMicrosoft
if "%target%"=="3" goto :RemoveMicrosoft
:ReturnFromRemoveMicrosoft
goto :Finish

:RemoveKaspersky
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
    rmdir /s /q "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" 
    echo Kaspersky Safe Kids removed.
) else ( 
    echo Kaspersky Safe Kids not found on drive %windirtoo%. 
)
if "%target%"=="1" goto :Finish
if "%target%"=="3" goto :ReturnFromRemoveKaspersky

:RemoveMicrosoft
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
    echo Deleting Microsoft Family Safety is not recommended. [cite: 12]
    del /p "%windirtoo%:\Windows\System32\wpcmon.exe"
) else ( 
    echo Microsoft Family Safety not found on drive %windirtoo%. [cite: 13]
)
if "%target%"=="2" goto :Finish
if "%target%"=="3" goto :ReturnFromRemoveMicrosoft


:: --- DISABLE (RENAME) ---
:ActionDisable
echo DISABLING...
:: Kaspersky Disable
if "%target%"=="1" goto :DisableKaspersky
if "%target%"=="3" goto :DisableKaspersky
:ReturnFromDisableKaspersky

:: MS Family Safety Disable
if "%target%"=="2" goto :DisableMicrosoft
if "%target%"=="3" goto :DisableMicrosoft
:ReturnFromDisableMicrosoft
goto :Finish

:DisableKaspersky
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
    rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" "Kaspersky Safe Kids 23.0 rename"
    echo Kaspersky disabled (renamed).
) else ( 
    echo Kaspersky Safe Kids not found or already renamed on drive %windirtoo%. 
)
if "%target%"=="1" goto :Finish
if "%target%"=="3" goto :ReturnFromDisableKaspersky

:DisableMicrosoft
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
    rename "%windirtoo%:\Windows\System32\wpcmon.exe" wpcmon1.exe
    echo Microsoft Family Safety disabled (renamed).
) else ( 
    echo Microsoft Family Safety not found or already renamed on drive %windirtoo%. [cite: 14]
)
if "%target%"=="2" goto :Finish
if "%target%"=="3" goto :ReturnFromDisableMicrosoft


:: --- ENABLE (RESTORE NAME) ---
:ActionEnable
echo ENABLING...
:: Kaspersky Enable
if "%target%"=="1" goto :EnableKaspersky
if "%target%"=="3" goto :EnableKaspersky
:ReturnFromEnableKaspersky

:: MS Family Safety Enable
if "%target%"=="2" goto :EnableMicrosoft
if "%target%"=="3" goto :EnableMicrosoft
:ReturnFromEnableMicrosoft
goto :Finish

:EnableKaspersky
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" (
    rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" "Kaspersky Safe Kids 23.0" [cite: 16]
    echo Kaspersky enabled.
) else ( 
    echo Kaspersky backup folder not found on drive %windirtoo%. 
)
if "%target%"=="1" goto :Finish
if "%target%"=="3" goto :ReturnFromEnableKaspersky

:EnableMicrosoft
if exist "%windirtoo%:\Windows\System32\wpcmon1.exe" ( 
    rename "%windirtoo%:\Windows\System32\wpcmon1.exe" wpcmon.exe
    echo Microsoft Family Safety enabled.
) else ( 
    echo Microsoft Family Safety backup file not found on drive %windirtoo%. 
)
if "%target%"=="2" goto :Finish
if "%target%"=="3" goto :ReturnFromEnableMicrosoft

:: -----------------------------------------------------------------
:: SECTION 7: EXIT
:: -----------------------------------------------------------------
:Finish
CD %WINDIR%
if "%debug%" == "nottrue" (
    cls
)
@echo on
endlocal
echo This is the end!
echo Bye Bye
echo Hope ur parents dont find me
goto :eof