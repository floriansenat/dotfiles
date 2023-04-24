return {
	'sindrets/diffview.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local diffview = require('diffview')

		diffview.setup({
			view = {
				default = {
					layout = 'diff3_horizontal'
				}
			}
		})

		vim.keymap.set('n', '<leader>pd', diffview.open, { desc = "[D]iffs", silent = true })
		vim.keymap.set('n', '<leader>fh', '<cmd>DiffviewFileHistory %<CR>', { desc = "[H]istory", silent = true })
	end
}
