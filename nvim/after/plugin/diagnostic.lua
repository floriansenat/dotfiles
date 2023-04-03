local wk = require('which-key')

wk.register({ ["<leader>d"] = { name = "[D]iagnostic" } })

vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = "[P]rev" })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = "[N]ext" })
vim.keymap.set('n', '<leader>dm', vim.diagnostic.open_float, { desc = "[M]essage" })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "[L]ist" })
