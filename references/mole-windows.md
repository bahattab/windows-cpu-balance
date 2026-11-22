# Mole CLI for Windows

WCB calls the [upstream Mole Windows CLI](https://github.com/tw93/Mole/tree/windows) as a separate program. Tested with [V1.46.0-windows](https://github.com/tw93/Mole/releases/tag/V1.46.0-windows). Mole is maintained by tw93 under GPL-3.0. See the [upstream agent skill](https://github.com/tw93/Mole/blob/main/skills/mole/SKILL.md) for its complete workflow.

WCB setup and every Mole action ensure Mole is ready automatically. They reuse a compatible Windows CLI version 1.46.0 or later on PATH, or download the pinned official x64 release, verify its SHA-256 digest, and install it under %LOCALAPPDATA%\WCB\Mole\1.46.0. The first download needs internet access. Subsequent actions reuse the local package. The managed copy is per user and requires no administrator access or PATH change. To remove it, delete only that version directory. WCB will reinstall it on the next Mole action.

| WCB action | Upstream command | Purpose |
| --- | --- | --- |
| Version | `mo --version` | Check the installed edition and version |
| Status | `mo status --json` | Check system load and resources |
| CleanPreview | `mo clean --dry-run` | Estimate space recovery |
| OptimizePreview | `mo optimize --dry-run` | Review proposed maintenance |
| InstalledApps | `mo uninstall --list` | Inventory installed software |

Call `scripts/invoke-mole.ps1 -Action <action>` from Windows PowerShell. The wrapper accepts only the actions above. Verify the Windows edition with Version before using the other actions. Diagnose responsiveness with repeated WCB measurements and use Mole status for complementary metrics. A disk cleanup estimate describes disk space. Preview output may include personal paths and Mole may write a local preview list or cache. Keep those records local and report preview failures explicitly.

Preserve chats, task processes, browser sessions, sync, and networking. Review a fresh preview with the user before any cleanup because some Mole operations permanently delete files. Leave uninstall selections and elevated maintenance to the user. Keep scheduled WCB runs diagnostic.
