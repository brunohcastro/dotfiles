# Keep PATH unique while preserving order.
typeset -U path PATH

[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/bin" ]] && path=("$HOME/bin" $path)

export GOPATH="$HOME/Development/go"
[[ -d "$GOPATH/bin" ]] && path=($path "$GOPATH/bin")

if [[ $(uname) == "Darwin" ]]; then
  [[ -d /opt/homebrew/opt/openjdk@21/bin ]] && path=(/opt/homebrew/opt/openjdk@21/bin $path)
  [[ -d /Applications/Docker.app/Contents/Resources/bin ]] && path=(/Applications/Docker.app/Contents/Resources/bin $path)

  export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
  export ANDROID_HOME="/Users/bruno/Library/Android/sdk"
  [[ -d "$ANDROID_HOME/platform-tools" ]] && path=($path "$ANDROID_HOME/platform-tools")
  [[ -d "$ANDROID_HOME/tools" ]] && path=($path "$ANDROID_HOME/tools" "$ANDROID_HOME/tools/bin")

  export PNPM_HOME="/Users/bruno/Library/pnpm"
  [[ -d "$PNPM_HOME" ]] && path=($path "$PNPM_HOME")

  [[ -d /Users/bruno/.docker/completions ]] && fpath=(/Users/bruno/.docker/completions $fpath)
fi

[[ -d /home/bruno/Development/flutter/bin ]] && path=(/home/bruno/Development/flutter/bin $path)
[[ -d /home/bruno/.opencode/bin ]] && path=(/home/bruno/.opencode/bin $path)

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
  alias vim="nvim"
fi

alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="nvim ~/.dotfiles/dotfiles/nvim/.config/nvim/init.lua"
alias netflix="google-chrome-stable --app=http://netflix.com"
alias smtpfs="simple-mtpfs --device 1 /home/bruno/Mount"

if [[ $(uname) == "Darwin" ]]; then
  alias ls="ls -G"
else
  alias ls="ls --color=auto"
  alias grep="grep --color=auto"
  alias pcmclean="sudo pacman -Sc"
  alias pcmpurge='sudo pacman -Rns $(pacman -Qtdq)'
fi

export ENABLE_LSP_TOOL=1

if command -v yarn >/dev/null 2>&1; then
  path=($path "$(yarn global bin)")
fi

if [[ -x /usr/bin/ledger ]]; then
  export LEDGER_FILE="$HOME/org/ledger/$(date +'%Y').journal"
fi

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
mkdir -p "$ZSH_CACHE_DIR/completions"

ANTIDOTE_HOME="${ANTIDOTE_HOME:-${ZDOTDIR:-$HOME}/.antidote}"
if [[ -f "$ANTIDOTE_HOME/antidote.zsh" ]]; then
  source "$ANTIDOTE_HOME/antidote.zsh"
  antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
elif [[ -o interactive ]]; then
  print -P "%F{yellow}antidote not found. Run: make -C ~/.dotfiles user/shell%f"
fi

if [[ -r /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
elif [[ -n "$HOMEBREW_PREFIX" && -r "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
fi

if [[ -r /usr/share/fzf/completion.zsh ]]; then
  source /usr/share/fzf/completion.zsh
elif [[ -n "$HOMEBREW_PREFIX" && -r "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]]; then
  source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
