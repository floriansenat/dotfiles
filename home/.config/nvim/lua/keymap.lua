vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

---:: Movements ::---
-- Use Shift + J/K to moves selected lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
-- Keep cursor centered when moving
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z') -- Keep cursor inplace while joining lines

---:: Buffers ::---
vim.keymap.set('n', '<leader>bq', ':bp|bd #<CR>', { silent = true, desc = 'Buffer' }) -- (keep window splits)
vim.keymap.set('n', '<leader>bQ', ':bd|e#<CR>', { silent = true, desc = 'All Buffer Except Focused One' })

---:: Diagnostics ::---
vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { desc = 'Show inline error' })
vim.keymap.set('n', 'ge', vim.diagnostic.setqflist, { desc = 'List of errors' })

---:: Quickfix ::---
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { silent = true, desc = '[O]pen' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { silent = true, desc = '[C]lose' })

---:: Files ::---
vim.api.nvim_create_user_command('FileReveal', function()
  local path = vim.api.nvim_buf_get_name(0)
  os.execute('open -R ' .. path)
end, {})
vim.keymap.set('n', '<leader>fr', '<cmd>FileReveal<CR>', { desc = '[R]eveal in finder' })
vim.keymap.set('n', '<leader>f/', '<cmd>let @*=expand("%")<CR>', { desc = 'Copy relative path' })
vim.keymap.set('n', '<leader>f%', '<cmd>let @*=expand("%:t")<CR>', { desc = 'Copy name' })

---:: LSP ::---
vim.keymap.set('n', '<leader>lr', ':e<CR>', { desc = '[R]eattach' })
vim.keymap.set('n', '<leader>lc', ':checkhealth vim.lsp<CR>', { desc = '[C]heckhealth' })
