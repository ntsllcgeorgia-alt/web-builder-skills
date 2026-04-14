# ═══════════════════════════════════════════════════════════════
# AUTO-BACKUP — Commits and pushes all D:\Projects repos
# Runs daily via Windows Task Scheduler
# Built by Claude for Hazem
# ═══════════════════════════════════════════════════════════════

$ErrorActionPreference = 'Continue'
$projectsDir = 'D:\Projects'
$logFile = 'D:\Projects\.auto-backup.log'
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$sessionHeader = "`n═══ $timestamp ═══"

# Secrets file names — NEVER auto-commit these
$secretPatterns = @(
    '.env', '.env.local', '.env.production',
    'credentials.json', 'secrets.json', 'secrets.txt',
    'config.secret.json', 'auth.json', 'api-keys.txt',
    '*.key', '*.pem', '*password*', '*token*'
)

function Log { param([string]$Text) Add-Content -Path $logFile -Value $Text }

Log $sessionHeader

if (-not (Test-Path $projectsDir)) {
    Log "ERROR: $projectsDir does not exist"
    exit 1
}

# Get all folders that are git repos
$repos = Get-ChildItem -Path $projectsDir -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName '.git')
}

if ($repos.Count -eq 0) {
    Log "No git repos found in $projectsDir"
    exit 0
}

Log "Found $($repos.Count) git repos to check"

foreach ($repo in $repos) {
    $name = $repo.Name
    $path = $repo.FullName
    Log "`n--- $name ---"
    Push-Location $path

    try {
        # Check if there's a remote
        $remoteUrl = git config --get remote.origin.url 2>$null
        if (-not $remoteUrl) {
            Log "  SKIP: No remote configured"
            Pop-Location
            continue
        }

        # Check for changes
        $status = git status --porcelain 2>$null

        if (-not $status) {
            # Nothing to commit — just push any unpushed commits
            $ahead = git rev-list --count '@{upstream}..HEAD' 2>$null
            if ($ahead -and [int]$ahead -gt 0) {
                Log "  Pushing $ahead unpushed commits..."
                git push 2>&1 | ForEach-Object { Log "    $_" }
            } else {
                Log "  Clean — nothing to push"
            }
            Pop-Location
            continue
        }

        # Check for secrets in staged/unstaged files
        $suspiciousFiles = @()
        foreach ($line in $status) {
            $file = $line.Substring(3).Trim()
            foreach ($pattern in $secretPatterns) {
                if ($file -like "*$pattern*") {
                    $suspiciousFiles += $file
                    break
                }
            }
        }

        if ($suspiciousFiles.Count -gt 0) {
            Log "  WARNING: Possible secrets detected, SKIPPING push:"
            $suspiciousFiles | ForEach-Object { Log "    - $_" }
            Log "  Commit these manually after reviewing."
            Pop-Location
            continue
        }

        # Check for merge conflict markers — don't auto-push broken code
        $conflictMarkers = git diff --check 2>&1
        if ($LASTEXITCODE -ne 0) {
            Log "  WARNING: Merge conflicts detected, skipping"
            Pop-Location
            continue
        }

        # Auto-commit everything
        $commitMsg = "Auto-backup $timestamp"
        Log "  Staging and committing changes..."
        git add -A 2>&1 | Out-Null
        git commit -m $commitMsg 2>&1 | ForEach-Object { Log "    $_" }

        # Push
        Log "  Pushing to $remoteUrl..."
        $pushResult = git push 2>&1
        $pushResult | ForEach-Object { Log "    $_" }

        if ($LASTEXITCODE -eq 0) {
            Log "  ✓ SUCCESS"
        } else {
            Log "  ✗ PUSH FAILED — may need manual intervention"
        }

    } catch {
        Log "  ERROR: $($_.Exception.Message)"
    } finally {
        Pop-Location
    }
}

Log "`n═══ Backup session complete at $(Get-Date -Format 'HH:mm:ss') ═══`n"

# Keep log file trimmed to last 500 lines (prevent infinite growth)
if (Test-Path $logFile) {
    $lines = Get-Content $logFile -Tail 500
    Set-Content -Path $logFile -Value $lines
}
