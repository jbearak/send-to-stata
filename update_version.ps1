<#
.SYNOPSIS
    Release script for send-to-stata. Builds, tests, commits, tags, and pushes.

.PARAMETER Version
    The version number to release (e.g., 0.2.0)

.EXAMPLE
    .\update_version.ps1 0.2.0
#>
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Version
)

$ErrorActionPreference = 'Stop'

# Validate version format
if ($Version -notmatch '^\d+\.\d+\.\d+$') {
    Write-Error "Invalid version format. Use semantic versioning (e.g., 0.2.0)"
    exit 1
}

$tag = "v$Version"
$csprojPath = "$PSScriptRoot\SendToStata.csproj"

# Check for uncommitted changes
$status = git status --porcelain
if ($status) {
    Write-Error "Working directory has uncommitted changes. Commit or stash them first."
    exit 1
}

# Check if tag already exists
$existingTag = git tag -l $tag
if ($existingTag) {
    Write-Error "Tag $tag already exists"
    exit 1
}

Write-Host "Releasing version $Version..." -ForegroundColor Cyan

# Update version in .csproj
Write-Host "Updating version in SendToStata.csproj..." -ForegroundColor Yellow
$content = Get-Content $csprojPath -Raw
$content = $content -replace '<Version>[^<]+</Version>', "<Version>$Version</Version>"
Set-Content $csprojPath $content -NoNewline

# Build
Write-Host "Building..." -ForegroundColor Yellow
dotnet build --configuration Release
if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed"
    git checkout $csprojPath
    exit 1
}

# Run tests
Write-Host "Running tests..." -ForegroundColor Yellow
dotnet test --configuration Release --no-build
if ($LASTEXITCODE -ne 0) {
    Write-Error "Tests failed"
    git checkout $csprojPath
    exit 1
}

# Commit
Write-Host "Committing..." -ForegroundColor Yellow
git add $csprojPath
git commit -m "Release $tag"

# Tag
Write-Host "Creating tag $tag..." -ForegroundColor Yellow
git tag -a $tag -m "Release $tag"

# Push
Write-Host "Pushing to origin..." -ForegroundColor Yellow
git push origin main
git push origin $tag

Write-Host "Successfully released $tag" -ForegroundColor Green
