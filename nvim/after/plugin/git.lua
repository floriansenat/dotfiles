local wk       = require('which-key')
local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function _lazygit_toggle()
	lazygit:toggle()
end

wk.register({ ['<leader>g'] = { name = '+[G]it' } })
vim.api.nvim_set_keymap("n", "<leader>go", "<cmd>lua _lazygit_toggle()<CR>",
	{ desc = "[O]verview", noremap = true, silent = true })
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = "[D]iffs", silent = true })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', { desc = "[H]istory", silent = true })
