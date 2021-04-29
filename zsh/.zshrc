# Prompt
autoload -U promptinit; promptinit
prompt pure

# Path
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/snap/bin

# Empty zsh theme for pure
ZSH_THEME=""

# Plugins
plugins=(
  git
  brew
  common-aliases
  node
  npm
  sudo
  colored-man-pages
  colorize
  cp
  zsh-syntax-highlighting
)

# Source
source $ZSH/oh-my-zsh.sh
source $ZSH/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Aliases
alias rm=trash
eval $(thefuck --alias)
