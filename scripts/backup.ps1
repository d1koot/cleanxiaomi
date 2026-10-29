# Saves device info and package lists to %USERPROFILE%\cleanxiaomi-backups
. "$PSScriptRoot\common.ps1"
$adb = Get-Adb
Assert-Device $adb
$dir = Get-BackupDir
$ts = Get-Date -Format "yyyyMMdd-HHmmss"

$info = @(
    "model:   $((& $adb shell getprop ro.product.model).Trim())",
    "android: $((& $adb shell getprop ro.build.version.release).Trim())",
    "hyperos: $((& $adb shell getprop ro.mi.os.version.name).Trim())",
    "miui:    $((& $adb shell getprop ro.miui.ui.version.name).Trim())",
    "region:  $((& $adb shell getprop ro.miui.region).Trim())"
)
$info | Tee-Object -FilePath (Join-Path $dir "device-$ts.txt")

(& $adb shell pm list packages --user 0) | ForEach-Object { $_.Trim() } | Sort-Object |
    Out-File -Encoding utf8 (Join-Path $dir "packages-all-$ts.txt")
(& $adb shell pm list packages -d --user 0) | ForEach-Object { $_.Trim() } | Sort-Object |
    Out-File -Encoding utf8 (Join-Path $dir "packages-disabled-$ts.txt")

Write-Host "Backup saved in $dir ($ts)"
