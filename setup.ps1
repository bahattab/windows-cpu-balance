[CmdletBinding()]
param([string]$SkillDirectory)
$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT') { throw 'WCB setup requires Windows.' }
$files = @(
    'SKILL.md', 'README.md', 'VERSION', 'setup.ps1',
    'references/mole-windows.md', 'references/service-software-audit.md',
    'references/setup-and-persistence.md', 'scripts/invoke-mole.ps1', 'scripts/measure-cpu.ps1'
)
foreach ($file in $files) {
    if (!(Test-Path -LiteralPath (Join-Path $PSScriptRoot $file) -PathType Leaf)) {
        throw "Incomplete WCB package: $file"
    }
}
if ($SkillDirectory) {
    $destination = [IO.Path]::GetFullPath($SkillDirectory)
    if ($destination.TrimEnd('\') -ne $PSScriptRoot.TrimEnd('\')) {
        $backup = Join-Path $env:LOCALAPPDATA ('WCB\skill-backups\' + [guid]::NewGuid())
        foreach ($file in $files) {
            $target = Join-Path $destination $file
            if (Test-Path -LiteralPath $target -PathType Leaf) {
                $saved = Join-Path $backup $file
                New-Item -ItemType Directory -Path (Split-Path -Parent $saved) -Force | Out-Null
                Copy-Item -LiteralPath $target -Destination $saved
            }
        }
        if (Test-Path -LiteralPath $backup) { Write-Output "Previous files: $backup" }
        foreach ($file in $files) {
            $target = Join-Path $destination $file
            New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
            Copy-Item -LiteralPath (Join-Path $PSScriptRoot $file) -Destination $target -Force
        }
        Write-Output "WCB installed: $destination"
    }
}
if (Get-Command mo.cmd -CommandType Application -ErrorAction SilentlyContinue) {
    Write-Output 'Mole is available. Verify with scripts/invoke-mole.ps1 -Action Version.'
} else {
    Write-Output 'Core WCB is ready. For optional Mole actions, install the official Mole for Windows CLI and make mo.cmd available on PATH.'
}
