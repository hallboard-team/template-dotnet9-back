#!/bin/bash
# Start .NET + VS Code dev container with dynamic version, port, and name

set -euo pipefail
cd "$(dirname "$0")"

# Usage: ./start-dev.sh <container_name> <port> <dotnet_version>
CONTAINER_NAME="${1:-$(basename "$(pwd)")_dev}"
PORT="${2:-5000}"
DOTNET_VERSION="${3:-9.0}"

export CONTAINER_NAME
export PORT
export DOTNET_VERSION

echo "🚀 Starting container '$CONTAINER_NAME' (port $PORT, .NET $DOTNET_VERSION)..."
podman-compose up -d --build

CONTAINER_ID=$(podman inspect -f '{{.Id}}' "$CONTAINER_NAME" 2>/dev/null || true)
if [ -z "$CONTAINER_ID" ]; then
  echo "❌ Container '$CONTAINER_NAME' not found."
  exit 1
fi

TARGET="vscode-remote://attached-container+${CONTAINER_ID}/workspaces/back"

echo "💻 Opening VS Code in container '$CONTAINER_NAME'..."
code --folder-uri "${TARGET}"
