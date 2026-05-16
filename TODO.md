# Terminal Improvement TODO

Ongoing work to sharpen terminal usage. Tackle one chunk at a time.

---

## Repo hygiene *(do first — unblocks everything else)*

- [x] Add root `.gitignore` — exclude `tmux/.config/tmux/plugins/`
- [x] Add a `Brewfile` so installed packages are tracked and reproducible
- [x] Decide on a bootstrap script (`./install.sh`) that runs `brew bundle`, `stow */`, and TPM install — *or* document the manual steps in README

---

## Fuzzy finding

- [x] Install `fzf` and run install script for shell keybindings (`Ctrl+R`, `Ctrl+T`, `Alt+C`)
- [x] Install `fd` and `bat` (required for FZF enhancements)
- [x] Set `FZF_DEFAULT_COMMAND` to use `fd` instead of `find`
- [x] Configure `FZF_DEFAULT_OPTS` — layout, border, `bat` preview

---

## Tmux

- [x] Install TPM (Tmux Plugin Manager)
- [x] Add plugins via TPM: `tmux-sensible`, `tmux-resurrect`, `tmux-continuum`, `vim-tmux-navigator`
- [x] Remove catppuccin — replaced with hand-rolled Rapture status bar
- [x] Add `~/.config/tmux/plugins/` to root `.gitignore`

---

## Prompt

- [ ] Configure `starship/.config/starship.toml` — currently empty
  - Rapture palette to match tmux/ghostty
  - Modules: git branch/status, directory, language versions (Rust at minimum)

---

## Modern CLI replacements *(high ROI)*

- [ ] `eza` — modern `ls` with icons + git status; alias `ls`/`ll`
- [ ] `ripgrep` (`rg`) — faster `grep`
- [ ] `git-delta` — pretty git diffs; wire into `.gitconfig`
- [ ] `lazygit` — TUI git client for staging, log browsing, interactive rebases
- [ ] `gh` — GitHub CLI for PRs, issues, gists from terminal

---

## Shell history & navigation

- [ ] `atuin` — searchable shell history with sync, replaces `Ctrl+R`
- [ ] Tune zsh history options in `.zshrc` (`HISTSIZE`, `SAVEHIST`, `HIST_IGNORE_DUPS`, `share_history`)

---

## Editor

- [ ] Add a `nvim` stow package — aliases assume `nvim` but no config exists in the repo
  - Options: kickstart.nvim, LazyVim, or roll your own
- [ ] Once nvim config exists, decide: keep `code --wait` as git editor, or switch to `nvim`

---

## Tmux session management *(after TPM)*

- [ ] `tmux-sessionx` or a `tmux-sessionizer` script — fuzzy project/session switcher

---

## Nice-to-haves

- [ ] `tldr` / `tealdeer` — example-based man pages
- [ ] `direnv` — per-project env vars loaded automatically
- [ ] `btop` — better `top`
- [ ] `yazi` — TUI file manager

---

## Known cleanups *(small, do whenever)*

- [ ] `zsh/.config/zsh/aliases.zsh:26` — `alist` alias hardcodes `/Users/abhaybenoy/...`; make path-portable or remove from dotfiles
- [ ] Remove empty trailing line in `aliases.zsh`
