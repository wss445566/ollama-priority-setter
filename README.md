# Ollama Priority Setter

This project is a simple application that utilizes the Windows API to monitor processes and change the priority of a specific process to idle. The application runs in the system tray and automatically checks for the "ollama.exe" process every 5 seconds, changing its priority to idle if found.

## Features

- Runs in the system tray without a user interface.
- Monitors running processes on the system.
- Finds the "ollama.exe" process.
- Changes the priority of the "ollama.exe" process to idle.

## Requirements

- Windows operating system
- MinGW (Minimalist GNU for Windows)

## Building the Project

To build the project, navigate to the project directory and run the following command:

```sh
x86_64-w64-mingw32-gcc src/main.c -o ollama-priority-setter.exe -lkernel32 -luser32 -lpsapi -mwindows
````

This will compile the source code and create the executable.

## Running the Application

After building the project, you can run the application by executing the generated `ollama-priority-setter.exe` file. The application will run in the system tray and automatically monitor the "ollama.exe" process.

## Usage

1. Run the `ollama-priority-setter.exe` application.
2. The application will check for the "ollama.exe" process every 5 seconds and change its priority to idle if found.
3. Right-click the system tray icon to exit the application.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.