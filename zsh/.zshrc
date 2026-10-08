# PATH
export PATH=$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

# Zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
source ~/.config/zsh/aliases.zsh

# Chalk-specific config
source ~/.config/zsh/chalk.zsh

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

export PATH="$HOME/.local/bin:$PATH"

export VCPKG_ROOT="/Users/abhay/vcpkg"

eval "$(direnv hook zsh)"

# Disabled: `chalk` is a shell function that rebuilds the Go binary, so this
# recompiled the CLI on every new terminal. Re-enable once the completion
# script is cached to a file instead of regenerated at startup.
# eval "$(chalk completion zsh)"

# Completion system. Nothing was initializing this, so `compdef` was undefined
# and tool completions silently failed. The full security scan of every
# completion file costs ~150ms, so only do it if the dump is over 24h old
# (the (#qN.mh+24) glob qualifier: N=no error if absent, .=regular file,
# mh+24=modified more than 24 hours ago); otherwise reuse it with -C at ~8ms.
autoload -Uz compinit
if [[ -n $HOME/.cache/zsh/zcompdump(#qN.mh+24) ]]; then
  compinit -d "$HOME/.cache/zsh/zcompdump"
else
  compinit -C -d "$HOME/.cache/zsh/zcompdump"
fi

# chalkadmin completion — cached. Generating it costs ~280ms (Go binary cold
# start on every terminal); sourcing the cached 212 lines is ~1ms. Regenerated
# automatically whenever the binary is newer than the cache.
_ca_bin=$(whence -p chalkadmin)
if [[ -n $_ca_bin ]]; then
  _ca_cache="$HOME/.cache/zsh/chalkadmin-completion.zsh"
  if [[ ! -s $_ca_cache || $_ca_bin -nt $_ca_cache ]]; then
    mkdir -p "${_ca_cache:h}"
    chalkadmin completion zsh > "$_ca_cache"
  fi
  source "$_ca_cache"
fi
unset _ca_bin _ca_cache

# Zoxide — must be last: it warns if anything else initializes after it, since
# later plugins can clobber its `cd` wrapper.
eval "$(zoxide init zsh)"
