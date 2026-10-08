# Config file editing
alias zource='source ~/.zshrc'
alias zedit='nvim ~/.zshrc'
alias gedit='nvim ~/.config/ghostty/config'
alias tedit='nvim ~/.tmux.conf'
alias tource='tmux source ~/.tmux.conf'
alias jedit='nvim ~/.config/zellij/config.kdl'
alias jource='zellij setup --check && echo "Config valid — restart zellij session to apply changes"'
alias jeys='awk '\''/^    [a-z_]+ \{/{mode=$1} /bind "/{print mode"\t"$0}'\'' ~/.config/zellij/config.kdl'
alias add-alias='nvim ~/.config/zsh/aliases.zsh'

# Terminal command improvements
alias ls='ls -aG'
alias cd='z'
alias ..='cd ..'
alias rd='rmdir'
md() {
  mkdir -p "$1" && cd "$1"
}
alias cc='claude'

# Git aliases
alias g='git'
alias gs='git status'
alias gaa='git add -A'
alias gc='git commit -m'
alias gac='git add -A && git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gb='git branch | fzf | xargs git switch'

# Rust aliases
alias cr='cargo run'
alias ct='cargo test'
alias cb='cargo build'

# Python venv
alias va='source .venv/bin/activate'

# Personal CLI tools
alias alist='/Users/abhaybenoy/Main-Files/Hacking/Rust_Projects/alist/target/release/alist'
wire() {
  ssh -p 2220 "bandit$1@bandit.labs.overthewire.org"
}
