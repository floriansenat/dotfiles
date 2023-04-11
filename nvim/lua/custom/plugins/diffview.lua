return {
	{
		'sindrets/diffview.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local diffview = require('diffview')

			vim.keymap.set('n', '<leader>gd', diffview.open, { desc = "[D]iffs", silent = true })
			vim.keymap.set('n', '<leader>gh', diffview.file_history, { desc = "[H]istory", silent = true })
		end
	}
}
