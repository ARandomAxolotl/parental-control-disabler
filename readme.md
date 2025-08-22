###### **OVERVIEW**

*This script is designed to temporarily disable certain parental control features on Windows. Specifically, it can:*

*Temporarily disable Kaspersky Safe Kids.*

*Access the Command Prompt from the login screen to disable Microsoft Family Safety or grant administrative privileges.*



###### **REQUIREMENTS**

*This script must be run from the Windows Recovery Environment (WinRE).*



###### **HOW TO USE**

*Access WinRE:*

* Hold the Shift key and click the Restart button from the Windows Start menu.
* You will be taken to the advanced boot options screen.

*Open Command Prompt:*

* Select Troubleshoot -> Advanced options -> Command Prompt.

*Identify Your Windows Drive:*

* Open Notepad with the notepad command.
* Go to the File -> Open menu.
* Browse the drives to find the one that contains the Windows folder. This is your Windows drive.

***Note: In the recovery environment, your Windows drive may not be C:.***

*Run the Script:*

* Once you have identified your Windows drive, you can run this script from the Command Prompt.
* Replace C: with your Windows drive letter.
* Type the full path to the script file and press Enter. For example: D:\\parental\_control\_disabler.cmd.



###### **OVERVIEW OF ARGUMENTS**

*Here are the command-line arguments you can use with this script:*

* /do: Executes commands to disable parental controls.
* /undo: Reverts all changes made.
* /showreadme: Opens the README.md file in Notepad so you can read the instructions.
* /on: Turns on debug mode. Use this as a second argument (e.g., script\_name.cmd /do /on).
* /off: Turns off debug mode. Use this as a second argument (e.g., script\_name.cmd /do /off).
* No arguments : Displays instructions and help on how to use the script.



###### **HOW THE SCRIPT WORKS**

* Disabling Kaspersky Safe Kids: The script renames the entire Kaspersky installation folder to prevent the application from launching.
* Unlocking the Command Prompt: The script replaces the sethc.exe (Sticky Keys) file with cmd.exe. When you press the Shift key 5 or more times on the login screen, the Command Prompt will appear. This allows you to:
* Run services.msc to disable parental control services.
* Run netplwiz to grant administrator privileges.
* Reverting Changes: The script includes commands to undo all changes, restoring the original filenames and deleting the copied cmd.exe file.



###### **WARNING \& DISCLAIMER**

* Use this script with caution. It can cause system instability if not executed correctly. 
* I am not responsible for any damage caused by the use or modification of this script.



###### **IMPORTANT WARNING FOR SCRIPT MODIFICATION**

*This is a powerful tool designed for a specific purpose. Modifying this script without a complete understanding of Windows system files and batch scripting can lead to unintended consequences, including:*

* System Instability: Incorrect commands can corrupt system files, making your operating system unstable or unbootable.
* Data Loss: Errors in the script could potentially lead to data loss.
* Security Vulnerabilities: Incorrectly modifying the script might create security loopholes on your system.
* Unexpected Behavior: The script may fail to function as intended or cause other programs to malfunction.

###### **It is highly recommended that you back up all important data before running any system-level scripts.**


