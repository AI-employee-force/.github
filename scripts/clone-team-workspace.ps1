param(
    [string]$Org = "AI-employee-force",
    [string]$BasePath = (Get-Location).Path,
    [ValidateSet("https", "ssh")]
    [string]$Protocol = "https",
    [switch]$ForcePull,
    [ValidateSet("1", "2", "3", "4", "5", "6")]
    [string]$RoleChoice
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed or not available on PATH."
}

$workspaceName = "ai-employee-force"
$workspaceRoot = Join-Path $BasePath $workspaceName

$repoGroups = [ordered]@{
    platform = @(
        "aief-shell",
        "aief-marketplace",
        "aief-control-center",
        "aief-admin-console",
        "aief-identity"
    )
    agents = @(
        "aief-fronto",
        "aief-backo",
        "aief-designo",
        "aief-devopsy",
        "aief-testo",
        "aief-automo",
        "aief-stacko"
    )
    shared = @(
        "aief-ui-kit",
        "aief-agent-sdk",
        "aief-types",
        "aief-auth-sdk",
        "aief-workflow-sdk",
        "aief-design-tokens",
        "aief-icons",
        "aief-bot-assets"
    )
    infra = @(
        "aief-infra",
        "aief-github-actions"
    )
    governance = @(
        "aief-docs",
        "aief-architecture",
        "aief-standards",
        "aief-prompts"
    )
}

$roleGroups = [ordered]@{
    "1" = @{
        Name = "Developer"
        Groups = @("agents", "shared")
    }
    "2" = @{
        Name = "Architect"
        Groups = @("platform", "agents", "shared")
    }
    "3" = @{
        Name = "Admin"
        Groups = @("governance", "infra")
    }
    "4" = @{
        Name = "Project Manager"
        Groups = @("platform", "agents", "governance")
    }
    "5" = @{
        Name = "Infra Manager"
        Groups = @("infra")
    }
    "6" = @{
        Name = "All"
        Groups = @("platform", "agents", "shared", "infra", "governance")
    }
}

function Ensure-Directory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "Created: $Path" -ForegroundColor Green
    }
}

function Get-CloneUrl {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repository
    )

    if ($Protocol -eq "ssh") {
        return "git@github.com:$Org/$Repository.git"
    }

    return "https://github.com/$Org/$Repository.git"
}

function Read-RoleChoice {
    while ($true) {
        Write-Host ""
        Write-Host "Select your role:" -ForegroundColor Cyan
        Write-Host "1. Developer"
        Write-Host "2. Architect"
        Write-Host "3. Admin"
        Write-Host "4. Project Manager"
        Write-Host "5. Infra Manager"
        Write-Host "6. All"

        $selectedRole = Read-Host "Enter role number (1-6)"

        if ($roleGroups.Contains($selectedRole)) {
            return $selectedRole
        }

        Write-Warning "Invalid choice. Enter 1, 2, 3, 4, 5, or 6."
    }
}

if (-not $RoleChoice) {
    $RoleChoice = Read-RoleChoice
}

$selectedRole = $roleGroups[$RoleChoice]
$selectedGroups = $selectedRole.Groups

Ensure-Directory -Path $workspaceRoot

Write-Host ""
Write-Host "Selected role: $($selectedRole.Name)" -ForegroundColor Green

foreach ($group in $selectedGroups) {
    $groupRoot = Join-Path $workspaceRoot $group
    Ensure-Directory -Path $groupRoot

    foreach ($repo in $repoGroups[$group]) {
        $targetPath = Join-Path $groupRoot $repo
        $cloneUrl = Get-CloneUrl -Repository $repo

        if (Test-Path $targetPath) {
            $gitDirectory = Join-Path $targetPath ".git"

            if (Test-Path $gitDirectory) {
                Write-Host "Exists: $targetPath" -ForegroundColor Yellow

                if ($ForcePull) {
                    Write-Host "Pulling latest changes for $repo" -ForegroundColor Cyan
                    git -C $targetPath pull --ff-only
                }

                continue
            }

            Write-Warning "Skipping non-git directory that already exists: $targetPath"
            continue
        }

        Write-Host "Cloning $cloneUrl into $targetPath" -ForegroundColor Cyan
        git clone $cloneUrl $targetPath
    }
}

Write-Host ""
Write-Host "Workspace is ready at: $workspaceRoot" -ForegroundColor Green
Write-Host "Folders cloned for role: $($selectedRole.Name)" -ForegroundColor Green
