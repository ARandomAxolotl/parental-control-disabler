@echo off
cls
SETLOCAL ENABLEDELAYEDEXPANSION
goto loadconfig

:stopeed
tasklist /FI "imagename eq explorer.exe" | find "explorer.exe" >nul
IF !errorlevel! == 0 (
    echo It seems like you're in the normal windows session, restarting to winRE
    SET /P restartqueue="Wanna restart to winre?(Y/N) : "
    if "%restartqueue%" == "Y" (
        shutdown /r /o /t 00
    ) else (
        echo You have to do it manualy!
        goto finish
    )
) ELSE (
    goto aroumenting
)

:aroumenting
if "%2" == "--debugon" (
    @echo on
    set debug=true
    goto debugon
) else (
    set debug=nottrue
    goto stillcheckanyway
)

:stillcheckanyway
if "%1" == "-d" ( set opt=1 )
if "%1" == "-e" ( set opt=2 )
if "%1" == "-r" ( set opt=3 )
if "%2" == "-m" ( set target=1 )
if "%2" == "-k" ( set target=2 )
if "%2" == "-b" ( set target=3 )
if "%1" == "" ( goto printhelp )
goto execute

:showreadme
if exist readme.md (
    notepad readme.md
) else (
    echo It looks like you didn't download the readme file
)
goto finish

:printhelp
echo -------------------------------
echo Parental control disable script
echo -------------------------------
echo What do u want to do?
echo 1 - (disable)
echo 2 - (enable)
echo 3 - (remove)
set /p opt=
goto helpstep2

:finish
CD %WINDIR%
if "%debug%" == "nottrue" (
    cls
)
@echo on
endlocal
cls
echo This is the end!
echo Bye Bye
echo Hope ur parents dont find me
goto :eof

:loadconfig
:: Define the path to your config file
set "CONFIG_FILE=config.txt"
:: Check if the config file exists
if not exist "%CONFIG_FILE%" (
    echo Calling the "configurator"
    goto configurator
)
echo Loading configuration from "%CONFIG_FILE%"...
:: Use FOR /F to read the file line by line
:: 'delims=' ensures the entire line is read into %%a	
:: 'tokens=1,*' splits the line at the first '='
for /f "usebackq tokens=1,* delims==" %%a in ("%CONFIG_FILE%") do (
    if not "%%a" == "" (
        if not "%%a" == "#" (
            :: Trim leading and trailing spaces from the variable name (%%a)
            set "var_name=%%a"
            :: Trim leading spaces from the value (%%b)
            set "var_value=%%b"

            :: Set the actual environment variable
            set "!var_name!=!var_value!"
            echo Set variable: !var_name! = !var_value!
        )
    )
)
echo.
echo Configuration loaded successfully.
echo.
goto aroumenting

:helpstep2
if "%debug%" == "nottrue" (  
    @echo off
    cls
)
echo -------------------------------
echo Parental control disable script
echo -------------------------------
echo Select target : 
echo 1 - (Kaspersky Safe Kids)
echo 2 - (Microsoft Family Safety)
echo 3 - (Both)
set /p target=
goto execute

:configurator
echo -------------------------------
echo Parental control disable script
echo -------------------------------
echo ----------Configurator---------
echo Opening notepad
start notepad
echo U can find your disks/partitions in
echo File -^> Save -^> This PC
echo Please find any partion/disk with Windows folder in it
echo WARNING : ONLY THE DISK LETTER
set /p configdisk=Enter your disk name(C,D,...) : 
echo windirtoo=%configdisk% > config.txt
goto loadconfig

:execute
if "%debug%" == "nottrue" (  
    @echo off
    cls
)
echo -------------------------------
echo Parental control disable script
echo -------------------------------
echo Executing...
if "%opt%"=="3" (
echo You are about to remove parental control apps
echo I DO NOT RECCOMMEND THIS OPTION
echo I RECCOMMEND DISABLING THEM
echo DO WITH CAUTION
choice /m "Do you wish to remove?"
if errorlevel 2 goto :finish
if errorlevel 1 goto :removal_next_warning
)
if "%opt%"=="1" ( goto disable_parental_control_app )
if "%opt%"=="2" ( goto enable_parental_control_app )

:removal_last_warning
echo THIS IS THE LAST WARNING
choice /m "Do you wish to remove?"
if errorlevel 2 goto :finish
if errorlevel 1 goto :remove_parental_controls_app

:remove_parental_controls_app
echo REMOVING...
if "%target%"=="1" (
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
rmdir /s "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" 
) else ( echo It's look like Kaspersky Safe Kids have been removed or have never been installed on drive %windirtoo%. )
)
if "%target%"=="2" (
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
echo Deleting Microsoft Family Safety is not recommended, as it will come back after an update.
del /p "%windirtoo%:\Windows\System32\wpcmon.exe"
) else ( echo It's look like Microsoft Family Safety have been removed on drive %windirtoo%. )
)
if "%target%"=="3" (
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
echo Deleting Microsoft Family Safety is not recommended, as it will come back after an update.
del /p "%windirtoo%:\Windows\System32\wpcmon.exe"
) else ( echo It's look like Microsoft Family Safety have been removed on drive %windirtoo%. )
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
rmdir /s "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" 
) else ( echo It's look like Kaspersky Safe Kids have been removed or have never been installed on drive %windirtoo%. )
)

:disable_parental_control_app
if "%target%"=="1" (
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" "Kaspersky Safe Kids 23.0 rename"
) else ( echo It's look like Kaspersky Safe Kids have been removed or have never been installed on drive %windirtoo%. )
)
if "%target%"=="2" (
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
rename "%windirtoo%:\Windows\System32\wpcmon.exe" wpcmon1.exe
) else ( echo It's look like Microsoft Family Safety have been removed on drive %windirtoo%. )
)
if "%target%"=="3" (
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" "Kaspersky Safe Kids 23.0 rename"
) else ( echo It's look like Kaspersky Safe Kids have been removed, renamed or have never been installed on drive %windirtoo%. )
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
rename "%windirtoo%:\Windows\System32\wpcmon.exe" wpcmon1.exe
) else ( echo It's look like Microsoft Family Safety have been removed, renamed on drive %windirtoo%. )
)

:enable_parental_control_app
if "%target%"=="1" (
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" (
rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" "Kaspersky Safe Kids 23.0"
) else ( echo It's look like Kaspersky Safe Kids have been removed or have never been installed on drive %windirtoo%. )
)
if "%target%"=="2" (
if exist "%windirtoo%:\Windows\System32\wpcmon1.exe" ( 
rename "%windirtoo%:\Windows\System32\wpcmon1.exe" wpcmon.exe
) else ( echo It's look like Microsoft Family Safety have been removed on drive %windirtoo%. )
)
if "%target%"=="3" (
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" (
rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" "Kaspersky Safe Kids 23.0"
) else ( echo It's look like Kaspersky Safe Kids have been removed, renamed or have never been installed on drive %windirtoo%. )
if exist "%windirtoo%:\Windows\System32\wpcmon1.exe" ( 
rename "%windirtoo%:\Windows\System32\wpcmon1.exe" wpcmon.exe
) else ( echo It's look like Microsoft Family Safety have been removed, renamed on drive %windirtoo%. )
)
