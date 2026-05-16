#!/bin/bash
# setup-termux.sh — One-time Termux setup script
# Run this FIRST after installing Termux from F-Droid
# Usage: bash setup-termux.sh

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
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ── Progress indicator ────────────────────────────────────
progress() {
  local current=$1 total=$2
  local pct=$((current * 100 / total))
  local filled=$((pct / 2))
  local empty=$((50 - filled))
  printf "\r  ["
  printf "%0.s█" $(seq 1 $filled 2>/dev/null) || true
  printf "%0.s " $(seq 1 $empty 2>/dev/null) || true
  printf "] %d%%" "$pct"
}

STEP=0
TOTAL_STEPS=8

# ── Step 1: Verify Termux ─────────────────────────────────
STEP=$((STEP + 1))
progress $STEP $TOTAL_STEPS
echo ""
info "Step 1/8: Verifying Termux environment..."

if [ ! -d "/data/data/com.termux" ]; then
  error "This script must be run inside Termux!"
fi
ok "Running inside Termux"

# ── Step 2: Update packages ───────────────────────────────
STEP=$((STEP + 1))
progress $STEP $TOTAL_STEPS
echo ""
info "Step 2/8: Updating packages..."
apt update -y
apt upgrade -y
ok "Packages updated"

# ── Step 3: Install core dependencies ─────────────────────
STEP=$((STEP + 1))
progress $STEP $TOTAL_STEPS
echo ""
info "Step 3/8: Installing core dependencies..."
CORE_PKGS="git nodejs python ripgrep fd lazygit unzip wget curl clang make"
for pkg_name in $CORE_PKGS; do
  if ! command -v "$pkg_name" &>/dev/null && ! dpkg -l | grep -q "$pkg_name" 2>/dev/null; then
    info "  Installing $pkg_name..."
    apt install -y "$pkg_name" 2>/dev/null || warn "  Failed to install $pkg_name (may be optional)"
  else
    ok "  $pkg_name already installed"
  fi
done
ok "Core dependencies installed"

# ── Step 4: Install optional language tools ────────────────
STEP=$((STEP + 1))
progress $STEP $TOTAL_STEPS
echo ""
info "Step 4/8: Installing optional language tools..."
OPTIONAL_PKGS="rust golang"
for pkg_name in $OPTIONAL_PKGS; do
  if ! command -v "$pkg_name" &>/dev/null; then
    info "  Installing $pkg_name (optional)..."
    apt install -y "$pkg_name" 2>/dev/null || warn "  Failed to install $pkg_name"
  fi
done
ok "Optional tools processed"

# ── Step 5: Setup storage access ──────────────────────────
STEP=$((STEP + 1))
progress $STEP $TOTAL_STEPS
echo ""
info "Step 5/8: Setting up storage access..."
if [ ! -d "$HOME/storage" ]; then
  termux-setup-storage 2>/dev/null || warn "Storage setup requires user interaction"
fi
ok "Storage configured"

# ── Step 6: Install Neovim ────────────────────────────────
STEP=$((STEP + 1))
progress $STEP $TOTAL_STEPS
echo ""
info "Step 6/8: Installing Neovim..."
if ! command -v nvim &>/dev/null; then
  apt install -y neovim 2>/dev/null || error "Failed to install Neovim"
fi
NVIM_VERSION=$(nvim --version | head -1)
ok "Neovim installed: $NVIM_VERSION"

# ── Step 7: Install termux-api (clipboard support) ────────
STEP=$((STEP + 1))
progress $STEP $TOTAL_STEPS
echo ""
info "Step 7/8: Installing termux-api..."
if ! command -v termux-clipboard-set &>/dev/null; then
  apt install -y termux-api 2>/dev/null || warn "termux-api install failed (clipboard may not work)"
fi
ok "termux-api configured"

# ── Step 8: Clone nvim-android config ─────────────────────
STEP=$((STEP + 1))
progress $STEP $TOTAL_STEPS
echo ""
info "Step 8/8: Setting up nvim-android config..."

NVIM_CONFIG_DIR="$HOME/.config/nvim"
REPO_URL="https://github.com/anhduyalpha/nvim-android.git"

# Backup existing config
if [ -d "$NVIM_CONFIG_DIR" ]; then
  BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
  warn "Existing config found. Backing up to: $BACKUP_DIR"
  mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

# Clone the repo
mkdir -p "$HOME/.config"
info "Cloning nvim-android..."
git clone "$REPO_URL" "$NVIM_CONFIG_DIR" || error "Failed to clone repo"
ok "nvim-android config installed"

# ── Done ──────────────────────────────────────────────────
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ Setup complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Next steps:"
echo -e "  1. Run ${BLUE}nvim${NC} to start (plugins will auto-install)"
echo -e "  2. Run ${BLUE}:Lazy${NC} inside Neovim to check plugin status"
echo -e "  3. Run ${BLUE}:Mason${NC} to install LSP servers"
echo -e "  4. (Optional) Run ${BLUE}bash scripts/install-deps.sh${NC} for language deps"
echo ""
echo -e "  Enjoy your Android IDE! 🚀"
