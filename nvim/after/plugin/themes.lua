local wk = require('which-key')

wk.register({ ['<leader>T'] = { name = '[T]heme' } })
vim.keymap.set('n', '<leader>Td', '<cmd>set background=dark<CR>', { desc = "[D]ark" })
vim.keymap.set('n', '<leader>Tl', '<cmd>set background=light<CR>', { desc = "[L]ight" })

