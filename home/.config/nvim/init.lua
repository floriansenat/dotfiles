vim.loader.enable() -- Fast Lua module loading (~30% startup speedup)

vim.g.mapleader = ' '

vim.o.termguicolors = true
vim.o.wrap = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.clipboard = 'unnamedplus'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.cmdheight = 0
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- builtin 0.10+, pas de dependance plugin
vim.o.foldlevelstart = 999

--:: UI2 (experimental 0.12) - supprime "Press Enter", coherent avec cmdheight=0 ::--
require('vim._core.ui2').enable { enable = true }

--:: Keymaps ::--
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Write' })
vim.keymap.set('n', '<leader>x', ':wq<CR>', { desc = 'Write & Quit' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>Q', ':qa<CR>', { desc = 'Quit All' })

--:: Buffers ::--
vim.api.nvim_create_user_command('BufferRevealInFinder', function()
  local path = vim.api.nvim_buf_get_name(0)
  os.execute('open -R ' .. path)
end, {})
vim.keymap.set('n', '<leader>br', ':BufferRevealInFinder<CR>', { desc = 'Reveal in finder' })
vim.keymap.set('n', '<leader>b/', ':let @*=expand("%")<CR>', { desc = 'Copy relative path' })
vim.keymap.set('n', '<leader>b%', ':let @*=expand("%:t")<CR>', { desc = 'Copy name' })
vim.keymap.set('n', '<leader>bq', ':bp|bd #<CR>', { silent = true, desc = 'Quit' })
vim.keymap.set('n', '<leader>bk', ':%bd | e# | bd#<CR>', { silent = true, desc = 'Keep' })

--:: Text Manipulation ::--
vim.api.nvim_create_user_command('ToggleFormat', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
end, {})
vim.keymap.set('n', '<leader>f', ':ToggleFormat<CR>', { desc = 'Format toggle' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

--:: Diagnostic ::--
vim.diagnostic.config {
  jump = { float = true },
}
vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { desc = 'Show inline error' })
vim.keymap.set('n', 'ge', vim.diagnostic.setqflist, { desc = 'List of errors' })

--:: LSP ::--
vim.api.nvim_create_user_command('LspInfo', 'checkhealth vim.lsp', { desc = 'Show LSP Info' })
vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd.edit(vim.fs.joinpath(vim.fn.stdpath 'state', 'lsp.log'))
end, { desc = 'Show LSP log' })
vim.api.nvim_create_user_command('LspRestart', 'lsp restart', { desc = 'Restart LSP' })

vim.keymap.set('n', '<leader>lr', ':e<CR>', { desc = 'Reattach' })
vim.keymap.set('n', '<leader>lc', ':checkhealth vim.lsp<CR>', { desc = 'Check health' })
vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', { desc = 'Info' })
vim.keymap.set('n', '<leader>ll', ':LspLog<CR>', { desc = 'Log' })

-- LSP progress
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local params = ev.data.params
    if not params or not params.value then return end
    local value = params.value
    vim.api.nvim_echo({ { value.message or '' } }, true, {
      id = 'lsp.' .. ev.data.client_id,
      kind = 'progress',
      source = vim.lsp.get_client_by_id(ev.data.client_id).name,
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
  end,
})

vim.lsp.enable {
  'astro',
  'lua_ls',
  'gopls',
  'zls',
  'phpactor',
  'vtsls',
  'jq-lsp',
  'jsonls',
  'html',
  'emmet_ls',
  'cssls',
  'biome',
  'eslint',
  'yamlls',
  'dockerls',
  'docker_compose_language_service',
}

--:: Plugins ::--
dofile(vim.fn.stdpath 'config' .. '/plugins.lua')
