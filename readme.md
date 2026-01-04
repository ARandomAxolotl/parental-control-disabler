# Parental Control Disabler

This batch script is designed to **Disable**, **Enable**, or **Remove** parental control software—specifically **Kaspersky Safe Kids** and **Microsoft Family Safety**\[cite: 13, 14]. It operates by renaming or deleting core system files on a target Windows partition.

> \[!WARNING]
> This script is intended to run in the \*\*Windows Recovery Environment (WinRE)\*\*. Running it within a normal Windows session may cause permission issues or fail to target the correct system files.

---

## 🚀 Features

* **Targeted Actions**: Choose between disabling (renaming), enabling (restoring), or completely removing software.
* **Multi-Software Support**: Works with Kaspersky Safe Kids 23.0 and Microsoft Family Safety (`wpcmon.exe`).
* **Automatic Configuration**: Scans all available drives (C-Z) to locate your Windows installation.
* **CLI \& TUI Support**: Use command-line arguments for automation or a text-based menu for manual use.

---

## 🛠 Usage

### 1\. Preparation (WinRE)

The script checks if `explorer.exe` is running. If it is, the script will offer to restart your computer into the **Recovery Options** (`shutdown /r /o /t 00`).

### 2\. Configuration

Upon first run, the "Configurator" will list all detected Windows installations.

1. Select the number corresponding to your Windows drive.
2. The selection is saved to `config.txt` as the variable `windirtoo`.

### 3\. Command Line Arguments

You can bypass the menus by providing arguments in the following format:
`parental\_control\_disabler.cmd \[option] \[target] \[flags]`

| Argument | Description | \[cite] |
| :--- | :--- | :--- |
| \*\*Options\*\* | `-d` (Disable), `-e` (Enable), `-r` (Remove) |  |
| \*\*Targets\*\* | `-m` (Microsoft), `-k` (Kaspersky), `-b` (Both) |
| \*\*Flags\*\* | `--no-preserve` (Skip removal warnings), `--skip-check-environment` |
| \*\*Debug\*\* | `--verbose` or `-d` |

**Example:**
`parental\_control\_disabler.cmd -d -b` (Disables both services)

---

## ⚠️ Important Safety Notes

* **Removal is High Risk**: I do **not** recommend the removal option. Disabling (renaming) is the safer alternative as it is easily reversible.
* **Microsoft Family Safety**: Deleting `wpcmon.exe` is highly discouraged; the script will prompt for confirmation twice before attempting deletion.
* **Data Integrity**: Ensure you select the correct drive letter in the configurator to avoid modifying the wrong partition.

---

## 📂 File Structure

* `parental\_control\_disabler.cmd`: The main execution script.
* `config.txt`: Generated file storing the targeted Windows drive (`windirtoo`).
