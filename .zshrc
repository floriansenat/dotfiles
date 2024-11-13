# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/florian/.zsh/completions:"* ]]; then export FPATH="/Users/florian/.zsh/completions:$FPATH"; fi
export ZSH="$HOME/.oh-my-zsh"

HIST_STAMPS="yyyy-mm-dd"

plugins=(zsh-syntax-highlighting zsh-autosuggestions vi-mode golang)

source $ZSH/oh-my-zsh.sh
source $HOME/.localrc

export FIXUID=$(id -u)
export FIXGID=$(id -g)
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/bin/docker-credential-ecr-login:$PATH"
export PATH="$(brew --prefix)/opt/curl/bin:$PATH"

# --- Bun ---
# [https://bun.sh/]
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun" # Completions
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# --- Python ---
# [https://www.python.org/]
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
alias python=python3
alias pip=pip3

# --- PNPM ---
# [https://pnpm.io/]
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# --- Go ---
# [https://go.dev/]
export PATH="$HOME/go/bin:$PATH"

# --- Aliases ---
alias awslog='aws sso login'
alias ll="ls -al"
alias cl="clear"
alias rm="rm -i"
alias cat="bat -p"
alias v="nvim"
alias z="zed-preview"
alias g="git"
alias lzg="lazygit"

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

# --- FZF Config ---
# [https://github.com/junegunn/fzf]
export FZF_DEFAULT_OPTS='--layout=reverse --preview "bat --style=numbers --color=always  --line-range=:500 {}"'
export FZF_CTRL_T_COMMAND='rg -uu --files -g "!node_modules/" -g "!.git/" -g "!vendor/"'
export FZF_DEFAULT_COMMAND='rg -uu --files -g "!node_modules/" -g "!.git/" -g "!vendor/"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- Starship ---
# [https://starship.rs/]
eval "$(starship init zsh)"
. "/Users/florian/.deno/env"