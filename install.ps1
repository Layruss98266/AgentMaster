# AgentMaster Installer for Windows
# Copies custom skills to ~/.claude/skills/ and clones dependency repos

$ErrorActionPreference = "Stop"

$SkillsDir = "$env:USERPROFILE\.claude\skills"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "AgentMaster Installer v1.0" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

# Create skills directory
New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null

# 1. Install custom skills
Write-Host "[1/5] Installing custom skills..." -ForegroundColor Yellow
Get-ChildItem "$ScriptDir\skills" -Directory | ForEach-Object {
    if (Test-Path "$($_.FullName)\SKILL.md") {
        Copy-Item -Path $_.FullName -Destination "$SkillsDir\$($_.Name)" -Recurse -Force
        Write-Host "  + $($_.Name)" -ForegroundColor Green
    }
}

# 2. Caveman
Write-Host ""
Write-Host "[2/5] Installing caveman (token compression)..." -ForegroundColor Yellow
if (-not (Test-Path "$SkillsDir\caveman")) {
    $tmp = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
    git clone --depth 1 https://github.com/JuliusBrussee/caveman.git $tmp 2>$null
    Copy-Item -Path "$tmp\skills\*" -Destination $SkillsDir -Recurse -Force
    Remove-Item $tmp -Recurse -Force
    Write-Host "  + caveman, caveman-commit, caveman-review, caveman-help, compress" -ForegroundColor Green
} else {
    Write-Host "  ~ caveman already installed, skipping" -ForegroundColor DarkGray
}

# 3. Superpowers
Write-Host ""
Write-Host "[3/5] Installing superpowers (dev workflow)..." -ForegroundColor Yellow
if (-not (Test-Path "$SkillsDir\brainstorming")) {
    $tmp = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
    git clone --depth 1 https://github.com/obra/superpowers.git $tmp 2>$null
    Copy-Item -Path "$tmp\skills\*" -Destination $SkillsDir -Recurse -Force
    Remove-Item $tmp -Recurse -Force
    Write-Host "  + brainstorming, writing-plans, test-driven-development, ..." -ForegroundColor Green
} else {
    Write-Host "  ~ superpowers already installed, skipping" -ForegroundColor DarkGray
}

# 4. Claude-skills
Write-Host ""
Write-Host "[4/5] Installing claude-skills (domain expertise)..." -ForegroundColor Yellow
if (-not (Test-Path "$SkillsDir\engineering-team")) {
    $tmp = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
    git clone --depth 1 https://github.com/alirezarezvani/claude-skills.git $tmp 2>$null
    Get-ChildItem $tmp -Directory | Where-Object { Test-Path "$($_.FullName)\SKILL.md" } | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination "$SkillsDir\$($_.Name)" -Recurse -Force
    }
    Remove-Item $tmp -Recurse -Force
    Write-Host "  + engineering-team, marketing-skill, product-team, c-level-advisor, ..." -ForegroundColor Green
} else {
    Write-Host "  ~ claude-skills already installed, skipping" -ForegroundColor DarkGray
}

# 5. Claude-mem skills
Write-Host ""
Write-Host "[5/5] Installing claude-mem skills (session memory)..." -ForegroundColor Yellow
if (-not (Test-Path "$SkillsDir\mem-search")) {
    $tmp = New-TemporaryFile | ForEach-Object { Remove-Item $_; New-Item -ItemType Directory -Path $_ }
    git clone --depth 1 https://github.com/thedotmack/claude-mem.git $tmp 2>$null
    Copy-Item -Path "$tmp\plugin\skills\*" -Destination $SkillsDir -Recurse -Force
    Remove-Item $tmp -Recurse -Force
    Write-Host "  + mem-search, smart-explore, knowledge-agent, make-plan, do, timeline-report" -ForegroundColor Green
} else {
    Write-Host "  ~ claude-mem skills already installed, skipping" -ForegroundColor DarkGray
}

# Done
$count = (Get-ChildItem $SkillsDir -Directory).Count
Write-Host ""
Write-Host "==========================" -ForegroundColor Cyan
Write-Host "AgentMaster installed!" -ForegroundColor Green
Write-Host ""
Write-Host "Skills installed to: $SkillsDir"
Write-Host "Total skills: $count"
Write-Host ""
Write-Host "Usage:"
Write-Host "  /agent-master              - invoke orchestrator"
Write-Host "  /agent-master route <task> - dry-run routing"
Write-Host "  /agent-master status       - show current state"
Write-Host "  /caveman                   - enable token compression"
Write-Host ""
Write-Host "Start a new Claude Code session to load all skills."
