# PATH
export PATH=$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

# Zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
source ~/.config/zsh/aliases.zsh

# Chalk-specific config
source ~/.config/zsh/chalk.zsh

# Zoxide (must be after PATH setup)
eval "$(zoxide init zsh)"

# Prompt
eval "$(starship init zsh)"

# History: up/down arrows filter on what's already typed before the cursor
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search   # Up
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search # Down
bindkey "^[[A" up-line-or-beginning-search                 # Up (fallback)
bindkey "^[[B" down-line-or-beginning-search               # Down (fallback)

# fzf — fuzzy finder with fd for file search and bat for preview
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=numbers --line-range=:500 {}"'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
eval "$(fzf --zsh)"
