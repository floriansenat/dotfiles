local wk = require('which-key')

wk.register({ ['<leader>p'] = {name = '[P]roject'}})
vim.keymap.set('n', '<leader>pe', vim.cmd.Ex, { silent = true, desc = "Show [E]xplorer" })

