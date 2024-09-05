if [ -d "$HOME/.local/bin" ]; then
    PATH="$PATH:$HOME/.local/bin"
fi

if [[ -z $DISPLAY ]] && ([[ $(tty) = /dev/tty1 ]] || [[ $(tty) = /dev/tty2 ]]) && [[ -z $XDG_SESSION_TYPE  ]]; then
    exec startx
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
