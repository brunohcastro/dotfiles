ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh}"
ZSH_COMPDUMP="${ZSH_COMPDUMP:-$ZSH_CACHE_DIR/zcompdump-${ZSH_VERSION}}"
ZSH_DISABLE_COMPFIX="${ZSH_DISABLE_COMPFIX:-true}"

mkdir -p "$ZSH_CACHE_DIR/completions"
zsh_fpath_prepend "$ZSH_CACHE_DIR/completions"

autoload -Uz colors && colors
autoload -Uz is-at-least add-zsh-hook compinit
zmodload zsh/complist 2>/dev/null
zmodload zsh/terminfo 2>/dev/null

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

compinit -u -d "$ZSH_COMPDUMP"
