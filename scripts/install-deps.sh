#!/bin/bash
# install-deps.sh — Interactive language dependency installer
# Run after setup-termux.sh to install language-specific tools
# Usage: bash install-deps.sh

set -euo pipefail

# ── Colors ────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ── Check environment ─────────────────────────────────────
if [ ! -d "/data/data/com.termux" ]; then
  warn "Not running in Termux. Some commands may not work."
fi

# ── Menu ──────────────────────────────────────────────────
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   nvim-android — Language Dependencies        ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════╝${NC}"
echo ""
echo "  Select languages to install:"
echo ""
echo "  [1] Python     (pyright, black, ruff, debugpy)     ~50MB"
echo "  [2] JavaScript (typescript-language-server, prettier, eslint) ~80MB"
echo "  [3] Rust       (rust-analyzer, cargo)               ~200MB"
echo "  [4] Go         (gopls, delve)                       ~150MB"
echo "  [5] C/C++      (clangd, clang-format, lldb)         ~100MB"
echo "  [6] Java       (jdtls) ⚠️  VERY HEAVY             ~500MB"
echo "  [7] All of the above                                ~700MB+"
echo "  [0] Skip / Exit"
echo ""
read -p "  Enter your choice (1-7, or multiple like 1,2,5): " CHOICE

# Parse choices
IFS=',' read -ra SELECTED <<< "$CHOICE"

install_python() {
  info "Installing Python dependencies..."
  pip install --user pynvim 2>/dev/null || warn "pynvim install failed"
  pip install --user debugpy 2>/dev/null || warn "debugpy install failed"
  pip install --user black ruff 2>/dev/null || warn "formatters install failed"
  ok "Python dependencies installed"
}

install_javascript() {
  info "Installing JavaScript/TypeScript dependencies..."
  npm install -g neovim 2>/dev/null || warn "neovim npm package failed"
  npm install -g typescript typescript-language-server 2>/dev/null || warn "ts_ls failed"
  npm install -g prettier eslint 2>/dev/null || warn "prettier/eslint failed"
  npm install -g @fsouza/prettierd 2>/dev/null || warn "prettierd failed"
  ok "JavaScript/TypeScript dependencies installed"
}

install_rust() {
  info "Installing Rust dependencies..."
  if ! command -v rustup &>/dev/null; then
    pkg install -y rust 2>/dev/null || { error "Rust install failed"; return; }
  fi
  rustup component add rust-analyzer 2>/dev/null || warn "rust-analyzer via rustup failed"
  ok "Rust dependencies installed"
}

install_go() {
  info "Installing Go dependencies..."
  pkg install -y golang 2>/dev/null || { error "Go install failed"; return; }
  go install golang.org/x/tools/gopls@latest 2>/dev/null || warn "gopls install failed"
  go install github.com/go-delve/delve/cmd/dlv@latest 2>/dev/null || warn "delve install failed"
  ok "Go dependencies installed"
}

install_cpp() {
  info "Installing C/C++ dependencies..."
  pkg install -y clang 2>/dev/null || warn "clang install failed"
  # clang-format is usually included with clang
  if ! command -v clang-format &>/dev/null; then
    pip install --user clang-format 2>/dev/null || warn "clang-format install failed"
  fi
  ok "C/C++ dependencies installed"
}

install_java() {
  warn "Java support (jdtls) is VERY heavy (~500MB+)"
  read -p "  Are you sure? (y/N): " CONFIRM
  if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    info "Skipping Java"
    return
  fi
  info "Installing Java dependencies..."
  pkg install -y openjdk-17 2>/dev/null || warn "JDK install failed"
  ok "Java dependencies installed"
}

# ── Process selections ────────────────────────────────────
for choice in "${SELECTED[@]}"; do
  choice=$(echo "$choice" | tr -d ' ')
  case "$choice" in
    1) install_python ;;
    2) install_javascript ;;
    3) install_rust ;;
    4) install_go ;;
    5) install_cpp ;;
    6) install_java ;;
    7)
      install_python
      install_javascript
      install_rust
      install_go
      install_cpp
      install_java
      ;;
    0) info "Skipping..."; exit 0 ;;
    *) warn "Unknown choice: $choice" ;;
  esac
done

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ Language dependencies installed!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""
echo "  LSP servers will be auto-installed by Mason when you open Neovim."
echo "  Run: nvim → :Mason to verify."
