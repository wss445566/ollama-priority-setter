# Ollama Priority Setter

This project is a simple application that utilizes the Windows API to monitor processes and change the priority of a specific process to idle. The application runs in the system tray and automatically checks for the "ollama.exe" process every 5 seconds, changing its priority to idle if found.

## Features

- Runs in the system tray without a user interface.
- Monitors running processes on the system.
- Finds the "ollama.exe" process.
- Changes the priority of the "ollama.exe" process to idle.

## Requirements

- Windows operating system
- MASM (Microsoft Macro Assembler)

## Building the Project

To build the project, navigate to the project directory and run the following command:

```sh
ml /c /coff src/main.asm
link /subsystem:windows /out:ollama-priority-setter.exe main.obj kernel32.lib user32.lib psapi.lib