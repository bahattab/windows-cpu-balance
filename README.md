# WCB — Windows CPU Balance

Version **1.3.0** · Invocation: **wcb** · Windows 10/11

A portable agent skill for investigating Windows slowdowns, reducing unnecessary background activity, and applying reversible application scheduling changes while preserving active work.

## Features

- Repeated CPU sampling, application memory usage, process/thread counts, and parent-process inspection.
- Application-specific processor affinity and priority recommendations with original settings recorded for undo.
- Existing affinity-monitor inspection, five-second polling guidance, bounded logs, and verification of actual behavior.
- Startup, running-service, and installed-software audits, including uninstall candidates, duplicate-version checks, memory pressure, dependencies, and rollback planning.
- Protection of active chats/tasks, unsaved work, sync, networking, security services, and shared runtimes.

## Install

Clone this repository into your agent's skills directory:

```powershell
git clone https://github.com/bahattab/windows-cpu-balance.git "$env:USERPROFILE\.codex\skills\0-windows-cpu-balance"
```

For agents using the shared convention, use `$env:USERPROFILE\.agents\skills\0-windows-cpu-balance` instead. If the destination already exists, back it up and update its contents; do not clone over it. Restart skill discovery or open a new chat if your agent caches installed skills.

Any agent that can read Markdown and run PowerShell can use [SKILL.md](SKILL.md) directly. Core WCB diagnostics require no API key, cloud account, Python, MCP server, or third-party module. This public repository can be cloned without GitHub authentication.

## Use

Ask your agent:

- `wcb`
- `Use wcb to reduce CPU usage and improve responsiveness without interrupting active work.`
- `Use wcb to check unnecessary services and software that could be uninstalled.`

For a read-only measurement without an agent:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\measure-cpu.ps1 -Seconds 8 -AsJson
```

The execution-policy flag applies only to that process and does not override organization policy. Some elevated processes may require administrator privileges for modification.

## Service and software audit

The [audit procedure](references/service-software-audit.md) separates measured CPU/RAM pressure from storage-only opportunities. Not running now is not evidence that an application is unused. Duplicate registry entries may refer to one installation; SDKs, runtimes, and build tools may be dependencies.

A request to inspect uninstall candidates does not authorize uninstalling them. The agent presents exact candidates and consequences before removal unless those actions were already explicitly approved. It uses supported uninstallers and preserves user data and shared dependencies.

## Scheduling and persistence

Affinity limits which logical CPUs an application can use; it does not reserve a CPU exclusively for Windows or guarantee lower CPU consumption. Lower priority changes scheduling under contention and may slow the affected work. Live changes normally last until process exit; no monitor or scheduled task is installed merely by copying this skill.

Before persistent changes, follow [setup and persistence](references/setup-and-persistence.md). Reuse existing policies, record original configuration, and verify live settings. Post-reboot behavior requires separate verification.

## Rollback

Before changes, the agent records original process affinity/priority, registry startup values, and any modified service or scheduled-task configuration. Restore those recorded values using the generated rollback instructions or script. Stopping an affinity monitor alone does not restore already-modified processes. Never use a rollback file from another computer or session without checking process identity.

## Package

- `SKILL.md` — agent workflow and boundaries
- `scripts/measure-cpu.ps1` — read-only CPU/process/thread sampling
- `references/setup-and-persistence.md` — installation, persistence, and recovery
- `references/service-software-audit.md` — service/software audit and uninstall review

## Version 1.3.0

Added service and installed-software auditing, memory-pressure checks, duplicate-version review, evidence-based uninstall candidates, and explicit removal authorization boundaries. Measurements are diagnostic observations, not a guarantee of improved responsiveness.

## Version 1.4.0

Adds optional Mole for Windows diagnostics, application inventory, cleanup and maintenance previews, and a portable PowerShell setup script. The integration calls the separate [Mole CLI](https://github.com/tw93/Mole/tree/windows) maintained by tw93 under GPL-3.0. The WCB integration and installer source are included here. The Mole release is distributed by its maintainer.

Run from a checkout or extracted release in Windows PowerShell:

```powershell
.\setup.ps1 -SkillDirectory "$env:USERPROFILE\.agents\skills\0-windows-cpu-balance"
.\scripts\invoke-mole.ps1 -Action Version
.\scripts\invoke-mole.ps1 -Action Status
.\scripts\invoke-mole.ps1 -Action CleanPreview
```

Choose any supported agent skills directory or give the agent the installed SKILL.md path. Setup validates the package, copies files, and backs up previous package files under %LOCALAPPDATA%\WCB\skill-backups. Restore a backup by copying its files back into the skill directory. Setup creates no scheduled tasks. See the [Windows reference](references/mole-windows.md) for supported commands.

## Version 1.5.0

Setup and the first Mole command automatically provision Mole. WCB reuses its managed copy or a compatible existing Windows installation. If neither is present, WCB downloads the official pinned x64 release, verifies its SHA-256 digest, and installs it for the current user. Later runs work with that local copy. The first download requires internet access. Hourly WCB CPU sampling remains independent of Mole.
