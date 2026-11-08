# Setup and persistence

## Requirements

Windows 10/11 and Windows PowerShell 5.1 or PowerShell 7. The bundled measurement script uses only built-in process/.NET/CIM facilities. No module installation or credentials are required. An administrator token is needed only when changing elevated processes or registering elevated tasks.

If local execution policy blocks scripts, use -ExecutionPolicy Bypass only on the current powershell.exe invocation. This does not change machine/user policy or override enforced organization Group Policy.

Any agent can read SKILL.md directly from a shared library. For automatic discovery, copy the complete folder into that agent's supported skills directory; location conventions differ by product. Common local directories include ~/.agents/skills and ~/.codex/skills. A shared Drive folder is not automatically discovered by every agent. Refresh or restart skill discovery if the agent caches its skill list.

## Existing-policy discovery

Inspect `Get-ScheduledTask` for existing CPU/affinity policies, then read the selected task's action file and principal. Discover policy names and paths on the current machine rather than assuming an installation-specific name. If absent, design a new user-scoped policy using the user's authorized application allowlist.

For a user-logon policy, use Task Scheduler with an AtLogOn trigger for the actual user, an Interactive principal, Highest only if target privileges require it, and a hidden PowerShell action. Logon persistence starts after sign-in, not before. A polling monitor has a short delay before newly launched processes are restricted; do not describe it as immediate core isolation. Record the original action, settings, rules and process values before modifying them.

Affinity is a bitmask of logical CPU indexes: CPU0=1, CPU1=2, CPU2=4; CPUs0-2 together=7. Calculate masks from actual hardware; never assume a four-CPU machine. For more encoders than eligible CPUs, some encoders share CPUs. Existing process IDs are temporary; persistent rules must identify future process instances safely and handle PID reuse.

## References

- https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setprocessaffinitymask
- https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.processoraffinity
- https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtasktrigger

No setup action in this document authorizes changing unrelated programs, installing other library skills, or changing system boot configuration.

## Default background cleanup and monitor maintenance

For process-count complaints, inspect both application ownership and resource consumption. Save registry startup entries with key path, value name, value kind and raw data before removing a selected entry. Restore using New-ItemProperty with the recorded kind/data. Back up policy scripts and task XML before changing persistent behavior. Application exit is temporary unless startup configuration is explicitly changed; an application may recreate its startup entry later.

For an existing monitor, obtain the machine logical CPU count once before polling, not via CIM/WMI every iteration. Default to Start-Sleep -Seconds 5. Cache stable topology, but calculate masks from actual hardware. Bound logs to around 1 MiB and retain one rotated previous log. Restart only the identified scheduled task, then read back all target affinities and priorities with adequate privileges. Sample CPU deltas over a measured interval; report percent of total machine CPU, excluding inspection overhead where practical. Process and thread counts before/after are observations, not guaranteed causal gains.

Preserve enough recovery information to restore the previous script, task and live process settings. Avoid force-termination of unidentified helper processes or applications with possible unsaved work. No per-application example in this skill grants blanket authorization to stop that application on every machine.
