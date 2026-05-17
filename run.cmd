@echo off
:: Initialize environment and set code page to UTF-8
setlocal EnableDelayedExpansion
chcp 65001 >nul 
set CurrentVersion=2
echo #################################### >nul
echo CHANGE THIS VERSION INFO AFTER AN UPDATE >nul
echo #################################### >nul
:: Capture the Escape character for potential coloring
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

call "%~dp0parental_control_disabler.cmd" %*