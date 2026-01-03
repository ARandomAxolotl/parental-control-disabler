# Parental Control Disabler

A batch script designed to Disable, Enable, or Remove parental control software (Kaspersky Safe Kids and Microsoft Family Safety) from Windows installations.

> \*\*WARNING:\*\* This script is optimized to run in the \*\*Windows Recovery Environment (WinRE)\*\*. Running in a standard session is not recommended.

## Features

* **Targeted Actions:** Disable, Enable, or Remove Kaspersky Safe Kids and Microsoft Family Safety\[cite: 19].
* **Drive Auto-Detection:** Automatically scans drives (C-Z), identifies Windows partitions via labels, and lets you select the target drive.
* **Safety First:** Implements a "rename" strategy for disabling files rather than deleting them, allowing for easy restoration.

## Usage

### Method 1: Interactive Menu (Recommended)

1. Boot into WinRE (Command Prompt).
2. Run the script: `parental\_control\_disabler.cmd`
3. **Configurator:** If `config.txt` is missing, the script will auto-scan your drives. Enter the number corresponding to your Windows drive.
4. **Select Option:**

   * `1` - Disable (Renames files)
   * `2` - Enable (Restores filenames)
   * `3` - Remove (Deletes files - **Double Warning protection**)

### Method 2: Command Line Arguments

Run the script with flags to bypass the menu:
`parental\_control\_disabler.cmd \[ACTION] \[TARGET] \[DEBUG]`

| Flag | Description |
| :--- | :--- |
| \*\*-d\*\* | Disable services |
| \*\*-e\*\* | Enable services |
| \*\*-r\*\* | Remove services |
| \*\*-k\*\* | Target: Kaspersky Safe Kids |
| \*\*-m\*\* | Target: Microsoft Family Safety |
| \*\*-b\*\* | Target: Both |

**Debug Mode:**
Add `-d` as the third argument (e.g., `cmd -d -b -d`) to enable verbose output.

## Configuration

The script stores your selected Windows drive letter in `config.txt`.

* Lines starting with `#` are ignored.
* Format: `windirtoo=\[DriveLetter]`

## Disclaimer

* **Removal Risks:** Option 3 (Remove) permanently deletes files. This is not recommended. The script will warn you twice before proceeding.
* **Microsoft Family Safety:** This service may automatically reinstall itself after Windows Updates.
