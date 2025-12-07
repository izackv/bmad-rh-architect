#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# RH Architect Expansion Pack Installer
# ============================================================
# Usage:
#   ./install.sh /path/to/bmad-enabled-project
#   ./install.sh /path/to/bmad-enabled-project --force
#
# Example:
#   ./install.sh ~/dev/my-app

FORCE_INSTALL=false

# Parse arguments
if [ $# -lt 1 ]; then
  echo "Usage: $0 /path/to/bmad-project [--force]"
  echo ""
  echo "Options:"
  echo "  --force    Skip BMAD installation check"
  exit 1
fi

TARGET_PROJECT_DIR="$1"

if [ "${2:-}" = "--force" ]; then
  FORCE_INSTALL=true
fi

# ============================================================
# Step 1: Validate target directory exists
# ============================================================
if [ ! -d "$TARGET_PROJECT_DIR" ]; then
  echo "[ERROR] Target directory '$TARGET_PROJECT_DIR' does not exist."
  echo ""
  echo "Please create the directory first or specify an existing path."
  exit 1
fi

# ============================================================
# Step 2: Check if BMAD is installed in target directory
# ============================================================
BMAD_FOUND=false

if [ -d "$TARGET_PROJECT_DIR/bmad-core" ] || \
   [ -d "$TARGET_PROJECT_DIR/.bmad-core" ] || \
   [ -f "$TARGET_PROJECT_DIR/.bmad-config.yaml" ]; then
  BMAD_FOUND=true
fi

if [ "$BMAD_FOUND" = false ] && [ "$FORCE_INSTALL" = false ]; then
  echo "[ERROR] BMAD is not installed in '$TARGET_PROJECT_DIR'"
  echo ""
  echo "This expansion pack requires BMAD to be installed first."
  echo ""
  echo "To install BMAD, run:"
  echo "  cd $TARGET_PROJECT_DIR"
  echo "  npx bmad-method install"
  echo ""
  echo "Then run this installer again:"
  echo "  $0 $TARGET_PROJECT_DIR"
  echo ""
  echo "Or use --force to skip this check (not recommended):"
  echo "  $0 $TARGET_PROJECT_DIR --force"
  exit 1
fi

if [ "$BMAD_FOUND" = false ] && [ "$FORCE_INSTALL" = true ]; then
  echo "[WARN] BMAD not detected, but continuing due to --force flag."
fi

# ============================================================
# Step 3: Check Python 3 is installed
# ============================================================
if ! command -v python3 >/dev/null 2>&1; then
  echo "[ERROR] Python 3 is required but not installed."
  echo ""
  echo "Please install Python 3:"
  echo ""
  echo "  macOS:   brew install python3"
  echo "  Ubuntu:  sudo apt install python3 python3-pip"
  echo "  Fedora:  sudo dnf install python3 python3-pip"
  echo ""
  echo "Then run this installer again."
  exit 1
fi

echo "[OK] Python 3 found: $(python3 --version)"

# ============================================================
# Step 4: Install bmad-pack-installer if needed
# ============================================================
if ! command -v bmad-pack-installer >/dev/null 2>&1; then
  echo ""
  echo "[INFO] Installing bmad-pack-installer..."
  
  if ! python3 -m pip install --user bmad-pack-installer 2>&1; then
    echo ""
    echo "[ERROR] Failed to install bmad-pack-installer"
    echo ""
    echo "Try installing manually:"
    echo "  python3 -m pip install --user bmad-pack-installer"
    echo ""
    echo "If you get permission errors, try:"
    echo "  python3 -m pip install --user --break-system-packages bmad-pack-installer"
    exit 1
  fi
  
  # Add ~/.local/bin to PATH for this session
  export PATH="$HOME/.local/bin:$PATH"
  
  # Verify installation
  if ! command -v bmad-pack-installer >/dev/null 2>&1; then
    echo ""
    echo "[ERROR] bmad-pack-installer installed but not found in PATH"
    echo ""
    echo "Add ~/.local/bin to your PATH:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "Add this line to your ~/.bashrc or ~/.zshrc to make it permanent."
    echo "Then run this installer again."
    exit 1
  fi
fi

echo "[OK] bmad-pack-installer found: $(command -v bmad-pack-installer)"

# ============================================================
# Step 5: Deploy the expansion pack
# ============================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "[INFO] Deploying RH Architect expansion pack..."
echo "       From: $SCRIPT_DIR"
echo "       To:   $TARGET_PROJECT_DIR"
echo ""

if ! bmad-pack-installer deploy . "$TARGET_PROJECT_DIR"; then
  echo ""
  echo "[ERROR] bmad-pack-installer deploy failed"
  echo ""
  echo "Check the error messages above and try again."
  exit 1
fi

echo "[OK] Expansion pack deployed successfully"

# ============================================================
# Step 6: Generate Cursor IDE rules (.mdc files)
# ============================================================
echo ""
echo "[INFO] Setting up Cursor IDE support..."

CURSOR_RULES_DIR="$TARGET_PROJECT_DIR/.cursor/rules/bmad"
mkdir -p "$CURSOR_RULES_DIR"

# Find the installed agents directory
PACK_NAME="bmad-rh-architect"
INSTALLED_AGENTS_DIR=""

# Check possible locations where agents might be installed
for possible_dir in \
    "$TARGET_PROJECT_DIR/.$PACK_NAME/agents" \
    "$TARGET_PROJECT_DIR/$PACK_NAME/agents" \
    "$TARGET_PROJECT_DIR/.bmad-core/expansion-packs/$PACK_NAME/agents" \
    "$SCRIPT_DIR/agents"; do
  if [ -d "$possible_dir" ]; then
    INSTALLED_AGENTS_DIR="$possible_dir"
    break
  fi
done

# Fallback: use the source agents directory from this pack
if [ -z "$INSTALLED_AGENTS_DIR" ] && [ -d "$SCRIPT_DIR/agents" ]; then
  INSTALLED_AGENTS_DIR="$SCRIPT_DIR/agents"
fi

CURSOR_AGENTS_CREATED=0

if [ -n "$INSTALLED_AGENTS_DIR" ] && [ -d "$INSTALLED_AGENTS_DIR" ]; then
  echo "       Found agents in: $INSTALLED_AGENTS_DIR"
  
  for agent_file in "$INSTALLED_AGENTS_DIR"/*.md; do
    if [ -f "$agent_file" ]; then
      # Get agent name without extension
      agent_name=$(basename "$agent_file" .md)
      mdc_file="$CURSOR_RULES_DIR/${agent_name}.mdc"
      
      # Extract title from agent file (first # heading or fallback to filename)
      title=$(grep -m1 "^# " "$agent_file" 2>/dev/null | sed 's/^# //' || echo "$agent_name")
      
      # Calculate relative path from project root to agent file
      if [[ "$INSTALLED_AGENTS_DIR" == "$TARGET_PROJECT_DIR"* ]]; then
        relative_path="${INSTALLED_AGENTS_DIR#$TARGET_PROJECT_DIR/}/$(basename "$agent_file")"
      else
        relative_path=".bmad-rh-architect/agents/$(basename "$agent_file")"
      fi
      
      # Create .mdc file with proper frontmatter
      cat > "$mdc_file" << EOF
---
description: ${title}
globs: 
alwaysApply: false
---

Load and follow all instructions from: ${relative_path}
EOF
      
      echo "       + ${agent_name}.mdc"
      ((CURSOR_AGENTS_CREATED++)) || true
    fi
  done
else
  echo "[WARN] Could not find agents directory"
  echo "       You may need to create .mdc files manually in .cursor/rules/bmad/"
fi

# ============================================================
# Installation Complete
# ============================================================
echo ""
echo "============================================================"
echo " Installation complete"
echo "============================================================"
echo ""
echo "Installed to: $TARGET_PROJECT_DIR"
if [ $CURSOR_AGENTS_CREATED -gt 0 ]; then
  echo "Cursor rules: $CURSOR_AGENTS_CREATED agent(s) configured"
fi
echo ""
echo "Claude Code usage:"
echo "  /rh-it-architect help"
echo "  /rhArch discovery"
echo "  /rhArch create-hld"
echo ""
echo "Cursor IDE usage:"
echo "  Type @rh-it-architect in chat (Ctrl+L / Cmd+L)"
echo "  Select the .mdc file from autocomplete"
echo ""
echo "Tip: Add to Cursor settings.json for better .mdc editing:"
echo '  "workbench.editorAssociations": { "*.mdc": "default" }'
echo ""
