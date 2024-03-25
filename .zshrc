export ZSH="$HOME/.oh-my-zsh"

HIST_STAMPS="yyyy-mm-dd"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions vi-mode)

source $ZSH/oh-my-zsh.sh

export FIXUID=$(id -u)
export FIXGID=$(id -g)
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/bin/docker-credential-ecr-login:$PATH"
export PATH="$(brew --prefix)/opt/curl/bin:$PATH"

# --- Bun ---
# [https://bun.sh/]
[ -s "/Users/florian/.bun/_bun" ] && source "/Users/florian/.bun/_bun" # Completions
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# --- Python ---
# [https://www.python.org/]
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
alias python=python3
alias pip=pip3

# --- PNPM ---
# [https://pnpm.io/]
export PNPM_HOME="/Users/florian/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# --- Go ---
# [https://go.dev/]
export PATH="/Users/florian/go/bin:$PATH"

# --- Aliases ---
alias awslog='aws sso login'
alias lzg="lazygit"
alias v="nvim"
alias ll="ls -al"
alias cl="clear"
alias rm="rm -i"
alias cat="bat -p"

# --- NVM ---
# [https://github.com/nvm-sh/nvm]
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
# end

# --- Starship ---
# [https://starship.rs/]
eval "$(starship init zsh)"

# --- FZF Config ---
# [https://github.com/junegunn/fzf]
export FZF_DEFAULT_OPTS='--layout=reverse --preview "bat --style=numbers --color=always  --line-range=:500 {}"'
export FZF_CTRL_T_COMMAND='rg -uu --files -g "!node_modules/" -g "!.git/" -g "!vendor/"'
export FZF_DEFAULT_COMMAND='rg -uu --files -g "!node_modules/" -g "!.git/" -g "!vendor/"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

