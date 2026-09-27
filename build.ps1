# PowerShell cross-platform static compilation script for vpcdrain
$ErrorActionPreference = "Stop"

$BinaryName = "vpcdrain"
$BuildDir = "bin"
$Version = "1.0.0"
$LdFlags = "-s -w -X main.version=$Version"

Write-Host "==> Building vpcdrain cross-platform static binaries (CGO_ENABLED=0)..." -ForegroundColor Cyan

if (-not (Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir | Out-Null
}

$targets = @(
    @{ OS = "linux";   Arch = "amd64"; Ext = "" },
    @{ OS = "linux";   Arch = "arm64"; Ext = "" },
    @{ OS = "darwin";  Arch = "amd64"; Ext = "" },
    @{ OS = "darwin";  Arch = "arm64"; Ext = "" },
    @{ OS = "windows"; Arch = "amd64"; Ext = ".exe" }
)

$env:CGO_ENABLED = "0"

foreach ($target in $targets) {
    $out = "$BuildDir/$BinaryName-$($target.OS)-$($target.Arch)$($target.Ext)"
    Write-Host "  -> Compiling $out ($($target.OS)/$($target.Arch))..." -ForegroundColor Yellow
    $env:GOOS = $target.OS
    $env:GOARCH = $target.Arch
    go build -ldflags $LdFlags -o $out ./cmd/vpcdrain
}

Write-Host "==> All binaries successfully compiled to $BuildDir/!" -ForegroundColor Green
Get-ChildItem -Path $BuildDir | Format-Table Name, Length, LastWriteTime
