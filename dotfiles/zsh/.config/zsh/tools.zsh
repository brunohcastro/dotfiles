if zsh_command_exists mise; then
  eval "$(mise activate zsh)"
fi

if zsh_has_tty; then
  zsh_source_first \
    /usr/share/fzf/key-bindings.zsh \
    "${HOMEBREW_PREFIX:-}/opt/fzf/shell/key-bindings.zsh"

  zsh_source_first \
    /usr/share/fzf/completion.zsh \
    "${HOMEBREW_PREFIX:-}/opt/fzf/shell/completion.zsh"
fi

if zsh_command_exists zoxide; then
  eval "$(zoxide init zsh)"
fi

if zsh_command_exists direnv; then
  eval "$(direnv hook zsh)"
fi

if zsh_has_tty && zsh_command_exists starship; then
  eval "$(starship init zsh)"
fi
