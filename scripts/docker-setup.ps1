# Docker setup script with persistence for Windows
# Usage: .\scripts\docker-setup.ps1 -Profile production|development|prebuilt

param(
    [ValidateSet("production", "development", "prebuilt")]
    [string]$Profile = "development"
)

$ErrorActionPreference = "Stop"

$DOCKER_DATA_DIR = ".docker"

Write-Host "🐳 Docker Setup - Profile: $Profile" -ForegroundColor Cyan
Write-Host "📁 Creating persistent storage directories..." -ForegroundColor Yellow

# Create data directories if they don't exist
$dirs = @(
    "$DOCKER_DATA_DIR/data",
    "$DOCKER_DATA_DIR/cache",
    "$DOCKER_DATA_DIR/npm-cache"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

Write-Host "✅ Directories created:" -ForegroundColor Green
Write-Host "   - $DOCKER_DATA_DIR/data (Wrangler config, application data)"
Write-Host "   - $DOCKER_DATA_DIR/cache (Build cache)"
Write-Host "   - $DOCKER_DATA_DIR/npm-cache (NPM package cache)"

Write-Host ""
Write-Host "🔨 Building and starting services..." -ForegroundColor Yellow

$profileArg = "--profile $Profile"

switch ($Profile) {
    "production" {
        & docker-compose $profileArg up -d --build
        Write-Host "✅ Production service started on http://localhost:5173" -ForegroundColor Green
    }
    "development" {
        & docker-compose $profileArg up -d --build
        Write-Host "✅ Development service started on http://localhost:5173" -ForegroundColor Green
    }
    "prebuilt" {
        & docker-compose $profileArg up -d
        Write-Host "✅ Prebuilt service started on http://localhost:5173" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "📊 Service Status:" -ForegroundColor Cyan
& docker-compose ps

$dataPath = (Get-Location).Path
Write-Host ""
Write-Host "💾 Persistent Data Locations:" -ForegroundColor Cyan
Write-Host "   Data: $dataPath\$DOCKER_DATA_DIR\data"
Write-Host "   Cache: $dataPath\$DOCKER_DATA_DIR\cache"
Write-Host "   NPM Cache: $dataPath\$DOCKER_DATA_DIR\npm-cache"

Write-Host ""
Write-Host "📝 Available Commands:" -ForegroundColor Cyan
Write-Host "   - View logs: docker-compose logs -f"
Write-Host "   - Stop services: docker-compose down"
Write-Host "   - Remove volumes: docker-compose down -v"
Write-Host "   - Rebuild: docker-compose build --no-cache"
