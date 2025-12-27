# Parental Control Disabler / Manager

**⚠️ DISCLAIMER: USE AT YOUR OWN RISK.**
This tool modifies system files and directories within Windows (`System32` and `Program Files`). Improper use may result in system instability. This project is for educational purposes.

## Overview

This project is a Batch script utility designed to manage (Disable, Enable, or Remove) specific parental control applications on Windows. [cite_start]It is specifically designed to run within the **Windows Recovery Environment (WinRE)** to bypass file locks and permissions that exist during a normal Windows session.

The tool targets:
1.  **Kaspersky Safe Kids**
2.  **Microsoft Family Safety** (`wpcmon.exe`)

## Project Structure

* **`run.cmd`**
    * **The Main Launcher.** Run this file first.
    * It allows you to choose between the original human-written script or the AI-debugged version.
* **`parental_control_disabler(witten by me but debugged by AI).cmd`**
    * **Recommended.** A refined version of the script. It uses `choice` commands for better input handling, has cleaner logic, and improved error handling.
* **`parental_control_disabler(witten by me).cmd`**
    * **Legacy.** The original human-written version of the script.

## Features

* **Session Detection:** Automatically detects if you are running in a normal Windows session and suggests rebooting into WinRE.
* **Toggle Functionality:**
    * **Disable:** Renames executable files/folders so the services cannot start (e.g., adds "rename" or changes `.exe` to `1.exe`).
    * **Enable:** Restores original filenames to re-enable the software.
* **Removal:** Deletes the target folders/files completely (Not recommended as they may return after updates).
* **Configuration Persistence:** Saves your Windows drive letter to `config.txt` so you don't have to re-enter it every time.

## How to Use

### 1. Boot into Windows Recovery Environment (WinRE)
This script modifies system files that are locked while Windows is running. You must be in the Command Prompt of the Recovery Environment.
1.  Hold **Shift** and press **Restart** in Windows.
2.  Go to **Troubleshoot** > **Advanced Options** > **Command Prompt**.

### 2. Running the Script
1.  Navigate to the folder where these scripts are saved.
2.  Run the launcher:
    ```cmd
    run.cmd
    ```
3.  Select which version of the script you want to run (AI-debugged is recommended).

### 3. Configuration (Drive Letter)
In WinRE, drive letters often change (e.g., your C: drive might show up as D:).
* On the first run, the script will launch the **Configurator**.
* It will open Notepad to help you check "This PC" and identify the correct drive letter containing the `Windows` folder.
* Enter **only** the letter (e.g., `C` or `D`).

### 4. Interactive Menu
Follow the on-screen prompts to:
1.  Select an Action: **Disable**, **Enable**, or **Remove**.
2.  Select a Target: **Kaspersky**, **Microsoft Family**, or **Both**.

## Command Line Arguments (Advanced)

[cite_start]You can bypass the menu by passing arguments directly to the script[cite: 3, 14].

**Syntax:** `script.cmd [ACTION] [TARGET] [--debugon]`

| Flag | Description |
| :--- | :--- |
| **Actions** | |
| `-d` | **Disable** parental controls. |
| `-e` | **Enable** parental controls. |
| `-r` | **Remove** parental controls (Destructive). |
| **Targets** | |
| `-m` | Target **Microsoft** Family Safety. |
| `-k` | Target **Kaspersky** Safe Kids. |
| `-b` | Target **Both**. |
| **Debug** | |
| `--debugon`| Enables verbose echo for debugging purposes. |

**Example:**
To disable Microsoft Family Safety immediately:
```cmd
"parental_control_disabler(witten by me but debugged by AI).cmd" -d -m
