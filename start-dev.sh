#!/bin/bash
# Start fullstack and open VS Code inside the container (reuses current window manually)

set -euo pipefail
cd "$(dirname "$0")"

echo "🚀 Building images (showing detailed progress)..."
podman-compose build --progress=plain 2>&1 | tee build.log

echo "🚀 Starting containers..."
podman-compose up -d

# Get container ID (must match container_name in podman-compose.yml)
CONTAINER_ID=$(podman inspect -f '{{.Id}}' back_dev 2>/dev/null || true)
if [ -z "${CONTAINER_ID}" ]; then
  echo "❌ back_dev container not found. Check container_name in podman-compose.yml."
  exit 1
fi

TARGET="vscode-remote://attached-container+${CONTAINER_ID}/workspaces/back"

echo "💻 Opening VS Code inside container..."
code --folder-uri "${TARGET}"

echo "✅ Done! You can close the first VS Code window manually after this one opens."
