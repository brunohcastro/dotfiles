ZSH_CONFIG_HOME="${${(%):-%N}:A:h}/.config/zsh"
source "$ZSH_CONFIG_HOME/os.zsh"

zsh_path_prepend "$HOME/.local/bin"

if zsh_is_linux && [[ ${DOTFILES_AUTO_START_X:-0} == 1 ]] && [[ -z $DISPLAY ]] && ([[ $(tty) = /dev/tty1 ]] || [[ $(tty) = /dev/tty2 ]]) && [[ -z $XDG_SESSION_TYPE  ]]; then
    exec startx
fi

if zsh_is_macos; then
  brew_prefix="$(zsh_homebrew_prefix)"
  if [[ -n "$brew_prefix" && -x "$brew_prefix/bin/brew" ]]; then
    eval "$("$brew_prefix/bin/brew" shellenv)"
  fi
  unset brew_prefix
fi
