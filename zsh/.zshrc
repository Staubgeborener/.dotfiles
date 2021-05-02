# Prompt
autoload -U promptinit; promptinit
prompt pure

# Path
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/.local/bin:/snap/bin

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
  fast-syntax-highlighting
)

# Automatically change the current working directory after closing ranger
ranger_cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}
# This binds Ctrl-O to ranger_cd:
bindkey -s '^o' 'ranger_cd\C-m'

# Source
source $ZSH/oh-my-zsh.sh

# Aliases
alias rm=trash
alias icat="kitty +kitten icat"
alias {spt,spotify-cli,spotify-tui}="~/.config/spotifyd/run"
eval $(thefuck --alias)
