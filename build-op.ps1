$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# Read metadata from info.toml
$toml = Get-Content (Join-Path $root 'info.toml') | Out-String
$name = ($toml | Select-String -Pattern 'name\s*=\s*"(.*?)"').Matches.Groups[1].Value
$version = ($toml | Select-String -Pattern 'version\s*=\s*"(.*?)"').Matches.Groups[1].Value

# Sanitize name for filename
$safeName = $name.ToLower() -replace '\s+', '-'

# Construct output filename
$Output = "$safeName-v$version.op"

$items = @(
    'Main.as',
    'Theme.as',
    'Tasks.as',
    'Timer.as',
    'UI_Overlay.as',
    'StatsUI.as',
    'Icons.as',
    'info.toml',
    'assets',
    'README.md',
    'CHANGELOG.md',
    'CREDITS.md'
)

$stage = Join-Path $root '.stage'
if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
New-Item -ItemType Directory -Path $stage | Out-Null

foreach ($item in $items) {
    $src = Join-Path $root $item
    if (Test-Path $src) {
        Copy-Item $src -Destination $stage -Recurse -Force
    }
}

# Zip stage into .op (zip format)
$zipPath = Join-Path $root '..' $Output
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($stage, $zipPath)

Remove-Item $stage -Recurse -Force
Write-Host "Created $zipPath"
