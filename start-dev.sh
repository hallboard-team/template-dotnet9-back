#!/bin/bash
# Start fullstack and open VS Code inside the container (dynamic name + port)

set -euo pipefail
cd "$(dirname "$0")"

# Use provided name and port or default to folder-based name + 5000
CONTAINER_NAME="${1:-$(basename "$(pwd)")_dev}"
PORT="${2:-5000}"

export CONTAINER_NAME
export PORT

echo "🚀 Building and starting containers for: $CONTAINER_NAME on port $PORT ..."
podman-compose up -d --build

# Get container ID dynamically
CONTAINER_ID=$(podman inspect -f '{{.Id}}' "$CONTAINER_NAME" 2>/dev/null || true)
if [ -z "${CONTAINER_ID}" ]; then
  echo "❌ Container '$CONTAINER_NAME' not found. Check 'container_name' in podman-compose.yml."
  exit 1
fi

TARGET="vscode-remote://attached-container+${CONTAINER_ID}/workspaces/back"

echo "💻 Opening VS Code in container: $CONTAINER_NAME ..."
code --folder-uri "${TARGET}"
