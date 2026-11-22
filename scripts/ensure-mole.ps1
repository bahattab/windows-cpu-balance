$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT') { throw 'WCB requires Windows.' }

$root = Join-Path $env:LOCALAPPDATA 'WCB\Mole'
$installed = Join-Path $root '1.46.0'
$launcher = Join-Path $installed 'mo.exe'
if (Test-Path -LiteralPath $launcher -PathType Leaf) { return $launcher }

$existing = Get-Command mo.exe,mo.cmd -CommandType Application -ErrorAction SilentlyContinue |
    Select-Object -First 1
if ($existing) {
    $version = & $existing.Source --version
    if ($LASTEXITCODE -eq 0 -and ($version -join "`n") -match '(?m)^Windows:' -and
        ($version -join "`n") -match '(?m)^Mole version (\d+\.\d+\.\d+)\b' -and
        [version]$Matches[1] -ge [version]'1.46.0') {
        return $existing.Source
    }
}
if ($env:PROCESSOR_ARCHITECTURE -ne 'AMD64' -and $env:PROCESSOR_ARCHITEW6432 -ne 'AMD64') {
    throw 'WCB automatic Mole installation requires x64 Windows. A compatible existing Mole installation can be used on other Windows architectures.'
}

New-Item -ItemType Directory -Path $root -Force | Out-Null
$root = (Resolve-Path -LiteralPath $root).Path
$stage = Join-Path $root ([guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stage | Out-Null
try {
    $archive = Join-Path $stage 'mole.zip'
    $payload = Join-Path $stage 'payload'
    Invoke-WebRequest -UseBasicParsing -TimeoutSec 120 -Uri 'https://github.com/tw93/Mole/releases/download/V1.46.0-windows/mole-1.46.0-x64.zip' -OutFile $archive
    $expected = '81a3633957cbf9258d4cc362ef79f89e059e8c37b2718a2ef39205b1c6782bcc'
    if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash -ne $expected) {
        throw 'Mole archive failed SHA-256 verification.'
    }
    Expand-Archive -LiteralPath $archive -DestinationPath $payload
    $probe = & (Join-Path $payload 'mo.exe') --version
    if ($LASTEXITCODE -ne 0 -or ($probe -join "`n") -notmatch '(?m)^Mole version 1\.46\.0\b') {
        throw 'Mole release launcher failed its version check.'
    }
    try {
        [IO.Directory]::Move($payload, $installed)
    } catch [IO.IOException] {
        if (!(Test-Path -LiteralPath $launcher -PathType Leaf)) { throw }
    }
    return $launcher
} finally {
    $resolved = (Resolve-Path -LiteralPath $stage).Path
    if ([IO.Path]::GetDirectoryName($resolved) -eq $root -and
        [IO.Path]::GetFileName($resolved) -match '^[a-f0-9]{32}$') {
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
