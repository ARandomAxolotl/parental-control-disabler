:LoadConfig
set "CONFIG_FILE=config.txt"
if %Debuglevel% gtr 0 echo [DEBUG] Checking if the config file exist...
:: Check if the config file exists
if not exist "%CONFIG_FILE%" (
    echo Config file not found. Calling the "configurator"...
    goto :Configurator
)
if %Debuglevel% gtr 0 echo [DEBUG] Loaing config from config.txt...
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
goto :Config_end

:: -----------------------------------------------------------------
:: CONFIGURATOR SUB-ROUTINE
:: -----------------------------------------------------------------
:Configurator
echo ╭─────────────────────────────────╮
echo ^│ Parental control disable script                     ^│
echo ╰─────────────────────────────────╯
if %Debuglevel% gtr 0 echo [DEBUG] Finding Windows installations...

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
choice /c YNE /M "Do you want to write to config?"
if "%errorlevel%"=="3" exit
if "%errorlevel%"=="1" echo windirtoo=%selectedDrive% > config.txt
:: Loop back to load the config once generated or selected
goto :LoadConfig

:Config_end
