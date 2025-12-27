@echo off
if not exist "parental_control_disabler(witten by me).cmd" ( 
echo The legacy version is NOT detected, launching the AI-debugged version  
call "parental_control_disabler(witten by me but debugged by AI).cmd"
goto :eof
)
if not exist "parental_control_disabler(witten by me but debugged by AI).cmd" ( 
echo The AI-debugged version is NOT detected, launching the LEGACY version  
call "parental_control_disabler(witten by me).cmd"
goto :eof
)
choice /m "Do you want to launch script witten by me but debugged by AI(it will performs better)?"
if errorlevel 2 "parental_control_disabler(witten by me).cmd"
if errorlevel 1 "parental_control_disabler(witten by me but debugged by AI).cmd"
