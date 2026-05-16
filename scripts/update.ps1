# AgentMaster Auto-Updater for Windows
# Pulls latest from all 5 dependency repos and syncs skills
#
# Usage:
#   .\scripts\update.ps1              # foreground
#   .\scripts\update.ps1 -Quiet       # suppress output (background mode)

param([switch]$Quiet)

$ErrorActionPreference = "Stop"
$SkillsDir = "$env:USERPROFILE\.claude\skills"
$CacheDir = "$env:USERPROFILE\.claude\.agentmaster-cache"
$LockFile = "$CacheDir\.update-lock"
$LastUpdateFile = "$CacheDir\.last-update"

function Log($msg) { if (-not $Quiet) { Write-Host $msg } }

# Prevent concurrent updates
if (Test-Path $LockFile) {
    $lockAge = ((Get-Date) - (Get-Item $LockFile).LastWriteTime).TotalSeconds
    if ($lockAge -lt 300) { Log "Update already running. Skipping."; exit 0 }
    Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
}

# Skip if updated within last 6 hours
New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null
if (Test-Path $LastUpdateFile) {
    $last = [int](Get-Content $LastUpdateFile -ErrorAction SilentlyContinue)
    $now = [int](Get-Date -UFormat %s)
    if (($now - $last) -lt 21600) {
        Log "Updated recently. Skipping (6h cooldown)."
        exit 0
    }
}

New-Item -ItemType File -Path $LockFile -Force | Out-Null

try {
    Log "AgentMaster: Checking for skill updates..."

    function Update-Repo {
        param($Name, $RepoUrl, $SkillSource)
        $cachePath = "$CacheDir\$Name"

        if (Test-Path "$cachePath\.git") {
            Push-Location $cachePath
            try {
                $before = git rev-parse HEAD 2>$null
                git pull --ff-only --quiet 2>$null
                $after = git rev-parse HEAD 2>$null
            } finally {
                Pop-Location
            }

            if ($before -eq $after) { Log "  ${Name}: up to date"; return }
            Log "  ${Name}: updated"
        } else {
            Log "  ${Name}: cloning..."
            if (Test-Path $cachePath) { Remove-Item $cachePath -Recurse -Force }
            git clone --depth 1 --quiet $RepoUrl $cachePath 2>$null
        }

        # Sync skills
        $src = "$cachePath\$SkillSource"
        if (Test-Path $src) {
            Get-ChildItem $src -Directory | ForEach-Object {
                if ((Test-Path "$($_.FullName)\SKILL.md") -or ($SkillSource -eq "skills")) {
                    Copy-Item -Path $_.FullName -Destination "$SkillsDir\$($_.Name)" -Recurse -Force
                }
            }
        }
    }

    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null

    Update-Repo -Name "caveman" -RepoUrl "https://github.com/JuliusBrussee/caveman.git" -SkillSource "skills"
    Update-Repo -Name "superpowers" -RepoUrl "https://github.com/obra/superpowers.git" -SkillSource "skills"
    Update-Repo -Name "claude-skills" -RepoUrl "https://github.com/alirezarezvani/claude-skills.git" -SkillSource "."
    Update-Repo -Name "claude-mem" -RepoUrl "https://github.com/thedotmack/claude-mem.git" -SkillSource "plugin\skills"

    # Self-update
    $amCache = "$CacheDir\agent-master"
    if (Test-Path "$amCache\.git") {
        Push-Location $amCache
        try {
            git pull --ff-only --quiet 2>$null
        } finally {
            Pop-Location
        }
    } else {
        git clone --depth 1 --quiet "https://github.com/Surya8991/AgentMaster.git" $amCache 2>$null
    }
    Copy-Item -Path "$amCache\skills\*" -Destination $SkillsDir -Recurse -Force
    Log "  agent-master: synced"

    # Record timestamp
    [int](Get-Date -UFormat %s) | Out-File $LastUpdateFile -Force

    $count = (Get-ChildItem $SkillsDir -Directory).Count
    Log ""
    Log "All skills synced. Total: $count skills"
} finally {
    Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
}
