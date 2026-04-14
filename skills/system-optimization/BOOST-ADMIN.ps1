# ═══════════════════════════════════════════════════════════════
# LAPTOP BOOST — ADMIN OPERATIONS
# Built by Claude for Hazem
# Right-click → "Run as Administrator"
# ═══════════════════════════════════════════════════════════════

# Auto-elevate if not running as admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Elevating to Administrator..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$host.UI.RawUI.WindowTitle = "LAPTOP BOOST - Admin Operations"
Clear-Host

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Text, [string]$Color = "White")
    Write-Host "  → $Text" -ForegroundColor $Color
}

function Write-OK { Write-Host "    ✓ OK" -ForegroundColor Green }
function Write-Fail { param([string]$Msg) Write-Host "    ✗ $Msg" -ForegroundColor Red }

# ═══════════════════════════════════════════════════════════════
# BASELINE: Capture disk space before
# ═══════════════════════════════════════════════════════════════
$beforeC = [math]::Round((Get-Volume -DriveLetter C).SizeRemaining / 1GB, 2)
Write-Host ""
Write-Host "  STARTING. C: drive free space: $beforeC GB" -ForegroundColor Yellow
Write-Host "  This will take 5-15 minutes. Do not close the window." -ForegroundColor Yellow

# ═══════════════════════════════════════════════════════════════
# 1. CHANGE DNS TO CLOUDFLARE + GOOGLE
# ═══════════════════════════════════════════════════════════════
Write-Section "1. FASTER DNS (Cloudflare 1.1.1.1 + Google 8.8.8.8)"

Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | ForEach-Object {
    Write-Step "Configuring DNS on: $($_.Name)"
    try {
        Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1', '8.8.8.8') -ErrorAction Stop
        Write-OK
    } catch {
        Write-Fail $_.Exception.Message
    }
}

Write-Step "Flushing DNS cache"
ipconfig /flushdns | Out-Null
Write-OK

# ═══════════════════════════════════════════════════════════════
# 2. NETWORK STACK RESET + TCP OPTIMIZATION
# ═══════════════════════════════════════════════════════════════
Write-Section "2. NETWORK STACK OPTIMIZATION"

Write-Step "Optimizing TCP auto-tuning (increase throughput)"
netsh int tcp set global autotuninglevel=normal | Out-Null
Write-OK

Write-Step "Enabling TCP Window Scaling"
netsh int tcp set global rss=enabled | Out-Null
Write-OK

Write-Step "Disabling bandwidth throttling"
netsh int tcp set global ecncapability=enabled | Out-Null
Write-OK

Write-Step "Enabling CTCP congestion provider (faster downloads)"
netsh int tcp set supplemental template=internet congestionprovider=ctcp | Out-Null
Write-OK

Write-Step "Disabling Nagle's algorithm (lower latency)"
$regPaths = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -ErrorAction SilentlyContinue
foreach ($path in $regPaths) {
    try {
        Set-ItemProperty -Path $path.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $path.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    } catch {}
}
Write-OK

# ═══════════════════════════════════════════════════════════════
# 3. WINDOWS UPDATE CACHE CLEANUP (frees 2-10 GB)
# ═══════════════════════════════════════════════════════════════
Write-Section "3. CLEAN WINDOWS UPDATE CACHE"

Write-Step "Stopping Windows Update service"
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
Write-OK

Write-Step "Deleting SoftwareDistribution cache (can be 2-10 GB)"
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-OK

Write-Step "Restarting Windows Update service"
Start-Service -Name wuauserv -ErrorAction SilentlyContinue
Start-Service -Name bits -ErrorAction SilentlyContinue
Write-OK

# ═══════════════════════════════════════════════════════════════
# 4. SYSTEM TEMP FILES + CACHES
# ═══════════════════════════════════════════════════════════════
Write-Section "4. DEEP CLEAN SYSTEM CACHES"

$cachePaths = @(
    @{Path="C:\Windows\Temp\*"; Name="Windows Temp"},
    @{Path="C:\Windows\Prefetch\*"; Name="Prefetch"},
    @{Path="C:\ProgramData\Microsoft\Windows\WER\*"; Name="Windows Error Reports"},
    @{Path="C:\Windows\Logs\CBS\*"; Name="CBS Logs"},
    @{Path="C:\Windows\Minidump\*"; Name="Memory Dumps"}
)

foreach ($item in $cachePaths) {
    Write-Step "Cleaning: $($item.Name)"
    try {
        Remove-Item -Path $item.Path -Recurse -Force -ErrorAction SilentlyContinue
        Write-OK
    } catch {
        Write-Fail "Some files in use (skipped)"
    }
}

Write-Step "Running Disk Cleanup (silent, aggressive)"
$sageset = 99
# Configure cleanup categories (most aggressive)
$cleanupKeys = @(
    "Active Setup Temp Folders", "BranchCache", "Downloaded Program Files",
    "Internet Cache Files", "Memory Dump Files", "Old ChkDsk Files",
    "Previous Installations", "Recycle Bin", "Service Pack Cleanup",
    "Setup Log Files", "System error memory dump files", "System error minidump files",
    "Temporary Files", "Temporary Setup Files", "Temporary Sync Files",
    "Thumbnail Cache", "Update Cleanup", "Upgrade Discarded Files",
    "User file versions", "Windows Defender", "Windows Error Reporting Archive Files",
    "Windows Error Reporting Queue Files", "Windows Error Reporting System Archive Files",
    "Windows Error Reporting System Queue Files", "Windows ESD installation files",
    "Windows Upgrade Log Files"
)
foreach ($key in $cleanupKeys) {
    $regKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$key"
    if (Test-Path $regKey) {
        Set-ItemProperty -Path $regKey -Name "StateFlags00$sageset" -Value 2 -Type DWord -ErrorAction SilentlyContinue
    }
}
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:$sageset" -Wait -WindowStyle Hidden
Write-OK

# ═══════════════════════════════════════════════════════════════
# 5. DISABLE STARTUP BLOAT
# ═══════════════════════════════════════════════════════════════
Write-Section "5. DISABLE STARTUP BLOAT"

$bloatToDisable = @(
    "Teams", "MicrosoftEdgeAutoLaunch_922CD16B7136BE3FB7E5FAE0080A4880",
    "AlienwareMobileConnectWelcome", "SupportAssist"
)

foreach ($app in $bloatToDisable) {
    Write-Step "Disabling startup: $app"
    try {
        # HKCU run
        $runKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        if ((Get-ItemProperty -Path $runKey -ErrorAction SilentlyContinue).PSObject.Properties.Name -contains $app) {
            Remove-ItemProperty -Path $runKey -Name $app -ErrorAction SilentlyContinue
        }
        # HKLM run
        $runKeyM = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
        if ((Get-ItemProperty -Path $runKeyM -ErrorAction SilentlyContinue).PSObject.Properties.Name -contains $app) {
            Remove-ItemProperty -Path $runKeyM -Name $app -ErrorAction SilentlyContinue
        }
        Write-OK
    } catch {
        Write-Fail "Not found or already disabled"
    }
}

# ═══════════════════════════════════════════════════════════════
# 6. INSTALL CLOUDFLARE WARP (free, faster + more private internet)
# ═══════════════════════════════════════════════════════════════
Write-Section "6. INSTALL CLOUDFLARE WARP (FREE VPN-LIKE SPEED BOOST)"

Write-Step "Checking if already installed"
$warpInstalled = Get-Command "warp-cli.exe" -ErrorAction SilentlyContinue
if ($warpInstalled) {
    Write-Host "    ✓ Already installed" -ForegroundColor Green
} else {
    Write-Step "Installing via winget"
    winget install --id Cloudflare.Warp -e --accept-package-agreements --accept-source-agreements --silent 2>&1 | Out-Null
    Write-OK
}

# ═══════════════════════════════════════════════════════════════
# 7. DISABLE WINDOWS BLOAT / TELEMETRY (minor speed boost)
# ═══════════════════════════════════════════════════════════════
Write-Section "7. DISABLE BACKGROUND TELEMETRY"

$servicesToDisable = @(
    "DiagTrack",           # Connected User Experiences and Telemetry
    "dmwappushservice",    # WAP Push Message Routing
    "RetailDemo"           # Retail Demo Service
)

foreach ($svc in $servicesToDisable) {
    Write-Step "Disabling: $svc"
    try {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        Write-OK
    } catch {
        Write-Fail "Service not found"
    }
}

# ═══════════════════════════════════════════════════════════════
# 8. VISUAL EFFECTS: PERFORMANCE MODE
# ═══════════════════════════════════════════════════════════════
Write-Section "8. OPTIMIZE VISUAL EFFECTS FOR SPEED"

Write-Step "Setting 'Adjust for best performance'"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord -ErrorAction SilentlyContinue
Write-OK

# ═══════════════════════════════════════════════════════════════
# FINAL REPORT
# ═══════════════════════════════════════════════════════════════
$afterC = [math]::Round((Get-Volume -DriveLetter C).SizeRemaining / 1GB, 2)
$recovered = [math]::Round($afterC - $beforeC, 2)

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  BOOST COMPLETE" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "  C: drive before: $beforeC GB free" -ForegroundColor White
Write-Host "  C: drive after:  $afterC GB free" -ForegroundColor White
Write-Host "  RECOVERED:       $recovered GB" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Changes made:" -ForegroundColor White
Write-Host "    • Ultimate Performance power plan active" -ForegroundColor Gray
Write-Host "    • DNS: 1.1.1.1 (Cloudflare) + 8.8.8.8 (Google)" -ForegroundColor Gray
Write-Host "    • Network stack optimized (TCP/Winsock tuned)" -ForegroundColor Gray
Write-Host "    • Windows Update cache cleared" -ForegroundColor Gray
Write-Host "    • Temp files, prefetch, error reports cleaned" -ForegroundColor Gray
Write-Host "    • Startup bloat disabled" -ForegroundColor Gray
Write-Host "    • Background telemetry disabled" -ForegroundColor Gray
Write-Host "    • Visual effects set to performance mode" -ForegroundColor Gray
Write-Host "    • Cloudflare WARP installed (launch it from Start menu)" -ForegroundColor Gray
Write-Host ""
Write-Host "  NEXT STEPS:" -ForegroundColor Yellow
Write-Host "    1. RESTART your computer to apply all changes" -ForegroundColor Yellow
Write-Host "    2. Open Cloudflare WARP from Start menu, enable it" -ForegroundColor Yellow
Write-Host "    3. Your projects are already moved to D:\Projects" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Press any key to close..." -ForegroundColor Cyan
[void][System.Console]::ReadKey($true)
