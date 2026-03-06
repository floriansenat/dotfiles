 #!/usr/bin/env bash
# oil-zed
# Minimal Neovim setup to launch only Oil
# Very useful for integration within other IDEs like Zed 

set -euo pipefail

# Resolve to absolute path
DIR=$(realpath "$(pwd)")

# Use minimal nvim config to avoid plugin conflicts
OIL_MINIMAL_DIR="$HOME/.config/nvim-oil"

# Launch Neovim with minimal config and Zed integration
cd "$DIR"
exec /opt/homebrew/bin/nvim \
  --cmd "set noswapfile" \
  -u "$OIL_MINIMAL_DIR/init.lua" \
  -c "lua vim.g.oil_open_in_zed = true" \
  -c "lua require('oil').open()" \
  -c "autocmd FileType oil nnoremap <buffer><silent> q :qa!<CR>" \
  -c "autocmd FileType oil nnoremap <buffer><silent> <Esc> :qa!<CR>"
