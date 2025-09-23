vim.g.mapleader = ' '

vim.o.termguicolors = true
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
vim.o.cmdheight = 0 -- Hides the command bar when not used
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevelstart = 999

vim.keymap.set('n', '<C-u>', '<C-u>zz') -- Keep cursor centered when moving
vim.keymap.set('n', '<C-d>', '<C-d>zz') -- Keep cursor centered when moving
vim.keymap.set('n', 'n', 'nzzzv') -- Keep cursor centered when moving
vim.keymap.set('n', 'N', 'Nzzzv') -- Keep cursor centered when moving
vim.keymap.set('n', 'J', 'mzJ`z') -- Keep cursor inplace while joining lines
-- Tryit —  Remove it after a month if not used
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>W', ':wq<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>Q', ':quit!<CR>')
-- Tryit.end

--:: Buffers ::--
vim.api.nvim_create_user_command('BufferRevealInFinder', function()
  local path = vim.api.nvim_buf_get_name(0)
  os.execute('open -R ' .. path)
end, {})
vim.keymap.set('n', '<leader>br', ':BufferRevealInFinder<CR>', { desc = '[R]eveal in finder' })
vim.keymap.set('n', '<leader>b/', ':let @*=expand("%")<CR>', { desc = 'Copy relative path' })
vim.keymap.set('n', '<leader>b%', ':let @*=expand("%:t")<CR>', { desc = 'Copy name' })
vim.keymap.set('n', '<leader>bq', ':bp|bd #<CR>', { silent = true, desc = '[Q]uit' }) -- (keep window splits)
vim.keymap.set('n', '<leader>bk', ':%bd | e# | bd#<CR>', { silent = true, desc = '[K]eep' })

--:: Text Manipulation ::--
vim.api.nvim_create_user_command('ToggleFormat', function()
  if vim.g.disable_autoformat then
    vim.g.disable_autoformat = false
  else
    vim.g.disable_autoformat = true
  end
end, {})
vim.keymap.set('n', '<leader>f', ':ToggleFormat<CR>', { desc = '[F]ormat toggle' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv") -- Use Shift + J/K to moves selected lines up/down in visual mode
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv") -- Use Shift + J/K to moves selected lines up/down in visual mode

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

--:: LSP ::--
vim.keymap.set('n', '<leader>lr', ':e<CR>', { desc = '[R]eattach lsp' })
vim.keymap.set('n', '<leader>lc', ':checkhealth vim.lsp<CR>', { desc = '[C]heck lsp health' })
vim.lsp.enable {
  'astro',
  'lua_ls',
  'gopls',
  'phpactor',
  'vtsls',
  'jq-lsp',
  'jsonls',
  'html',
  'emmet_ls',
  'cssls',
  'biome',
  'eslint',
}

--:: Diagnostic ::--
vim.diagnostic.config {
  jump = { float = true },
}
vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { desc = 'Show inline error' })
vim.keymap.set('n', 'ge', vim.diagnostic.setqflist, { desc = 'List of errors' })


--:: Lazy Setup ::--
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup 'plugins'
