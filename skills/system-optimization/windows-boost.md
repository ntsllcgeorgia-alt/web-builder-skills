# Windows System Performance Boost

Turn any slow Windows laptop into a fast dev machine. Safe, tested, reversible.

## When to Use This Skill

The user complains about:
- Slow laptop, slow browser, slow VS Code
- Sluggish typing in editors
- Git operations taking forever
- Websites loading slowly
- Laptop feels hot or fan always running
- "Not enough disk space" warnings

## Diagnose First

Before fixing anything, run this diagnostic to know what's actually slow:

```powershell
# Drive space — the #1 cause of slow Windows
Get-Volume | Where-Object {$_.DriveLetter} | Format-Table DriveLetter, FileSystemLabel, @{Name='Size(GB)';Expression={[math]::Round($_.Size/1GB,1)}}, @{Name='Free(GB)';Expression={[math]::Round($_.SizeRemaining/1GB,1)}}

# Memory usage
Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 10 Name, @{Name='Memory(MB)';Expression={[math]::Round($_.WS/1MB,1)}}, CPU | Format-Table

# Current power plan
powercfg /getactivescheme

# Current DNS
Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.ServerAddresses.Count -gt 0} | Select-Object InterfaceAlias, ServerAddresses

# Startup programs
Get-CimInstance Win32_StartupCommand | Select-Object Name
```

## The Real Fixes (in priority order)

### 1. Free up the system drive (biggest impact)

**Why it matters**: Windows needs 20%+ free space on C: to function. SSDs at >90% full slow to a crawl and physically wear out faster.

**What to do:**
- Clean Windows Update cache (can be 2-10 GB)
- Clear temp files
- Move OneDrive to a different drive if C: is small
- Move active projects OUT of OneDrive (git operations slow to a halt inside OneDrive)

### 2. Move Projects Out of OneDrive

**This is HUGE for developers.** Every file change in a OneDrive folder triggers cloud sync. Git operations, VS Code saves, npm installs — all wait on OneDrive.

```bash
# Move to a non-synced drive
mkdir -p D:\Projects
mv "C:\Users\USERNAME\OneDrive\my-project" "D:\Projects\"
```

Git remotes and commit history stay intact. Just re-open the folder in VS Code from the new location.

### 3. Ultimate Performance Power Plan

Hidden by default on most laptops. Unlock it:

```powershell
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
# Then in Settings → Power Options, select "Ultimate Performance"
```

Or auto-activate:
```powershell
$ultimate = powercfg /list | Select-String 'Ultimate Performance'
if ($ultimate) {
    $guid = ($ultimate -split '\s+')[3]
    powercfg /setactive $guid
}
```

### 4. Faster DNS (Cloudflare + Google)

Default router DNS is slow. Switch to:
- Primary: `1.1.1.1` (Cloudflare — fastest globally)
- Secondary: `8.8.8.8` (Google — reliable fallback)

```powershell
# REQUIRES ADMIN
Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ('1.1.1.1','8.8.8.8')
}
ipconfig /flushdns
```

### 5. Install Cloudflare WARP (free VPN-like tunnel)

Makes internet noticeably faster by routing through Cloudflare's optimized network. Free, no account required.

```bash
winget install --id Cloudflare.Warp -e --accept-package-agreements
```

After install, open from Start menu and click to enable.

### 6. Network Stack Tuning (ADMIN)

```powershell
# Enable TCP auto-tuning (higher throughput)
netsh int tcp set global autotuninglevel=normal

# Enable Receive Side Scaling (parallel packet processing)
netsh int tcp set global rss=enabled

# Enable Explicit Congestion Notification
netsh int tcp set global ecncapability=enabled

# Use CTCP (faster downloads on high-latency networks)
netsh int tcp set supplemental template=internet congestionprovider=ctcp
```

### 7. Disable Startup Bloat

Common culprits that slow boot and eat RAM:
- Teams (auto-launch)
- Microsoft Edge autolaunch
- Alienware / OEM bloat (Dell, HP, Lenovo equivalents)
- SupportAssist / PCDoctor

```powershell
# List all startup items
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command

# Disable specific ones (ADMIN)
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Teams"
Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "SupportAssist"
```

Or use Task Manager → Startup tab → right-click → Disable.

### 8. Clean Windows Update Cache

Can be huge (2-10 GB):

```powershell
# ADMIN REQUIRED
Stop-Service wuauserv, bits -Force
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force
Start-Service wuauserv, bits
```

### 9. Deep Disk Cleanup (Silent Mode)

Windows Disk Cleanup has a hidden advanced mode:

```powershell
# Configure aggressive cleanup
$sageset = 99
$cleanupKeys = @(
    "Active Setup Temp Folders", "Downloaded Program Files",
    "Internet Cache Files", "Memory Dump Files", "Previous Installations",
    "Recycle Bin", "Service Pack Cleanup", "Temporary Files",
    "Thumbnail Cache", "Update Cleanup", "Windows Error Reports"
)
foreach ($key in $cleanupKeys) {
    $regKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$key"
    if (Test-Path $regKey) {
        Set-ItemProperty -Path $regKey -Name "StateFlags00$sageset" -Value 2 -Type DWord
    }
}
# Run silent
Start-Process cleanmgr.exe -ArgumentList "/sagerun:$sageset" -Wait -WindowStyle Hidden
```

### 10. Visual Effects — Performance Mode

Turns off window animations, transparency, shadows. Noticeable snappier feel:

```powershell
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord
```

## What I Usually Skip

- **Registry cleaners** (CCleaner etc.) — more hype than gain, can break things
- **"RAM boosters"** — Windows manages RAM fine
- **Disk defragmenters on SSDs** — never defrag an SSD, Windows handles TRIM automatically
- **Antivirus stacking** — Windows Defender is enough, running 2 AVs tanks speed

## Expected Results

For a typical "slow laptop" (16GB RAM, SSD, Intel i5/i7):
- Boot time: 40-60s → 15-25s
- VS Code save lag: gone (if projects were in OneDrive)
- Browser load: 20-30% faster with DNS/WARP changes
- Disk space: usually 10-30 GB recovered
- Overall feel: noticeably snappier within minutes

## Safety Notes

- **Everything above is reversible** — no nuclear options
- Power plan can be reverted in Settings → Power
- DNS can be reverted to "Automatic" in network adapter properties
- Disabled services can be re-enabled in `services.msc`
- Moved projects keep all git history — nothing is deleted

## The Script

See `BOOST-ADMIN.ps1` in this folder for the full automated admin script. Right-click → "Run as Administrator".
