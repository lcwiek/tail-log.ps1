<#
    File:        tail-log.ps1
    Company:     //coding.lifestyle Studio
    Description: Lightweight PowerShell log tailing utility with rotation handling
    License:     MIT License

    © 2025 //coding.lifestyle Studio. Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the “Software”), to deal in the Software without
    restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute,
    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished
    to do so, subject to the following conditions:

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.

    Project repository: https://github.com/lcwiek/tail-log.ps1
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$LogPath
)

# Check if the file exists
if (-not (Test-Path $LogPath)) {
    Write-Host "File does not exist: $LogPath"
    exit 1
}

Write-Host "Monitoring file: $LogPath`n"

$lastSize = 0

while ($true) {
    if (Test-Path $LogPath) {
        $file = [System.IO.File]::Open($LogPath, 'Open', 'Read', [System.IO.FileShare]::ReadWrite)
        $reader = New-Object System.IO.StreamReader($file)

        if ($lastSize -gt $file.Length) {
            Write-Host "`n--- File was rotated ---`n"
            $file.Seek(0, 'Begin') | Out-Null
        } else {
            $file.Seek($lastSize, 'Begin') | Out-Null
        }

        while (-not $reader.EndOfStream) {
            $line = $reader.ReadLine()
            Write-Output $line
        }

        $lastSize = $file.Position

        $reader.Close()
        $file.Close()
    } else {
        Write-Host "`nFile not found. Waiting..."
        $lastSize = 0
    }

    Start-Sleep -Milliseconds 200
}
