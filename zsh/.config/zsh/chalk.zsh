# Chalk-specific environment, aliases, and helpers
alias add-chalk-alias='nvim ~/.dotfiles/zsh/.config/zsh/chalk.zsh'

# PATH
export PATH="$HOME/Development/chalk/cli:$PATH"
# NOTE: this runs inside `eval "$(chalk completion zsh)"` at shell startup, so
# the build must not write anything to stdout -- whatever it prints gets eval'd
# as a command. pushd/popd echo the directory stack in interactive shells, which
# is why they're not used here; a plain cd in the subshell has the same effect.
chalk () {
  (
    set -e
    cd ~/Development/chalk/cli
    GOOS=darwin GOARCH=arm64 go build -o chalk 1>&2
  ) || return
  ~/Development/chalk/cli/chalk "$@"
}
# vcpkg
export VCPKG_ROOT="$HOME/vcpkg"

# libchalk sccache settings
export SCCACHE_GCS_BUCKET="chalk-develop-binary-cache"
export SCCACHE_GCS_KEY_PREFIX="sccache/"
export SCCACHE_GCS_KEY_PATH="$HOME/.config/chalk/sccache-key.json"

# nvm — lazy loaded. Sourcing nvm.sh costs ~350ms (it defines ~4k lines of
# shell, then activates the default Node), which was half of shell startup.
# Instead, stub the commands that need it; the first call to any of them
# unsets the stubs, loads the real nvm, and re-dispatches.
export NVM_DIR="$HOME/.nvm"
_nvm_lazy_load() {
  unset -f nvm node npm npx yarn 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
for _nvm_cmd in nvm node npm npx yarn; do
  eval "${_nvm_cmd}() { _nvm_lazy_load; ${_nvm_cmd} \"\$@\"; }"
done
unset _nvm_cmd

# Aliases
alias localenv="nix develop -c bazel run //:chalk_environment -- "
