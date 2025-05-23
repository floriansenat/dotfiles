HIST_STAMPS="yyyy-mm-dd"

source $HOME/.localrc

export EDITOR=nvim
export FIXUID=$(id -u)
export FIXGID=$(id -g)
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"

for f in ~/.config/zsh/*; do source $f; done

eval "$(starship init zsh)"

# bun completions
[ -s "/opt/homebrew/Cellar/bun/1.1.34/share/zsh/site-functions/_bun" ] && source "/opt/homebrew/Cellar/bun/1.1.34/share/zsh/site-functions/_bun"

