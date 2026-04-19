param(
    [string]$Org = "AI-employee-force",
    [ValidateSet("public", "private", "internal")]
    [string]$Visibility = "private"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI ('gh') is not installed. Install it first, then run 'gh auth login'."
}

$repoPaths = @(
    "platform/aief-shell",
    "platform/aief-marketplace",
    "platform/aief-control-center",
    "platform/aief-admin-console",
    "platform/aief-identity",
    "agents/aief-fronto",
    "agents/aief-backo",
    "agents/aief-designo",
    "agents/aief-devopsy",
    "agents/aief-testo",
    "agents/aief-automo",
    "agents/aief-stacko",
    "shared/aief-ui-kit",
    "shared/aief-agent-sdk",
    "shared/aief-types",
    "shared/aief-auth-sdk",
    "shared/aief-workflow-sdk",
    "shared/aief-design-tokens",
    "shared/aief-icons",
    "shared/aief-bot-assets",
    "infra/aief-infra",
    "infra/aief-github-actions",
    "governance/aief-docs",
    "governance/aief-architecture",
    "governance/aief-standards",
    "governance/aief-prompts"
)

$workspaceRoot = Split-Path $PSScriptRoot -Parent

foreach ($repoPath in $repoPaths) {
    $repo = Split-Path $repoPath -Leaf
    $localPath = Join-Path $workspaceRoot $repoPath
    $remoteUrl = "https://github.com/$Org/$repo.git"

    if (-not (Test-Path $localPath)) {
        Write-Warning "Skipping missing local path: $localPath"
        continue
    }

    gh repo view "$Org/$repo" 1>$null 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Repo already exists, skipping create: $Org/$repo" -ForegroundColor Yellow
        continue
    }

    Write-Host "Creating $Org/$repo ..." -ForegroundColor Cyan
    gh repo create "$Org/$repo" --$Visibility --source $localPath --remote origin | Out-Null

    $hasRemote = git -C $localPath remote get-url origin 2>$null
    if (-not $hasRemote) {
        git -C $localPath remote add origin $remoteUrl | Out-Null
    }

    Write-Host "Linked $localPath to $remoteUrl" -ForegroundColor DarkGray
}

Write-Host "Repository creation loop finished." -ForegroundColor Green
