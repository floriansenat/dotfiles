export ZSH="$HOME/.oh-my-zsh"

HIST_STAMPS="yyyy-mm-dd"

plugins=(zsh-syntax-highlighting zsh-autosuggestions vi-mode golang)

source $ZSH/oh-my-zsh.sh
source $HOME/.localrc

export FIXUID=$(id -u)
export FIXGID=$(id -g)
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export EDITOR=nvim
export PNPM_HOME="$HOME/Library/pnpm"

for f in ~/.config/zsh/*; do source $f; done

eval "$(starship init zsh)"

# bun completions
[ -s "/opt/homebrew/Cellar/bun/1.1.34/share/zsh/site-functions/_bun" ] && source "/opt/homebrew/Cellar/bun/1.1.34/share/zsh/site-functions/_bun"
