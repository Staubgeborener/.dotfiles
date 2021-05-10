# Prompt
autoload -U promptinit;
promptinit
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
# Add, commit and sign
alias gac="git add . && git commit -S -m" # + commit message
# Initialize
alias gi="git init && gac 'Initial commit'"
# Pushing/pulling from remotes
alias gp="git push" # + remote & branch names
alias gl="git pull" # + remote & branch names
# Pushing/pulling to origin remote
alias gpo="git push origin" # + branch name
alias glo="git pull origin" # + branch name
# Pushing/pulling to origin remote, master branch
alias gpom="git push origin master"
alias glom="git pull origin master"
# Create new branch or checkout into existing branch
alias gb="git branch" # + branch name
alias gc="git checkout" # + branch name
# Create new branch and checkout into it
alias gcb="git checkout -b" # + branch name
#fuck
eval $(thefuck --alias)
