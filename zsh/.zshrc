# PATH
export PATH=$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

# Zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
source ~/.config/zsh/aliases.zsh

# Zoxide (must be after PATH setup)
eval "$(zoxide init zsh)"

# Prompt
eval "$(starship init zsh)"
