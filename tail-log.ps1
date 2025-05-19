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

$dir = Split-Path $LogPath
$file = Split-Path $LogPath -Leaf

Write-Host "Monitoring file: $LogPath`n"

$previousLength = 0

while ($true) {
    if (Test-Path $LogPath) {
        # Read the entire file content as a single string
        $currentContent = Get-Content $LogPath -Raw
        $currentLength = $currentContent.Length

        if ($currentLength -lt $previousLength) {
            # The file was overwritten or rotated
            Write-Host "`n--- File was rotated ---`n"
            Write-Output $currentContent
        }
        elseif ($currentLength -gt $previousLength) {
            # Display only new content added since last check
            $newData = $currentContent.Substring($previousLength)
            Write-Output $newData
        }

        $previousLength = $currentLength
    } else {
        # File not found (possibly deleted or rotated)
        Write-Host "`nFile disappeared. Waiting for it to reappear..."
        $previousLength = 0
    }

    Start-Sleep -Milliseconds 200
}
