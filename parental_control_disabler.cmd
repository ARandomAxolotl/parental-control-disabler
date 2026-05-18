call "%~dp0scripts\argparse.cmd" %*

if "%Skip_check_env%"=="0" ( call "%~dp0scripts\checkenv.cmd" )

if "%Task%"=="Enable" (
    set "cmd=--enable"
) else if "%Task%"=="Disable" (
    set "cmd=--disable"
) else if "%Task%"=="Remove" (
    set "cmd=--remove"
) else if "%Task%"=="Stop" (
    set "cmd=--stop"
) else if "%Target%"=="HelpMenu" ( 
    goto :cliHelp 
) else (
    call "%~dp0scripts\tui.cmd"
    exit /b
)

if "%Target%"=="MS" (
    set "cmd=%cmd% "--target:ms""
) else if "%Target%"=="Kas" (
    set "cmd=%cmd% "--target:kas""
) else if "%Target%"=="Both" (
    set "cmd=%cmd% "--target:both""
)

if not "%cmd%"=="--stop --target:ms" (
    if "%winpe%"=="False" ( 
        echo Plz run in winpe
        exit /b 1
    )
)

if "%Debuglevel%"=="1" (
    set "cmd=%cmd% -d"
) else if "%Debuglevel%"=="2" (
    set "cmd=%cmd% -dd"
    @echo on
)

if not "%cmd%"=="--stop --target:ms" call "%~dp0scripts\config.cmd"

call "%~dp0scripts\exec.cmd" %cmd%

exit /b

:cliHelp
echo.
echo Usage: run.cmd [Options] [Targets] [Flags]
echo.
echo Options:
echo   -h, --help        				Show this help message
echo   -d                				Disable
echo   -e                				Enable
echo   -s                				Stop
echo   -r               				Remove
echo Targets:
echo   -m               				Microsoft Family Safety
echo   -k               				Kaspersky Safe Kids
echo   -b              				Both
echo Flags:
echo   --skip-check-environment   			Skip checking env
echo   -D             				Debug mode, print most infomation
echo   --verbose, -DD   				Print executed commands (extremely verbose)
echo Exambles : 
echo  - run.cmd -sn : stop Microsoft Family Safety
echo  - run.cmd -rk : removes Kaspersky Safe Kids
echo Tip: -sm is equivalent to -s -m (same as -ms)
