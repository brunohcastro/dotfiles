[[ -z "$HISTFILE" ]] && HISTFILE="$HOME/.zsh_history"
(( HISTSIZE < 50000 )) && HISTSIZE=50000
(( SAVEHIST < 10000 )) && SAVEHIST=10000

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
