##### **Overview**

###### **This script is designed to assist in temporarily disabling certain parental control features on Windows, including:**

* Temporarily disabling Kaspersky Safe Kids.
* Gaining access to the Command Prompt from the login screen to disable Microsoft Family Safety or grant administrative privileges.



###### **Requirements**

* This script file must be run from the Windows Recovery Environment (WinRE).
* WinRE can be accessed by holding the Shift key and clicking the Restart option from the Windows Start menu.



###### **How to Use**

* Access the Windows Recovery Environment (WinRE)
* Hold the Shift key and click Restart from the Start menu.
* This will take you to the advanced boot options screen.
* Open Command Prompt
* Select Troubleshoot -> Advanced options -> Command Prompt.
* Identify Your Windows Drive
* Use the notepad command to open Notepad, then go to File -> Open.
* Browse the drives to find the one containing the Windows folder. This is your Windows drive.
* Note: In the recovery environment, your Windows drive may not be C:. 
* Run the Script
* Once you have identified your Windows drive, you can run this script from the Command Prompt.
* In the script, replace 
* E: with your Windows drive letter (e.g., C:). 
* Type the full path to the script file and press Enter. For example: D:\\parental\_control\_disabler.cmd if you saved the script on drive D.



###### **How the Script Works**

* The script functions by renaming the executable files of the parental control programs, preventing them from launching normally.
* Kaspersky Safe Kids: It renames safekids.exe to safekids1.exe and safekidsui.exe to safekidsui1.exe.
* Unlocking the Command Prompt: It replaces the sethc.exe (Sticky Keys) file with cmd.exe. When you press the 
* Shift key 5 or more times on the login screen, the Command Prompt will appear. This allows you to perform tasks such as:
* Running services.msc to disable parental control services.
* Running netplwiz to grant admin privileges.
* Reverting Changes: The script also includes commands to undo all changes, restoring the original filenames and deleting the copied cmd.exe file.



###### **Warning and Disclaimer**

* Use this script with caution.
* It can cause system instability if you dont do it right.
* I am not responsible for any damage caused by the use of this script.



###### **Important Warning for Script Modification**

* This script is a powerful tool designed for a specific purpose. Modifying this script without a complete understanding of Windows system files and batch scripting can lead to unintended consequences, including:
* System Instability: Incorrect commands can corrupt system files, making your operating system unstable or unbootable.
* Loss of Data: Errors in the script could potentially lead to data loss.
* Security Vulnerabilities: Modifying the script incorrectly might create security loopholes on your system.
* Unexpected Behavior: The script may fail to function as intended or cause other programs to malfunction.
* It is highly recommended that you do not modify this script unless you are an experienced user with a full understanding of the potential risks. Always back up your important data before running any system-level scripts.



##### **I was too lazy so i use AI to generate this readme.**


