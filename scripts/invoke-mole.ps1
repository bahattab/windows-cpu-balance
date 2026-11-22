param(
    [ValidateSet('Version','Status','CleanPreview','OptimizePreview','InstalledApps')]
    [string]$Action = 'Status'
)
$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT') { throw 'Mole integration requires Windows.' }
$mole = Get-Command mo.cmd -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
if (!$mole) { throw 'Install the official Mole for Windows CLI and make mo.cmd available on PATH.' }
$arguments = @(switch ($Action) {
    Version { '--version' }
    Status { 'status', '--json' }
    CleanPreview { 'clean', '--dry-run' }
    OptimizePreview { 'optimize', '--dry-run' }
    InstalledApps { 'uninstall', '--list' }
})
& $mole.Source @arguments
exit $LASTEXITCODE
