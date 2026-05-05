# Dotfiles

Personal config, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## New machine setup

```sh
# 1. Install Homebrew, then dependencies
brew install stow zoxide starship fzf fd bat \
             zsh-autosuggestions zsh-syntax-highlighting

# 2. Clone and stow
git clone <this-repo> ~/.dotfiles
cd ~/.dotfiles
stow ghostty git karabiner starship tmux zed zsh

# 3. Install tmux plugins (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```

## Packages

| Package     | What it configures                                              |
|-------------|-----------------------------------------------------------------|
| `ghostty`   | Terminal emulator — Hack Nerd Font, Rapture theme               |
| `git`       | User identity, VSCode as editor/diff/merge tool                 |
| `karabiner` | Double-tap left Shift → Caps Lock                               |
| `starship`  | Shell prompt (currently empty — see TODO)                       |
| `tmux`      | Prefix `C-Space`, Rapture status bar, TPM plugins               |
| `zed`       | Editor: Catppuccin Mocha, vim mode, relative numbers            |
| `zsh`       | Plain zsh + autosuggestions + syntax-highlighting + fzf         |

## Shell tooling

| Tool                      | Purpose                                              |
|---------------------------|------------------------------------------------------|
| `zoxide`                  | Smart `cd` (aliased as `cd`)                         |
| `starship`                | Shell prompt                                         |
| `fzf`                     | Fuzzy finder — `Ctrl+R` history, `Ctrl+T` files, `Alt+C` dirs |
| `fd`                      | Fast file search (used by fzf)                       |
| `bat`                     | Syntax-highlighted file preview (used by fzf)        |
| `zsh-autosuggestions`     | Fish-style command suggestions                       |
| `zsh-syntax-highlighting` | Real-time syntax coloring                            |

## Tmux plugins (via TPM)

| Plugin               | Purpose                                         |
|----------------------|-------------------------------------------------|
| `tmux-sensible`      | Sane defaults, `C-Space+Ctrl-n/p` window nav    |
| `vim-tmux-navigator` | `Ctrl+h/j/k/l` pane navigation (vim-aware)      |
| `tmux-resurrect`     | Save/restore sessions — `prefix+Ctrl-s/r`       |
| `tmux-continuum`     | Auto-save sessions every 15 min                 |

## Roadmap

See [TODO.md](./TODO.md) for ongoing terminal-improvement work.
