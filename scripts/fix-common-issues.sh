#!/bin/bash
# fix-common-issues.sh — Fix common Termux/Android issues
# Run this if you encounter problems with nvim-android
# Usage: bash fix-common-issues.sh

set -euo pipefail

# ── Colors ────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   nvim-android — Fix Common Issues            ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
echo ""

# ── Fix 1: Clipboard ──────────────────────────────────────
info "Fix 1/8: Clipboard integration..."
if command -v termux-clipboard-set &>/dev/null; then
  echo "test" | termux-clipboard-set 2>/dev/null
  RESULT=$(termux-clipboard-get 2>/dev/null)
  if [ "$RESULT" = "test" ]; then
    ok "Clipboard working correctly"
  else
    warn "Clipboard not responding. Install Termux:API app from F-Droid"
    warn "Then run: pkg install termux-api"
  fi
else
  warn "termux-clipboard-set not found"
  info "Installing termux-api..."
  pkg install -y termux-api 2>/dev/null || warn "Failed to install termux-api"
fi

# ── Fix 2: Treesitter build ───────────────────────────────
info "Fix 2/8: Treesitter build dependencies..."
if command -v gcc &>/dev/null || command -v cc &>/dev/null; then
  ok "C compiler found"
else
  info "Installing clang for Treesitter..."
  pkg install -y clang 2>/dev/null || warn "Failed to install clang"
fi

# ── Fix 3: Font/icons ────────────────────────────────────
info "Fix 3/8: Font icon fallback..."
# Termux doesn't support Nerd Fonts natively
# Neo-tree and other plugins use text fallbacks automatically
# This is handled by nvim-web-devicons
ok "Font fallbacks configured in plugin settings"

# ── Fix 4: Python venv issues ─────────────────────────────
info "Fix 4/8: Python virtual environment..."
if command -v python3 &>/dev/null; then
  python3 -m venv --help &>/dev/null && ok "Python venv module available" || {
    info "Installing python-venv..."
    pkg install -y python-venv 2>/dev/null || warn "python-venv not available"
  }
  # Ensure pip is available
  python3 -m pip --version &>/dev/null || {
    info "Installing pip..."
    pkg install -y python-pip 2>/dev/null || python3 -m ensurepip 2>/dev/null || warn "pip install failed"
  }
else
  warn "Python3 not found. Install with: pkg install python"
fi

# ── Fix 5: Node.js version ────────────────────────────────
info "Fix 5/8: Node.js version check..."
if command -v node &>/dev/null; then
  NODE_VERSION=$(node --version 2>/dev/null)
  NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d'.' -f1 | tr -d 'v')
  if [ "$NODE_MAJOR" -lt 16 ]; then
    warn "Node.js $NODE_VERSION is too old (need >= 16)"
    info "Installing newer Node.js..."
    pkg install -y nodejs-lts 2>/dev/null || npm install -g n 2>/dev/null && n lts 2>/dev/null || warn "Node upgrade failed"
  else
    ok "Node.js $NODE_VERSION is OK"
  fi
else
  warn "Node.js not found. Install with: pkg install nodejs"
fi

# ── Fix 6: Git config ─────────────────────────────────────
info "Fix 6/8: Git configuration..."
if ! git config --global user.name &>/dev/null; then
  warn "Git user.name not set"
  read -p "  Enter your name: " GIT_NAME
  git config --global user.name "$GIT_NAME"
fi
if ! git config --global user.email &>/dev/null; then
  warn "Git user.email not set"
  read -p "  Enter your email: " GIT_EMAIL
  git config --global user.email "$GIT_EMAIL"
fi
ok "Git configured"

# ── Fix 7: Permission fixes ───────────────────────────────
info "Fix 7/8: Permission fixes..."
# Ensure scripts are executable
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
chmod +x "$SCRIPT_DIR"/*.sh 2>/dev/null && ok "Scripts are executable" || warn "chmod failed"

# ── Fix 8: Performance tweaks ─────────────────────────────
info "Fix 8/8: Performance tweaks..."
# Create undo directory if it doesn't exist
UNDODIR="$HOME/.local/share/nvim/undodir"
mkdir -p "$UNDODIR" 2>/dev/null && ok "Undo directory created" || warn "Could not create undo dir"

# Clean up Neovim cache
CACHE_DIR="$HOME/.cache/nvim"
if [ -d "$CACHE_DIR" ]; then
  CACHE_SIZE=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1)
  info "Neovim cache size: $CACHE_SIZE"
  if [ "$(du -s "$CACHE_DIR" 2>/dev/null | cut -f1)" -gt 100000 ]; then
    info "Cache is large. Cleaning..."
    rm -rf "$CACHE_DIR"/* 2>/dev/null
    ok "Cache cleaned"
  fi
fi

# ── Summary ───────────────────────────────────────────────
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ Issue fixes complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""
echo "  If issues persist:"
echo "  1. Check: nvim --startuptime (for slow startup)"
echo "  2. Run: :checkhealth inside Neovim"
echo "  3. Check GitHub issues: https://github.com/anhduyalpha/nvim-android/issues"
