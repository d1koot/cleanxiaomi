# Shared helpers for the PowerShell scripts. Not run directly.
function Get-Adb {
    $cmd = Get-Command adb -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    foreach ($p in @(".\adb.exe", (Join-Path $PSScriptRoot "..\adb.exe"))) {
        if (Test-Path $p) { return (Resolve-Path $p).Path }
    }
    Write-Host "adb not found. Install Android platform-tools and add it to PATH, or run from its folder."
    exit 1
}

function Assert-Device($adb) {
    $state = (& $adb get-state 2>$null)
    if ("$state".Trim() -ne "device") {
        Write-Host "No authorized device. Run '.\adb devices' and accept the prompt on the phone."
        exit 1
    }
}

function Get-BackupDir {
    $dir = Join-Path $HOME "cleanxiaomi-backups"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    return $dir
}
