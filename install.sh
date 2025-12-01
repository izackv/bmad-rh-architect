#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./install.sh /path/to/bmad-enabled-project
#
# Example:
#   ./install.sh ~/dev/my-app

if [ $# -ne 1 ]; then
  echo "Usage: $0 /path/to/bmad-project"
  exit 1
fi

TARGET_PROJECT_DIR="$1"

if [ ! -d "$TARGET_PROJECT_DIR" ]; then
  echo "Error: target project directory '$TARGET_PROJECT_DIR' does not exist."
  exit 1
fi

# Basic heuristic: check for a BMAD core marker directory or file.
if [ ! -d "$TARGET_PROJECT_DIR/bmad-core" ] &&    [ ! -d "$TARGET_PROJECT_DIR/.bmad-core" ] &&    [ ! -f "$TARGET_PROJECT_DIR/.bmad-config.yaml" ]; then
  echo "Warning: target directory does not look like a BMAD project."
  echo "Make sure you installed BMAD core there first (for example using your internal 'npx bmad-method install')."
fi

# Check python3
if ! command -v python3 >/dev/null 2>&1; then
  echo "Error: python3 is required to install bmad-pack-installer."
  echo "Please install Python 3 and try again."
  exit 1
fi

# Check bmad-pack-installer
if ! command -v bmad-pack-installer >/dev/null 2>&1; then
  echo "bmad-pack-installer not found. Installing it with pip3..."
  python3 -m pip install --user bmad-pack-installer

  export PATH="$HOME/.local/bin:$PATH"

  if ! command -v bmad-pack-installer >/dev/null 2>&1; then
    echo "Error: bmad-pack-installer still not found in PATH after installation."
    echo "Make sure ~/.local/bin is in your PATH and try again."
    exit 1
  fi
fi

echo "Using bmad-pack-installer at: $(command -v bmad-pack-installer)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Deploying RH Architect expansion pack to: $TARGET_PROJECT_DIR"
bmad-pack-installer deploy . "$TARGET_PROJECT_DIR"

echo "Done."
echo
echo "Next steps:"
echo "  - Open your BMAD-enabled project at: $TARGET_PROJECT_DIR"
echo "  - Use the new agent via slash commands, for example:"
echo "      /rhArch help"
echo "      /rhArch discovery"
echo "      /rhArch create-hld"
