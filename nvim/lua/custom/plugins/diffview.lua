return {
	'sindrets/diffview.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local diffview = require'diffview'

		diffview.setup({
			use_icons = false,
			view = {
				merge_tool = {
					layout = 'diff3_mixed'
				}

			}
		})

		vim.keymap.set('n', '<leader>pd', diffview.open, { desc = "[D]iffs", silent = true })
		vim.keymap.set('n', '<leader>fh', '<cmd>DiffviewFileHistory %<CR>', { desc = "[H]istory", silent = true })
	end
}
