@echo off
if not exist "parental_control_disabler(witten by me).cmd" ( 
echo The legacy version is NOT detected, launching the AI-debugged version  
"parental_control_disabler(witten by me but debugged by AI).cmd"
)
if not exist "parental_control_disabler(witten by me but debugged by AI).cmd" ( 
echo The AI-debugged version is NOT detected, launching the LEGACY version  
"parental_control_disabler(witten by me).cmd"
)
choice /m "Do you want to launch script witten by me but debugged by AI(it will performs better)?"
if errorlevel 2 "parental_control_disabler(witten by me).cmd"
if errorlevel 1 "parental_control_disabler(witten by me but debugged by AI).cmd"
