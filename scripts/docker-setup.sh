#!/bin/bash
# Docker setup script with persistence
# Usage: ./scripts/docker-setup.sh [production|development|prebuilt]

set -e

PROFILE="${1:-development}"
DOCKER_DATA_DIR=".docker"

echo "🐳 Docker Setup - Profile: $PROFILE"
echo "📁 Creating persistent storage directories..."

# Create data directories if they don't exist
mkdir -p "$DOCKER_DATA_DIR/data"
mkdir -p "$DOCKER_DATA_DIR/cache"
mkdir -p "$DOCKER_DATA_DIR/npm-cache"

echo "✅ Directories created:"
echo "   - $DOCKER_DATA_DIR/data (Wrangler config, application data)"
echo "   - $DOCKER_DATA_DIR/cache (Build cache)"
echo "   - $DOCKER_DATA_DIR/npm-cache (NPM package cache)"

echo ""
echo "🔨 Building and starting services..."

case "$PROFILE" in
  production)
    docker-compose --profile production up -d --build
    echo "✅ Production service started on http://localhost:5173"
    ;;
  development)
    docker-compose --profile development up -d --build
    echo "✅ Development service started on http://localhost:5173"
    ;;
  prebuilt)
    docker-compose --profile prebuilt up -d
    echo "✅ Prebuilt service started on http://localhost:5173"
    ;;
  *)
    echo "❌ Unknown profile: $PROFILE"
    echo "Usage: ./scripts/docker-setup.sh [production|development|prebuilt]"
    exit 1
    ;;
esac

echo ""
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "💾 Persistent Data Locations:"
echo "   Data: $(pwd)/$DOCKER_DATA_DIR/data"
echo "   Cache: $(pwd)/$DOCKER_DATA_DIR/cache"
echo "   NPM Cache: $(pwd)/$DOCKER_DATA_DIR/npm-cache"

echo ""
echo "📝 Available Commands:"
echo "   - View logs: docker-compose logs -f"
echo "   - Stop services: docker-compose down"
echo "   - Remove volumes: docker-compose down -v"
echo "   - Rebuild: docker-compose build --no-cache"
