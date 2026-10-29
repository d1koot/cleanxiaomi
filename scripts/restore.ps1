# Usage: .\scripts\restore.ps1 -Log "$HOME\cleanxiaomi-backups\changes-YYYYMMDD-HHMMSS.log"
param([Parameter(Mandatory = $true)][string]$Log)
. "$PSScriptRoot\common.ps1"
$adb = Get-Adb
Assert-Device $adb
if (-not (Test-Path $Log)) { Write-Host "Log not found: $Log"; exit 1 }

foreach ($line in Get-Content $Log) {
    $parts = $line.Trim() -split "\s+"
    if ($parts.Count -lt 2) { continue }
    $action = $parts[0]; $pkg = $parts[1]
    switch ($action) {
        "disabled" { & $adb shell pm enable --user 0 $pkg }
        "removed"  { & $adb shell cmd package install-existing $pkg }
    }
}
Write-Host "Restore finished. Reboot the phone."
