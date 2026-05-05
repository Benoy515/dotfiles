# Chalk-specific environment, aliases, and helpers

# PATH
export PATH="$HOME/Development/chalk/cli:$PATH"

# vcpkg
export VCPKG_ROOT="$HOME/vcpkg"

# libchalk sccache settings
export SCCACHE_GCS_BUCKET="chalk-develop-binary-cache"
export SCCACHE_GCS_KEY_PREFIX="sccache/"
export SCCACHE_GCS_KEY_PATH="$HOME/.config/chalk/sccache-key.json"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Aliases
alias chalkdev='bash ~/Development/scripts/dev_tmux.sh'

build_libchalk() {
  (
    cd "$HOME/Development/chalk/chalk-private/libchalk/"
    source "$HOME/Development/chalk/chalk-private/engine/.venv/bin/activate"
    export USE_CLION_BUILD_FOLDER_STYLE=1
    export CMAKE_BUILD_PARALLEL_LEVEL=8
    unset SCCACHE_GCS_BUCKET SCCACHE_GCS_KEY_PREFIX SCCACHE_GCS_KEY_PATH
    export SCCACHE_RECACHE
    uv pip install --upgrade pip wheel setuptools
    uv pip install . --reinstall --verbose
    uv pip install setuptools==68.2.2
  )
}
