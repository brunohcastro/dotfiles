ANTIDOTE_HOME="${ANTIDOTE_HOME:-${ZDOTDIR:-$HOME}/.antidote}"

if [[ -f "$ANTIDOTE_HOME/antidote.zsh" ]]; then
  source "$ANTIDOTE_HOME/antidote.zsh"
  antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"

  if zsh_has_tty; then
    antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.interactive.txt"
  fi
elif zsh_is_interactive; then
  print -P "%F{yellow}antidote not found. Run: make -C ~/.dotfiles user/shell%f"
fi
