param(
    [ValidateSet('Version','Status','CleanPreview','OptimizePreview','InstalledApps')]
    [string]$Action = 'Status'
)
$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT') { throw 'Mole integration requires Windows.' }
$mole = & (Join-Path $PSScriptRoot 'ensure-mole.ps1')
$arguments = @(switch ($Action) {
    Version { '--version' }
    Status { 'status', '--json' }
    CleanPreview { 'clean', '--dry-run' }
    OptimizePreview { 'optimize', '--dry-run' }
    InstalledApps { 'uninstall', '--list' }
})
& $mole @arguments
exit $LASTEXITCODE
