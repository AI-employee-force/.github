# AI Employee Force Workspace

This workspace is organized as a multi-repo portfolio for the `AI-employee-force` initiative.

## Structure

- `platform/`: end-user and operator-facing applications
- `agents/`: specialist agent products and runtimes
- `shared/`: shared SDKs, design assets, and reusable packages
- `infra/`: infrastructure and delivery automation
- `governance/`: architecture, standards, prompts, and documentation

## Repositories

### Platform

- `aief-shell`
- `aief-marketplace`
- `aief-control-center`
- `aief-admin-console`
- `aief-identity`

### Agents

- `aief-fronto`
- `aief-backo`
- `aief-designo`
- `aief-devopsy`
- `aief-testo`
- `aief-automo`
- `aief-stacko`

### Shared

- `aief-ui-kit`
- `aief-agent-sdk`
- `aief-types`
- `aief-auth-sdk`
- `aief-workflow-sdk`
- `aief-design-tokens`
- `aief-icons`
- `aief-bot-assets`

### Infra

- `aief-infra`
- `aief-github-actions`

### Governance

- `aief-docs`
- `aief-architecture`
- `aief-standards`
- `aief-prompts`

## Publishing

Use [scripts/create-org-repos.ps1](C:\Users\aparekh\Desktop\Projects\aI-employee-force\scripts\create-org-repos.ps1) after `gh` is installed and authenticated with access to the `AI-employee-force` organization.

## Team Setup

Use [scripts/clone-team-workspace.ps1](C:\Users\aparekh\Desktop\Projects\aI-employee-force\scripts\clone-team-workspace.ps1) to create a fresh `ai-employee-force` workspace, prompt the team member for a role, and clone only the matching repositories into the right category folders.

When the script runs, it asks for one of these role numbers:

- `1` Developer: creates `agents/` and `shared/` and clones those repos only
- `2` Architect: creates `platform/`, `agents/`, and `shared/` and clones those repos only
- `3` Admin: creates `governance/` and `infra/` and clones those repos only
- `4` Project Manager: creates `platform/`, `agents/`, and `governance/` and clones those repos only
- `5` Infra Manager: creates `infra/` and clones those repos only
- `6` All: creates `platform/`, `agents/`, `shared/`, `infra/`, and `governance/` and clones all repos

Example:

```powershell
cd C:\Users\aparekh\Desktop\Projects
.\aI-employee-force\scripts\clone-team-workspace.ps1
```

Optional non-interactive usage:

```powershell
.\aI-employee-force\scripts\clone-team-workspace.ps1 -RoleChoice 2
.\aI-employee-force\scripts\clone-team-workspace.ps1 -RoleChoice 6 -Protocol ssh -ForcePull
```
