# Dotfiles

Personal config, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick start

```sh
# Prerequisites: Homebrew, stow, and the tools listed below
cd ~/.dotfiles
stow ghostty git karabiner starship tmux zed zsh   # individual packages
# or: stow */                                        # all at once
```

## Packages

| Package    | What it configures                                       |
|------------|----------------------------------------------------------|
| `ghostty`  | Terminal emulator — Hack Nerd Font, Rapture theme        |
| `git`      | User identity, VSCode as editor/diff/merge tool          |
| `karabiner`| Double-tap left Shift → Caps Lock                        |
| `starship` | Shell prompt (currently empty — see TODO)                |
| `tmux`     | Prefix `C-Space`, Catppuccin Mocha, vim-pane navigation  |
| `zed`      | Editor: Catppuccin Mocha, vim mode, relative numbers     |
| `zsh`      | Plain zsh + autosuggestions + syntax-highlighting        |

## Shell tooling in use

- **zoxide** — smart `cd` (aliased as `cd`)
- **starship** — shell prompt
- **zsh-autosuggestions** — fish-style command suggestions
- **zsh-syntax-highlighting** — real-time syntax coloring

## External dependencies (install via Homebrew)

```sh
brew install stow zoxide starship zsh-autosuggestions zsh-syntax-highlighting
```

## Roadmap

See [TODO.md](./TODO.md) for ongoing terminal-improvement work.
