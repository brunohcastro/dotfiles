ZSH_CONFIG_HOME="${${(%):-%N}:A:h}/.config/zsh"
source "$ZSH_CONFIG_HOME/os.zsh"
source "$ZSH_CONFIG_HOME/history.zsh"
source "$ZSH_CONFIG_HOME/paths.zsh"
source "$ZSH_CONFIG_HOME/completion.zsh"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
  alias vim="nvim"
fi

source "$ZSH_CONFIG_HOME/aliases.zsh"

export ENABLE_LSP_TOOL=1

if zsh_command_exists ledger; then
  export LEDGER_FILE="$HOME/org/ledger/$(date +'%Y').journal"
fi

source "$ZSH_CONFIG_HOME/plugins.zsh"
source "$ZSH_CONFIG_HOME/tools.zsh"
