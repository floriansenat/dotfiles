local wk = require('which-key')
local nvimTree = require('nvim-tree.api')

wk.register({ ['<leader>p'] = { name = '[P]roject' } })
vim.keymap.set('n', '<leader>pe', vim.cmd.Ex, { silent = true, desc = "Show [E]xplorer" })
vim.keymap.set('n', '<leader>pv', nvimTree.tree.toggle, { silent = true, desc = "Show [V]iew" })
vim.keymap.set('n', '<leader>pr', nvimTree.tree.reload, { silent = true, desc = "[R]eload" })
