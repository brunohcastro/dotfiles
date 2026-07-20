alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="nvim ~/.dotfiles/dotfiles/nvim/.config/nvim/init.lua"

if zsh_is_macos; then
  alias ls="ls -G"
elif zsh_is_linux; then
  alias ls="ls --color=auto"
  alias grep="grep --color=auto"
  alias pcmclean="sudo pacman -Sc"
  alias pcmpurge='sudo pacman -Rns $(pacman -Qtdq)'
  alias smtpfs="simple-mtpfs --device 1 $HOME/Mount"
fi

if zsh_command_exists google-chrome-stable; then
  alias netflix="google-chrome-stable --app=http://netflix.com"
fi
