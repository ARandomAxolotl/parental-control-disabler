echo off
echo Make sure you boot to windows recovery environment(shift + restart) to make this work!
echo Use the command promt in the advanced option
echo Run this file
pause
:: Change this E: to your Windows disk drive
:: You can use notepad to see your Windows disk drive
:: In some cases, it isn't C:
E:
cd Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0\
rename safekidsui.exe safekidsui1.exe
rename safekids.exe safekids1.exe
cd ..
cd ..
cd ..
cd Windows\System32
ren sethc.exe sethc1.exe
copy cmd.exe sethc.exe
ren wpcmon.exe wpcmon1.exe
echo You can close the command promt now
echo Press any key on your keyboard will undo the step
echo 
echo If you want to disable Microsoft family safety, go to the login screen
echo -> Press the shift(or control/alt) key 5(or more) time
echo -> Command promt should appear
echo -> Type "services.msc" 
echo -> Find and disable the parental controls services
ehco 
echo If you want to grant admin
echo -> Press the shift(or control/alt) key 5(or more) time
echo -> Command Promt should appear
echo -> Type netplwiz
pause
cd ..
cd ..
cd Program Files (x86)\Kaspersky Lab\Kaspersky Safe Kids 23.0\
rename safekidsui1.exe safekidsui.exe
rename safekids1.exe safekids.exe
cd ..
cd ..
cd ..
cd Windows\System32
del sethc.exe
ren sethc1.exe sethc.exe
ren wpcmon1.exe wpcmon.exe