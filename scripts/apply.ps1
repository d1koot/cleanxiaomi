# Usage:  .\scripts\apply.ps1 -List .\packages\tier1-ads.txt          (dry run)
#         .\scripts\apply.ps1 -List .\packages\tier1-ads.txt -Yes     (apply)
param(
    [Parameter(Mandatory = $true)][string]$List,
    [switch]$Yes
)
. "$PSScriptRoot\common.ps1"
$adb = Get-Adb
Assert-Device $adb
$dir = Get-BackupDir
if (-not (Get-ChildItem (Join-Path $dir "packages-all-*.txt") -ErrorAction SilentlyContinue)) {
    Write-Host "Run .\scripts\backup.ps1 first."
    exit 1
}

$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$log = Join-Path $dir "changes-$ts.log"
$installed = (& $adb shell pm list packages --user 0) | ForEach-Object { $_.Trim() }

foreach ($line in Get-Content $List) {
    $pkg = ($line -split "#")[0].Trim()
    if (-not $pkg) { continue }
    if ($installed -notcontains "package:$pkg") { Write-Host "skip (not installed): $pkg"; continue }
    if (-not $Yes) { Write-Host "would change: $pkg"; continue }

    $out = (& $adb shell pm disable-user --user 0 $pkg 2>&1) -join " "
    if ($out -match "disabled-user") {
        Write-Host "disabled: $pkg"
        Add-Content $log "disabled $pkg"
    }
    else {
        $out2 = (& $adb shell pm uninstall -k --user 0 $pkg 2>&1) -join " "
        if ($out2 -match "Success") {
            Write-Host "removed for user 0 (reversible): $pkg"
            Add-Content $log "removed $pkg"
        }
        else {
            Write-Host "FAILED: $pkg -> $out2"
        }
    }
}

if ($Yes) { Write-Host "Done. Undo with: .\scripts\restore.ps1 -Log `"$log`"" }
else { Write-Host "Dry run only. Add -Yes to apply." }
