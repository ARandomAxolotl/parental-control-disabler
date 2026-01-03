# Changelog

## \[New Version] - parental\_control\_disabler.cmd

### Added

* **UTF-8 Support:** Added `chcp 65001` to ensure special characters (like the new borders) render correctly.
* **Auto-Configurator:** Replaced the manual Notepad interaction. The script now iterates through drive letters (C-Z), uses `wmic` to find volume labels, and allows the user to select the Windows drive from a numbered list.
* **Visuals:** Implemented ASCII box-drawing characters (e.g., `╭───╮`) for menus and headers.
* **Safety Protocols:** Added a "Double Warning" system for the Removal option. Users must now confirm the action twice.
* **Debug Indicators:** Added explicit `\\\[DEBUG MODE ENABLED]` output when the `-d` flag is active.
* **Environment Check:** Added specific logic to detect if `explorer.exe` is *not* running to immediately proceed to configuration, optimizing for WinRE.

### Changed

* **Menu Input:** Switched from the `choice` command to `set /p` for capturing user input in the main menu and target selection.
* **Flow Control:** Refactored execution logic. \[cite\_start]Replaced `call :subroutine` with `goto` statements and specific return labels (e.g., `:ReturnFromRemoveKaspersky`).
* **Argument Parsing:** Updated argument parsing syntax for cleaner readability and stricter debug flag checking (`-d` instead of `--debugon`).

### Removed

* **Manual Config:** Removed the logic that opened Notepad to ask the user to type their drive letter manually.
* **Old Restart Logic:** Modified the restart prompt to use standard input rather than the `choice` command.
