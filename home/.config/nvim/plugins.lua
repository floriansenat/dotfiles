vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end

    if name == 'fff.nvim' and kind == 'install' then
      if not ev.data.active then
        vim.cmd.packadd 'fff.nvim'
      end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.pack.add {
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-mini/mini.pairs',
  'https://github.com/kylechui/nvim-surround',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.x' },
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/f-person/auto-dark-mode.nvim',
  'https://github.com/sainnhe/everforest',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/dmtrKovalenko/fff.nvim',
  { src = 'https://github.com/shortcuts/no-neck-pain.nvim', version = 'stable' },
  'https://github.com/stevearc/quicker.nvim',
  'https://github.com/folke/which-key.nvim',
}

-- Treesitter (pcall - unavailable on first start, before install)
local ok_ts, treesitter = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
  treesitter.setup {
    ensure_installed = {
      'lua',
      'php',
      'go',
      'tsx',
      'typescript',
      'javascript',
      'json',
      'html',
      'css',
      'vimdoc',
      'vim',
      'markdown',
      'markdown_inline',
      'zig',
    },
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
  }
end

-- mini.pairs
require('mini.pairs').setup {}

-- nvim-surround
require('nvim-surround').setup {}

-- blink.cmp
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    list = { selection = { preselect = true, auto_insert = true } },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    accept = { auto_brackets = { enabled = false } },
  },
  sources = { default = { 'lsp', 'path', 'buffer' } },
  signature = { enabled = true },
}

-- conform.nvim
require('conform').setup {
  notify_on_error = false,
  formatters_by_ft = {
    lua = { 'stylua' },
    json = { 'biome' },
    jsonc = { 'biome' },
    javascript = { 'biome', 'biome-organize-imports' },
    javascriptreact = { 'biome', 'biome-organize-imports' },
    typescript = { 'biome', 'biome-organize-imports' },
    typescriptreact = { 'biome', 'biome-organize-imports' },
    go = { 'goimports', 'gofmt' },
    rust = { 'rustfmt' },
    php = { 'php_cs_fixer' },
  },
  default_format_opts = { lsp_format = 'fallback' },
  format_on_save = function()
    if vim.g.disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = 'never' }
  end,
}
vim.keymap.set('', '<leader>bf', function()
  require('conform').format { async = true, lsp_format = 'never' }
end, { desc = 'Format' })

-- gitsigns
require('gitsigns').setup {}
vim.keymap.set('n', ']c', ':Gitsigns next_hunk<CR>', { desc = 'Next Change' })
vim.keymap.set('n', '[c', ':Gitsigns prev_hunk<CR>', { desc = 'Previous Change' })
vim.keymap.set('n', '<leader>hs', ':Gitsigns preview_hunk_inline<CR>', { desc = 'Show' })
vim.keymap.set('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset' })
vim.keymap.set('n', '<leader>bb', ':Gitsigns blame<CR>', { desc = 'Blame' })

-- mason
require('mason').setup {}

-- auto-dark-mode + everforest
require('auto-dark-mode').setup {
  set_dark_mode = function()
    vim.api.nvim_set_option_value('background', 'dark', {})
    vim.g.everforest_background = 'hard'
    vim.g.everforest_colors_override = { bg0 = { '#1E2326', '234' } }
    vim.cmd.colorscheme 'everforest'
  end,
  set_light_mode = function()
    vim.api.nvim_set_option_value('background', 'light', {})
    vim.g.everforest_background = 'soft'
    vim.g.everforest_colors_override = { bg0 = { '#EFEBD4', '234' } }
    vim.cmd.colorscheme 'everforest'
  end,
  update_interval = 1000,
}

-- oil.nvim
require('oil').setup {
  default_file_explorer = true,
  view_options = { show_hidden = true },
}
vim.keymap.set('n', '-', ':Oil<CR>', { desc = 'Open parent directory' })

-- fff.nvim
require('fff').setup {
  prompt = '➜ ',
  title = 'Search',
  layout = { height = 0.99, width = 0.99 },
}
vim.keymap.set('n', '<leader>sf', function()
  require('fff').find_files()
end, { desc = '[F]iles' })
vim.keymap.set('n', '<leader>sg', function()
  require('fff').live_grep()
end, { desc = '[G]rep' })
vim.keymap.set('n', '<leader>ss', function()
  require('fff').scan_files()
end, { desc = '[S]can' })

-- no-neck-pain
require('no-neck-pain').setup { width = 120 }
vim.keymap.set('n', '<leader>c', '<cmd>NoNeckPain<CR>', { desc = 'Center mode' })

-- quicker.nvim
require('quicker').setup {
  keys = {
    {
      '>',
      ":lua require'quicker'.expand { before = 2, after = 2, add_to_existing = true }<CR>",
      desc = 'Expand quickfix context',
    },
    {
      '<',
      ":lua require'quicker'.collapse()<CR>",
      desc = 'Collapse quickfix context',
    },
  },
}

-- which-key
local wk = require 'which-key'
wk.setup {
  preset = 'helix',
  icons = { mappings = false },
  plugins = { presets = { operators = false, motions = false } },
}
wk.add { { '<leader>b', group = 'Buffer' } }
wk.add { { '<leader>d', group = 'Diagnostics' } }
wk.add { { '<leader>l', group = 'Lsp' } }
wk.add { { '<leader>h', group = 'Hunk' } }
wk.add { { '<leader>s', group = 'Search' } }

-- Undo tree builtin (nvim 0.12) - load on demand
vim.keymap.set('n', '<leader>bh', function()
  vim.cmd.packadd 'nvim.undotree'
  vim.cmd 'Undotree'
end, { desc = 'History' })
