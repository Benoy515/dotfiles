#!/usr/bin/env bash
# Bootstrap a fresh machine from this dotfiles repo.
# Safe to re-run — every step is idempotent.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
cd "$DOTFILES_DIR"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # shellcheck disable=SC2016
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  log "Homebrew already installed"
fi

# 2. Brewfile
log "Installing Brewfile dependencies"
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. Stow every package directory in the repo root
PACKAGES=(ghostty git karabiner nvim starship tmux zed zellij zsh)
log "Stowing packages: ${PACKAGES[*]}"
stow --restow --target="$HOME" "${PACKAGES[@]}"

# 4. TPM (tmux plugin manager) + plugins
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  log "Cloning TPM"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  log "TPM already present"
fi
log "Installing tmux plugins"
"$TPM_DIR/bin/install_plugins"

# 5. fzf shell keybindings (Ctrl-R / Ctrl-T / Alt-C)
FZF_PREFIX="$(brew --prefix fzf)"
if [ -x "$FZF_PREFIX/install" ]; then
  log "Wiring fzf shell keybindings"
  "$FZF_PREFIX/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# 6. Warm up nvim plugins (vim.pack fetches on first run)
if command -v nvim >/dev/null 2>&1; then
  log "Warming up nvim plugins (headless)"
  nvim --headless "+lua vim.defer_fn(function() vim.cmd('qa!') end, 30000)" 2>/dev/null || true
fi

log "Done. Open a new shell to pick up zsh/starship/zoxide."
