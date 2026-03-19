#!/usr/bin/env bash
# install.sh — Install Ansible on Debian/Ubuntu (PEP 668 safe)
# Handles: Debian 12+, Ubuntu 23.04+, older systems, CI environments
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
die()     { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# ── Detect OS ────────────────────────────────────────────────────────────────
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  OS_ID="${ID:-unknown}"
  OS_VERSION="${VERSION_ID:-0}"
else
  die "Cannot detect OS. Only Debian/Ubuntu are supported."
fi

info "Detected: ${PRETTY_NAME:-$OS_ID $OS_VERSION}"

# ── Check if Ansible is already installed ─────────────────────────────────────
if command -v ansible &>/dev/null; then
  ANSIBLE_VER=$(ansible --version | head -1)
  success "Ansible already installed: $ANSIBLE_VER"
  exit 0
fi

# ── Strategy selection ────────────────────────────────────────────────────────
# Prefer pipx (PEP 668 safe, isolated, no venv to activate).
# Fall back to apt (ansible-core only, older version but zero-dep).
# Last resort: pip --break-system-packages (explicit opt-in).

install_via_pipx() {
  info "Installing Ansible via pipx..."
  if ! command -v pipx &>/dev/null; then
    info "pipx not found — installing with apt..."
    sudo apt-get update -qq
    sudo apt-get install -y pipx python3-full
    pipx ensurepath
    # Make pipx PATH available in the current shell session
    export PATH="$PATH:$HOME/.local/bin"
  fi
  pipx install --include-deps ansible
  # Expose ansible* binaries to the current shell
  pipx ensurepath
  success "Ansible installed via pipx."
  info "Restart your shell or run:  source ~/.bashrc  (or ~/.zshrc)"
}

install_via_apt() {
  info "Installing ansible via apt (ansible-core)..."
  sudo apt-get update -qq
  # ansible-core is the minimal package; 'ansible' meta-package may not exist
  if apt-cache show ansible &>/dev/null 2>&1; then
    sudo apt-get install -y ansible
  else
    sudo apt-get install -y ansible-core
    warn "Installed ansible-core (minimal). Some collections may be missing."
    warn "Run: ansible-galaxy collection install community.general"
  fi
  success "Ansible installed via apt."
}

install_via_pip_break() {
  warn "Using --break-system-packages as last resort (not recommended)."
  warn "Consider using pipx instead: https://pipx.pypa.io"
  sudo pip install --break-system-packages ansible
  success "Ansible installed via pip --break-system-packages."
}

# ── Run the best available strategy ──────────────────────────────────────────
if command -v pipx &>/dev/null || apt-cache show pipx &>/dev/null 2>&1; then
  install_via_pipx
elif apt-cache show ansible &>/dev/null 2>&1 || apt-cache show ansible-core &>/dev/null 2>&1; then
  info "pipx not available — falling back to apt."
  install_via_apt
else
  warn "Neither pipx nor apt packages available — using pip --break-system-packages."
  install_via_pip_break
fi

# ── Final check ───────────────────────────────────────────────────────────────
if command -v ansible &>/dev/null; then
  success "All done! $(ansible --version | head -1)"
  echo ""
  echo "  Run the playbook:"
  echo "    ansible-playbook site.yml --ask-become-pass"
  echo "    ansible-playbook site.yml -i \"localhost,\" --connection local"
else
  warn "ansible binary not found in current PATH."
  warn "If you used pipx, restart your shell or run: source ~/.bashrc"
fi
