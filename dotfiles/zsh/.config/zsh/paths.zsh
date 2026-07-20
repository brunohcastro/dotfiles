zsh_path_prepend "$HOME/.local/bin" "$HOME/bin"

export GOPATH="$HOME/Development/go"
zsh_path_append "$GOPATH/bin"

zsh_path_prepend "$HOME/Development/flutter/bin" "$HOME/.opencode/bin"

if zsh_is_macos; then
  HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(zsh_homebrew_prefix)}"
  export HOMEBREW_PREFIX

  if [[ -n "$HOMEBREW_PREFIX" ]]; then
    export JAVA_HOME="${JAVA_HOME:-$HOMEBREW_PREFIX/opt/openjdk@21}"
  fi

  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PNPM_HOME="$HOME/Library/pnpm"

  if [[ -n "${JAVA_HOME:-}" ]]; then
    zsh_path_prepend "$JAVA_HOME/bin"
  fi

  zsh_path_prepend "/Applications/Docker.app/Contents/Resources/bin"

  zsh_path_append \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/tools" \
    "$ANDROID_HOME/tools/bin" \
    "$PNPM_HOME"

  zsh_fpath_prepend "$HOME/.docker/completions"
fi

if zsh_command_exists yarn; then
  yarn_global_bin="$(yarn global bin 2>/dev/null)"
  zsh_path_append "$yarn_global_bin"
  unset yarn_global_bin
fi
