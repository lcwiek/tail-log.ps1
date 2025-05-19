# tail-log.ps1

## Description

`tail-log.ps1` is a PowerShell script that safely monitors a log file in real-time on Windows without locking the file. It gracefully handles file overwrites or rotations (e.g., by logging services like WinSW).

## Features

- Non-blocking file access
- Handles file overwrite/rotation
- Displays only new appended lines
- Detects file deletion/reappearance
- No need to modify source applications

## Requirements

- PowerShell 5.1 or newer
- Windows OS
- No external dependencies

## Usage

```powershell
.	ail-log.ps1 -LogPath "C:\Logs\app.log"
```

The script will:

1. Show only new lines added to the file,
2. Print entire file if it's rotated (size shrinks),
3. Notify if the file disappears and wait for it to reappear.

### Example `.bat` launcher

```bat
@echo off
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "tail-log.ps1" -LogPath "C:\Logs\app.log"
```

## License

MIT (see LICENSE file if provided)
