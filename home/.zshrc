HIST_STAMPS="yyyy-mm-dd"

source $HOME/.localrc

export EDITOR=nvim
export FIXUID=$(id -u)
export FIXGID=$(id -g)
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"

os="${OSTYPE%%[^a-z]*}"
source ~/.config/zsh/$os.conf

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


. "$HOME/.grit/bin/env"
