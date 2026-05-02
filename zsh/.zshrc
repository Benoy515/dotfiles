# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/abhaybenoy/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/abhaybenoy/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/abhaybenoy/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/abhaybenoy/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# PATH
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
source ~/.config/zsh/aliases.zsh

# Zoxide (must be after PATH setup)
eval "$(zoxide init zsh)"

# Prompt
eval "$(starship init zsh)"
