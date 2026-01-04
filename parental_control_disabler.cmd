@echo off
:: Initialize environment and set code page to UTF-8
SETLOCAL ENABLEDELAYEDEXPANSION
chcp 65001 >nul 

:: Capture the Escape character for potential coloring
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: -----------------------------------------------------------------
:: SECTION 1: DEBUG CHECK (MOVED TO TOP)
:: -----------------------------------------------------------------
:: Check for debug flag (-d) immediately.
:: Note: The original logic checks the 3rd argument for the debug flag.
if "%5" == "--verbose" (
    @echo on
    set debug=true
) else (
	if "%5" == "-d" (
		set debug=maybe
	) else (
		set debug=nottrue
	)
)

if "%4" == "--verbose" (
    @echo on
    set debug=true
) else (
	if "%4" == "-d" (
		set debug=maybe
	) else (
		set debug=nottrue
	)
)

:: -----------------------------------------------------------------
:: SECTION 2: ENVIRONMENT CHECK
:: -----------------------------------------------------------------
:: Checks if explorer.exe is running.
:CheckEnvironment
if NOT "%debug%"=="nottrue" echo [DEBUG] Checking the environment...
tasklist /FI "imagename eq explorer.exe" | find "explorer.exe" >nul
if "%1" == "--skip-check-environment" ( goto :LoadConfig )
if "%3" == "--skip-check-environment" ( goto :LoadConfig )
if "%4" == "--skip-check-environment" ( goto :LoadConfig )
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
)
:: If explorer isn't running, flow triggers to Config Loading

:: -----------------------------------------------------------------
:: SECTION 3: CONFIGURATION
:: -----------------------------------------------------------------
:LoadConfig
:: Define the path to your config file
set "CONFIG_FILE=config.txt"
if NOT "%debug%"=="nottrue" echo [DEBUG] Checking if the config file exist...
:: Check if the config file exists
if not exist "%CONFIG_FILE%" (
    echo Config file not found. Calling the "configurator"...
    goto :Configurator
)
if NOT "%debug%"=="nottrue" echo [DEBUG] Loaing config from config.txt...
echo Loading configuration from "%CONFIG_FILE%"...
:: Parse config file. Skips lines starting with "#".
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
echo Configuration loaded successfully.
echo.
:: Configuration is done, move to argument parsing
goto :ParseOptions

:: -----------------------------------------------------------------
:: CONFIGURATOR SUB-ROUTINE
:: -----------------------------------------------------------------
:Configurator
echo ╭─────────────────────────────────╮
echo │ Parental control disable script │
echo ╰─────────────────────────────────╯
if NOT "%debug%"=="nottrue" echo [DEBUG] Finding Windows installations...

echo Searching for all Windows installations...
echo ──────────────────────────────────────────
set "count=0"

:: Iterate through all possible drive letters
for %%i in (C D E F G H I J K L M N O P Q R S T U V W Y Z) do (
    if exist "%%i:\Windows\System32" (
        set /a count+=1
        set "drive[!count!]=%%i"
        
        :: Get the volume label
        for /f "tokens=2 delims==" %%j in ('wmic volume where "DriveLetter='%%i:'" get Label /value 2^>nul') do set "label=%%j"
        
        echo [!count!] Drive %%i: [!label!]
    )
)

if %count%==0 (
    echo No Windows partitions found.
    goto :Finish
)

echo ──────────────────────────────────────────
set /p choice="Enter the number of the drive you want to work with (1-%count%): 
:: --- NEW SECTION: Save to config.txt ---
:: 1. Get the letter from the array based on choice
set "selectedDrive=!drive[%choice%]!"

:: 2. Write to config.txt (This overwrites existing file)
echo windirtoo=%selectedDrive% > config.txt
:: Loop back to load the config once generated or selected
goto :LoadConfig

:: -----------------------------------------------------------------
:: SECTION 4: ARGUMENT PARSING
:: -----------------------------------------------------------------
:ParseOptions
if NOT "%debug%"=="nottrue" echo [DEBUG] Mapping the arguments...
:: Map arguments to variables
if "%1" == "-d" ( set "opt=1" )
if "%1" == "-e" ( set "opt=2" )
if "%1" == "-r" ( set "opt=3" )
if "%1" == "-h" ( goto :cliHelp )
if "%1" == "--help" ( goto :cliHelp )

if "%2" == "-m" ( set "target=1" )
if "%2" == "-k" ( set "target=2" )
if "%2" == "-b" ( set "target=3" )

if "%3" == "--no-preserve" ( set preserve=no )

:: If no arguments are provided, show the help menu
if "%1" == "" ( 
	if NOT "%debug%"=="nottrue" echo [DEBUG] No option provided, starting TUI...
	goto :StartTUI
)
if "%2" == "" ( 
	if NOT "%debug%"=="nottrue" echo [DEBUG] No target provided, starting TUI...
	goto :StartTUI
)

:: If arguments exist, skip the menu and execute directly
goto :Execute

:: -----------------------------------------------------------------
:: SECTION 5: USER INTERFACE / MENUS
:: -----------------------------------------------------------------
:StartTUI
echo ╭─────────────────────────────────╮
echo │ Parental control disable script │
echo ╰─────────────────────────────────╯
echo What do u want to do?
echo 1 - (Disable)
echo 2 - (Enable)
echo 3 - (Remove)
set /p opt=Enter option: 
if NOT "%debug%"=="nottrue" echo [DEBUG] Option selected : %opt%
goto :SelectTarget

:SelectTarget
echo ╭─────────────────────────────────╮
echo │ Parental control disable script │
echo ╰─────────────────────────────────╯
echo Select target : 
echo 1 - (Kaspersky Safe Kids)
echo 2 - (Microsoft Family Safety)
echo 3 - (Both)
set /p target=Enter target: 
if NOT "%debug%"=="nottrue" echo [DEBUG] Target selected : %target%
goto :Execute

:: -----------------------------------------------------------------
:: SECTION 6: EXECUTION LOGIC
:: -----------------------------------------------------------------
:Execute
echo ╭─────────────────────────────────╮
echo │        Executing......          │
echo ╰─────────────────────────────────╯
if NOT "%debug%"=="nottrue" echo [DEBUG] Starting execution prase...
:: Check for Removal Option (High Risk)
if "%opt%"=="3" (
	if "%preserve%" == "no" ( goto :ActionRemove )
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
if errorlevel 1 goto :ActionRemove

:: -----------------------------------------------------------------
:: SECTION 7: ACTIONS (REMOVE / DISABLE / ENABLE)
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
    echo Deleting Microsoft Family Safety is not recommended.
    del /p "%windirtoo%:\Windows\System32\wpcmon.exe"
) else ( 
    echo Microsoft Family Safety not found on drive %windirtoo%.
)
if "%target%"=="2" goto :Finish
if "%target%"=="3" goto :ReturnFromRemoveMicrosoft


:: --- DISABLE (RENAME) ---
:ActionDisable
echo DISABLING...
:: Kaspersky Disable
if "%target%"=="2" goto :DisableKaspersky
:: idk but i added this for debug a random bug in batch
if "%target%"=="3" goto :DisableKaspersky
:ReturnFromDisableKaspersky

:: MS Family Safety Disable
if "%target%"=="1" goto :DisableMicrosoft
if "%target%"=="3" goto :DisableMicrosoft
:ReturnFromDisableMicrosoft
goto :Finish

:DisableKaspersky
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
    rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" "Kaspersky Safe Kids 23.0 rename"
    echo Kaspersky disabled (renamed^).
) else ( 
    echo Kaspersky Safe Kids not found or already renamed on drive %windirtoo%
)
if "%target%"=="1" goto :Finish
if "%target%"=="3" goto :ReturnFromDisableKaspersky

:DisableMicrosoft
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
    rename "%windirtoo%:\Windows\System32\wpcmon.exe" wpcmon1.exe
    echo Microsoft Family Safety disabled (renamed^)
) else ( 
    echo Microsoft Family Safety not found or already renamed on drive %windirtoo%
)
if "%target%"=="2" goto :Finish
if "%target%"=="3" goto :ReturnFromDisableMicrosoft


::---ENABLE(RESTORE NAME)---
:ActionEnable
echo ENABLING...
:: Kaspersky Enable
if "%target%"=="2" goto :EnableKaspersky
if "%target%"=="3" goto :EnableKaspersky
:ReturnFromEnableKaspersky

:: MS Family Safety Enable
if "%target%"=="1" goto :EnableMicrosoft
if "%target%"=="3" goto :EnableMicrosoft
:ReturnFromEnableMicrosoft
goto :Finish

:EnableKaspersky
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" (
    rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" "Kaspersky Safe Kids 23.0"
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
goto Finish

:cliHelp
echo.
echo Usage: %~nx0 [options/flags2] [target] [flag/flags2/debug flag] [debug flag]
echo.
echo Options:
echo   -h, --help        			Show this help message
echo   -d                			Disable
echo   -e                			Enable
echo Targets:
echo    -m               			Microsoft Faminily Safely
echo    -k               			Kaspersky safe kids
echo    -b              			Both
echo Flags:
echo   --no-preserve   				Do not show 2-step-verification during removal
echo Flags2:
echo   --skip-check-environment     Skip the check environment prase
echo Debug flag :
echo   --verbose					Verbose mode, print everything(can be messy)
echo   -d							Debug mode, print most infomation
echo Tip : You can use "" as an empty argument
goto :Finish

:: -----------------------------------------------------------------
:: SECTION 8: EXIT
:: -----------------------------------------------------------------
:Finish
CD %WINDIR%
endlocal
echo This is the end!
echo Bye Bye
echo Hope ur parents dont find me
echo on
goto :eof