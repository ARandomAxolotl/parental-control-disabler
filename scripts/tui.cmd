echo ╭─────────────────────────────────╮
echo ^│ Parental control disable script                    ^ │
echo ╰─────────────────────────────────╯
echo What do u want to do?
echo 1 - (Disable)
echo 2 - (Enable)
echo 3 - (Stop)
echo 4 - (Remove)
set /p opt=Enter option: 
if %debug% gtr 0 echo [DEBUG] Option selected : %opt%
if "%opt%"=="2" (
    set "cmd=--enable"
) else if "%opt%"=="1" (
    set "cmd=--disable"
) else if "%opt%"=="4" (
    set "cmd=--remove"
) else if "%opt%"=="3" (
    set "cmd=--stop"
)

:SelectTarget
echo Select Target : 
echo 1 - (Kaspersky Safe Kids)
echo 2 - (Microsoft Family Safety)
echo 3 - (Both)
set /p Target=Enter target: 
if %debug% gtr 0 echo [DEBUG] Target selected : %Target%
if "%Target%"=="1" (
    set "cmd=%cmd% --Target=ms"
) else if "%Target%"=="2" (
    set "cmd=%cmd% --Target=kas"
) else if "%Target%"=="3" (
    set "cmd=%cmd% --Target=both"
)