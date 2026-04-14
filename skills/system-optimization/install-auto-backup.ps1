# ═══════════════════════════════════════════════════════════════
# Install AUTO-BACKUP as a daily scheduled task
# Right-click → "Run as Administrator"
# ═══════════════════════════════════════════════════════════════

# Auto-elevate
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Elevating to Administrator..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Clear-Host
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  INSTALLING AUTO-BACKUP (daily 6:00 PM)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$taskName = "Auto-Backup-Projects"
$scriptPath = "C:\Users\mazen\auto-backup.ps1"

if (-not (Test-Path $scriptPath)) {
    Write-Host "ERROR: $scriptPath not found!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Remove existing task if it exists
$existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "Removing existing task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Build the task
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

# Trigger: every day at 6:00 PM
$trigger = New-ScheduledTaskTrigger -Daily -At "6:00 PM"

# Settings: wake up laptop if sleeping, retry if missed
$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -WakeToRun `
    -RunOnlyIfNetworkAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 15) `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries

$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive

Register-ScheduledTask `
    -TaskName $taskName `
    -Description "Auto-commits and pushes all git repos in D:\Projects daily" `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Principal $principal | Out-Null

Write-Host ""
Write-Host "✓ TASK INSTALLED" -ForegroundColor Green
Write-Host ""
Write-Host "  Name:    $taskName" -ForegroundColor White
Write-Host "  Runs:    Every day at 6:00 PM" -ForegroundColor White
Write-Host "  Script:  $scriptPath" -ForegroundColor White
Write-Host "  Log at:  D:\Projects\.auto-backup.log" -ForegroundColor White
Write-Host ""
Write-Host "  The task will:" -ForegroundColor Cyan
Write-Host "    • Check all git repos in D:\Projects" -ForegroundColor Gray
Write-Host "    • Auto-commit any uncommitted changes" -ForegroundColor Gray
Write-Host "    • Push to GitHub" -ForegroundColor Gray
Write-Host "    • Skip files containing secrets (.env, keys, passwords)" -ForegroundColor Gray
Write-Host "    • Skip repos with merge conflicts" -ForegroundColor Gray
Write-Host "    • Wake the laptop from sleep if needed" -ForegroundColor Gray
Write-Host ""
Write-Host "  Want to test it right now? [Y/N]" -ForegroundColor Yellow
$response = Read-Host

if ($response -eq 'Y' -or $response -eq 'y') {
    Write-Host ""
    Write-Host "  Running auto-backup now..." -ForegroundColor Cyan
    Start-ScheduledTask -TaskName $taskName
    Start-Sleep -Seconds 3
    Write-Host "  Task started. Check D:\Projects\.auto-backup.log for results." -ForegroundColor Green
}

Write-Host ""
Write-Host "  To change the time:  Task Scheduler → Task Scheduler Library → Auto-Backup-Projects" -ForegroundColor Gray
Write-Host "  To remove:           powershell -Command ""Unregister-ScheduledTask -TaskName '$taskName' -Confirm:`$false""" -ForegroundColor Gray
Write-Host ""
Write-Host "  Press any key to close..." -ForegroundColor Cyan
[void][System.Console]::ReadKey($true)
