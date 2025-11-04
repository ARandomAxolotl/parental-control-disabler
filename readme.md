### **Parental Control Disabler Script**

##### **⚠️ SERIOUS WARNING ⚠️**

This script is designed to modify core Windows system files and disable security software. Misuse can cause system instability or create severe security vulnerabilities.

* **DO NOT** run this script if you do not fully understand what it does.
* The author is not responsible for any damage to your system.

**Overview**

This batch script is designed to disable (or re-enable) two parental control programs:

1. **Kaspersky Safe Kids**
2. **Microsoft Family Safety**

It does this by renaming critical executable files and installation directories to prevent them from launching.

### **‼️ MANDATORY REQUIREMENTS ‼️**

1. **Windows Recovery Environment (WinRE):** This script **MUST** be run from the Windows Recovery Environment (WinRE). It will not work in a normal Windows session due to file-in-use and permission restrictions.

   * You can enter WinRE by holding Shift while clicking Restart from the Start menu, then navigating to Troubleshoot > Advanced options > Command Prompt.

2. **Administrator Privileges:** You need administrative rights. The command prompt in WinRE typically runs with SYSTEM privileges, which is sufficient.
3. **Script Location:** It is recommended to place this script on a USB drive and run it from there within WinRE.

## **How to Use**

1. Save the parental\_control\_disabler.cmd file to a USB drive.
2. Boot the target computer into **WinRE** and open the **Command Prompt**.
3. In the Command Prompt, identify your drive letters. They may be different in WinRE (e.g., your Windows drive might be D: and your USB E:).

   * You can use the diskpart command, followed by list volume, to see your drives.

4. Navigate to your USB drive (e.g., E:).
5. Run the script by typing its name:  
   parental\_control\_disabler.cmd

#### **Usage Options**

##### **1. Interactive Menu (Recommended)**

If you run the script with no arguments (parental\_control\_disabler.cmd), an interactive menu will appear:

1. **Choose action:**

   * 1 - (disable)
   * 2 - (enable)

2. **Choose target:**

   * 1 - (Kaspersky Safe Kids)
   * 2 - (Microsoft Family Safety)
   * 3 - (Both)

The script will perform the corresponding action based on your selections.

##### **2. Command-Line Arguments**

You can also run the script with arguments to perform a specific action immediately:

* --disablekaspersky: Disables Kaspersky Safe Kids.
* --disablemicrosoftfamilysafely: Disables Microsoft Family Safety (and installs the sethc.exe backdoor).
* --disableboth: Disables both.
* --enablekaspersky: Re-enables Kaspersky Safe Kids.
* --enablemicrosoftfamilysafely: Re-enables Microsoft Family Safety (and removes the sethc.exe backdoor).
* --enableboth: Re-enables both.
* --debugon: (Use as the second argument) Runs the script with debug mode (echo on).

**Example:**

parental\_control\_disabler.cmd --disableboth

parental\_control\_disabler.cmd "" --debugon

parental\_control\_disabler.cmd --enableboth --debugon

#### **Technical Details (What does this script do?)**

##### **Disable Microsoft Family Safety (:domic)**

1. Navigates to Windows\\System32.
2. Renames wpcmon.exe (Windows Parental Controls Monitor) to wpcmon1.exe to disable it.
3. Renames sethc.exe (the Sticky Keys program) to sethc1.exe.
4. Copies cmd.exe (Command Prompt) and names it sethc.exe.

   * **Consequence:** This creates a "backdoor." From the Windows login screen, pressing the Shift key 5 times will open a Command Prompt with SYSTEM privileges instead of Sticky Keys.

#### **Re-enable Microsoft Family Safety (:undomic)**

1. Navigates to Windows\\System32.
2. Deletes the copied sethc.exe (which is cmd.exe).
3. Renames sethc1.exe back to sethc.exe (restoring Sticky Keys).
4. Renames wpcmon1.exe back to wpcmon.exe (re-enabling monitoring).

#### **Disable Kaspersky Safe Kids (:dokas)**

1. Navigates to Program Files (x86)\\Kaspersky Lab\\.
2. Renames the Kaspersky Safe Kids 23.0 directory to Kaspersky Fuck Kids.

   * **Consequence:** The OS and Kaspersky services will be unable to find the program's executables, preventing it from launching.

##### **Re-enable Kaspersky Safe Kids (:undokas)**

1. Navigates to Program Files (x86)\\Kaspersky Lab\\.
2. Renames the Kaspersky Fuck Kids directory back to Kaspersky Safe Kids 23.0.
