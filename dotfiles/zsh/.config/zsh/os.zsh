# Shared platform and path helpers for login and interactive zsh.
typeset -gU path PATH
typeset -gU fpath

typeset -g ZSH_PLATFORM="${ZSH_PLATFORM:-$(uname -s)}"
case "$ZSH_PLATFORM" in
  Darwin) typeset -g ZSH_OS="macos" ;;
  Linux) typeset -g ZSH_OS="linux" ;;
  *) typeset -g ZSH_OS="unknown" ;;
esac

zsh_is_macos() { [[ "$ZSH_OS" == "macos" ]] }
zsh_is_linux() { [[ "$ZSH_OS" == "linux" ]] }
zsh_is_interactive() { [[ -o interactive ]] }
zsh_has_tty() { [[ -o interactive && -t 0 && -t 1 ]] }
zsh_command_exists() { command -v "$1" >/dev/null 2>&1 }

zsh_path_prepend() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] && path=("$dir" "${path[@]}")
  done
}

zsh_path_append() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] && path=("${path[@]}" "$dir")
  done
}

zsh_fpath_prepend() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] && fpath=("$dir" "${fpath[@]}")
  done
}

zsh_source_first() {
  local file
  for file in "$@"; do
    [[ -n "$file" && -r "$file" ]] || continue
    source "$file"
    return 0
  done
  return 1
}

zsh_homebrew_prefix() {
  local brew_path

  if [[ -n "${HOMEBREW_PREFIX:-}" && -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
    print -r -- "$HOMEBREW_PREFIX"
    return 0
  fi

  for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_path" ]]; then
      "$brew_path" --prefix 2>/dev/null
      return $?
    fi
  done

  if zsh_command_exists brew; then
    brew --prefix 2>/dev/null
    return $?
  fi

  return 1
}
