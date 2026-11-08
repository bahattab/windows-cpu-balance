---
name: 0-windows-cpu-balance
description: Trigger on the standalone command wcb or an explicit request to use wcb (case-insensitive), as well as 0-windows-cpu-balance. Diagnose Windows CPU contention and configure persistent processor affinity for selected heavy applications while preserving desktop responsiveness. Use for heavy programs, high process/thread counts, background/startup cleanup, service and installed-software audits, uninstall candidate review, CPU core allocation, or persistent CPU rules.
metadata:
  display_name: "0 - windows-cpu-balance"
  version: "1.3.0"
  platform: "Windows"
  trigger_alias: "wcb"
---

# 0 - windows-cpu-balance

This skill works with any agent able to read Markdown and run local Windows PowerShell commands. It requires no Codex API, MCP server, cloud account, Python, or third-party application. On non-Windows hosts, explain that its scripts are unsupported and do not execute them.

## Trigger alias

Activate this skill for the standalone command `wcb` (case-insensitive), `$wcb`, `/wcb`, or an explicit request to use WCB. Retain `$0-windows-cpu-balance` and the full skill name. Do not trigger merely because these letters appear inside unrelated text or quoted logs. Apply the same workflow and authorization boundaries to the alias as to the full name.

## Setup and inspection

Read [setup and persistence](references/setup-and-persistence.md) before changing persistent configuration. Resolve all script paths relative to this SKILL.md, regardless of the agent's working directory. Read the local host's applicable instructions first.

Run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<skill-directory>\scripts\measure-cpu.ps1" -Seconds 8`. Add `-AsJson` for structured results. The process-scoped execution policy flag does not change machine/user policy; respect enforced organization policy. Inspection normally needs no elevation; report inaccessible processes. Repeat a representative sample before labeling a program persistently heavy. Inspect candidate executable paths, ownership and workload roles. Do not classify by cumulative lifetime CPU or a single spike.

## Default responsiveness workflow

Every invocation includes process/thread inspection and monitor-efficiency checks, alongside CPU sampling. Capture before/after process and thread counts, group processes by executable, identify top thread owners and trace suspicious duplicates to their parents. These measurements are provided by the bundled script with `-AsJson`. A large count alone does not prove overload: waiting threads do not use CPU, and counts fluctuate while agents/tools run. Do not promise a fixed target or attribute all observed changes to your edits.

When the user requests system cleanup or speed improvements, perform reversible cleanup of verified unnecessary background activity within that scope. A background-only Phone Link instance can be a candidate if it has no visible window, ongoing call or user task; never terminate an active session. Preserve notes, calculations, playback, video exports, sync, security services and active agent infrastructure. Prefer a supported graceful exit. Do not mass-kill svchost, conhost, node, REPL or WebView instances: inspect ownership, identity and role first. A missing parent or old start time alone does not prove a process is unused.

Inspect optional startup entries. An existing current-user MicrosoftEdgeAutoLaunch entry is a candidate for removal when startup reduction is requested; first save its exact registry path, name, type and value and provide restoration instructions. Do not introduce browser management policies, uninstall applications or disable security/sync services simply to lower counts. Read-only diagnosis requests do not authorize cleanup. Existing explicit authorization remains valid; do not ask again for the same approved reversible action.

By default, any affinity monitor created or maintained by this skill caches hardware topology before its loop, uses a five-second polling interval unless the user's workload needs otherwise, bounds logs (rotate at about 1 MiB), and reuses one existing scheduled task. Preserve application rules when optimizing the monitor. Parse changed PowerShell, restart only that policy task when authorized, then verify live affinity/priority, task state and the monitor's measured CPU overhead. Do not describe task registration or reduced counts alone as proof that responsiveness improved.

These defaults govern the skill's workflow when invoked. They do not install a boot-time program that automatically terminates unknown applications. Persistent monitors enforce only reviewed application rules. Report changes, rollback location, actual readings and limitations.

## Choose the scope

Affinity excludes selected applications from a logical CPU; it does not reserve a CPU exclusively for Windows. Never change boot processor counts, kernel affinity, security software, drivers or all applications as a blanket policy. Do not terminate jobs or sessions to reduce CPU usage.

For background encoders, BelowNormal priority and distributing instances over all but the final logical CPU can improve responsiveness. For an interactive browser such as Chrome, prefer allowing all but the final logical CPU while retaining its priority. Do not confine every browser subprocess to one CPU. On a single logical CPU, avoid affinity restrictions entirely. Treat two-CPU hosts conservatively because excluding one removes half their available parallelism.

Preserve active agent/chat session infrastructure. Do not constrain generic node, python, java or WebView processes by name: identify their owning workload first. Select persistent rules by verified application identity and user intent. Automatically inspect and propose candidates, but do not permanently classify unknown programs without evaluating their role. Preserve original live affinity and priority for undo.

## Persist and verify

Inspect existing tasks and policies before adding a monitor. Reuse a suitable policy instead of installing duplicate background loops. Discover the user's actual account, machine-wide logical CPU count, script location and target executables; never embed another computer's username or PID.

Keep policy files protected against modification by unrelated users, bound logs, cache hardware information outside polling loops, and avoid frequent expensive WMI queries. Use the user's interactive highest token only when needed for elevated targets. Do not execute user-writable policy code as SYSTEM.

Verify script syntax, task trigger/action/principal, and live affinity and priority through readback at the required privilege level. Registration alone is not behavioral proof. Do not reboot or launch a user's browser only to test. Distinguish verified live behavior, configuration for future starts and unverified post-reboot operation.

Undo by stopping the monitor, restoring its backup, and restoring recorded live process affinity/priority or allowing those processes to finish and restart. Disabling a task does not reset affinity already applied. Report which applications changed, the tradeoff in background throughput, exclusions, and verification limits.

## Service and software audit

For slowdown, cleanup, startup, or unused-software reviews, read [service and software audit](references/service-software-audit.md). Include service ownership/dependencies, memory pressure, installed software and evidence-based uninstall candidates; inspection alone does not authorize removal.
