echo ╭─────────────────────────────────╮
echo ^│        Executing......                                          ^│
echo ╰─────────────────────────────────╯
if "%Debuglevel%" gtr 0 echo [DEBUG] Starting execution prase...
:: Check for Removal Option (High Risk)
if "%~1"=="--remove" (
    echo You are about to remove parental control apps.
    echo I DO NOT RECOMMEND THIS OPTION. I RECOMMEND DISABLING THEM.
    echo DO WITH CAUTION.
    
    choice /m "Do you wish to remove?"
    if errorlevel 2 exit /b 1
    if errorlevel 1 goto :RemovalWarning2
)
if "%~1"=="--disable" ( goto :ActionDisable )
if "%~1"=="--enable" ( goto :ActionEnable )
if "%~1"=="--stop" ( goto :ActionStop )

:RemovalWarning2
echo THIS IS THE LAST WARNING.
choice /m "Do you wish to remove?"
if errorlevel 2 exit /b 1
if errorlevel 1 goto :ActionRemove

:ActionRemove
echo REMOVING...
:: Kaspersky Removal
if "%~2"=="--target:kas" goto :RemoveKaspersky
if "%~2"=="--target:both" goto :RemoveKaspersky
:ReturnFromRemoveKaspersky

:: MS Family Safety Removal
if "%~2"=="--target:ms" goto :RemoveMicrosoft
if "%~2"=="--target:both" goto :RemoveMicrosoft
:ReturnFromRemoveMicrosoft
exit /b

:RemoveKaspersky
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
    rmdir /s /q "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" 
    echo Kaspersky Safe Kids removed.
) else ( 
    echo Kaspersky Safe Kids not found on drive %windirtoo%. 
)
if "%~2"=="--target:kas" exit /b
if "%~2"=="--target:both" goto :ReturnFromRemoveKaspersky

:RemoveMicrosoft
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
    echo Deleting Microsoft Family Safety is not recommended.
    del /p "%windirtoo%:\Windows\System32\wpcmon.exe"
) else ( 
    echo Microsoft Family Safety not found on drive %windirtoo%.
)
if "%~2"=="--target:ms" exit /b
if "%~2"=="--target:both" goto :ReturnFromRemoveMicrosoft

:ActionDisable
echo DISABLING...
:: Kaspersky Disable
if "%~2"=="--target:kas" goto :DisableKaspersky
:: idk but i added this for debug a random bug in batch
if "%~2"=="--target:both" goto :DisableKaspersky
:ReturnFromDisableKaspersky

:: MS Family Safety Disable
if "%~2"=="--target:ms" goto :DisableMicrosoft
if "%~2"=="--target:both" goto :DisableMicrosoft
:ReturnFromDisableMicrosoft
exit /b

:DisableKaspersky
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" (
    rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0" "Kaspersky Safe Kids 23.0 rename"
    echo Kaspersky disabled (renamed^).
) else ( 
    echo Kaspersky Safe Kids not found or already renamed on drive %windirtoo%
)
if "%~2"=="--target:kas" exit /b
if "%~2"=="--target:both" goto :ReturnFromDisableKaspersky

:DisableMicrosoft
if exist "%windirtoo%:\Windows\System32\wpcmon.exe" ( 
    rename "%windirtoo%:\Windows\System32\wpcmon.exe" wpcmon1.exe
    echo Microsoft Family Safety disabled (renamed^)
) else ( 
    echo Microsoft Family Safety not found or already renamed on drive %windirtoo%
)
if "%~2"=="--target:ms" exit /b
if "%~2"=="--target:both" goto :ReturnFromDisableMicrosoft

:ActionEnable
echo ENABLING...
:: Kaspersky Enable
if "%~2"=="--target:kas" goto :EnableKaspersky
if "%~2"=="--target:both" goto :EnableKaspersky
:ReturnFromEnableKaspersky

:: MS Family Safety Enable
if "%~2"=="--target:ms" goto :EnableMicrosoft
if "%~2"=="--target:both" goto :EnableMicrosoft
:ReturnFromEnableMicrosoft
exit /b

:EnableKaspersky
if exist "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" (
    rename "%windirtoo%:\Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0 rename" "Kaspersky Safe Kids 23.0"
    echo Kaspersky enabled.
) else ( 
    echo Kaspersky backup folder not found on drive %windirtoo%.
)
if "%~2"=="--target:kas" exit /b
if "%~2"=="--target:both" goto :ReturnFromEnableKaspersky

:EnableMicrosoft
if exist "%windirtoo%:\Windows\System32\wpcmon1.exe" ( 
    rename "%windirtoo%:\Windows\System32\wpcmon1.exe" wpcmon.exe
    echo Microsoft Family Safety enabled.
) else ( 
    echo Microsoft Family Safety backup file not found on drive %windirtoo%.
)
if "%~2"=="--target:ms" exit /b
if "%~2"=="--target:both" goto :ReturnFromEnableMicrosoft
exit /b

:ActionStop
if not "%~2"=="--target:ms" (
    echo I can only stop Microslop Family Safety
    exit /b
)
:RetryStop
echo Stopping requires you to have Admin acess
echo This will create another cmd window.
powershell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d \"%cd%\scripts\" && stop.cmd' -Verb RunAs"
if "%ERRORLEVEL%"=="1" (
    choice /c YN /m "Do you want to retry? : "
    if errorlevel 2 exit /b 1
    if errorlevel 1 goto RetryStop
)

 

