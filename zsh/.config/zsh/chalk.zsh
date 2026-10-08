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
alias chalkdev='bash ~/Development/scripts/dev_zellij.sh'

# Run the chalk engine locally against a target chalk project directory.
# Usage: enginelocal <PROJECT_DIR>
enginelocal() {
  if [ -z "$1" ]; then
    echo "Usage: enginelocal <PROJECT_DIR>" >&2
    return 1
  fi
  (
    cd "$HOME/Development/chalk/chalk-private/engine" && \
    RESULT_BUS_TOPIC=a \
    PARQUET_DATASET_STORAGE_BUCKET=file:// \
    PARQUET_PLAN_STAGES_STORAGE_BUCKET=file:// \
    TIMESCALE_URI=postgresql+psycopg2://chalk:chalk@localhost:6543/postgres \
    CHALK_TEAM_ID=a CHALK_PROJECT_ID=a CHALK_DEPLOYMENT_id=a _CHALK_ACTIVE_ENVIRONMENT=a \
    REDIS_URI=redis://:6284001732@localhost:6379 \
    REDIS_IS_CLUSTERED=false REDIS_LIGHTNING_READ_FROM_REPLICAS=false \
    ONLINE_STORE_KIND=REDIS_LIGHTNING \
    DYNAMODB_ONLINE_STORE_URI=dynamodb://localhost:9123/online_store \
    DYNAMODB_CREATE_TABLES_IF_NOT_EXISTS=true \
    CHALK_DYNAMODB_AWS_ACCESS_KEY_ID=fake CHALK_DYNAMODB_AWS_SECRET_ACCESS_KEY=fake \
    IGNORE_AUTH=true \
    TARGET_ROOT="$1" \
    CHECK_IGNORES_WHEN_IMPORTING=true \
    uv run python -m chalkengine.feature_server.app
  )
}

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
